From: "Michel van der Breggen" <mvdbreggen@csolutions.nl>
Subject: dm can't mount when bios raid degraded.
Date: Wed, 28 Mar 2007 10:31:05 +0200
Message-ID: <002001c77113$6da2c690$5201a8c0@intranet.dc>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1920453943=="
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

--===============1920453943==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_001D_01C77124.30FE6C10"

This is a multi-part message in MIME format.

------=_NextPart_000_001D_01C77124.30FE6C10
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Dear all,
I have a Asus P5LD2 mainboard with Intel Raid controller onboard ( ISW =
). I've defined a raid1 set with two 500Gb SATA2. In the FC6 installer i =
saw one volume ISW_HCHAJGCAG_RaidVolume0 which i partioned and installed =
FC6 on. Now everything boots normaly. But when i degrade the Raid1 by =
removing 1 drive ( this drive has a lot of bad sectors ), the boot goes =
correct till the moment that dm sees that there should be a mirror and =
says that it misses one drive. From that point on it won't start the =
mapper and my partioned can't be found and the kernel stops to a =
screaming halt.. End of line.=20
When i reconnect the second drive everything works correctly. But the =
reason that people use raid1 is that when one harddrive fails we atleast =
can go on. My bios indeed also says that is misses one drive but still =
defines the logical drive, so we can boot linux until device-mapper =
starts.

Does anybody know how to stop device-mapper from trying to find the raid =
itself and just use the raid-logical drive that the bios defines? ( i =
would like to send the failed drive back to the supplier for a swap, but =
i can't take the server down for a whole week ).

With kind regards,
Michel van der Breggen

------=_NextPart_000_001D_01C77124.30FE6C10
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.6000.16414" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>Dear all,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>I have a Asus P5LD2 mainboard with =
Intel Raid=20
controller onboard ( ISW ). I've defined a raid1 set with two 500Gb =
SATA2. In=20
the FC6 installer i saw one volume ISW_HCHAJGCAG_RaidVolume0 which i =
partioned=20
and installed FC6 on. Now everything boots normaly. But when i degrade =
the Raid1=20
by removing 1 drive ( this drive has a lot of bad sectors ), the boot =
goes=20
correct till the moment that dm sees that there should be a mirror and =
says that=20
it misses one drive. From that point on it won't start the mapper and my =

partioned can't be found and the kernel stops&nbsp;to a screaming halt.. =
End of=20
line. </FONT></DIV>
<DIV><FONT face=3DArial size=3D2>When i reconnect the second drive =
everything works=20
correctly. But the reason that people use raid1 is that when one =
harddrive fails=20
we atleast can go on. My bios indeed also says that is misses one drive =
but=20
still defines the logical drive, so we can boot linux until =
device-mapper=20
starts.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Does anybody know how to stop =
device-mapper from=20
trying to find the raid itself and just use the raid-logical drive that =
the bios=20
defines? ( i would like to send the failed drive back to the supplier =
for a=20
swap, but i can't take the server down for a whole week ).</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>With kind regards,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Michel van der Breggen</FONT></DIV>
<DIV>&nbsp;</DIV></BODY></HTML>

------=_NextPart_000_001D_01C77124.30FE6C10--


--===============1920453943==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1920453943==--
