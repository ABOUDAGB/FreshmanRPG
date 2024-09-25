<<<<<<< HEAD
# Flutter Barcode Scanner



## Getting started

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.engr.ship.edu/merlin/flutter-barcode-scanner.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://gitlab.engr.ship.edu/merlin/flutter-barcode-scanner/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Set auto-merge](https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/index.html)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing (SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!). Thanks to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README

Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
=======
# flutter_barcode_scanner

A plugin for Flutter apps that adds barcode scanning support on both Android and iOS.

[![pub package](https://img.shields.io/pub/v/flutter_barcode_scanner.svg)](https://pub.dartlang.org/packages/flutter_barcode_scanner)

![Demo gif](https://github.com/AmolGangadhare/MyProfileRepo/blob/master/flutter_barcode_scanning_demo.gif "Demo")


## Try example
Just clone or download the repository, open the project in `Android Studio/ VS Code`, open `pubspec.yaml` and click on `Packages get`.
Connect device and hit `run`. 
To run on iPhone you need to run from Xcode first time and just make `pod install` in `example/ios` then run from Xcode.

## Getting Started 
Follow the steps for Android and iOS

PLEASE FOLLOW **iOS** STEPS CAREFULLY

### Android

:zap:  Don't worry, you don't need to do anything.

### iOS - Requires Swift support

Deployment target : 12

#### 1. Fresh start: 
 1. Create a new flutter project. Please check for **Include swift support for iOS code**.
 2. After creating new flutter project open `/ios` project in Xcode and set minimum **deployment target to 12**
    and set **Swift version to 5**.
 3. After setting up the deployment target and swift version, close the Xcode then run **pod install** in `/ios` in flutter project.
 
 You have done with basic configuration now proceed to section **How to use**.
 
#### 2. Adding to existing flutter app: 
#### If your existing ios code is **Swift** then you just need to do following.
  1. Set **minimum deployment target to 12** and set **Swift version to 5**.
  2. Close the Xcode and run **pod install** in `/ios` in flutter project.
  3. Now proceed to section **How to use**.
 
#### If your existing ios code is **Objective-C** then you need to do following.
  1. Create a new flutter project with same name at different location (Don't forget to check **Include swift support for iOS code** while creating) 
  2. Just copy newly created `/ios` folder from project and replace with existing `/ios`.
  3. Open ios project in Xcode and set **minimum deployment target to 12** and set **Swift version to 5**.
  4. Run **pod install** in `/ios` 
    
**Note: If you did any changes in ios part before, you might need to make these configuration again**

## How to use ?

To use on iOS, you will need to add the camera usage description.
To do that open the Xcode and add camera usage description in `Info.plist`. 

```
<key>NSCameraUsageDescription</key>
<string>Camera permission is required for barcode scanning.</string>
```


After making the changes in Android ans iOS add flutter_barcode_scanner to `pubspec.yaml`
```  
dependencies:
  ...
  flutter_barcode_scanner: ^2.0.0
```

### One time scan
1. You need to import the package first.

```
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
```

    
2. Then use the `scanBarcode` method to access barcode scanning.
    
```
String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                                    COLOR_CODE, 
                                                    CANCEL_BUTTON_TEXT, 
                                                    isShowFlashIcon, 
                                                    scanMode);
```

Here in `scanBarcode`,

 `COLOR_CODE` is hex-color which is the color of line in barcode overlay you can pass color of your choice,
 
 `CANCEL_BUTTON_TEXT` is a text of cancel button on screen you can pass text of your choice and language,
 
 `isShowFlashIcon` is bool value used to show or hide the flash icon,
 
 `scanMode` is a enum in which user can pass any of `{ QR, BARCODE, DEFAULT }`, if nothing is passed it will consider a default value which will be `QR`.
 It shows the graphics overlay like for barcode and QR.
 
 NOTE: Currently, `scanMode` is just to show the graphics overlay for barcode and QR. Any of this mode selected will scan both QR and barcode. 

### Continuous scan
* If you need to scan barcodes continuously without closing camera use `FlutterBarcodeScanner.getBarcodeStreamReceiver`
params will be same like `FlutterBarcodeScanner.scanBarcode`
e.g. 


```
FlutterBarcodeScanner.getBarcodeStreamReceiver("#ff6666", "Cancel", false, ScanMode.DEFAULT)
         .listen((barcode) { 
         /// barcode to be used
         });
```

### Contribution:

would :heart: to see any contribution, give :star:  if you like

### Contact:


<p>
<a href="https://github.com/AmolGangadhare"><img src="https://github.com/AmolGangadhare/MyProfileRepo/blob/master/git_hub_logo.png" width="32" height="33" style="max-width:100%;"></a>
<a href="https://stackoverflow.com/users/9823185/amol-gangadhare" rel="nofollow"><img src="https://github.com/AmolGangadhare/MyProfileRepo/blob/master/stack_o_logo.svg" width="36" height="36" style="max-width:100%;"></a>
<a href="https://www.linkedin.com/in/amolgangadhare/" rel="nofollow"><img src="https://github.com/AmolGangadhare/MyProfileRepo/blob/master/linked_in_logo.svg" width="36" height="36" style="max-width:100%;"></a>
</p>

E-mail: amol.gangadhare@gmail.com
>>>>>>> ec522c7 (initial commit)
