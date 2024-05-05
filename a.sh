#!/bin/bash

version_numeric=200217097

data_offset=1183
shared_obj_deps=(libpango-1.0.so.0 libXext.so.6 libpthread.so.0 libXi.so.6 libgobject-2.0.so.0 libgtk-3.so.0 libdl.so.2 libgdk_pixbuf-2.0.so.0 libX11.so.6 libuuid.so.1 librt.so.1 libexpat.so.1 libglib-2.0.so.0 libXdamage.so.1 libatk-1.0.so.0 libm.so.6 libatspi.so.0 libcups.so.2 libgio-2.0.so.0 libXfixes.so.3 libXrender.so.1 libxcb.so.1 libsmime3.so libcairo.so.2 libXcomposite.so.1 libgdk-3.so.0 libpangocairo-1.0.so.0 libgcc_s.so.1 libX11-xcb.so.1 libdbus-1.so.3 libnss3.so libXrandr.so.2 libnspr4.so libXcursor.so.1 libnssutil3.so libXss.so.1 libasound.so.2 libatk-bridge-2.0.so.0 libc.so.6 libXtst.so.6)
setup_type=

default_linux_user=acunetix
db_port=35432
server_port=3443

host_name=$(hostname)
base_folder=
temp_dir=
master_user=
master_password=
db_host=localhost
db_user=acunetix
db_password=
db_name=wvs
db_pgdir=
db_datadir=
version="v_$version_numeric"
linux_user=$default_linux_user
linux_group=$default_linux_user

install_log=install.log


if [ -z "$setup_type" ]; then
    product_name="acunetix"
else
    product_name="acunetix_trial"
fi


for i in "$@"
do
case $i in
    --user=*)
    linux_user="${i#*=}"
    echo Using username "$linux_user"
    ;;
    -e | --engineonly ) engine_only=1 ;;
    -f | --force ) no_dependency_check=1 ;;
esac
done

show_eula(){
    echo Please read the following License Agreement. You must accept the terms of this
    echo agreement before continuing with the installation.
    echo press ENTER to continue
    printf ">>> "
    read -r dummy
    pager="cat"

    if command -v "more" > /dev/null 2>&1; then
      pager="more"
    fi

    "$pager" <<EOF
Product: Acunetix on-premises web vulnerability scanner and vulnerability management solution

END-USER LICENSE AGREEMENT

Definitions
"End-User License Agreement" ("EULA") or "License" means this End-User License Agreement.
"You", or "Licensee", or "End-User" means an individual or a single entity, corporate or other statutory body with legal personality that is granted a License by Acunetix Ltd, and is deemed to hold that License.

U.S. Government exception for definition of "You", "Licensee" or "End-User":
In the event that the customer is a United States (U.S.) Government customer, as per General Service Administration (GSA) Schedule contracts or similar government frameworks, then "You", or "Licensee", or "End-User" is defined as an "entity authorized to order under GSA Schedule contracts as defined in" respective GSA Orders, "as may be revised from time to time" and the term definition as an "individual" is strictly excluded. The Licensee cannot be an individual because any implication of individual licensing triggers the requirements for legal review by Federal Employee unions. Conversely, because of competition rules, the contractor must be defined as a single entity even if the contractor is part of a corporate group. The Government cannot contract with a group, or in the alternative, with a set of contracting parties.

"Product" means the Acunetix on-premises web vulnerability scanner and vulnerability management solution, which includes computer software that must run on a Workstation Computer and may include associated media, printed materials, and online or electronic documentation.
"Trial Edition" means a version of the Product, which may have reduced functionality, and is available for a limited period of time.
"Workstation Computer" means a single computer, such as a workstation, terminal or other device.
"Edition" means a particular form in which the Product is issued, with particular permissions, features and restrictions.
"Open Source" means computer software for which the source code is freely available according to the specific license under which that software is distributed.
"Intellectual Property Rights" means intellectual property rights, including patents, trademarks, design rights, copyrights, database rights, trade secrets and all rights of an equivalent nature anywhere in the world.
"Confidential Information" means any information disclosed by one party to another which is defined as confidential and proprietary as per the terms of this EULA. Acunetix recognizes that U.S. Government Federal agencies are subject to the Freedom of Information Act, 5 USC 552, which requires that certain information be released, despite being characterized as "confidential" by the vendor.
"Recipient" means a party receiving Confidential Information.
"Updates" means subsequent releases and error corrections for Product previously licensed, as published by Acunetix Ltd from time to time.
"Maintenance Agreement" ("MA") means a term service associated with a License that entitles the License holder to free version upgrades of the Product, as well as limited Support. Always associated with a "Perpetual License", a Maintenance Agreement is classified under GSA Special Item Number (SIN) 132-33 (software maintenance as a product) and is billed at the time of purchase.
"Upgrade Insurance" means the part of a Maintenance Agreement which provides access to the latest version of the Product to an End-User.
"Support" means the furnishing of technical assistance, code fixes, patches, remedies, provided on a best effort basis, via any telematic means chosen by Acunetix Ltd.
"Subscription License" means a term License with an expiry date. Such licenses are always deemed to be classified under GSA SIN 132-32 (term licenses).
"Acunetix Parties" means Acunetix Ltd and its parents, subsidiaries, shareholders, directors, officers, employees, licensors, suppliers and agents.

Scope IMPORTANT - READ CAREFULLY
This End-User License Agreement (EULA) is a legal agreement between You and Acunetix Ltd for the download, installation and use of the Product.

U.S. Government exceptions/addenda to "Scope":
Acunetix Ltd normally provides the Product subject to a software License Control Mechanism, embedded in the Product, which is designed to implement usage conditions that reflect the broad principles defined in this EULA.
The parties agree that it is not proportional nor reasonably practical for Acunetix Ltd to remove this element of the code from the Product to change the EULA embedded in its Product for the purpose of specific Federal Acquisition Regulation (FAR) or corporate purchasing procedure compliance.
Similarly, Acunetix Ltd recognizes that, under FAR 1.601(a), in an acquisition involving the use of appropriated funds, an agreement binding on the U.S. Government may only be entered into by an authorized contracting officer. Acunetix Ltd also recognizes that, under FAR 43.102, the same requirement applies to all contract modifications.
All terms and conditions must be included within a purchasing contract signed by the U.S. Government with Acunetix Ltd or its authorized distribution or resale channel partner.
In light of the above FAR clauses, the below EULA clauses (a), (c) and (d) referring to unilateral EULA updates by Acunetix Ltd, and acceptance of the EULA by the action of a U.S. Government employee clicking on a download or EULA acceptance button, do not apply to You if You are a U.S. Government customer purchasing the Product under GSA Schedule contracts or similar government frameworks.

Applicability for U.S. Government
The terms and conditions in this EULA are hereby incorporated by reference to the extent that they are consistent with Federal Law (e.g. the Anti-deficiency Act (31 U.S. Code (USC) 1341(a)(1)(B)), the Contracts Dispute Act of 1978 (41 USC 601 et seq., now 41 USC 7101 et seq.), the Prompt Payment Act, Anti-Assignment statutes (31 USC 3727 and 41 USC 15), Conduct of Litigation Reserved to Department of Justice (DOJ) (28 USC 516), and Patent and copyright cases (28 USC 1498)).
To the extent the Articles in the EULA are inconsistent with Federal Law (see FAR 12.212(a)), they shall be deemed to be modified as per Article 26 of this EULA, for any U.S. Government contracts.

Acunetix Ltd is willing to license the Product to You, the Licensee, ONLY IF YOU ACCEPT ALL THE TERMS OF THIS EULA. Acunetix Ltd is not willing to make the Product available under any other terms or subject to any other conditions.

a) Acunetix Ltd may from time to time revise this EULA (including by moving or deleting portions of, or adding to, the terms that govern Your use of the Product). You are bound by any such revisions. The text of this EULA can be provided on request. This clause (a) does not apply to You if You are a U.S. Government customer purchasing Product under GSA Schedule contracts or similar government frameworks for whom FAR 1.601(a), and FAR 43.102 apply.

b) YOU AGREE TO BE BOUND BY THE TERMS OF THIS EULA BY EXECUTING THIS AGREEMENT IN WRITING IF YOU ARE A U.S. GOVERNMENT CUSTOMER PURCHASING UNDER GSA SCHEDULE OR SIMILAR GOVERNMENT FRAMEWORK AGREEMENT AS PER FAR1.601(a) AND FAR 43.102.

c) IF YOU ARE NOT A U.S. GOVERNMENT CUSTOMER PURCHASING UNDER GSA SCHEDULE OR SIMILAR GOVERNMENT FRAMEWORK AGREEMENT, THEN YOU AGREE TO BE BOUND BY THE TERMS OF THIS EULA BY DOWNLOADING, INSTALLING, COPYING OR OTHERWISE USING THE PRODUCT. IF YOU DO NOT AGREE, DO NOT DOWNLOAD, INSTALL OR USE THE PRODUCT.

