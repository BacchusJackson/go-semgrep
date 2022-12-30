package go_semgrep

import (
	"bytes"
	"encoding/json"
	"os"
	"testing"
)

// A simple test to make sure encoding and decoding works as expected on a real Semgrep Output scan
// scan was produced using semgrep CLI on JuiceShop project.
// Command: semgrep ci --config=p/typescript --json | jq > juiceshop-semgrep-scan.json
func TestSemgrepOutputV1Jsonschema_Encoding(t *testing.T) {
	f, err := os.Open("juiceshop-semgrep-scan.json")
	if err != nil {
		t.FailNow()
	}

	var SemgrepScan SemgrepOutputV1Jsonschema

	if err := json.NewDecoder(f).Decode(&SemgrepScan); err != nil {
		t.Fatal(err)
	}

	buf := new(bytes.Buffer)

	if err := json.NewEncoder(buf).Encode(&SemgrepScan); err != nil {
		t.Fatal(err)
	}

	if buf.Len() < 1_000 {
		t.Fatal("Unexpected number of bytes encoded")
	}
}
