From: "=?gb2312?B?zfW1wLDu?=" <wangdb@toyou.com.cn>
Subject: Issue occurred when fixed using mapped device and
	software RAID
Date: Thu, 19 May 2011 16:53:10 +0800
Message-ID: <201105191653099689768@toyou.com.cn>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2689642589104268062=="
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
To: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids


This is a multi-part message in MIME format.

--===============2689642589104268062==
Content-Type: multipart/alternative;
	boundary="=====003_Dragon264107453551_====="


This is a multi-part message in MIME format.

--=====003_Dragon264107453551_=====
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit

Hi All,

    Is there anyone would help me? The issue is:

steps.

a. created a software RAID5 with 4 disks
b. created a volume group with the md in step a
c. created a logical volume with vg in step b
d. plugged out 2 physical drives, which were the member of the software RAID5 in step a, the software RAID5 was offline.

there were two results:

1. could not delete the logical volume and volume group, when the plugged out disks did not contain the lvm metadata.

2. could not see the logical volume and volume group when i scan them, and could not delete the software RAID5, when the plugged out disks contained the lvm metadata.

And i made the md driver, exported the mddev_s.openers, and found the openers is not zero, so I could not delete the software RAID5.

Thank you very much.

Best Wishes,
Daobang Wang.

--=====003_Dragon264107453551_=====
Content-Type: text/html;
	charset="gb2312"
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML xmlns:o = "urn:schemas-microsoft-com:office:office"><HEAD>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<META content="MSHTML 6.00.2900.6082" name=GENERATOR><LINK 
href="BLOCKQUOTE{margin-Top: 0px; margin-Bottom: 0px; margin-Left: 2em}" 
rel=stylesheet></HEAD>
<BODY style="FONT-SIZE: 10pt; MARGIN: 10px; FONT-FAMILY: verdana">
<DIV><FONT size=2><FONT color=#000080 size=2>Hi All,</FONT></FONT></DIV>
<DIV><FONT color=#000080 size=2></FONT>&nbsp;</DIV>
<DIV><FONT color=#000080 size=2>&nbsp;&nbsp;&nbsp;&nbsp;Is there anyone would 
help me? The issue is:</FONT></DIV>
<DIV><FONT color=#000080></FONT>&nbsp;</DIV>
<DIV><FONT color=#000080>steps.</FONT></DIV>
<DIV><FONT color=#000080></FONT>&nbsp;</DIV>
<DIV><FONT color=#000080>a. created a software RAID5 with 4 disks</FONT></DIV>
<DIV><FONT color=#000080>b. created a volume group with the md in step 
a</FONT></DIV>
<DIV><FONT color=#000080>c. created a logical volume with vg in step 
b</FONT></DIV>
<DIV><FONT color=#000080>d. plugged out 2 physical drives, which were the member 
of the software RAID5 in step a, the software RAID5 was offline.</FONT></DIV>
<DIV><FONT color=#000080></FONT>&nbsp;</DIV>
<DIV><FONT color=#000080 size=2>there were two results:</FONT></DIV>
<DIV><FONT color=#000080></FONT>&nbsp;</DIV>
<DIV><FONT color=#000080 size=2>1. could not delete the logical volume and 
volume group, when the plugged out disks did not contain the lvm 
metadata.</FONT></DIV>
<DIV><FONT color=#000080 size=2></FONT>&nbsp;</DIV>
<DIV><FONT color=#000080 size=2>2. could not see the logical volume and volume 
group when i scan them, and could not delete the software RAID5, when the 
plugged out disks contained the lvm metadata.</FONT></DIV>
<DIV><FONT color=#000080 size=2></FONT>&nbsp;</DIV>
<DIV><FONT color=#000080 size=2>And&nbsp;i made the md driver, exported the 
mddev_s.openers, and found the openers is not zero, so I could not delete the 
software RAID5.</FONT></DIV>
<DIV><FONT color=#000080 size=2></FONT>&nbsp;</DIV>
<DIV><FONT color=#000080 size=2>Thank you very much.</FONT></DIV>
<DIV><FONT color=#000080 size=2></FONT>&nbsp;</DIV>
<DIV><FONT color=#000080 size=2>Best Wishes,</FONT></DIV>
<DIV><FONT size=2><FONT color=#000080>Daobang 
Wang.</FONT></DIV></FONT></BODY></HTML>

--=====003_Dragon264107453551_=====--


--===============2689642589104268062==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2689642589104268062==--
