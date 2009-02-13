From: "Allen, Jack" <Jack.Allen@mckesson.com>
Subject: RE: Changing SAN vendors
Date: Thu, 12 Feb 2009 18:03:28 -0600
Message-ID: <4905EFD192EEDF4A9A19EEE98C32B7F70F3EB744@DBQV3005.na.corp.mckesson.com>
References: <4905EFD192EEDF4A9A19EEE98C32B7F70EFB4A29@DBQV3005.na.corp.mckesson.com>
	<4905EFD192EEDF4A9A19EEE98C32B7F70F0DC22D@DBQV3005.na.corp.mckesson.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1070111367=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4905EFD192EEDF4A9A19EEE98C32B7F70F0DC22D@DBQV3005.na.corp.mckesson.com>
Content-class: urn:content-classes:message
In-Reply-To: <4905EFD192EEDF4A9A19EEE98C32B7F70F0DC22D@DBQV3005.na.corp.mckesson.com>
References: <4905EFD192EEDF4A9A19EEE98C32B7F70EFB4A29@DBQV3005.na.corp.mckesson.com>
	<4905EFD192EEDF4A9A19EEE98C32B7F70F0DC22D@DBQV3005.na.corp.mckesson.com>
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

--===============1070111367==
Content-class: urn:content-classes:message
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C98D6E.7FE8B1ED"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C98D6E.7FE8B1ED
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello:
    Still looking for an answer for RH AS 4.7.
=20
    No body has any ideas?
=20
-----
Thanks:
Jack Allen

  _____ =20

From: Allen, Jack=20
Sent: Thursday, February 05, 2009 5:03 PM
To: device-mapper development
Subject: RE: [dm-devel] Changing SAN vendors


=20


  _____ =20

From: Allen, Jack=20
Sent: Tuesday, February 03, 2009 6:45 PM
To: dm-devel@redhat.com
Subject: [dm-devel] Changing SAN vendors



Hello:=20
        Our IT group has decided to switch SAN Vendors. The switch over
for a couple of systems has gone fine, but I have some questions on =
some
things that have changed.

        First a little information on how the switch over is taking
place. The old SAN is a EMC CX and the new SAN is a HP XP. The system =
is
connected to a SAN switch which is then connected to both SANs. We shut
down the system, and then rezone the switch/SAN to access the XP now
instead of the CX. The XP passes through all the I/O request to the CX.
When we know the data can be seen correctly, they do some commands that
copies the data from the CX to the XP and then the I/O takes place on
the XP from that point on. All this works fine.

        When only connected to the CX, I had /dev/mapper/mpath1 and
/dev/mapper/mpath2. After the reboot and rezoning /dev/mapper/mpath1 =
and
/dev/mapper/mpath2 are gone and /dev/mapper/mpath3 and
/dev/mapper/mpath4 are there. LVM finds the Volume Group and all =
Logical
Volumes with no problem.

        My question is what do I have to change in some configuration
file or what ever to make /dev/mapper/mpath1 and /dev/mapper/mpath2 be
in place instead of /dev/mapper/mpath3 and /dev/mapper/mpath4?

        I know this is not creating any real problem, but it is kind of
misleading, because it looks like 2 paths are missing.

-----=20
Thanks=20
Jack Allen=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

    Well no one replied, so I will answer my on question in hopes that
it may help someone else. But I will ask another question and hope
someone will reply to it, because I have goggled and can not find the
answers.

    The Answer: The friendly names are kept in
/var/lib/multipath/bindings. Because the WWID changed multipathd =
created
new entries. All I had to do was remove the entries for the old WWID =
and
change the friendly name for the new WWID. Simple, but hard to locate
the file when no documents I could find to begin with tells you that is
where the friendly names are kept.

    The Question: The first system was running RH EL 5.2, but the next
system is running RH AS 4.7. There was no /var/lib/multipath directory,
therefore no bindings file. So I created both, and entered mpath0 and
mpath1 with the WWID, but it still uses mpath2 and mpath3. I know
multipathd are different version between the two RH Release. Is there
something else I need to change on the RH AS 4.7 system to make it use
the mpath0 and mpath1 names?