d) BEFORE YOU CLICK ON "Download" AT THE FULL VERSION DOWNLOAD PAGE, OR CHECK THE "I accept the agreement" BUTTON AND CLICK ON "Next" DURING INSTALLATION, CAREFULLY READ THE TERMS AND CONDITIONS OF THIS LICENSE. BY CHOOSING THE "I accept the agreement" BUTTON YOU ARE (1) REPRESENTING THAT YOU ARE OVER THE AGE OF 18 AND HAVE THE CAPACITY AND AUTHORITY TO BIND YOURSELF AND YOUR EMPLOYER, AS APPLICABLE, TO THE TERMS OF THIS LICENSE AND (2) CONSENTING ON BEHALF OF YOURSELF AND/OR AS AN AUTHORIZED REPRESENTATIVE OF YOUR EMPLOYER, AS APPLICABLE, TO BE BOUND BY THIS EULA. IF YOU DO NOT AGREE TO ALL OF THE TERMS AND CONDITIONS OF THIS EULA, OR DO NOT REPRESENT THE FOREGOING, DO NOT CLICK ON "Download" AT THE FULL VERSION DOWNLOAD PAGE, OR CHECK THE "I do not accept the agreement" BUTTON DURING THE INSTALLATION, IN WHICH CASE YOU WILL NOT AND MAY NOT RECEIVE, INSTALL OR USE THE PRODUCT. This clause (d) does not apply to You if You are a U.S. Government customer purchasing Product under GSA Schedule contracts or similar government frameworks for whom FAR 1.601(a), and FAR 43.102 apply.

e) Any use of the Product other than pursuant to the terms of this EULA is a violation of U.S. and international copyright laws and conventions.

Should You have any questions regarding this EULA, or should You wish to reject it, You must write to: Acunetix Ltd, Level 10, Portomaso Business Tower, St Julians STJ4011 Malta or email: sales@acunetix.com .
Grant, Reservation of Rights, Installation and Use, Storage and use over a Network

1. Grant
Subject to the terms and conditions of this EULA, Acunetix Ltd hereby grants to Licensee a limited, personal, non-exclusive, non-sublicensable, non-transferable License to install on magnetic or optical media and use a copy of the Product as expressly detailed herein and particularly as detailed in Articles 3 and 5 below.

The License granted to Licensee is expressly made subject to the following limitations:
Licensee may not itself (and shall not permit any third party to):
(i) Copy, other than as expressly permitted, all or any portion of the Product, except that Licensee may make one copy of the Product for archival purposes for use by Licensee only in the event the Product shall become inoperative;
(ii) Modify or translate the Product;
(iii) Modify, alter, or use the Product so as to enable more installations, scans, users, a longer term of use etc. than is authorized in the relevant Product purchase agreement;
(iv) Reverse engineer, decompile or disassemble the Product, in whole or in part;
(v) Use the Product to directly or indirectly provide a time-sharing or subscription service to any third party or to function as a service bureau or application service provider;
(vi) Create derivative works based on the Product;
(vii) Publicly display the Product;
(viii) Rent, lease, sublicense, sell, market, distribute, assign, transfer, or otherwise permit access to the Product to any third party;
(ix) Exceed the number of targets or concurrent scans or installs or users limit applicable to the particular Edition or version or type of license or part number of Product.

2. Reservation of Rights
Acunetix Ltd reserves all rights not expressly granted to You in this EULA. The Licensee may not exercise any right to the Product not expressly granted in this EULA.

3. Installation and use
(i) In the case of part numbers AOPSTAnnn, AOPPROnnn, AOPENTnnn (where nnn is 005 to 050), WVSE1P, WVSEU1Y, WVSEUP, WVSEU1Y10, WVSEUP10, WVSC1Y, WVSCP, WVSC1Y10, WVSCP10 and any associated Maintenance Agreements, You may install, use, access, display and run one copy of the Product on ONE (1) Workstation Computer accessed by the number of users allowed for that particular Edition.

(ii) If granted a License as per AOPPROUNL5, AOPENT AOPENTnnn (where nnn is 100 or greater), or any of the WVSFx group of part numbers (WVSF05Q, WVSF10Q, WVSF20Q, WVSF30Q, WVSF05QP, WVSF10QP, WVSF20QP, WVSF30QP), then this License allows You to install, use, access, display and run additional instances up to the maximum number specified in the description of that specific License, along with its associated terms, including the number of users that may access the same central management system, the number of satellite scan engines, the number of single user standalone installs that may be running on different multiple Workstation Computers, and the rate at which these could be deployed. The sum of the central management system, satellite engines and standalone installs may never exceed the number of engines in a Multi-Engine License. A Multi-Engine License may not be redeployed without a valid Maintenance Agreement.

(iii) You must only use the Product according to the Edition for which it was sold.

(iv) You are only entitled to use the Product to scan: (i) your own websites or web applications and (ii) third party websites or web applications (i.e. sites or applications that are not owned by the holder of this EULA) if You have obtained permission from the website or web application owner to do so.

(v) Furthermore, You acknowledge that scanning a website or web application is best performed on a copy of the live production website or web application, typically referred to as a staging server, as per industry best practices.
If You are a U.S. Government customer purchasing this Product under GSA Schedule contracts or similar government frameworks for whom anti-deficiency laws (31 USC 1341 and 41 USC) apply, then You do not agree to indemnify Acunetix Parties. If you are not a U.S. Government customer purchasing this Product under GSA Schedule contracts or similar government frameworks, You also automatically indemnify Acunetix Parties from any damages ensuing from Your incorrect or unplanned use of the Product.

U.S. Government exceptions/addenda to Article 3.(v):
The U.S. Government agrees to promptly consider and adjudicate any and all claims made by Acunetix Ltd which may arise out of use of this License by the Government, duly authorized representatives, or contractors of the Government, and to pay for any damage or injury as may be required by Federal law. Such adjudication will be in accordance with the Federal Tort Claims Act or such other legal authority as may be pertinent.

4. Storage and use over a Network
In the case of part numbers AOPSTAnnn, AOPPROnnn, AOPENTnnn (where nnn is 005 to 050), WVSE1P, WVSEU1Y, WVSEUP, WVSEU1Y10, WVSEUP10, WVSC1Y, WVSCP, WVSC1Y10, WVSCP10 and any associated Maintenance Agreements, You may also store or install a copy of the Product on a storage system, such as a network server or a storage area network, which can be used only to install or run the Product on Your other Workstation Computers over an internal network; however, You must acquire and dedicate an additional License for each separate Workstation Computer on or from which the Product is installed, used, accessed, displayed or run or purchase the appropriate multi-user and/or multi-engine License. A single user or single engine License for the Product may NOT be shared or used, concurrently or not, on different Workstation Computers.

Software As A Service, Managed Service Provider, Application Service Provider License Agreements, Trial Edition and Proof of Concept Licenses, Not for Resale License, Beta-Testing, Additional Software

5. Software As A Service, Managed Service Provider, Application Service Provider License Agreements
This EULA does not grant You any right to run any form of Software As A Service, Managed Service Provider, or Application Service Provider, or any other such form of automated or semi-automated, membership or subscription based, shared use services using the Product. Should You wish to use the technology embedded in the Product to provide such services, You acknowledge that You are obliged to inform Acunetix Ltd of Your intended mode of use of the Product, and seek the necessary commercial arrangements with Acunetix Ltd and special license agreements (part number WVSSPL) from Acunetix Ltd that Acunetix Ltd may or may not elect to furnish You with.

6. Trial Edition and Proof of Concept Licenses
If available, You may undertake a one-time evaluation of the time-limited Trial Edition which may have reduced functionality, at no cost, at Your own risk, solely to reach a purchase decision. At the end of the evaluation period, You must either License the Product, or cease all use of it. The Trial Edition shall be without warranty of any kind and is provided "AS IS". Acunetix Ltd may also elect to provide You with a time-limited Proof of Concept License. Whichever mode of evaluation is used, Acunetix Ltd has no obligation to provide Support during Your use of a Trial Edition or Proof of Concept License, insofar, that, if Acunetix Ltd elects to provide any such Support, it is understood by all parties, that this Support is provided solely on a voluntary best effort basis, without warranty of any kind. Consulting fees for extraordinary professional services could be requested from and be electively proposed by Acunetix Ltd for consideration.

7. Not for Resale License
Product identified as "Not for Resale" or "NFR," may not be resold, transferred or used for any purpose other than demonstration, test or evaluation.

8. Beta Testing
Time-limited Beta versions of Product may be provided to You, at no cost, at Your own risk, without warranty of any kind, "AS IS" and subject to the "General Confidentiality" provision described in this EULA (see Article 19 "General Confidentiality"), as well as the clear understanding that You are obliged to provide truthful, accurate and complete feedback on the Beta version of the Product, with no expectation of remuneration, and You agree to waive any claims for royalties or any other forms of remuneration, with Acunetix Ltd, on any use made by Acunetix Ltd of the feedback provided, in whatever form.

