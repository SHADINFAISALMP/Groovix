import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groovix/reuseable_widgets.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: bgTheme(),
          ),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_outlined,
                          color: color1white,
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.0533),
                      mytext(
                        'Privacy Policy',
                        18 * MediaQuery.of(context).size.width / 375.0,
                        color1white,
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.0125),
                  Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.048),
                      child: Text(
                        '''SHADIN FAISAL built the Groovix app as a Free app. This SERVICE is provided by SHADIN FAISAL at no cost and is intended for use as is. 
        \nThis page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.
        \nIf you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.
        \nThe terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Groovix unless otherwise defined in this Privacy Policy.
        
        Information Collection and Use
        \nFor a better experience, while using our Service, I may require you to provide us with certain personally identifiable information. The information that I request will be retained on your device and is not collected by me in any way.
        
        Log Data
        \nI want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics.
        
        Cookies
        \nCookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.
        \nThis Service does not use these “cookies” explicitly. However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.
        
        Service Providers
        \nI may employ third-party companies and individuals due to the following reasons:
        \nTo facilitate our Service;
        \nTo provide the Service on our behalf;
        \nTo perform Service-related services; or
        \nTo assist us in analyzing how our Service is used.
        \nI want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.
        
        Security
        \nI value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.
        
        Links to Other Sites
        \nThis Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.
        Children’s Privacy
        \nI do not knowingly collect personally identifiable information from children. I encourage all children to never submit any personally identifiable information through the Application and/or Services. I encourage parents and legal guardians to monitor their children's Internet usage and to help enforce this Policy by instructing their children never to provide personally identifiable information through the Application and/or Services without their permission. If you have reason to believe that a child has provided personally identifiable information to us through the Application and/or Services, please contact us. You must also be at least 16 years of age to consent to the processing of your personally identifiable information in your country (in some countries we may allow your parent or guardian to do so on your behalf).
        
        Changes to This Privacy Policy
        \nI may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.
        \nThis policy is effective as of 2024-01-01
        
        Contact Us
       \nIf you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at shadinfaisal305@gmail.com.
        
       ''',
                        style: TextStyle(
                          fontFamily: GoogleFonts.aboreto().fontFamily,
                          color: color1white,
                          fontSize:
                              16 * MediaQuery.of(context).size.width / 375.0,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
