# Go

!!! Info

    打 CTF 中遇见了几道 Go 的逆向，正好在 GitHub 上看到了一些好玩的小玩意也是拿 Go 写的，所以就想学习一下 Go 语言。记得很草，权当备忘。


## Example Program

```go
package main
import (
    "fmt"
    "math/rand"
)

func add(x int, y int) int {
    return (x + y) % rand.Intn(100)
}

func main() {
    fmt.Println("Hello, World!")
    fmt.Printf("Get a random number: %g\n", add(113, 202))
}
```