9. Additional Software
This EULA applies to updates or supplements to the original Product provided by Acunetix Ltd, unless we provide other terms along with the update or supplement.

Upgrades, No Downgrade, Maintenance Agreements (Upgrades, Updates and Support), Product Life, "End of Sales" and "End of Support"

10. Upgrades, No Downgrade
(i) Eligibility: To use a Product identified as an upgrade, You must first be licensed for the original product identified by Acunetix Ltd as eligible for the upgrade.
(ii) No Downgrade: Upgrades are elective. However, after exercising a right to upgrade, via Maintenance Agreement or otherwise, You may no longer use the product that formed the basis for Your upgrade eligibility. If you wish to test a new version prior to upgrading, You may submit commercially reasonable requests for Trial Edition or Proof of Concept Licenses for new version testing at sales@acunetix.com which will not be unreasonably withheld if You are already a customer.

11. Maintenance Agreements (Upgrades, Updates and Support)
(i) The Maintenance Agreement (MA) entitles the Licensee to Upgrade Insurance, as well as Support.
(ii) Upgrade Insurance includes patches as well as new versions of the Product.
(iii) Support shall be conveyed by telematic means to You in order to help You with Your ongoing use of the Product.
(iv) Support is available during normal business hours at Acunetix Ltd. Acunetix Ltd may at its own discretion and without engaging in any statements of service levels with customers, extend its Support availability to other time zones, where feasible.
(v) If MA is not included in the part number You are about to purchase, You can purchase the respective MA package no later than 30 days from the first DOWNLOAD or ACTIVATION of the Product against that License.
(vi) The same 30 day period applies when the MA expires and is up for renewal.
(vii) The MA is based on a "Use it or Lose it" principle. If the right to upgrade to the latest version is not invoked by installing the latest version of the Product and reactivating the license key before the expiry date of the MA, then that right will be lost when the MA expires.
(viii) If You do not purchase or renew the MA and wish to upgrade to the latest version once a new version is released, You will have to purchase a version upgrade.

U.S. Government exceptions/addenda to Article 11:
Acunetix Ltd will not automatically renew Licenses, nor levy penalties or fees without Your explicit consent. Acunetix Ltd declares that it will conform with the anti-deficiency and budgeting laws (31 USC 1341, 41 USC 11) and will only levy charges beyond a contract amount if specifically authorized by existing statutes, such as the Prompt Payment Act, or Equal Access to Justice Act.

12. Product Life, End of Sales and End of Support
Acunetix Ltd is not obliged to provide Support for, nor a backup copy of obsolete versions of the Product. You understand and accept that the version of the Product preceding the latest version will be immediately withdrawn from sales, will no longer be available for download, and Support for it will only be provided for a period of twelve (12) months after launch of the subsequent version, subject to the holding of a valid Maintenance Agreement (MA), or Subscription License, or any other similar such arrangement depending on the type of Product. Such Support will only be provided on a best effort basis and at the sole discretion of Acunetix Ltd. Should a remedy for the older version be deemed not feasible by Acunetix Ltd, it will not be obliged to provide a remedy for that older version, and you may invoke Your right to upgrade to the latest version of the Product, provided that You hold a valid MA.

The only rights You have in this respect are (a) to upgrade as per Acunetix Ltd's instructions, (b) continued use of the current Product version with its un-remedied flaws, or (c) reject the License, by discontinuing use of the Product (see Article 16 "Term, Termination").

Your inability to upgrade due to lack of MA will not open Acunetix Ltd up to any claims whatsoever due to Your inability to run the older version of the Product, for whatever reason such as, but not limited to, unavailability of older versions of underpinning technologies, obsolescence, changes in the underlying Operating System, i.e. changes that did not exist at the time of design of that particular version of the Product.

Limitation of Transfers, Content Updates and License Control Mechanism, Limitation on Reverse Engineering, Decompilation, and Disassembly, Term, Termination

13. Limitation of Transfers

Limitation of Transfer of Product to a different Workstation Computer
(i) With the exception of and as expressly permitted by specific Licenses, You may move the Product to a different Workstation Computer only in cases of catastrophic disaster (System Failure, Force Majeure), or due to obsolescence of the underlying Workstation Computer (Force Majeure). The degree or frequency at which this right can be invoked will be subject to scrutiny by Acunetix Ltd and whether it would be allowed is at the absolute discretion of Acunetix Ltd.

Transfer of License to a different License Holder, Exception to No Transfer Rule
(ii) The initial Licensee of the Product may make a one-time transfer of the Product to another end user only in cases of mergers, acquisitions or between 100% owned subsidiaries or filial business units of the same holding companies. The transfer has to include all component parts, media, printed materials, this EULA, and if applicable, the Certificate of Authenticity. The transfer may not be an indirect transfer, such as a consignment. For instance, the Product cannot be transferred to another Workstation Computer belonging to a service provider to deliver service using the same Product back to the original Licensee. In this case, a suitable license must be purchased by the service provider. Prior to the transfer, the end user receiving the transferred Product must agree to all the EULA terms.

No Rental
(iii) You may not rent, lease, or lend the Product.

Prior Authorisation Required
(iv) In cases 13(i) and 13(ii) described above, and with the exception of and as expressly permitted by specific Licenses in the case of 13(i) alone, You are obliged to inform Acunetix Ltd via sales@acunetix.com of all such transfers but cannot make the move unless authorisation is received. The acceptance or not of the Transfer of any Product License is at the absolute discretion of Acunetix Ltd. The onus of due diligence for proper record keeping and security of use of Licenses and the burden of liability for use of the Product is totally upon the Licensee.

U.S. Government exceptions/addenda to Article 13:
If a License Transfer is deemed to be an Assignment or Novation, Acunetix Ltd will abide by FAR 42.12 (Novation and Change-of-Name Agreements). Moreover, Assignments are subject to FAR 52.232-23 (Assignment of Claims) and the same FAR 42.12 (Novation and Change-of-Name Agreements).

14. Content Updates and License Control Mechanism
The Product requires, for optimum use, access to the Internet for regular updates. Such content may be provided for a limited time, from time to time, or in accordance with an applicable and valid Maintenance Agreement or Subscription License.

When receiving these updates, and also during the course of normal use of the Product, information is exchanged with Acunetix Ltd that consists of, among other items of information, the license key or code that prevents unlimited copying, or that limits the time of use or functionality in accordance with the type of License that You purchase.

You consent that the Product will automatically connect with Acunetix Ltd for this purpose, during installation, use, and updates, and will not hinder it in any way from connecting with Acunetix Ltd.

Furthermore, You agree to waive any expectation of ability to activate a License offline, a privilege which is only granted in certain specific special cases, which will only be granted at the absolute discretion of Acunetix Ltd, subject to absolute assurances that all principles and articles covered by this EULA are fully observed by the Licensee.

15. Limitation on Reverse Engineering, Decompilation, and Disassembly
You may not reverse engineer, decompile, or disassemble the Product, in any way. You may not engage in any activity that would impede, divert or otherwise tamper with the exchange of information with Acunetix Ltd, with a view to circumvent the licensing mechanism in place with the Product.

16. Term, Termination
Without prejudice to any other rights, Acunetix Ltd may revoke this EULA if You do not abide by the terms and conditions of this EULA.

U.S. Government exceptions/addenda to Article 16. Term, Termination:
Articles in the EULA referencing termination or cancellation are hereby deemed to be modified as per Article 26 if not in conformity with FAR 52.212-4 and the Contract Disputes Act 41. Without prejudice to its intellectual property rights, Acunetix Ltd will abide by FAR 52.233-1, FAR 12.302(b), the Prompt Payment Act (31 USC 3901 et seq.), Treasury regulations at 5 Code of Federal Regulations (CFR) 1315 and the Equal Access to Justice Act (5 USC 504) when submitting claims for non-performance of commercial and License obligations by Government. Termination will only be resorted to by Acunetix Ltd if such remedy is granted to it after conclusion of the Contracts Disputes Act dispute resolutions process or if such remedy is otherwise ordered by a United States Federal Court.

A Subscription License that has reached its expiry date is to be considered as terminated or revoked.

When a License is terminated, You must destroy all copies of the Product and all of its component parts.

In the case of a Subscription License a new Subscription License may be acquired to continue to use that installation of the Product.

Consent and use of Data, Publicity, General Confidentiality, Mutual NDA for Support purposes

