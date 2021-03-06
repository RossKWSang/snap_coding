Map<String, dynamic> languageTemplate = {
  "C": [
    "#include <stdio.h>",
    "",
    "int main(void){",
    "\tprintf(\"Hello world\");",
    "\treturn 0;",
    "}",
  ],
  "C++": [
    "#include <stdio.h>",
    "",
    "int main(void){",
    "\tprintf(\"Hello world\");",
    "\treturn 0;",
    "}",
  ],
  "C#": [
    "using System;",
    "using System.Collections.Generic;",
    "using System.Linq;",
    "using System.Text;",
    "using System.Threading.Tasks;",
    "",
    "namespace Hello_World",
    "{",
    "\tclass Program",
    "\t{",
    "\t\tstatic void Main(string[] args)",
    "\t\t{",
    "\t\t\tConsole.Writeine(\"Hello, world!\");",
    "\t\t}",
    "\t}",
    "}",
  ],
  "Java": [
    "public class HelloWorld {",
    "\tpublic class void main(String[] args) {",
    "\t\tSystem.out.println(\"Hello, world!\");",
    "\t}",
    "}",
  ],
  "Python": [
    "print(\"Hello, world!\")",
  ],
  "Ruby": [
    "puts \"Hello, world!\"",
  ],
  "PHP": [
    "<?php",
    "\techo \"Hello, world!\";",
    "?>",
  ],
  "Javascript": [
    "console.log(\"Hello, World!\");",
  ],
  "dart": [
    "print(\"Hello, world!\");",
  ],
  "go": [
    "package main",
    "",
    "import \"fmt\"",
    "func main() {",
    "\tfmt.Println(\"Hello, world!\")",
    "}",
  ],
  "rust": [
    "fn main() {",
    "\tprintln!(\"Hello, world!\");",
    "}",
  ],
  "html": [
    "Hello, world!",
  ],
  "css": [
    "<style>",
    "\tbody: before {",
    "\t\tcontent: \"Hello, world!\";",
    "\t}",
    "</style>",
  ],
  "bash": [
    "var=\"Hello, world!\"",
    "echo \"\$var\"",
    "printf \"\%s\\n\" \"\$var\"",
  ],
  "typescript": [
    "let message: string = \"Hello, world!\";",
    "console.log(message);",
  ],
  "R": [
    "print(\"Hello, world!\")",
  ],
};
