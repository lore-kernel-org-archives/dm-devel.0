From: "Greene, Rick" <rick.greene@ncogroup.com>
Subject: RE: Multipath not rebuilding correctly on reboot
Date: Thu, 31 Jan 2008 15:21:34 -0500
Message-ID: <2F1F44D192D1284BAA298E48C1B2A4F90234F16F@exchmail03.ncogroup.com>
References: <2F1F44D192D1284BAA298E48C1B2A4F90234F16E@exchmail03.ncogroup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C86446.DFBFB028"
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <2F1F44D192D1284BAA298E48C1B2A4F90234F16E@exchmail03.ncogroup.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C86446.DFBFB028
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Ah nuts...forgot to save the one file before attaching.  Here is the
missing manual_run.txt file

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Greene, Rick
Sent: Thursday, January 31, 2008 3:20 PM
To: device-mapper development
Subject: [dm-devel] Multipath not rebuilding correctly on reboot

Now that I seem to have multipath and my XP 1024 working together, I've
found a new issue.  Someone recently had a similar thread going, but I
saw no ultimate resolution.

My problem is that when I reboot my server, the multipath configuration
is not coming back the way it was before.  I moved the two external
tools I use to find the UID into /etc (they had bin in /usr/bin and
/sbin), updated the multipath.conf file (and one of the scripts) to
reflect this, but odd things are still happening.

Attached is initial_view.txt, which shows what multipath is coming up
with when I do the commands shown (the bulk of the file is multipath -v3
output, but at the bottom of the file is a multipath -ll output as
well).  It (seems to) correctly shows that I have 4 disks, each visible
via two separate paths.

After I reboot, however, I get different results.  Once it showed 4
paths for mpath0, and 2 paths for mpath1, 2, and 3.  Next time it
correctly showed mpath0, mpath1, and mpath3, but didn't show mpath2 at
all.  On the next attempt I got everything correct, and the very next
one only showed mpath0 and mpath1.

The post_reboot.txt file shows the contents of the /var/log/boot.log
file and the output of the dmesg command, along with the "multipath -ll"
view from the most recent reboot.

I then manually did a "multipath -v2" and the missing two paths then
came back.  The file manual_run.txt shows those results plus the updated
"multipath -ll".

Do I need to just make my own /etc/init.d script to do a "multipath -v2"
at the end of booting to make sure it all gets covered, along with the
requisite LVM & mount commands to get the VG that is on these disks
working right?

Thanks in advance,
Rick




------_=_NextPart_001_01C86446.DFBFB028
Content-Type: text/plain;
	name="manual_run.txt"
Content-Transfer-Encoding: base64
Content-Description: manual_run.txt
Content-Disposition: attachment;
	filename="manual_run.txt"

IyBtdWx0aXBhdGggLXYyDQpjcmVhdGU6IG1wYXRoMiAoMDAwNDAwMjZfMDU6ODUpDQpbc2l6ZT0x
MyBHQl1bZmVhdHVyZXM9IjAiXVtod2hhbmRsZXI9IjAiXQ0KXF8gcm91bmQtcm9iaW4gMA0KIFxf
IDE6MDowOjIgc2RjIDg6MzIgIFtyZWFkeV0NCiBcXyAyOjA6MDoyIHNkZyA4Ojk2ICBbcmVhZHld
DQoNCmNyZWF0ZTogbXBhdGgzICgwMDA0MDAyNl8wNTo4NikNCltzaXplPTEzIEdCXVtmZWF0dXJl
cz0iMCJdW2h3aGFuZGxlcj0iMCJdDQpcXyByb3VuZC1yb2JpbiAwDQogXF8gMTowOjA6MyBzZGQg
ODo0OCAgW3JlYWR5XQ0KIFxfIDI6MDowOjMgc2RoIDg6MTEyIFtyZWFkeV0NCg0KW3Jvb3RAY29y
dXgzOCB+XSMgbXVsdGlwYXRoIC1sbA0KbXBhdGgyICgwMDA0MDAyNl8wNTo4NSkNCltzaXplPTEz
IEdCXVtmZWF0dXJlcz0iMCJdW2h3aGFuZGxlcj0iMCJdDQpcXyByb3VuZC1yb2JpbiAwIFthY3Rp
dmVdDQogXF8gMTowOjA6MiBzZGMgODozMiAgW2FjdGl2ZV1bcmVhZHldDQogXF8gMjowOjA6MiBz
ZGcgODo5NiAgW2FjdGl2ZV1bcmVhZHldDQoNCm1wYXRoMSAoMDAwNDAwMjZfMDU6ODQpDQpbc2l6
ZT0xMyBHQl1bZmVhdHVyZXM9IjAiXVtod2hhbmRsZXI9IjAiXQ0KXF8gcm91bmQtcm9iaW4gMCBb
ZW5hYmxlZF0NCiBcXyAyOjA6MDoxIHNkZiA4OjgwICBbYWN0aXZlXVtyZWFkeV0NCiBcXyAxOjA6
MDoxIHNkYiA4OjE2ICBbYWN0aXZlXVtyZWFkeV0NCg0KbXBhdGgwICgwMDA0MDAyNl8wNTo4MykN
CltzaXplPTEzIEdCXVtmZWF0dXJlcz0iMCJdW2h3aGFuZGxlcj0iMCJdDQpcXyByb3VuZC1yb2Jp
biAwIFtlbmFibGVkXQ0KIFxfIDI6MDowOjAgc2RlIDg6NjQgIFthY3RpdmVdW3JlYWR5XQ0KIFxf
IDE6MDowOjAgc2RhIDg6MCAgIFthY3RpdmVdW3JlYWR5XQ0KDQptcGF0aDMgKDAwMDQwMDI2XzA1
Ojg2KQ0KW3NpemU9MTMgR0JdW2ZlYXR1cmVzPSIwIl1baHdoYW5kbGVyPSIwIl0NClxfIHJvdW5k
LXJvYmluIDAgW2FjdGl2ZV0NCiBcXyAxOjA6MDozIHNkZCA4OjQ4ICBbYWN0aXZlXVtyZWFkeV0N
CiBcXyAyOjA6MDozIHNkaCA4OjExMiBbYWN0aXZlXVtyZWFkeV0NCg==

------_=_NextPart_001_01C86446.DFBFB028
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C86446.DFBFB028--