17. Consent and use of Data
You agree that Acunetix Ltd and its affiliates may collect and use technical information You provide as a part of Your use of the Product primarily for the purposes described in Articles 11, 13, 14 and 15, for the Support purposes described in Article 19 and for general Product improvement, usage statistics, license verification, and market research. You acknowledge that the information collected may contain automated reporting routines that will automatically identify and analyze certain aspects of use and performance of the Product and/or the systems on which they are installed, including but not limited to: number of web sites configured in the Product, number of scans conducted, number of logins in the last 30 days, enabling of configurations settings, as well as the operator and operating environment (including features used and problems and issues that arise in connection therewith), and provide reports to Acunetix Ltd. You have the option of disabling the collection of the aforementioned information by contacting Acunetix's support team. Each party shall comply with its respective obligations under applicable data protection laws ("DPL"), as well as its respective obligations under local applicable legislation regarding customer trade secrets and any legislation regarding national security measures if contractually applicable.

18. Publicity
(i) If You are not a U.S. Government customer purchasing Product under GSA Schedule contracts or similar government frameworks, then You agree that Acunetix Ltd may refer to the name of Your corporation as a customer of Acunetix Ltd, both internally and in externally published media, unless You expressly, and in writing, restrict Acunetix Ltd from mentioning You. Any additional disclosure by Acunetix Ltd with respect to You or Your company shall be subject to Your prior written consent.

(ii) If You are a U.S. Government customer purchasing Product under GSA Schedule contracts or similar government frameworks, then all marketing shall be to the extent permitted by the General Services Acquisition Regulation (GSAR) 552.203-71. For the sake of clarity, Acunetix Ltd. shall not refer to such a purchase contract in commercial advertising or similar promotions in such a manner as to state or imply that the product or service provided is endorsed or preferred by the White House, the Executive Office of the President, or any other element of the Federal Government, or is considered by these entities to be superior to other products or services. Any advertisement by Acunetix Ltd. including price-off coupons, that refers to a military resale activity shall contain the following statement: "This advertisement is neither paid for nor sponsored, in whole or in part, by any element of the United States Government."

19. General Confidentiality, Mutual NDA for Support purposes

(i) General Confidentiality
You acknowledge that the Product and certain other materials are confidential as provided herein. Acunetix Parties' Confidential Information includes any and all information related to the services and/or business of Acunetix Parties that is treated as confidential or secret by Acunetix Parties (that is, it is the subject of efforts by Acunetix Parties, as applicable, that are reasonable under the circumstances to maintain its secrecy), including, without limitation:
a. The Product;
b. Any and all other information which is disclosed by Acunetix Ltd to You orally, electronically, visually, or in a document or other tangible form which is either identified as or should be reasonably understood to be confidential and/or proprietary; and,
c. Any notes, extracts, analysis, or materials prepared by You which are copies of or derivative works of Acunetix Parties' Confidential Information from which the substance of said information can be inferred or otherwise understood (the "Confidential Information").

(ii) Mutual Confidentiality for Support purposes
During the course of delivery of Support it will be necessary for Confidential Information to be exchanged between You and Acunetix Ltd. The Recipient may use such Confidential Information only for the purposes for which it was provided, and may disclose it only to employees, or contractors or partners, obligated to the Recipient under similar confidentiality restrictions and only for the purposes it was provided.

(iii) Confidential Information shall not include information which Recipient can clearly establish by written evidence:
a. Is already lawfully known to or independently developed by Recipient without access to the Confidential Information;
b. Is disclosed in non-confidential published materials;
c. Is generally known to the public; or
d. Is rightfully obtained from any third party without any obligation of confidentiality.

(iv) Recipient agrees not to disclose Confidential Information to any third party and will protect and treat all Confidential Information with the highest degree of care. Except as otherwise expressly provided in this EULA, Recipient will not use or make any copies of Confidential Information, in whole or in part, without the prior written authorisation of the other party. Recipient may disclose Confidential Information if required by statute, regulation, or order of a court of competent jurisdiction, provided that Recipient provides the other party with prior notice, discloses only the minimum Confidential Information required to be disclosed, and cooperates with the other party in taking appropriate protective measures. These obligations shall continue to survive indefinitely following termination of this License with respect to Confidential Information.

(v) In the absence of a prompt and equitable remedy for Your breach of EULA conditions, leading to termination of this EULA, Acunetix Parties will be permitted to use Confidential Information as evidence for the purpose of dispute resolution in a court of competent jurisdiction, while still conforming to applicable Data Protection Laws ('DPL') and applicable legislation regarding customer trade secrets, intellectual property and any legislation regarding national security.

U.S. Government exceptions/addenda to Article 19 General Confidentiality, Mutual NDA for Support purposes:
Acunetix Ltd agrees that the EULA contains no confidential or proprietary information and acknowledges that the EULA will be available to the public, and further the pricing terms, and associated documents shall not be deemed confidential.
Any provisions that require the Licensee to keep certain information confidential are subject to the Freedom of Information Act, 5 USC 552, and any order by a United States Federal Court.

Limited Warranty for Software Products, "As Is", Disclaimer of Warranties, Exclusion of Incidental, Consequential and Certain Other Damages, Disclaimer or Limitation of Liability and Remedies, Indemnification

20. Limited Warranty for Software Products
(i) Acunetix Ltd warrants that the Product will perform substantially in accordance with the accompanying materials for a period of thirty days from the date of receipt, provided you do not already have a Maintenance Agreement in place, in accordance with the terms of Articles 11 and 12 above.
(ii) Any supplements or updates to the Product, including without limitation, any (if any) service packs or hot fixes provided to You after the expiration of the thirty day Limited Warranty period are not covered by any warranty or condition, express, implied or statutory.
(iii) Limitation on Remedies, No Consequential or Other Damages: Your exclusive remedy for any breach of this Limited Warranty is as set forth below. Except for any refund elected by Acunetix Ltd, YOU ARE NOT ENTITLED TO ANY DAMAGES, INCLUDING BUT NOT LIMITED TO CONSEQUENTIAL DAMAGES, if the Product does not meet Acunetix Ltd's Limited Warranty, and, to the maximum extent allowed by applicable law, even if any remedy fails in its essential purpose. The terms of Article 22 below ("Exclusion of Incidental, Consequential and Certain Other Damages") are also incorporated into this Limited Warranty.
(iv) This Limited Warranty gives You specific legal rights. Acunetix Parties' entire liability and Your exclusive remedy shall be, at Acunetix Ltd's option from time to time exercised subject to applicable law:
(a) Return of the price paid (if any) for the Product; or
(b) Repair or replacement of the Product that does not meet this Limited Warranty and that is returned to Acunetix Ltd with a copy of Your receipt.
(v) You will receive the remedy elected by Acunetix Ltd without charge, except that You are responsible for any expenses You may incur (e.g. cost of shipping the Product to/from Acunetix Ltd). This Limited Warranty is void if failure of the Product has resulted from accident, abuse, misapplication, abnormal use or a virus. Any replacement Product will be warranted for thirty (30) days. To exercise Your remedy, contact Acunetix Ltd with proof of purchase from an authorized international source.
(vi) This Limited Warranty is the only express warranty made to You and is provided in lieu of any other express warranties (if any) created by any documentation or packaging.

21. "As Is", Disclaimer of Warranties
THE PRODUCT IS PROVIDED "AS IS." ACUNETIX LTD DOES NOT WARRANT THAT THE FUNCTIONS CONTAINED IN THE PRODUCT WILL MEET YOUR REQUIREMENTS, OR THAT THE OPERATION OF THE PRODUCT WILL BE UNINTERRUPTED OR ERROR-FREE, OR THAT DEFECTS IN THE PRODUCT WILL BE CORRECTED. FURTHERMORE, ACUNETIX LTD DOES NOT WARRANT OR MAKE ANY REPRESENTATIONS REGARDING THE USE OR THE RESULTS OF THE USE OF THE PRODUCT OR ANY DOCUMENTATION PROVIDED THEREWITH IN TERMS OF THEIR CORRECTNESS, ACCURACY, RELIABILITY, OR OTHERWISE. NO ORAL OR WRITTEN INFORMATION OR ADVICE GIVEN BY ACUNETIX PARTIES SHALL CREATE A WARRANTY OR IN ANY WAY INCREASE THE SCOPE OF THIS WARRANTY. ACUNETIX PARTIES DO NOT MAKE ANY, AND HEREBY SPECIFICALLY DISCLAIM ANY OTHER REPRESENTATIONS, ENDORSEMENTS, GUARANTIES, OR WARRANTIES, EXPRESSED, IMPLIED OR STATUTORY, RELATED TO THE PRODUCT INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTY OF MERCHANTABILITY, TITLE, FITNESS FOR A PARTICULAR PURPOSE, ACCURACY OR COMPLETENESS OF RESPONSES, OF RESULTS, OF WORKMANLIKE EFFORT, OF LACK OF VIRUSES, AND OF LACK OF NEGLIGENCE, AND THE PROVISION OF OR FAILURE TO PROVIDE SUPPORT. THERE IS NO WARRANTY OR CONDITION OF TITLE, QUIET ENJOYMENT, QUIET POSSESSION, CORRESPONDENCE TO DESCRIPTION OR NON-INFRINGEMENT (OF INTELLECTUAL PROPERTY RIGHTS OR OTHERWISE) WITH REGARD TO THE PRODUCT.