-----

Thanks:

Jack Allen

=20


------_=_NextPart_001_01C98D6E.7FE8B1ED
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>Changing SAN vendors</TITLE>

<META content=3D"MSHTML 6.00.2900.3492" name=3DGENERATOR></HEAD>
<BODY>
<DIV dir=3Dltr align=3Dleft><SPAN class=3D863130200-13022009><FONT =
face=3DArial=20
color=3D#800000 size=3D2>Hello:</FONT></SPAN></DIV>
<DIV dir=3Dltr align=3Dleft><SPAN =
class=3D863130200-13022009>&nbsp;&nbsp;&nbsp; <FONT=20
face=3DArial color=3D#800000 size=3D2>Still looking for an answer for =
RH AS=20
4.7.</FONT></SPAN></DIV>
<DIV dir=3Dltr align=3Dleft><SPAN class=3D863130200-13022009><FONT =
face=3DArial=20
color=3D#800000 size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV dir=3Dltr align=3Dleft><SPAN =
class=3D863130200-13022009>&nbsp;&nbsp;&nbsp; <FONT=20
face=3DArial color=3D#800000 size=3D2>No body has any =
ideas?</FONT></SPAN></DIV>
<DIV dir=3Dltr align=3Dleft><SPAN class=3D863130200-13022009><FONT =
face=3DArial=20
color=3D#800000 size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV dir=3Dltr align=3Dleft><SPAN class=3D863130200-13022009><FONT =
face=3DArial=20
color=3D#800000 size=3D2>-----</FONT></SPAN></DIV>
<DIV dir=3Dltr align=3Dleft><SPAN class=3D863130200-13022009><FONT =
face=3DArial=20
color=3D#800000 size=3D2>Thanks:</FONT></SPAN></DIV>
<DIV dir=3Dltr align=3Dleft><SPAN class=3D863130200-13022009><FONT =
face=3DArial=20
color=3D#800000 size=3D2>Jack Allen</FONT></SPAN></DIV><BR>
<DIV class=3DOutlookMessageHeader lang=3Den-us dir=3Dltr align=3Dleft>
<HR tabIndex=3D-1>
<FONT face=3DTahoma size=3D2><B>From:</B> Allen, Jack <BR><B>Sent:</B> =
Thursday,=20
February 05, 2009 5:03 PM<BR><B>To:</B> device-mapper=20
development<BR><B>Subject:</B> RE: [dm-devel] Changing SAN=20
vendors<BR></FONT><BR></DIV>
<DIV></DIV>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#800000=20
size=3D2></FONT>&nbsp;</DIV><FONT face=3DArial color=3D#800000 =
size=3D2></FONT><BR>
<DIV class=3DOutlookMessageHeader lang=3Den-us dir=3Dltr align=3Dleft>
<HR tabIndex=3D-1>
<FONT face=3DTahoma size=3D2><B>From:</B> Allen, Jack <BR><B>Sent:</B> =
Tuesday,=20
February 03, 2009 6:45 PM<BR><B>To:</B> =
dm-devel@redhat.com<BR><B>Subject:</B>=20
[dm-devel] Changing SAN vendors<BR></FONT><BR></DIV>
<DIV></DIV><!-- Converted from text/rtf format -->
<P><FONT face=3DArial size=3D2>Hello:</FONT>=20
<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT face=3DArial =
size=3D2>Our IT=20
group has decided to switch SAN Vendors. The switch over for a couple =
of systems=20
has gone fine, but I have some questions on some things that have=20
changed.</FONT></P>
<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT face=3DArial =
size=3D2>First a=20
little information on how the switch over is taking place. The old SAN =
is a EMC=20
CX and the new SAN is a HP XP. The system is connected to a SAN switch =
which is=20
then connected to both SANs. We shut down the system, and then rezone =
the=20
switch/SAN to access the XP now instead of the CX. The XP passes =
through all the=20
I/O request to the CX. When we know the data can be seen correctly, =
they do some=20
commands that copies the data from the CX to the XP and then the I/O =
takes place=20
on the XP from that point on. All this works fine.</FONT></P>
<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT face=3DArial =
size=3D2>When only=20
connected to the CX, I had /dev/mapper/mpath1 and /dev/mapper/mpath2. =
After the=20
reboot and rezoning /dev/mapper/mpath1 and /dev/mapper/mpath2 are gone =
and=20
/dev/mapper/mpath3 and /dev/mapper/mpath4 are there. LVM finds the =
Volume Group=20
and all Logical Volumes with no problem.</FONT></P>
<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT face=3DArial =
size=3D2>My=20
question is what do I have to change in some configuration file or what =
ever to=20
make /dev/mapper/mpath1 and /dev/mapper/mpath2 be in place instead of=20
/dev/mapper/mpath3 and /dev/mapper/mpath4?</FONT></P>
<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT face=3DArial =
size=3D2>I know=20
this is not creating any real problem, but it is kind of misleading, =
because it=20
looks like 2 paths are missing.</FONT></P>
<P><FONT face=3DArial size=3D2>-----</FONT> <BR><FONT face=3DArial=20
size=3D2>Thanks</FONT> <BR><FONT face=3DArial size=3D2>Jack=20
Allen</FONT>&nbsp;<BR><SPAN class=3D295395121-05022009><FONT =
face=3DArial=20
color=3D#800000=20
size=3D2>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</FONT></SPA=
N></P>
<P><SPAN class=3D295395121-05022009>&nbsp;&nbsp;&nbsp;&nbsp;<FONT =
face=3DArial=20
color=3D#800000 size=3D2>Well no one replied,&nbsp;so I will answer my =
on question=20
in hopes that it may help someone else. But I will ask another question =
and hope=20
someone will reply to it,&nbsp;because I have goggled and can not find =
the=20
answers.</FONT></SPAN></P>
<P><SPAN class=3D295395121-05022009>&nbsp;&nbsp;&nbsp;&nbsp;<FONT =
face=3DArial=20
color=3D#800000 size=3D2>The Answer: The</FONT>&nbsp;<FONT face=3DArial =
color=3D#800000=20
size=3D2>friendly names are kept in /var/lib/multipath/bindings. =
Because the WWID=20
changed multipathd created new entries. All I had to do was remove the =
entries=20
for the old WWID and change the friendly name for the new WWID. Simple, =
but hard=20
to locate the file when no documents I could find to begin with tells =
you that=20
is where the friendly names are kept.</FONT></SPAN></P>
<P><SPAN class=3D295395121-05022009>&nbsp;&nbsp;&nbsp; <FONT =
face=3DArial=20
color=3D#800000 size=3D2>The Question: The first system was running RH =
EL 5.2, but=20
the next system is running RH AS 4.7. There was no /var/lib/multipath =
directory,=20
therefore no bindings file. So I created both, and entered mpath0 and =
mpath1=20
with the WWID, but it still uses mpath2 and mpath3. I know multipathd =
are=20
different version between the two RH Release. Is there something else I =
need to=20
change on the RH AS 4.7 system to make it use the mpath0 and mpath1=20
names?</FONT></SPAN></P>
<P><SPAN class=3D295395121-05022009><FONT face=3DArial color=3D#800000=20
size=3D2>-----</FONT></SPAN></P>
<P><SPAN class=3D295395121-05022009><FONT face=3DArial color=3D#800000=20
size=3D2>Thanks:</FONT></SPAN></P>
<P><SPAN class=3D295395121-05022009><FONT face=3DArial color=3D#800000 =
size=3D2>Jack=20
Allen</FONT></SPAN></P>
<P><SPAN class=3D295395121-05022009></SPAN>&nbsp;</P></BODY></HTML>

------_=_NextPart_001_01C98D6E.7FE8B1ED--


--===============1070111367==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1070111367==--
