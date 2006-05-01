From: Nitin Vengurlekar <nitin.vengurlekar@oracle.com>
Subject: udev.rules template for dm.
Date: Mon, 01 May 2006 16:55:34 -0500
Message-ID: <445683D6.6070307@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0990962236=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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
--===============0990962236==
Content-Type: multipart/alternative;
	boundary="------------020804080408080409070308"

This is a multi-part message in MIME format.
--------------020804080408080409070308
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I'm configuring dm w/ udev, everything is working great!   Just one 
question:
when I saw the udev.rules file, it had the following in it, is this the 
default (did it get configured by the dm install)?  Also cant a more 
simple template be used ?

thx in advance.

KERNEL="dm-[0-9]*", PROGRAM="/sbin/dmsetup ls --target multipath --exec 
basename  -j %M -m %m", RESULT="?*", NAME="%k", SYMLINK="mpath/%c"

 

KERNEL="dm-[0-9]*", PROGRAM="dmsetup info -c --noheadings -j %M -m %m | 
grep -q .*:.*:.*:.*:.*:.*:.*:part[0-9]*-mpath-", PROGRAM="/sbin/dmsetup 
ls --target line ar --exec basename -j %M -m %m", RESULT="?*", 
NAME="%k", SYMLINK="mpath/%c"



--------------020804080408080409070308
Content-Type: text/html; charset=us-ascii
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
I'm configuring dm w/ udev, everything is working great!&nbsp;&nbsp; Just one
question:<br>
when I saw the udev.rules file, it had the following in it, is this the
default (did it get configured by the dm install)?&nbsp; Also cant a more
simple template be used ?<br>
<br>
thx in advance.<br>
<br>
<div
 style="border: 0.5pt solid black; padding: 1pt 4pt; background: rgb(243, 243, 243) none repeat scroll 0%; -moz-background-clip: initial; -moz-background-origin: initial; -moz-background-inline-policy: initial;">
<p class="MsoBodyTextIndent3"
 style="border: medium none ; padding: 0in; margin-left: 0in;"><span
 style="color: red;">KERNEL="dm-[0-9]*", PROGRAM="/sbin/dmsetup ls
--target multipath --exec basename<span style="">&nbsp; </span>-j
%M -m %m", RESULT="?*", NAME="%k",
SYMLINK="mpath/%c" <o:p></o:p></span></p>
<p class="MsoBodyTextIndent3"
 style="border: medium none ; padding: 0in; margin-left: 0in;"><span
 style="color: red;"><!--[if !supportEmptyParas]-->&nbsp;<!--[endif]--><o:p></o:p></span></p>
<p class="MsoBodyTextIndent3"
 style="border: medium none ; padding: 0in; margin-left: 0in;"><span
 style="color: red;">KERNEL="dm-[0-9]*", PROGRAM="dmsetup info -c
--noheadings -j %M -m %m | grep &#8211;q
.*:.*:.*:.*:.*:.*:.*:part[0-9]*-mpath-", PROGRAM="/sbin/dmsetup ls
--target line ar --exec basename -j %M -m %m", RESULT="?*",
NAME="%k", SYMLINK="mpath/%c"<o:p></o:p></span></p>
</div>
<br>
</body>
</html>

--------------020804080408080409070308--


--===============0990962236==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0990962236==--
