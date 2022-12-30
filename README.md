# Go Semgrep

All credit for [Semgrep](https://github.com/returntocorp/semgrep) goes to [R2C](https://r2c.dev/)

`semgrep-interfaces` repo contains `semgrep_output_v1.jsonschema` which was used to auto generate the Go struct using
[go-jsonschema](https://github.com/atombender/go-jsonschema)

Command used to generate:

````shell
gojsonschema -p go_semgrep semgrep-interfaces/semgrep_output_v1.jsonschema > semgrep.go
````

Versions are tagged to match the Semgrep Version used to auto generate the struct.

## Use Cases

This project was built to make the semgrep JSON output usable in other Go projects.

Use a type alias if you're doing anything more than encoding/decoding.

Example:

```shell
go mod init example
go mod tidy
go get github.com/BacchusJackson/go-semgrep@1.2.1
```

```go
package main

import (
	"encoding/json"
	"fmt"
	"github.com/BacchusJackson/go-semgrep@1.2.1"
	"os"
)

type SemgrepScan go_semgrep.SemgrepOutputV1Jsonschema

func main() {
	f, err := os.Open("juiceshop-semgrep-scan.json")
	if err != nil {
		panic(err)
	}

	var scan SemgrepScan
	if err := json.NewDecoder(f).Decode(&scan); err != nil {
		panic(err)
	}


	warningCount := 0
	for _, result := range scan.Results {
		if result.Extra.Severity == "WARNING" {
			warningCount += 1
		}
	}

	fmt.Println("Total Warnings:", warningCount)
}
```