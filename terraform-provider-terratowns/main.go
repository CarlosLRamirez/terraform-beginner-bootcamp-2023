
// package main: Declares the package name
// The main package is special in Go, It's where the execution of the program starts.
package main


// Imports the fmt package, which contains function for formatted I/O
import {
	"fmt"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
}
// Defines the main function, the entry point of the application. 
// When yo run the program, its starts execution from this function
func main(){

	plugin.Serve{$plugin.ServeOpts}{
		ProviderFunc: Provider

	}


	//Format.PrintLine
	//Prints to standard output
	fmt.Println("Hello, World!")
}


func Provider() *schema.Provider{

	var p *schema.Provider
	p = &schema.Provider{
		ResourceMap:
		DataSourceMap:
		Schema: 
	}

}