# ERC Standards

!!! Info 
    参考：

    - [openzeppelin 的 ERC 实现](https://github.com/OpenZeppelin/openzeppelin-contracts)
    - [xg 有关 ERC 的笔记](https://note.tonycrane.cc/ctf/blockchain/eth/erc/)

写在前面：很多时候我们需要编译器与虚拟机版本较低时的合约代码，而恰好 openzeppelin 在 GitHub 上有非常多的 fork，我们就可以翻阅 fork，找到需要版本的合约代码，但是这种题一般少多多了，甚至很多题目都需要更新（甚至刚刚发布）的版本的虚拟机。

## ERC-20

## ERC-721

### Events

- `event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);`
    - Emitted when `tokenId` token is transferred from `from` to `to`.
- `event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);`
    - Emitted when `owner` enables `approved` to manage the `tokenId` token.
- `event ApprovalForAll(address indexed owner, address indexed operator, bool approved);`
    - Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.

### Approve

- `function approve(address to, uint256 tokenId) public virtual;`
    - 作用：授权 `tokenId` 给 `to`。
    - 细节：见 `_approve`，只有在需要发出事件（`emitEvent` 为真）或者授权者不为 0 时才读取所有者，这时候会检查代币拥有者是否是授权者、`auth` 是否被代币的拥有者授权，这两个条件均不满足就会抛出异常。我们经常使用的 `approve` 函数就默认了 `emitEvent` 为真，这时候会仔细检查授权情况。在最后将 `_tokenApprovals[tokenId]` 设置为 `to`。
    - 实现：
    ```solidity
    function approve(address to, uint256 tokenId) public virtual {
        _approve(to, tokenId, _msgSender());
    }

    function _approve(address to, uint256 tokenId, address auth) internal {
        _approve(to, tokenId, auth, true);
    }

    function _approve(address to, uint256 tokenId, address auth, bool emitEvent) internal virtual {
        // Avoid reading the owner unless necessary
        if (emitEvent || auth != address(0)) {
            address owner = _requireOwned(tokenId);
            // We do not use _isAuthorized because single-token approvals should not be able to call approve
            if (auth != address(0) && owner != auth && !isApprovedForAll(owner, auth)) {
                revert ERC721InvalidApprover(auth);
            }
            if (emitEvent) {
                emit Approval(owner, to, tokenId);
            }
        }
        _tokenApprovals[tokenId] = to;
    }
    ```
- `function setApprovalForAll(address operator, bool approved) public virtual;`
    - 实现：
    ```solidity
    function setApprovalForAll(address operator, bool approved) public virtual {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
        if (operator == address(0)) {
            revert ERC721InvalidOperator(operator);
        }
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }
    ```

### Inquire

- `function balanceOf(address owner) public view virtual returns (uint256);`

- `function ownerOf(uint256 tokenId) public view virtual returns (address);`

- `function getApproved(uint256 tokenId) public view virtual returns (address);`
    - 作用：查询 tokenId 的授权者，也就是返回 `_tokenApprovals[tokenId]`，同时要求该代币存在（拥有者不为 0）。
    - 实现：
    ```solidity
    function getApproved(uint256 tokenId) public view virtual returns (address) {
        _requireOwned(tokenId);
        return _getApproved(tokenId);
    }

    function _getApproved(uint256 tokenId) internal view virtual returns (address) {
        return _tokenApprovals[tokenId];
    }
    ```
- `function isApprovedForAll(address owner, address operator) public view virtual returns (bool);`
    - 实现：
    ```solidity
    function isApprovedForAll(address owner, address operator) public view virtual returns (bool) {
        return _operatorApprovals[owner][operator];
    }
    ```


### Check

- `function _isAuthorized(address owner, address spender, uint256 tokenId) internal view virtual returns (bool);`
    - 作用：检查 `spender` 是否有权限操作 `tokenId`，但是不抛出异常。
    - 细节：要求 `spender` 不为 0，同时需要下面三个要求满足其一：
        - `owner` 与 `spender` 相同，拥有者自然有权操纵代币；
        - `owner` 授权给 `spender`，全局授权，`spender` 可以操纵 `owner` 的所有代币；
        - `tokenId` 的授权者是 `spender`。
    - 实现：
    ```solidity
    function _isAuthorized(address owner, address spender, uint256 tokenId) internal view virtual returns (bool) {
        return
            spender != address(0) &&
            (owner == spender || isApprovedForAll(owner, spender) || _getApproved(tokenId) == spender);
    }
    ```
- `function _checkAuthorized(address owner, address spender, uint256 tokenId) internal view virtual;`
    - 作用：检查 `spender` 是否有权限操作 `tokenId`，如果没有就抛出异常。
    - 细节：首先调用 `_isAuthorized` 检查权限，如果没有权限就抛出异常，异常分为两种情况：
        - `owner` 为 0，代币不存在，抛出 `ERC721NonexistentToken` 异常；
        - `owner` 为 0，代币存在，但是 `spender` 没有权限，抛出 `ERC721InsufficientApproval` 异常，在做 [SchoolBus Safe NFT](https://www.zjusec.com/challenges/169) 一题的过程中遇见最多的就是这个异常。
    - 实现：
    ```solidity
    function _checkAuthorized(address owner, address spender, uint256 tokenId) internal view virtual {
        if (!_isAuthorized(owner, spender, tokenId)) {
            if (owner == address(0)) {
                revert ERC721NonexistentToken(tokenId);
            } else {
                revert ERC721InsufficientApproval(spender, tokenId);
            }
        }
    }
    ```
- `function _update(address to, uint256 tokenId, address auth) internal virtual returns (address);`
    - 实现：
    ```solidity
    function _update(address to, uint256 tokenId, address auth) internal virtual returns (address) {
        address from = _ownerOf(tokenId);

        // Perform (optional) operator check
        if (auth != address(0)) {
            _checkAuthorized(from, auth, tokenId);
        }

        // Execute the update
        if (from != address(0)) {
            // Clear approval. No need to re-authorize or emit the Approval event
            _approve(address(0), tokenId, address(0), false);

            unchecked {
                _balances[from] -= 1;
            }
        }

        if (to != address(0)) {
            unchecked {
                _balances[to] += 1;
            }
        }

        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        return from;
    }
    ```
- `function _requireOwned(uint256 tokenId) internal view virtual returns (address);`
    - 作用：检查 tokenId 是否存在，如果不存在（也就是拥有者为地址 0）就抛出异常。
    - 实现：
    ```solidity
    function _requireOwned(uint256 tokenId) internal view returns (address) {
        address owner = _ownerOf(tokenId);
        if (owner == address(0)) {
            revert ERC721NonexistentToken(tokenId);
        }
        return owner;
    }
    ```

### Transfer

- `function transferFrom(address from, address to, uint256 tokenId) public virtual;`
    - 实现：
    ```solidity
    function transferFrom(address from, address to, uint256 tokenId) public virtual {
        if (to == address(0)) {
            revert ERC721InvalidReceiver(address(0));
        }
        // Setting an "auth" arguments enables the `_isAuthorized` check which verifies that the token exists
        // (from != 0). Therefore, it is not needed to verify that the return value is not 0 here.
        address previousOwner = _update(to, tokenId, _msgSender());
        if (previousOwner != from) {
            revert ERC721IncorrectOwner(from, tokenId, previousOwner);
        }
    }
    ```
- `function safeTransferFrom(address from, address to, uint256 tokenId) public;`
    - 实现：
    ```solidity
    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual {
        transferFrom(from, to, tokenId);
        _checkOnERC721Received(from, to, tokenId, data);
    }
    
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory data) private {
        if (to.code.length > 0) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
                if (retval != IERC721Receiver.onERC721Received.selector) {
                    revert ERC721InvalidReceiver(to);
                }
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert ERC721InvalidReceiver(to);
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        }
    }
    ```
