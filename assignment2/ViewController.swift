//
//  ViewController.swift
//  Assignment2
//
//  Created by Esti Tweg on 2016-02-29.
//  Copyright © 2016 Esti Tweg. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //Make IB Oustlet variables for the decimal, ternary, and octal buttons and for the text feild
    @IBOutlet var decimalButton : UIButton!
    @IBOutlet var ternaryButton : UIButton!
    @IBOutlet var octalButton : UIButton!
    @IBOutlet var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        //make the 3 buttons red with rounded corners
        let layer = decimalButton.layer
        layer.cornerRadius = 7.0
        layer.masksToBounds = true
        layer.borderWidth = 0.8
        decimalButton.backgroundColor = UIColor.redColor()
        
        let layer2 = ternaryButton.layer
        layer2.cornerRadius = 7.0
        layer2.masksToBounds = true
        layer2.borderWidth = 0.8
        ternaryButton.backgroundColor = UIColor.redColor()
        
        let layer3 = octalButton.layer
        layer3.cornerRadius = 7.0
        layer3.masksToBounds = true
        layer3.borderWidth = 0.8
        octalButton.backgroundColor = UIColor.redColor()
        
        //set background colour to be grey
        self.view.backgroundColor = UIColor.lightGrayColor()
        //set the text field
        textField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func decimalButtonClicked(sender : AnyObject) {
        //if the decimal button is clicked
        //check if the other buttons are green
        //if they are, change them back to red
        if (ternaryButton.backgroundColor == UIColor.greenColor() || octalButton.backgroundColor == UIColor.greenColor()){
            ternaryButton.backgroundColor = UIColor.redColor()
            octalButton.backgroundColor = UIColor.redColor()
        }
        //change this button to green
        decimalButton.backgroundColor = UIColor.greenColor()
        //get the text string that the user inputed
        let text = String(textField.text!)
        
        //if there is nothing in the text field then display error messege
        if (text.isEmpty){
            textField.text = "ERROR"
            textField.backgroundColor = UIColor.redColor()
        }
        
        //if the user did not enter the right number of charecters (there needs to be it least 3)
        //then display the error messege
        if(text.characters.count<3) {
            textField.text = "ERROR"
            textField.backgroundColor = UIColor.redColor()
        }
        //there are itleast three characters inputed
        else{
            //make an array from the input
            //each character inputed is its own element in the array
            let textArray = [Character](text.characters)
            //get the first second charecters from the array
            let firstCharValue = textArray[0]
            let secondCharValue = textArray[1]
            var runMe = true
            //if the first charecter is not either o or d or t or the second charecter is not : then display the error messege
            if (!((firstCharValue == "d" || firstCharValue == "o" || firstCharValue == "t" ) && (secondCharValue  == ":"))){
                textField.text = "ERROR"
                textField.backgroundColor = UIColor.redColor()
            }
            //check if all the character  are numbers and not a letter or symbol
            //change each charecter to its ascii value and make sure its within the correct range
            else{
                for (var i = 0; i<textArray.count ; i++){
                    if (String(textArray[i]).unicodeScalars.first?.value<48 || String(textArray[i]).unicodeScalars.first?.value>57){
                        runMe = false
                    }
                }
                if ((firstCharValue == "d" || firstCharValue == "o" || firstCharValue == "t" ) && (secondCharValue  == ":") && runMe){
                    //get the number of charecters inputed
                    //from that, caluclate the number of digits in the inputed number
                    let numOfChars = textArray.count
                    let numOfDigits = numOfChars-2
                    //make an array of the inputer numbers, fill it with the right number of zeros as placeholders
                    var numbers = [Int](count:numOfDigits, repeatedValue: 0)
                    //fill the array in with the numbers from the input
                    for (var i = 0; i < numOfDigits ; i++){
                        numbers[i] = Int(String(textArray[i+2]))!
                    }
                    //change the array of integers into the actual entered number
                    let number = intArrayToInt(numbers, numOfDigits: numOfDigits)
                    // if user entered a decimal number and wants a decimal number
                    if(firstCharValue == "d"){
                        //then output the same number that they entered
                        textField.text = String(number)
                    }
                    //if the user entered an octal number to be converted to decimal
                    else if(firstCharValue == "o"){
                        //convert the octal number to a decimal integer and then to a string
                        //output the string
                        let output = String(octalToDecimal(number))
                        textField.text = output
                    }
                    //the user entered a ternary nubmer to be converted to decimal
                    else if (firstCharValue == "t"){
                        //convert the ternary number to a decimal integer and then to a string
                        //output the string
                        let output = String(ternaryToDecimal(number))
                        textField.text = output
                    }
                    //set the text feild back to white (if it had changed to red)
                    textField.backgroundColor = UIColor.whiteColor()
                }
            }
            //if it was none of those senarios then its invalid input and display the error messege
            if (!runMe){
                textField.text = "ERROR"
                textField.backgroundColor = UIColor.redColor()
            }
        }
    }
    
    @IBAction func ternaryButtonClicked(sender : AnyObject) {
        //if the user clicked the ternary button
        //check if the other buttons are green
        //if they are, change them back to red
        if (decimalButton.backgroundColor == UIColor.greenColor() || octalButton.backgroundColor == UIColor.greenColor()){
            decimalButton.backgroundColor = UIColor.redColor()
            octalButton.backgroundColor = UIColor.redColor()
        }
        //change this button to green
        ternaryButton.backgroundColor = UIColor.greenColor()
        //get the String of the input
        let text = String(textField.text!)
        
        //if th euser did not type anything then display the error messege
        if (text.isEmpty){
            textField.text = "ERROR"
            textField.backgroundColor = UIColor.redColor()
        }
        //if there are less than three characters inputed then display the error messege
        if(text.characters.count<3) {
            textField.text = "ERROR"
            textField.backgroundColor = UIColor.redColor()
        }
        else{
            //make an array where each charecter inputed is its own element
            let textArray = [Character](text.characters)
            //get the first, second and charecters from the array
            let firstCharValue = textArray[0]
            let secondCharValue = textArray[1]
            var runMe = true
            //if the first charecter is not either o or d or t or the second charecter is not : then display the error messege
            if (!((firstCharValue == "d" || firstCharValue == "o" || firstCharValue == "t" ) && (secondCharValue  == ":"))){
                textField.text = "ERROR"
                textField.backgroundColor = UIColor.redColor()
            }
            //check that each character is a number and not a letter or symbol
            //change each charecter to its ascii value and make sure its within the correct range
            else{
                for (var i = 0; i<textArray.count ; i++){
                    if (String(textArray[i]).unicodeScalars.first?.value<48 || String(textArray[i]).unicodeScalars.first?.value>57){
                        runMe = false
                    }
                }
                if ((firstCharValue == "d" || firstCharValue == "o" || firstCharValue == "t" ) && (secondCharValue  == ":") && runMe){
                    //get the number of charecters inputed
                    //from that, caluclate the number of digits in the inputed number
                    let numOfChars = textArray.count
                    let numOfDigits = numOfChars-2
                    //make an array of integers, fill it with the right number of zeros as placeholders
                    var numbers = [Int](count:numOfDigits, repeatedValue: 0)
                    for (var i = 0; i < numOfDigits ; i++){
                        //fill the array in with the numbers from the input
                        numbers[i] = Int(String(textArray[i+2]))!
                    }
                    //change the array of integers into the actual entered number
                    let number = intArrayToInt(numbers, numOfDigits: numOfDigits)
                    // if user entered a decimal number and wants a ternary number
                    if(firstCharValue == "d"){
                        //convert the decimal number to Ternary and then to a string
                        let output = String(decimalToTernary(number, numOfDigits : numOfDigits))
                        //output the string
                        textField.text = output
                    }
                        //if the user entered an octal number to be converted to decimal
                    else if(firstCharValue == "o"){
                        //convert the octal nubmer to decimal
                        let decimalNum = octalToDecimal(number)
                        //then make an array of the decimal number digits
                        let decimalArray = [Int](arrayLiteral: decimalNum)
                        //convert the decimal number to ternary then to a tring and output that
                        let output = String(decimalToTernary(decimalNum, numOfDigits: decimalArray.count))
                        textField.text = output
                    }
                        //the user endered a ternary number and wants a ternary number
                    else if (firstCharValue == "t"){
                        //output the nubmer given
                        textField.text = String(number)
                    }
                    //set the text feild back to white
                    textField.backgroundColor = UIColor.whiteColor()
                }
            }
            //otherwise some sort of error
            if (!runMe) {
                textField.text = "ERROR"
                textField.backgroundColor = UIColor.redColor()
            }
        }
    }



    @IBAction func octalButtonClicked(sender : AnyObject) {
        //if the octal button is clicked
        //check if the other buttons are green
        //if they are, change them back to red
        if (decimalButton.backgroundColor == UIColor.greenColor() || ternaryButton.backgroundColor == UIColor.greenColor()){
            decimalButton.backgroundColor = UIColor.redColor()
            ternaryButton.backgroundColor = UIColor.redColor()
        }
        //change this button to green
        octalButton.backgroundColor = UIColor.greenColor()
        //get the inputed text as a string
        let text = String(textField.text!)
        //check if the text is empty, if it is then display the error messege
        if (text.isEmpty){
            textField.text = "ERROR"
            textField.backgroundColor = UIColor.redColor()
        }
        //if the text has less than three characters then it is invalif and display the error messege
        if(text.characters.count<3) {
            textField.text = "ERROR"
            textField.backgroundColor = UIColor.redColor()
        }
        //otherwise there are itleast three charecters in the text
        else {
            //make an array of the input where each charecter is its own element in the array
            let textArray = [Character](text.characters)
            //get the first and second characters from the array
            let firstCharValue = textArray[0]
            let secondCharValue = textArray[1]
            var runMe = true
            //if the first charecter is not either o or d or t or the second charecter is not : then display the error messege
            if (!((firstCharValue == "d" || firstCharValue == "o" || firstCharValue == "t" ) && (secondCharValue  == ":"))){
                textField.text = "ERROR"
                textField.backgroundColor = UIColor.redColor()
            }
            //check that each character is a number and not a letter or symbol
            //change each charecter to its ascii value and make sure its within the correct range
            else {
                for (var i = 0; i<textArray.count ; i++){
                    if (String(textArray[i]).unicodeScalars.first?.value<48 || String(textArray[i]).unicodeScalars.first?.value>57){
                        runMe = false
                    }
                }
                if((firstCharValue == "d" || firstCharValue == "o" || firstCharValue == "t" ) && (secondCharValue  == ":") && runMe){
                    //get the number of charecters inputed
                    //from that, caluclate the number of digits in the inputed number
                    let numOfChars = textArray.count
                    let numOfDigits = numOfChars-2
                    //make an array of integers, fill it with the right number of zeros as placeholders
                    var numbers = [Int](count:numOfDigits, repeatedValue: 0)
                    for (var i = 0; i < numOfDigits ; i++){
                        //fill the array in with the numbers from the input
                        numbers[i] = Int(String(textArray[i+2]))!
                    }
                    //change the array of integers into the actual entered number
                    let number = intArrayToInt(numbers, numOfDigits: numOfDigits)
                    // if user entered a decimal number and wants a Octal number
                    if(firstCharValue == "d"){
                        //convert the decimal number to octal and then to a string
                        let output = String(decimalToOctal(number, numOfDigits : numOfDigits))
                        //output the string
                        textField.text = output
                    }
                    //if the user entered an octal number to be converted to octal
                    else if(firstCharValue == "o"){
                        //output the inputed number
                        textField.text = String(number)
                    }
                    //the user endered a ternary number and wants a octal number
                    else if (firstCharValue == "t"){
                        //conver the ternary number to a decimal number
                        let decimalNum = ternaryToDecimal(number)
                        //change the decimal number to an array where each digit is its own element
                        let decimalArray = [Int](arrayLiteral: decimalNum)
                        //convert the decimal number (array) to octal and then to a string
                        let output = String(decimalToOctal(decimalNum, numOfDigits: decimalArray.count))
                        //output the string
                        textField.text = output
                    }
                    //set the text feild back to white in case it turned red
                    textField.backgroundColor = UIColor.whiteColor()
                }
            }
            //some other invalid senario, display the error messege
            if (!runMe) {
                textField.text = "ERROR"
                textField.backgroundColor = UIColor.redColor()
            }
        }
    }
    
    //function to change an array of integers (where each digit is its own element)
    //to a number
    func intArrayToInt(numbers: [Int], numOfDigits : Int) -> Int {
        var number = 0;
        var place = 1
        //run through the array from the last element to the first
        //add together the digits nultiplied by its corrisponding place (10's, 100's...)
        for (var i = numOfDigits - 1 ; i >= 0 ; i--){
            number += numbers[i] * place
            place *= 10
        }
        return number
    }
    
    
    //function to convert a decimal number to a ternary number
    func decimalToTernary(var num: Int, numOfDigits : Int) -> Int {
        //initialize variables
        var counter = 0
        var number = num
        var remainder = 0
        var result = 4;
        //go through the calculation process to count how many digits this ternary number will have
        while (result != 0){
            result = num/3
            remainder = num%3
            num /= 3
            counter++
        }
        //using the just calculated number, make an array of that size
        var intArray = [Int](count:counter, repeatedValue: 0)
        //repete the process to convert to a ternary number and fill the array with the calculated digits
        var i = intArray.count-1
        remainder = 0
        result = 4;
        while (result != 0){
            result = number/3
            remainder = number%3
            number /= 3
            intArray[i] = remainder
            i--
        }
        //convert the array to an integer and return the ternary number
        return intArrayToInt(intArray, numOfDigits: intArray.count)
    }
    
    
        //function to convert a decimal number to a Octal number
    func decimalToOctal(var num: Int, numOfDigits : Int) -> Int{
        //initialize variables
        var counter = 0
        var number = num
        var remainder = 0
        var result = 4;
        //go through the calculation process to count how many digits this ternary number will have
        while (result != 0){
            result = num/8
            remainder = num%8
            num /= 8
            counter++
        }
        //using the just calculated number, make an array of that size
        var intArray = [Int](count:counter, repeatedValue: 0)
        //repete the process to convert to an octal number and fill the array with the calculated digits
        var i = intArray.count-1
        remainder = 0
        result = 4;
        while (result != 0){
            result = number/8
            remainder = number%8
            number /= 8
            intArray[i] = remainder
            i--
        }
        //convert the array to an integer and return the Octal number
        return intArrayToInt(intArray, numOfDigits: intArray.count)
    }
    
    //function to convert an octal number to a decimal number
    func octalToDecimal(num: Int) -> Int {
        //return the octal number converted to decimal using the radix method
        return Int(String(num), radix: 8)!
    }
    
    //function to convert a ternary number to a decimal number
    func ternaryToDecimal(num: Int) -> Int {
        //return the ternary number converted to decimal using the radix method
        return Int(String(num), radix: 3)!
    }
    


    
}

