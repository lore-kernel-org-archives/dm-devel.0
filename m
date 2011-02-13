From: "rkliese@gmx.de" <rkliese@gmx.de>
Subject: What is the status of RAID5 support with pdc (AMD SB850
 Southbridge) hardware? dmraid -rD output
Date: Mon, 14 Feb 2011 00:17:58 +0100
Message-ID: <4D5866A6.7020207@gmx.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000500070608090403090806"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------000500070608090403090806
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello together,

I read in the linux archive of this list in a message form the 
14/Jan/2011 that the developers would appreciate the output
of dmraid -rD of a system which sb850 chipset and valid configured RAID5.

I hope this is the right way to send it and that it is not obsolete, so 
I have attached the output.

The system is a GA-890FXA-UD5 system with 5 2TB disk configured to a 
RAID5 on kernel level.
The RAID is used so far with Windows 7 and seems to be full operational 
with that.

I hope this input helps to develop support of dmraid RAID5 configuration 
for sb850 chip sets!

Kind regards
Rainer Kliese


--------------000500070608090403090806
Content-Type: application/x-compressed-tar;
 name="dmraid.pdc.tgz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmraid.pdc.tgz"

H4sIAGJhWE0AA+2bd1hTVxjG700CceNs3cYJrniTkBuJA2fVuiiljroak6CoEE1w702rFlx1
j5aqbW2rHdZttY669957te69wBtAQq4+4vMIh5uc9/dPTm7Ok5yTc97zjftdS6TdFGFR97SY
qzGZBSdg0OuTXgXEr0ltjUav5TmeC9QZGE54w+sZlT7TRpSG3o5ok12lYuw2W/Tb+qX3uYdi
ca2/w2JWOyIGWDP8N5wLzL++7q711+jSrD8vrL9OK1xScRk+kjdA+frrgjgDpw3S8NVzZPVQ
QBbgpn+T2mLKhE2ejv4DXz//dZyGg/5JEGK3RUY4rKowq7lrlK2HrUv/KqomUWY1w8iYixfO
nzt75vSpkyeOHzt6hGWYA/v37d2ze9fOHdu3bf13y+ZNG//ZsP7vdWvXrF61csXyv5b9+cfv
vy1d8usvPy/+6ccfFi1c8H38d9/Onzd3zuxZM2dMn/bN1CmTJ02Mi/16wvhxX30ZM3bM6FEj
RwwfNnTI4EEDB/Tv17dP72iHvVdPW1Rkj+7dIrp2CbdazJ1NX3Tq2KF9u8/btmnd6rOwT0M/
CWnZonmzph83adzoo4YN6terWye4dq2aNYxB1Q28PlAwG1w1ddUqlStVDPCvUL5c2TKlVaVK
liherGiRwh9+UKhggfz58vrlyZ0rZ47s2ZS+Pgq5jGUSE148f/b0yeNHDx/cv3f3zu1bN2/8
/9/1a1evXL7kPv/Dhw564fzXC/NXCvvAl/WTvdoTS2NOX00UYBk/hY/Sh2GmhMYnJCYE+7JJ
XRVp+yuFvzC5zTJKhUxol5Q7947SV57SljPKbAqhnU/oo3inPRkqnEjv6fvJE1NgWTb5wvt9
XybgHJ37lSzZ/yBD8TT9037+0Tx/Y7lasW7+X2e1LTzcYc1oPyfd+I/TiuM/vTYQ/h8JOIR9
VOOmf4uE8j/QPxGQ/6EbUf5XOvZfD/2TAPafbtz0b5WQ/Yf+iQD7Tzci/UvH/hugfxLA/tON
6P6vBOy/Idn+a6F/EsD+040o/y+B+g8e9R8EQf0Hvff/Uus/WFcNhxPUf5AA9R/eiKfpn/bz
j+b5G8sHx4ryP9Lx/1D/TwT4f/TqP9X/U7j7Z/D/SAD/zxvxNP3Tfv7RPH9jQKNYUf2fdPw/
5P+JAP+PXv2n+n9yl6/mBP4fCeD/eSOepn/azz+a52/0D40T1X9IoP7LgOe/CIL6L7oRPf8h
nfhPA/2TAPEfvfY/Nf6TueI2J4j/SID4zxvxNP3Tfv7RPH9jhZA4Uf2vBOr/edT/EwT1/3Qj
uv8ngfxPyvN/PPRPAuR/AAAAAAAAAAAAAAAAAAAAAADAO3gJvbDrmQB4AAA=
--------------000500070608090403090806
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000500070608090403090806--
