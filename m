From: Oren Held <orenhe@il.ibm.com>
Subject: [Multipath DOCS] Some possibly deprecated info
Date: Sun, 18 Apr 2010 19:28:23 +0300
Message-ID: <4BCB3327.1040407@il.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9151810628471378629=="
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
--===============9151810628471378629==
Content-Type: multipart/alternative;
	boundary="------------040401050305010501010702"

This is a multi-part message in MIME format.
--------------040401050305010501010702
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

Hello,

In http://christophe.varoqui.free.fr/refbook.html, "the multipathd 
daemon" pargagraph states:
"This daemon executes the external multipath config tool when events occur."

As far as I understand from the current code this is no more true, for 
multipathd uses libmultipath to create new maps, and not real execution 
of an external binary.

(And.. of course it could be easier if docs were moved to some wiki space..)

Best Regards,

Oren Held
Host Side Development Team
IBM-XIV

--------------040401050305010501010702
Content-Transfer-Encoding: 7bit
Content-Type: text/html; charset=ISO-8859-1

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
</head>
<body text="#000000" bgcolor="#ffffff">
Hello,<br>
<br>
In<a href="http://christophe.varoqui.free.fr/refbook.html">
http://christophe.varoqui.free.fr/refbook.html</a>, "the multipathd
daemon" pargagraph states:<br>
"This daemon executes the external multipath config tool when events
occur."<br>
<br>
As far as I understand from the current code this is no more true, for
multipathd uses libmultipath to create new maps, and not real execution
of an external binary.<br>
<br>
(And.. of course it could be easier if docs were moved to some wiki
space..)<br>
<br>
Best Regards,<br>
<br>
<div class="moz-signature"><span style="color: rgb(63, 63, 63);">Oren
Held<br>
Host Side Development Team<br>
IBM-XIV<br>
</span></div>
</body>
</html>

--------------040401050305010501010702--


--===============9151810628471378629==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============9151810628471378629==--
