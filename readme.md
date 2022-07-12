# UART Uploader - By Schmurtz

Script for easy upload files on linux devices which have only UART (=port com = serial connection)
It include a menu to guide the user and repeat actions quickly, it can be used as a command line utility 

![image](https://user-images.githubusercontent.com/7110113/178542715-b7706eac-8210-432f-8803-f723b1c85a86.png)

------------------------------------------------
**Contents:**
* [Download](#Download)
* [How to use](#How-to-use)

* [Release Notes](#Release-Notes)
* [Details](#Details)
	* How does it work ?
	* Alternative ways to upload a file on uart connection
	* Remarks & Futur Improvements
* [Credits](#credits-)
* [Thanks](#Thanks)

------------------------------------------------
## Download


The "normal" way to download sources on Github :

<img src="https://user-images.githubusercontent.com/7110113/177954376-4b36be7a-eb07-4cca-8fa6-7866e5bdece1.png" width="300" height="200">


------------------------------------------------
## How to use

** base64 binary is required on target device ! **

Usage:    

interactive mode : 
```UART_Uploader``` -> You will have to enter your local file path, your folder destination on th remote device the COM port and the serial speed.
Everything is pretty easy thanks to a menu dedicated.
You can use drag and dorop to select your source file or a file browser if you enter the command ff on the file selection menu.


Command line mode : 
```UART_Uploader "file_path" "folder_destination" "com_port" "serial_speed" [/r] or [/s]```

            /r = 'run now' -> an upload will run immediately, 
	    		              you still have to press a key to close the upload Window
            /s = 'silent' : no user interction, upload window is automatically killed after 5 seconds



For help:    ```SerialSend /? ```

Example:     ```UART_Uploader.bat "MyBinary" "/tmp/target directory" com3 115200 /r /s```


to automate multiple uploads you can do something like that 



------------------------------------------------
 

 ## Release Notes
```
/*  Release Notes (yyyy/mm/dd):                                                             */
/*  v1.0 - 2022/07/12 :                                                                     */
/*    - Initial release                                                                     */
```

 ## Details
------------------------------------------------
#### How does it work ?
I was looking for a way to send files on linux device (Miyoo Mini console) which haven't network connection, only an UART port available.

The script will encode your source file in base64 and put it in a text file with some additional commands. Then this text file will be executed remotely with plink (a putty utility).


#### Alternative ways to upload a file on uart connection :

For a text file or a shell script, an easy way is to use vim (or nano if you're lucky) and copy paste inside. 

An alternative to upload text files is to use putty and cat command : 
 - type ```cat > somefile``` in putty
- copy/paste your text file in putty and hit Ctrl +D at the end

It's not very convenient and it doesn't works for binary files.

For binary files a way is to encode your source file in base64, send this base64 text file and then decode this file on the target device.
You will need base64 utility on both devices (one to encode and one to decode on the target device).
In case you don't have base64 utility on the target linux device, you could replace it by a script [like this one](https://gist.github.com/markusfisch/2648733).

#### Remarks & Futur Improvements :
- A difficulty is to know when plink has finished its upload. There's nothing easy to detect that. On my linux device I wasn't able to reset uart connection. So that's why I ask to the user to close plink himself when the upload is terminated.
- A similar script in shell for linux.
- A version of the script which support missing base64 binary on the target device [see here](https://gist.github.com/markusfisch/2648733).

------------------------------------------------

  ## Credits : 
 [This stack stackexchange post from ilkkachu](https://unix.stackexchange.com/a/356762) which inspirate the creation of this script ! 
 
 Some binaries for batch which are used in this script :
 - nircmd & nircmdc from nirsoft to manage windows.
 - EchoX from [Bill Stewart](https://westmesatech.com/?page_id=26) to add easily some colors in the menu
 - base64 from [DI Management](https://www.di-mgt.com.au/base64-for-windows.html) to encode in base64 on Windows
 - [PuTTY & plink](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)

 ## Thanks
  
You like this project ? You want to improve this project ? 

Do not hesitate, **Participate**, there are many ways :
- If you don't know how to script you can test releases and post some issues, some tips and tricks for daily use.
- If you're a coder you can fork, edit and publish your modifications with Pull Request on github :)<br/>
- Or you can buy me a coffee to keep me awake during night coding sessions :dizzy_face: !<br/><br/>
[![Buy me a coffee][buymeacoffee-shield]][buymeacoffee]
<br/><br/>

[buymeacoffee-shield]: https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg
[buymeacoffee]: https://www.buymeacoffee.com/schmurtz
 ===========================================================================
 