22. Exclusion of Incidental, Consequential and Certain Other Damages
TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, IN NO EVENT SHALL ACUNETIX PARTIES BE LIABLE FOR ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES WHATSOEVER (INCLUDING, BUT NOT LIMITED TO, DAMAGES FOR LOSS OF PROFITS OR CONFIDENTIAL OR OTHER INFORMATION, FOR BUSINESS INTERRUPTION, FOR PERSONAL INJURY, FOR LOSS OF PRIVACY, FOR FAILURE TO MEET ANY DUTY INCLUDING OF GOOD FAITH OR OF REASONABLE CARE, FOR NEGLIGENCE, AND FOR ANY OTHER PECUNIARY OR OTHER LOSS WHATSOEVER) ARISING OUT OF OR IN ANY WAY RELATED TO THE USE OF OR INABILITY TO USE THE PRODUCT, THE PROVISION OF OR FAILURE TO PROVIDE SUPPORT, OR OTHERWISE UNDER OR IN CONNECTION WITH ANY PROVISION OF THIS EULA, EVEN IN THE EVENT OF THE FAULT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY, BREACH OF CONTRACT OR BREACH OF WARRANTY OF ACUNETIX PARTIES, AND EVEN IF ACUNETIX PARTIES HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

23. Disclaimer or Limitation of Liability and Remedies
Notwithstanding any damages that You might incur for any reason whatsoever (including, without limitation, all damages referenced above and all direct or general damages), the entire liability of Acunetix Parties under any provision of this EULA and Your exclusive remedy for all of the foregoing (except for any remedy of repair or replacement elected by Acunetix Ltd with respect to any breach of the Limited Warranty) shall be limited to the greater of the amount actually paid by You for the Product, during the preceding 12 months, or U.S.$5.00. The foregoing limitations, exclusions and disclaimers (including Sections 20, 21 and 22 above) shall apply to the maximum extent permitted by applicable law, even if any remedy fails its essential purpose.

U.S. Government exceptions/addenda to Article 22. Exclusion of Incidental, Consequential and Certain Other Damages, and 23, Disclaimer or Limitation of Liability and Remedies:
Acunetix Ltd and the Licensee shall not be liable for any indirect, incidental, special, or consequential damages, or any loss of profits, revenue, data, or data use. Furthermore, Acunetix Ltd and the Licensee shall not be liable for punitive damages except to the extent this limitation is prohibited by applicable law. This clause shall not impair the U.S. Government's right to recover for fraud or crimes arising out of or related to a U.S. Government contract under any federal fraud statute, including the False Claims Act, 31 USC 3729-3733, and for any other matter for which liability cannot be excluded by law.

24. Indemnification
If You are not a U.S. Government customer purchasing the Product under GSA Schedule contracts or similar government frameworks, then You agree to indemnify, defend, and hold Acunetix Parties harmless from any claim, loss, demand, or damage, including reasonable attorneys' fees, asserted by any third party due to or arising out of Your breach of any provision of this EULA, Your negligent or wrongful acts, and/or Your violation of any applicable laws.

U.S. Government exceptions/addenda to Article 24. Indemnification:
Article 24. Indemnification does not apply to You if You are a U.S. Government customer purchasing the Product under GSA Schedule contracts or similar government frameworks for whom anti-deficiency laws 31 USC 1341 and 41 USC 6301 apply.

Entire Agreement and Severability, US Government End Users, Governing Law, Equitable Relief, No Waiver or Delay

25. Entire Agreement
The entire agreement consists of this EULA and any addendum or amendment to this EULA which is included with the Product. If You are also a U.S. Government customer purchasing Product under GSA Schedule contracts or similar government frameworks, then the underlying GSA Schedule Contract, Schedule Pricelists and associated Purchase Order(s) will also form part of the entire agreement.

This, therefore, is the entire agreement between You and Acunetix Ltd relating to the Product and Support (if any) and they supersede all prior or contemporaneous oral or written communications, proposals and representations with respect to the Product or any other subject matter covered by this EULA. To the extent the terms of any Acunetix Ltd terms and conditions, policies or programs for Support conflict with the terms of this EULA, the terms of this EULA shall prevail.

In addition, if You are not a U.S. Government customer purchasing Product under GSA Schedule contracts or similar government frameworks, then the terms set out in this EULA shall prevail and control over any and all additional or conflicting terms or provisions contained in any document of Yours, whether set out in a purchase order or alternative license, and any and all such additional or conflicting terms shall be void and shall have no effect.

If this License is translated into a language other than English and there are conflicts between the translations, the English version shall prevail and control.

This EULA:
(i) May not be assigned by You. Any purported assignment will be null and void;
(ii) May not be amended by You, but Acunetix Ltd may amend the EULA from time to time and shall incorporate any amended EULA in the latest current version of the Product available as a download from the website at www.acunetix.com and may be provided upon request;
(iii) Constitutes the entire understanding between the parties with respect to the subject matter of this EULA and supersedes all written and oral prior agreements, negotiations and discussions between the parties relating to it; and
(iv) Is for the sole benefit of Acunetix Ltd and You and nothing herein, express or implied, is intended to or shall confer upon any other person or entity any legal or equitable right, benefit or remedy of any nature whatsoever under or by reason of this EULA.

U.S. Government exceptions/addenda to Article 25 Entire Agreement:
Acunetix Ltd recognizes that, under FAR 43.102, any contract modifications affecting the rights of the parties may only be entered into by an authorized contracting officer.
All modifications to the current terms and conditions must be included within a contract amendment signed by the U.S. Government with Acunetix.
Moreover, both Acunetix Ltd and Licensee will abide by FAR 52.232-23 (Assignment of Claims) and FAR 42.12 (Novation and Change-of-Name Agreements).

26. Severability
If any part of any provision of this EULA is found to be illegal, invalid or unenforceable, that provision shall apply with the minimum modification necessary to make it legal, valid and enforceable.
Paragraph headings are for convenience and shall have no effect or interpretation.

27. US Government End Users
The Product is a "commercial item," as defined in 48 CFR 2.101, consisting of "commercial computer software" and "commercial computer software documentation," as such terms are used in 48 CFR 12.212. Consistent with 48 CFR 12.212 and 48 CFR 227.7202-1 through to 227.7202-4, as applicable, all U.S. Government End Users acquire the Product with only those rights set forth herein.

Provided that, any purchases by U.S. Government End Users under a General Services Administration (GSA) Schedule or similar purchasing framework must conform with Federal Law and pre-agreed GSA Schedule or other framework agreement terms between the GSA or other framework and Acunetix Ltd.

To the extent the terms and conditions in this EULA are inconsistent with Federal Law they shall be deemed to be modified as per Article 26 for any U.S. Government contracts.

28. Governing Law
This EULA shall be governed by and construed in accordance with the laws of England, without regard to conflict of law provisions thereto. You submit to the jurisdiction of any court sitting in England, in any action or proceeding arising out of or relating to this EULA and agree that all claims in respect of the action or proceeding may be heard and determined in any such court. There shall be no class action, arbitration or litigation pursuant to this EULA. Acunetix Ltd may seek injunctive relief in any venue of its choosing. You hereby submit to personal jurisdiction in such courts. The parties hereto specifically exclude the United Nations Convention on Contracts for the International Sale of Goods and the Uniform Computer Information Transactions Act (UCITA) from this EULA and any transaction between them that may be implemented in connection with this License. The original of this EULA has been written in English. The parties hereto waive any statute, law, or regulation that might provide an alternative law or forum or to have this EULA written in any language other than English.

29. Equitable Relief
It is agreed that because of the proprietary nature of the Product, Acunetix Parties' remedies at law for a breach by You of its obligations under this EULA will be inadequate and that Acunetix Parties shall, in the event of such breach, be entitled to, in addition to any other remedy available to it, equitable relief, including injunctive relief, without the posting of any bond and in addition to all other remedies provided under this License or available at law.


U.S. Government exceptions/addenda to Articles 28. Governing Law, and 29. Equitable Relief:
In the case of U.S. Government customers, the validity, interpretation and enforcement of this EULA will be governed by and construed in accordance with the Federal laws of the United States.
Furthermore, Acunetix Ltd accepts that depending on the cause of action, both venue and the statute of limitations are mandated by applicable Federal law.
The Armed Service Board, the Civilian Board of Contract Appeals (CBCA), the Tennessee Valley Authority Board, the Postal Service Board, or other agency boards, where applicable, and subject to their jurisdiction on a contract in dispute, are accepted by Acunetix Ltd to be adequate, binding alternative dispute resolution venues.
You accept that Acunetix Ltd reserves the right to seek redress in the U.S. Court of Federal Claims, or, in the subset of claims where U.S. District Courts may have concurrent jurisdiction with the U.S. Court of Federal Claims, both parties may agree to hearings in a U.S. District Court, located in a specific state, and You hereby submit to jurisdiction in such courts.
Articles in the EULA referencing equitable remedies are deemed not applicable to U.S. Government contracts and are therefore deemed to be modified as per Article 26.

