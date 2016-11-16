From: tang.junhui@zte.com.cn
Subject: Improve processing efficiency for addition and deletion
 of multipath devices
Date: Wed, 16 Nov 2016 09:46:37 +0800
Message-ID: <OF7C96E124.CD19B12D-ON4825806D.00095E60-4825806D.0009BD8C@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4539797352364587811=="
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
To: christophe.varoqui@opensvc.com, bmarzins@redhat.com, hare@suse.de
Cc: dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

This is a multipart message in MIME format.
--===============4539797352364587811==
Content-Type: multipart/alternative;
	boundary="=_alternative 0009BD894825806D_="

This is a multipart message in MIME format.
--=_alternative 0009BD894825806D_=
Content-Type: text/plain; charset="US-ASCII"

In these scenarios, multipath processing efficiency is very low:
1) There are many paths in multipath devices,
2) Add/delete devices when iSCSI login/logout or FC link up/down.

Multipath process so slowly that it is not satisfied some applications, 
For example, 
openstack is often timeout in waiting for the creation of multipath 
devices.

The reason of the low processing efficiency I think is that multipath 
process uevent 
message one by one, and each one also produce a new dm 
addition/change/deletion 
uevent message to increased system resource consumption, actually most of 
these uevent 
message have no sense at all.

So, can we find out a way to reduce these uevent messages to promote 
multipath 
processing efficiency? Personally, I think we can merge these uevent 
messages before 
processing. For example, during the 4 iSCSI session login procedures, we 
can wait for a 
moment until the addition uevent messages of 4 paths are all arrived, and 
then we can 
merge these uevent messages to one and deal with it at once. The way to 
deal with 
deletion uevent messages is the same.

How do you think about? Any points of view are welcome.
--=_alternative 0009BD894825806D_=
Content-Type: text/html; charset="US-ASCII"

<font size=3 face="Times New Roman">In these scenarios, multipath processing
efficiency is very low:</font>
<br><font size=3 face="Times New Roman">1) There are many paths in multipath
devices,</font>
<br><font size=3 face="Times New Roman">2) Add/delete devices when iSCSI
login/logout or FC link up/down.</font>
<br>
<br><font size=3 face="Times New Roman">Multipath process so slowly that
it is not satisfied some applications, For example, </font>
<br><font size=3 face="Times New Roman">openstack is often timeout in waiting
for the creation of multipath devices.</font>
<br>
<br><font size=3 face="Times New Roman">The reason of the low processing
efficiency I think is that multipath process uevent </font>
<br><font size=3 face="Times New Roman">message one by one, and each one
also produce a new dm addition/change/deletion </font>
<br><font size=3 face="Times New Roman">uevent message to increased system
resource consumption, actually most of these uevent </font>
<br><font size=3 face="Times New Roman">message have no sense at all.</font>
<br>
<br><font size=3 face="Times New Roman">So, can we find out a way to reduce
these uevent messages to promote multipath </font>
<br><font size=3 face="Times New Roman">processing efficiency? Personally,
I think we can merge these uevent messages before </font>
<br><font size=3 face="Times New Roman">processing. For example, during
the 4 iSCSI session login procedures, we can wait for a </font>
<br><font size=3 face="Times New Roman">moment until the addition uevent
messages of 4 paths are all arrived, and then we can </font>
<br><font size=3 face="Times New Roman">merge these uevent messages to
one and deal with it at once. The way to deal with </font>
<br><font size=3 face="Times New Roman">deletion uevent messages is the
same.</font>
<br>
<br><font size=3 face="Times New Roman">How do you think about? Any points
of view are welcome.</font>
--=_alternative 0009BD894825806D_=--


--===============4539797352364587811==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4539797352364587811==--
