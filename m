From: "Ishai Rabinovitz" <ishai@mellanox.co.il>
Subject: Module reference count problem when using multipath
Date: Wed, 12 Jul 2006 15:08:00 +0300
Message-ID: <6AB138A2AB8C8E4A98B9C0C3D52670E302842878@mtlexch01.mtl.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0585616505=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

--===============0585616505==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C6A5AB.D6AC6210"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C6A5AB.D6AC6210
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi All,
=20
I take part in the development of SRP (Scsi RDMA Protocol). and I'm
trying to work with dm to support failover.
I downloaded multipath 0.4.7 and I'm working with linux-2.6.18-rc1
kernel over RHAS4.OU3 distribution.
=20
I have connected to the SRP target (That has a lot of disks), and they
can be accessed through /dev/sdb /dev/sdc and so on. I run multipath and
got the mapping as it should be.
=20
The problem is that the reference count of ib_srp module is equal to the
number of disks that were mapped using multipath. Because of that I can
not remove the ib_srp module.
This does not occur without multipath.
=20
There is also reference count of 1 on dm_round_robin.
=20
I tried to look at "ps aux" and "lsof" but found no process or file that
should hold reference to ib_srp. I tried to google it without any
success.
=20
Can someone answer any of the following questions:
1) Why does every disk that is mapped through multipath hold a reference
to the ib_srp module?  Is this the correct behavior, or is it a bug?
2) Can I remove a mapping from the multipath ?
3) Any ideas how I can debug this.
=20
I will appreciate any help.
=20
Thanks
Ishai

------_=_NextPart_001_01C6A5AB.D6AC6210
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 6.00.2900.2912" name=3DGENERATOR></HEAD>
<BODY>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial size=3D2>Hi=20
All,</FONT></SPAN></DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial size=3D2>I take =
part in the=20
development of SRP (Scsi RDMA Protocol). and I'm trying to work with dm=20
to&nbsp;support failover.</FONT></SPAN></DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial size=3D2>I =
downloaded=20
multipath 0.4.7 and I'm working&nbsp;with linux-2.6.18-rc1 kernel over =
RHAS4.OU3=20
distribution.</FONT></SPAN></DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial =
size=3D2>I&nbsp;have=20
connected to&nbsp;the SRP target (That has a lot of disks), and they can =
be=20
accessed through /dev/sdb&nbsp;/dev/sdc and so on. </FONT></SPAN><SPAN=20
class=3D448572611-12072006><FONT face=3DArial size=3D2>I run multipath =
and got the=20
mapping as it should be.</FONT></SPAN></DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial size=3D2>The =
problem is=20
that&nbsp;the reference count&nbsp;of ib_srp module&nbsp;is equal =
to&nbsp;the=20
number of disks that were mapped using multipath. Because of that&nbsp;I =
can not=20
remove the ib_srp module.</FONT></SPAN></DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial size=3D2>This =
does not occur=20
without multipath.</FONT></SPAN></DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial size=3D2>There =
is also=20
reference count of 1&nbsp;on dm_round_robin.</FONT></SPAN></DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial size=3D2>I =
tried to look at=20
"ps aux" and "lsof" but found no process or file that should hold =
reference to=20
ib_srp. I tried to google it without any success.</FONT></SPAN></DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial size=3D2>Can =
someone answer=20
any of the following&nbsp;questions:</FONT></SPAN></DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial size=3D2>1) Why =
does every=20
disk that is mapped through multipath hold a reference to the ib_srp=20
module?&nbsp; Is this the correct behavior, or is it a =
bug?</FONT></SPAN></DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial size=3D2>2) Can =
I remove a=20
mapping from the multipath ?</FONT></SPAN></DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial size=3D2>3) Any =
ideas how I=20
can debug this.</FONT></SPAN></DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial size=3D2>I will =
appreciate=20
any help.</FONT></SPAN></DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial=20
size=3D2>Thanks</FONT></SPAN></DIV>
<DIV><SPAN class=3D448572611-12072006><FONT face=3DArial=20
size=3D2>Ishai</FONT></SPAN></DIV></BODY></HTML>

------_=_NextPart_001_01C6A5AB.D6AC6210--


--===============0585616505==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0585616505==--