30. No Waiver or Delay
Furthermore, the delay or failure of Acunetix Ltd to exercise any right provided in the EULA shall not be deemed a waiver of such right. Any express waiver, delay or failure by Acunetix Ltd to exercise promptly any right under this EULA due to will not create a continuing waiver or any expectation of non-enforcement.

31. Force Majeure
A party is not liable under this EULA for non-performance caused by events or conditions beyond that party's control if that party makes reasonable efforts to perform. This provision does not relieve You of Your obligation to make all payments due.

U.S. Government exceptions/addenda to Article 31. Force Majeure:
Acunetix Ltd accepts the terms and conditions outlined in FAR 52.212-4(f) Excusable delays.

Copyright Notices, Trademarks, Logos and Product Designs, Third Party Licensors, Open Source, Ownership, Intellectual Property Rights

32. Copyright Notices, Trademarks, Logos and Product Designs
The Product is protected by copyright and all other applicable intellectual property laws and treaties of the United States and other nations and by any international treaties, unless specifically excluded herein. Acunetix Parties own the title, copyright, and other Intellectual Property Rights in the Product.

Acunetix is copyright (c) 2005-2017 of Acunetix Ltd. All rights reserved. Acunetix is a registered trademark of Acunetix Ltd in the US, Europe and other countries. Acunetix and the Acunetix logo are registered trademarks of Acunetix Ltd in the US, Europe and other countries. All other trademarks and service marks and shape marks are the property of their respective owners.

33. Third Party Licensors
You acknowledge that the Product includes software applications and tools licensed to Acunetix Ltd by those third parties. This third-party software included in the Product is provided "AS IS" and without any warranty of any kind.
The Product is licensed for United States Patent No US 6,584,569.

34. Open Source
Part of the Product may incorporate and consist of third party Open Source software, which You may use under the terms and conditions of the specific license under which the Open Source software is distributed. Title to software remains with the applicable licensor(s). Any Open Source provided with or contained in the Product is provided "AS IS" and without any warranty of any kind.

U.S. Government addendum to Articles 33. Third Party Licensors and Article 34. Open Source:
Acunetix Ltd warrants to the U.S. Government Licensee that it has fully assessed all licensing implications of third-party and Open Source software use when Product is used by the Licensee as per Product documentation and that the Licensee will not be impacted in any way.

35. Ownership, Intellectual Property Rights
This License does not convey to Licensee an interest in or to the Product, but only a limited right of use revocable in accordance with the terms of this License. Acunetix Parties own all right, title and interest in and to the Product. No license or other right in or to the Product is granted to Licensee except for the rights specifically set forth in this License. Licensee hereby agrees to abide by all applicable laws and international treaties, and undertakes to inform Acunetix Ltd of any suspected breach of Intellectual Property Rights belonging to Acunetix Parties.

EOF
    echo
    echo "Accept the license terms? [yes|no]"
    printf "[no] >>> "
    read -r ans
    while [ "$ans" != "yes" ] && [ "$ans" != "Yes" ] && [ "$ans" != "YES" ] && \
          [ "$ans" != "no" ]  && [ "$ans" != "No" ]  && [ "$ans" != "NO" ]
    do
        echo "Please answer 'yes' or 'no':'"
        printf ">>> "
        read -r ans
    done
    if [ "$ans" != "yes" ] && [ "$ans" != "Yes" ] && [ "$ans" != "YES" ]
    then
        echo "License terms were rejected. Aborting installation."
        exit 2
    fi
}

exit_with_error()
{
    if [ ! -z $1 ]; then
        echo "$@" | fold -sw80
    else
        echo "Aborting installation"
    fi

    exit -1
}

check_for_dependencies()
{
    if [ -z "$shared_obj_deps" ]; then
        echo "Warning: no dependencies configured."
        return 1
    fi

    if [ ! -z "$no_dependency_check" ]; then
        echo "Warning: dependency check disabled."
        return 1
    fi

    ldconfig_output="$(ldconfig -p)"

    all_dependency_met=1

    echo "Checking for dependencies..."

    for i in ${shared_obj_deps[@]}; do
        if [[ ! $ldconfig_output =~ "${i}" ]]; then
           echo "    - dependency $i not found on the system"
           all_dependency_met=0
        fi
    done

    if [ "$all_dependency_met" = "0" ]; then
        echo "Some dependencies are not found on the system. Aborting installation."
        exit_with_error
    fi
}

check_os(){

    if [ "$EUID" -ne 0 ]
        then echo "The installer needs to be run as root."
        exit_with_error
    fi

    echo
    echo "Checking os..."
    # for now we check only for 64 bits
    uname -a | grep --quiet x86_64

    if [ "$?" -ne 0 ] ; then
        echo "Acunetix requires a 64-bit operating system."
        exit_with_error
    fi
}

check_for_open_ports(){

    if [ "$1" != "engineonly" ]; then
        echo "Checking database port..."
        lsof -i:$db_port -n > /dev/null 2>&1

        if [ "$?" -eq 0 ] ; then
            echo "Acunetix requires tcp port $db_port to be unused."
            exit_with_error
        fi
    fi

    echo "Checking backend port..."
    lsof -i:$server_port -n > /dev/null 2>&1

    if [ "$?" -eq 0 ] ; then
        echo "Acunetix requires tcp port $server_port to be unused."
        exit_with_error
    fi
}


random_string () {
    cat /dev/urandom|base64|tr -dc [:alnum:]|head -c $1
}

start_the_database_process()
{
    echo
    echo "Starting the database process..."
    sudo -u $linux_user $db_pgdir/bin/pg_ctl -D $db_datadir -o "--port=$db_port" -w start >> $install_log 2>&1
    if [ "$?" -ne 0 ]; then
        echo "Problems starting the database process."
        exit_with_error
    fi
}

stop_the_database_process()
{
    echo "Stopping the database process..."
    sudo -u $linux_user $db_pgdir/bin/pg_ctl -D $db_datadir -w stop >> $install_log 2>&1
}


get_password_score()
{
    score=0
    if [[ $1 =~ [A-Z] ]]; then
            #echo "CAPS found"
            score=$(( $score+1 ))
    fi

    if [[ $1 =~ [a-z] ]]; then
            #echo "normal found"
            score=$(( $score+1 ))
    fi

    if [[ $1 =~ [0-9] ]]; then
            #echo "number found"
            score=$(( $score+1 ))
    fi

    if [[ $1 =~ [!-/:-@\[-\`{-~] ]]; then
            #echo "special found"
            score=$(( $score+1 ))
    fi

    return $score
}


configure_master_user(){

    echo
    echo "Configuring the master user..."

    local master_password2=
    local regex="^([A-Za-z0-9]+(\.|\-|\_)?){1,}@([A-Za-z0-9]+(\.|\-|\_)?){1,}\.([A-Za-z]{2,})+"
    while true; do
        read -p '    Email: ' master_user

        echo $master_user | egrep --quiet $regex

        if [ "$?" -eq 0 ] ; then
            break
        else
            echo "    Bad email format"
        fi

    done

    while true; do
        read -sp '    Password: ' master_password

        echo

        if [ ${#master_password} -lt 8 ]; then
            echo "    Password has to be of minimum 8 characters, containing at least 3 of the following:"
            echo "    1 number, 1 small letter, 1 capital letter and 1 special character e.g. !@#$% etc."
            continue
        fi

        get_password_score $master_password

        if [ $? -lt 3 ]; then
            echo "    Password has to be of minimum 8 characters, containing at least 3 of the following:"
            echo "    1 number, 1 small letter, 1 capital letter and 1 special character e.g. !@#$% etc."
            continue
        fi

        read -sp '    Password again: ' master_password2
        echo
        [ "$master_password" = "$master_password2" ] && break
        echo "Passwords don't match"
    done
}

run_db_script(){

    echo "$1"
    sudo -u $linux_user PGPASSWORD=$db_password $db_pgdir/bin/psql -q -d $db_name -f $2 -b -h $db_host -p $db_port -U $db_user -v ON_ERROR_STOP=1 >> $install_log 2>&1

    if [ "$?" -ne 0 ]; then
        echo "Error running SQL script."
        stop_the_database_process
        exit_with_error
    fi
}

run_db_sql(){

    echo "$1"
    sudo -u $linux_user PGPASSWORD=$db_password $db_pgdir/bin/psql -q -d $db_name -c "$2" -b -h $db_host -p $db_port -U $db_user -v ON_ERROR_STOP=1 >> $install_log 2>&1
    if [ "$?" -ne 0 ]; then
        echo "Error running SQL command."
        stop_the_database_process
        exit_with_error
    fi
}

clean_install_create_database(){

    echo
    echo "Installing the database..."

    db_password=$(random_string 32)

    echo -n $db_password > $temp_dir/pw
    sudo -u $linux_user $db_pgdir/bin/initdb --auth=md5 --encoding=UTF8 --no-locale --username=$db_user --pwfile=$temp_dir/pw --pgdata=$db_datadir >> $install_log 2>&1

    if [ "$?" -ne 0 ]; then
        rm $temp_dir/pw
        echo "Error creating the database."
        exit_with_error
    fi

    rm $temp_dir/pw

    start_the_database_process

    sudo -u $linux_user PGPASSWORD=$db_password $db_pgdir/bin/createdb -h $db_host -p $db_port -U $db_user $db_name "Acunetix Database" >> $install_log 2>&1

    run_db_script "   - Create database"  $base_folder/data/temp/create_database.sql
    run_db_script "   - Populate database"  $base_folder/data/temp/static_data.sql
    run_db_script "   - Add new vulnerability data" $base_folder/data/temp/upsert_vtypes.sql
    run_db_script "   - Updating script versions" $base_folder/data/temp/script_versions.sql

    run_db_sql "   - Creating the master user" "INSERT INTO users \
            (user_id, email, password, enabled, first_name) \
            VALUES ('986ad8c0a5b3df4d7028d5f3c06e936c', '$master_user', encode(digest('$master_password', 'sha256'), 'hex'), true, 'Administrator')"

    stop_the_database_process
}


patch_wvsc_ini()
{
    local v1="$base_folder/$version/scanner"
    local v2="$base_folder/data"

    ve1=${v1//\//\\\/}
    ve2=${v2//\//\\\/}

    sudo -u $linux_user sed -i "s/AppPath=\./AppPath=$ve1/g" $v1/wvsc.ini
    sudo -u $linux_user sed -i "s/DataPath=\.\.\.\.\/data/DataPath=$ve2/g" $v1/wvsc.ini
}

create_uninstall()
{
    echo "Creating uninstall..."
    sudo -u $linux_user cp $base_folder/data/templates/linux/uninstall.sh $base_folder/uninstall.sh
    sudo -u $linux_user sed -i "s/##linux_user##/$linux_user/g" $base_folder/uninstall.sh
    sudo -u $linux_user sed -i "s/##setup_type##/$setup_type/g" $base_folder/uninstall.sh
    chmod +x $base_folder/uninstall.sh
    chown $linux_user: $base_folder/uninstall.sh
}

create_password_change()
{
    sudo -u $linux_user cp $base_folder/data/templates/linux/change_credentials.sh $base_folder/change_credentials.sh
    sudo -u $linux_user sed -i "s/##linux_user##/$linux_user/g" $base_folder/change_credentials.sh
    sudo -u $linux_user sed -i "s/##product_name##/$product_name/g" $base_folder/change_credentials.sh
    chmod +x $base_folder/change_credentials.sh
    chown $linux_user: $base_folder/change_credentials.sh
}

create_ini_file()
{
    echo "Saving settings..."

    target_secret_salt=$(random_string 32)
    session_secret=$(random_string 32)
    uploads_salt=$(random_string 32)
    sudo -u $linux_user cat << EOF > $base_folder/wvs.ini
logging.file.file_name=~/.$product_name/logs/backend.log
base_storage=~/.$product_name/data
logging.file.level=INFO
server.address=0.0.0.0
server.port=$server_port
server.host=$host_name
server.frontend.session_secret=$session_secret
wvs.temp_dir=~/.$product_name/data/temp
target_secret_salt=$target_secret_salt
uploads_salt=$uploads_salt
server.ssl.certificate=~/.$product_name/data/certs/server.cer
server.ssl.private_key=~/.$product_name/data/certs/server.key
databases.connections.master.connection.user=$db_user
databases.connections.master.connection.host=$db_host
databases.connections.master.connection.port=$db_port
databases.connections.master.connection.db=$db_name
databases.connections.master.connection.password=$db_password
server.static_document_root=~/.$product_name/$version/ui
wvs.app_dir=~/.$product_name/$version/scanner
EOF

    if [ "$1" = "engineonly" ]; then
        echo "engineonly=1" >> $base_folder/wvs.ini
    fi

    chown $linux_user: $base_folder/wvs.ini

    sudo -u $linux_user chmod u=rw,g=rw,o= $base_folder/wvs.ini
}


registering_the_service()
{
    echo "Registering service..."
    cat << EOF > /etc/systemd/system/"$product_name".service

[Unit]
Description=Acunetix Service
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=20
User=$linux_user
ExecStart=$base_folder/start.sh

[Install]
WantedBy=multi-user.target
EOF

    systemctl enable "$product_name"
    systemctl daemon-reload

}

create_startup_script()
{
    echo "Creating the startup script..."

    sudo -u $linux_user cp $base_folder/data/templates/linux/start.sh $base_folder/start.sh

    sudo -u $linux_user sed -i "s/##version##/$version/g" $base_folder/start.sh
    sudo -u $linux_user sed -i "s/##db_port##/$db_port/g" $base_folder/start.sh
    sudo -u $linux_user sed -i "s/##product_name##/$product_name/g" $base_folder/start.sh

    if [ "$1" = "engineonly" ]; then
        sudo -u $linux_user sed -i "s/engine_only=0/engine_only=1/g" $base_folder/start.sh
    fi

    chmod +x $base_folder/start.sh
    chown $linux_user: $base_folder/start.sh
}

extract()
{

    echo
    echo "Extracting files to $base_folder...."

    if [ -z "$data_offset" ]; then
        sudo -u $linux_user tar xjf acunetix_"$version_numeric"_x64.tar.bz -C $base_folder
    else
        tail -n +$data_offset $0|sudo -u $linux_user tar xjf - -C $base_folder
    fi
}

clean_install_init_filesystem()
{
    echo
    echo "Initializing file system..."

    sudo -u $linux_user mkdir $base_folder

    #sudo -u $linux_user chmod u=rw,g=rw,o= $base_folder

    temp_dir=$base_folder/temp
    sudo -u $linux_user mkdir $temp_dir

    db_datadir=$base_folder/db
    sudo -u $linux_user mkdir $db_datadir

    logs_dir=$base_folder/logs
    sudo -u $linux_user mkdir $logs_dir

    extract
    sudo -u $linux_user mv --update $base_folder/$version/data $base_folder/data

    db_pgdir=$base_folder/$version/database

    sudo -u $linux_user mkdir $base_folder/data/bxss
    sudo -u $linux_user mkdir $base_folder/data/certs
    sudo -u $linux_user mkdir $base_folder/data/http_resp
    sudo -u $linux_user mkdir $base_folder/data/license
    sudo -u $linux_user mkdir $base_folder/data/scans
    sudo -u $linux_user mkdir $base_folder/data/targets
}

generate_certificates() {
    echo
    echo "Generating certificates..."
    if [[ ! -f $base_folder/data/certs/server.key || ! -f $base_folder/data/certs/server.cer ]];then
        if [ ! -d $base_folder/data/certs ]; then
            sudo -u $linux_user mkdir $data_folder/certs
        fi
        if [[ ! -f $base_folder/data/certs/ca.key || ! -f $base_folder/data/certs/ca.cer ]];then
            echo " Generating certificate authority & certificates"
            sudo -u $linux_user $base_folder/$version/scanner/certgen /a /d $base_folder/data/certs /c $host_name #> /dev/null 2>&1
        else
            echo " Generating certificates"
            sudo -u $linux_user $base_folder/$version/scanner/certgen /d $base_folder/data/certs /c $host_name #> /dev/null 2>&1
        fi
    fi
}

configure_hostname()
{
    echo
    echo "Configuring hostname..."
    echo     Insert new hostname, or leave blank to use "$host_name"

    read -p "    Hostname [$host_name]:" hn
    if [ -z "$hn" ]; then
        echo "    Using hostname $host_name"
    else
        host_name="$hn"
    fi
}

configure_linux_user()
{
    echo
    echo "Configuring $linux_user user..."

    id -u $linux_user >> /dev/null 2>&1

    if [ "$?" -eq 0 ]; then
        echo "    User $linux_user already exist."
    else
        echo "    Creating user $linux_user."

        # attempt to create the group
        groupadd $linux_group > /dev/null 2>&1
        useradd -g $linux_group -r -m $linux_user > /dev/null 2>&1
        if [ "$?" -ne 0 ]; then
            echo "Error creating the user."
            exit_with_error
        fi
    fi

    id -u $linux_user >> /dev/null 2>&1;
    if [ "$?" -ne 0 ]; then
        echo "User $linux_user not found."
        exit_with_error
    fi

    if [ ! -d /home/$linux_user ]; then
        echo "Home directory for user $linux_user not found."
        exit_with_error
    fi
}

add_shortcut()
{
    echo
    echo "Adding LSR shortcuts..."
    cat << EOF > /usr/bin/"$product_name"-login-recorder
#!/bin/bash
echo Acunetix Login Sequence Recorder
$base_folder/$version/scanner/node lsr wizard "$@" > /dev/null 2>&1
EOF
    cat << EOF > /usr/bin/"$product_name"-login-editor
#!/bin/bash
echo Acunetix Login Sequence Editor
$base_folder/$version/scanner/node lsr standalone "$@" > /dev/null 2>&1
EOF
    chmod a+x /usr/bin/"$product_name"-login-recorder
    chmod a+x /usr/bin/"$product_name"-login-editor
}

get_settings_from_ini()
{
    db_user=$(awk -F "=" '/databases.connections.master.connection.user/ {print $2}' $base_folder/wvs.ini)
    if [ -z "$db_user" ]; then
        echo "Previous Acunetix installation found at $base_folder, but has invalid wvs.ini file."
        echo "Remove $base_folder and re-run the installer for a fresh install."
        echo
        exit_with_error
    fi

    db_host=$(awk -F "=" '/databases.connections.master.connection.host/ {print $2}' $base_folder/wvs.ini)
    if [ -z "$db_host" ]; then
        echo "Previous Acunetix installation found at $base_folder, but has invalid wvs.ini file."
        echo "Remove $base_folder and re-run the installer for a fresh install."
        echo
        exit_with_error
    fi

    db_port=$(awk -F "=" '/databases.connections.master.connection.port/ {print $2}' $base_folder/wvs.ini)
    if [ -z "$db_port" ]; then
        echo "Previous Acunetix installation found at $base_folder, but has invalid wvs.ini file."
        echo "Remove $base_folder and re-run the installer for a fresh install."
        echo
        exit_with_error
    fi

    db_name=$(awk -F "=" '/databases.connections.master.connection.db/ {print $2}' $base_folder/wvs.ini)
    if [ -z "$db_name" ]; then
        echo "Previous Acunetix installation found at $base_folder, but has invalid wvs.ini file."
        echo "Remove $base_folder and re-run the installer for a fresh install."
        echo
        exit_with_error
    fi

    db_password=$(awk -F "=" '/databases.connections.master.connection.password/ {print $2}' $base_folder/wvs.ini)
    if [ -z "$db_password" ]; then
        echo "Previous Acunetix installation found at $base_folder, but has invalid wvs.ini file."
        echo "Remove $base_folder and re-run the installer for a fresh install."
        echo
        exit_with_error
    fi
}

upgrade_version_check()
{
    # detect version
    gr="(?<=wvs\.app_dir\=~\/\.$product_name\/v_)[0-9]+(?=\/scanner)"
    old_version_numeric=$(cat $base_folder/wvs.ini | grep -o -P $gr)

    if [ -z "$old_version_numeric" ]; then
        echo "Previous Acunetix installation found at $base_folder, but can't determine the application version."
        echo
        exit_with_error
    fi

    if [ "$old_version_numeric" -gt "$version_numeric" ]; then
        echo "Previous Acunetix installation with newer version:$old_version_numeric found at $base_folder."
        echo
        exit_with_error
    fi

    old_version="v_$old_version_numeric"

    if [ ! -d $base_folder/$old_version ]; then
        echo "Data only install found with version $old_version_numeric"
        return
    fi

    read -p "Acunetix version: $old_version_numeric found at $base_folder. Do you want to upgrade to $version (y/n)? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo
        echo "Upgrading Acunetix $old_version to $version..."
        echo
    else
        echo
        echo "Installation cancelled."
        echo
        exit_with_error
    fi
}

clean_install_master()
{
    # attempting to stop any product service registered
    systemctl stop "$product_name" > /dev/null 2>&1

    check_for_open_ports

    configure_hostname
    configure_master_user
    clean_install_init_filesystem
    clean_install_create_database
    generate_certificates
    create_ini_file
    patch_wvsc_ini
    create_startup_script

    registering_the_service
}

upgrade_master()
{
    upgrade_version_check

    # attempting to stop any product service registered
    systemctl stop "$product_name"

    check_for_open_ports

    get_settings_from_ini

    extract

    #update the database
    echo
    echo "Upgrading the database..."
    echo

    db_pgdir=$base_folder/$version/database
    temp_dir=$base_folder/temp
    db_datadir=$base_folder/db

    start_the_database_process

    run_db_script "   - Update database structure"  $base_folder/$version/data/temp/update_database.sql
    run_db_script "   - Update database data"  $base_folder/$version/data/temp/static_data.sql
    run_db_script "   - Add new vulnerability data" $base_folder/$version/data/temp/upsert_vtypes.sql
    run_db_script "   - Updating script versions" $base_folder/$version/data/temp/script_versions.sql

    stop_the_database_process

    echo
    echo "Updating filesystem..."

    # sudo -u $linux_user mv --update $base_folder/$version/data $base_folder
    sudo -u $linux_user cp -rf  $base_folder/$version/data/* $base_folder/data

    #update the wvs.ini
    sudo -u $linux_user sed -i "s/$old_version/$version/g" $base_folder/wvs.ini

    #update the start.sh
    sudo -u $linux_user sed -i "s/version=v_[0-9]\+/version=$version/g" $base_folder/start.sh

    patch_wvsc_ini

    # delete previous version
    if [ $old_version != $version ]; then
        rm -r $base_folder/$old_version
    fi

    registering_the_service
}

clean_install_engine()
{
    systemctl stop "$product_name"

    check_for_open_ports "engineonly"

    clean_install_init_filesystem

    generate_certificates
    create_ini_file "engineonly"
    patch_wvsc_ini
    create_startup_script "engineonly"
    registering_the_service
}

upgrade_engine()
{
    upgrade_version_check

    # attempting to stop any product service registered
    systemctl stop "$product_name"

    echo "Extracting files...."
    extract

    echo
    echo "Updating filesystem..."

    # sudo -u $linux_user mv --update $base_folder/$version/data $base_folder
    sudo -u $linux_user cp -rf  $base_folder/$version/data/* $base_folder/data

    # update the wvs.ini
    sudo -u $linux_user sed -i "s/$old_version/$version/g" $base_folder/wvs.ini

    # update the start.sh
    sudo -u $linux_user sed -i "s/version=v_[0-9]\+/version=$version/g" $base_folder/start.sh

    patch_wvsc_ini

    systemctl start "$product_name"

    # delete previous version
    rm -r $base_folder/$old_version

    registering_the_service
}

install_engine()
{
    echo
    echo "Acunetix (Engine) Installer Version: $version, Copyright (c) Acunetix"
    echo "---------------------------------------------------------------------"

    check_os
    check_for_dependencies

    show_eula

    configure_linux_user

    base_folder=/home/$linux_user/.$product_name

    echo
    echo "By default the Acunetix will be installed to $base_folder"
    echo

    if [ ! -d $base_folder ]; then
        clean_install_engine
        return 1
    fi

    # detect installation type
    old_engine_only=$(cat $base_folder/wvs.ini | grep -o -P '(?<=engineonly=)[0-9]')

    if [ "$old_engine_only" -ne 1 ]; then
        echo "Current installation is not engine only. Please re-run the installer without the --engineonly option"
        exit_with_error
        # upgrade_master
    fi

    upgrade_engine
}

install_master()
{
    echo
    echo "Acunetix Installer Version: $version, Copyright (c) Acunetix"
    echo "------------------------------------------------------------"

    check_os
    check_for_dependencies

    show_eula

    configure_linux_user

    base_folder=/home/$linux_user/.$product_name

    echo
    echo "By default the Acunetix will be installed to $base_folder"
    echo

    if [ ! -d $base_folder ]; then
        clean_install_master
        return 1
    fi

    if [ ! -z "$setup_type" ]; then
        echo "A previous version of Acunetix is already installed."
        echo "This installer type does not support upgrades."
        echo "Please uninstall your Acunetix software and re-run the installer."
        exit_with_error
    fi

    # detect installation type
    old_engine_only=$(cat $base_folder/wvs.ini | grep -o -P '(?<=engineonly=)[0-9]')

    if [ "$old_engine_only" = "1" ]; then

        echo "Current installation is engine only. Please run the installer with --engineonly option"
        exit_with_error
    fi

    upgrade_master
}


if [ -z "$engine_only" ]; then
    install_master
    add_shortcut
    create_uninstall
    create_password_change
else
    if [ ! -z "$setup_type" ]; then
        echo "This installer does not support engine only option."
        exit_with_error
    fi

    install_engine
    create_uninstall
    create_password_change
fi

# chown root:root "$base_folder/$version/scanner/chromium/chrome-sandbox"
# chmod u+s "$base_folder/$version/scanner/chromium/chrome-sandbox"

# start the service
systemctl start "$product_name"

echo
echo "Please visit https://$host_name:$server_port/ to access Acunetix UI"
echo

exit 0
##### data ##61d8af006d0e4b5cb1c7687fd4f730cb###
BZh91AY&SYk8hQ�������������������������������������D_}�o��
