From: Kevin Maguire <k.c.f.maguire@gmail.com>
Subject: map in use - by what?
Date: Mon, 15 Mar 2010 10:52:18 +0100
Message-ID: <db9fa2351003150252md9d7e6ak1d7625d98914283f@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8444415667890178106=="
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

--===============8444415667890178106==
Content-Type: multipart/alternative; boundary=001485f5cd9630d7410481d3d667

--001485f5cd9630d7410481d3d667
Content-Type: text/plain; charset=ISO-8859-1

Hi

I wish to remove some mpath devices (which are in fact SAN storage)  from my
server.

Previously LVM objects was built on top of these devices, but these have
been removed via lvremove + vgremove + pvremove. lvs/vgs/pvs list nothing
related to the underlying mpath devices.

I then commented out the relevant entries in /etc/multipath.conf and tried:

$ multipath -F
sossan4: map in use
ecfs1: map in use
sossan5: map in use

(sossan4/5 should now be removable, ecfs1 is still in use)

Also

# multipath -ll
sossan4 (3600a0b800048ead00000070c4b2a66ee) dm-2 SUN,CSM200_R
[size=6.4T][features=1 queue_if_no_path][hwhandler=1 rdac][rw]
\_ round-robin 0 [prio=3][active]
 \_ 1:0:0:0 sdb 8:16  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:0 sde 8:64  [active][ghost]
ecfs1 (3600d0230ffffffff02bd6d4c3b1a8900) dm-3 IFT,A16F-R2431
[size=6.4T][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:1:0 sdc 8:32  [active][ready]
\_ round-robin 0 [prio=1][enabled]
 \_ 2:0:1:0 sdf 8:80  [active][ready]
sossan5 (3600a0b800048eac2000008c34b2a6961) dm-4 SUN,CSM200_R
[size=6.4T][features=1 queue_if_no_path][hwhandler=1 rdac][rw]
\_ round-robin 0 [prio=3][active]
 \_ 1:0:2:0 sdd 8:48  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:2:0 sdg 8:96  [active][ghost]
# dmsetup remove sossan4
device-mapper: remove ioctl failed: Device or resource busy
Command failed
# dmsetup remove sossan5
device-mapper: remove ioctl failed: Device or resource busy
Command failed
# dmsetup info sossan4
Name:              sossan4
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        8
Event number:      5
Major, minor:      253, 2
Number of targets: 1
UUID: mpath-3600a0b800048ead00000070c4b2a66ee
# dmsetup info sossan5
Name:              sossan5
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        8
Event number:      3
Major, minor:      253, 4
Number of targets: 1
UUID: mpath-3600a0b800048eac2000008c34b2a6961

Note the "Open Count" is 8 and not 0 !? How do i find out what is keeping
these resources busy?

I am pretty sure a reboot would fix this, maybe even a brute force removal
of the underlying sdX devices, but as this is a production system I would
rather find the "right way"?

Versions:

# uname -a
Linux otsvm02 2.6.18-164.el5xen #1 SMP Tue Aug 18 15:59:52 EDT 2009 x86_64
x86_64 x86_64 GNU/Linux
# cat /etc/redhat-release
Red Hat Enterprise Linux Server release 5.4 (Tikanga)
# rpm -q device-mapper
device-mapper-1.02.32-1.el5
# dmsetup version
Library version:   1.02.32 (2009-05-21)
Driver version:    4.11.5

Ideas?

Thanks,
Kevin

--001485f5cd9630d7410481d3d667
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi<br><br>I wish to remove some mpath devices (which are in fact SAN storag=
e)=A0 from my server.<br><br>Previously LVM objects was built on top of the=
se devices, but these have been removed via lvremove + vgremove + pvremove.=
 lvs/vgs/pvs list nothing related to the underlying mpath devices.<br>
<br>I then commented out the relevant entries in /etc/multipath.conf and tr=
ied:<br><br>$ multipath -F<br>sossan4: map in use<br>ecfs1: map in use<br>s=
ossan5: map in use<br><br>(sossan4/5 should now be removable, ecfs1 is stil=
l in use)<br>
<br>Also<br><br># multipath -ll<br>sossan4 (3600a0b800048ead00000070c4b2a66=
ee) dm-2 SUN,CSM200_R<br>[size=3D6.4T][features=3D1 queue_if_no_path][hwhan=
dler=3D1 rdac][rw]<br>\_ round-robin 0 [prio=3D3][active]<br>=A0\_ 1:0:0:0 =
sdb 8:16=A0 [active][ready]<br>
\_ round-robin 0 [prio=3D0][enabled]<br>=A0\_ 2:0:0:0 sde 8:64=A0 [active][=
ghost]<br>ecfs1 (3600d0230ffffffff02bd6d4c3b1a8900) dm-3 IFT,A16F-R2431<br>=
[size=3D6.4T][features=3D1 queue_if_no_path][hwhandler=3D0][rw]<br>\_ round=
-robin 0 [prio=3D1][active]<br>
=A0\_ 1:0:1:0 sdc 8:32=A0 [active][ready]<br>\_ round-robin 0 [prio=3D1][en=
abled]<br>=A0\_ 2:0:1:0 sdf 8:80=A0 [active][ready]<br>sossan5 (3600a0b8000=
48eac2000008c34b2a6961) dm-4 SUN,CSM200_R<br>[size=3D6.4T][features=3D1 que=
ue_if_no_path][hwhandler=3D1 rdac][rw]<br>
\_ round-robin 0 [prio=3D3][active]<br>=A0\_ 1:0:2:0 sdd 8:48=A0 [active][r=
eady]<br>\_ round-robin 0 [prio=3D0][enabled]<br>=A0\_ 2:0:2:0 sdg 8:96=A0 =
[active][ghost]<br># dmsetup remove sossan4<br>device-mapper: remove ioctl =
failed: Device or resource busy<br>
Command failed<br># dmsetup remove sossan5<br>device-mapper: remove ioctl f=
ailed: Device or resource busy<br>Command failed<br># dmsetup info sossan4<=
br>Name:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sossan4<br>State:=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTIVE<br>Read Ahead:=A0=A0=A0=A0=A0=A0=A0 256<=
br>
Tables present:=A0=A0=A0 LIVE<br>Open count:=A0=A0=A0=A0=A0=A0=A0 8<br>Even=
t number:=A0=A0=A0=A0=A0 5<br>Major, minor:=A0=A0=A0=A0=A0 253, 2<br>Number=
 of targets: 1<br>UUID: mpath-3600a0b800048ead00000070c4b2a66ee<br># dmsetu=
p info sossan5<br>Name:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sossan5<br>
State:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTIVE<br>Read Ahead:=A0=A0=A0=
=A0=A0=A0=A0 256<br>Tables present:=A0=A0=A0 LIVE<br>Open count:=A0=A0=A0=
=A0=A0=A0=A0 8<br>Event number:=A0=A0=A0=A0=A0 3<br>Major, minor:=A0=A0=A0=
=A0=A0 253, 4<br>Number of targets: 1<br>UUID: mpath-3600a0b800048eac200000=
8c34b2a6961<br>
<br>Note the &quot;Open Count&quot; is 8 and not 0 !? How do i find out wha=
t is keeping these resources busy?<br><br>I am pretty sure a reboot would f=
ix this, maybe even a brute force removal of the underlying sdX devices, bu=
t as this is a production system I would rather find the &quot;right way&qu=
ot;?<br>
<br>Versions:<br><br># uname -a<br>Linux otsvm02 2.6.18-164.el5xen #1 SMP T=
ue Aug 18 15:59:52 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux<br># cat /etc/re=
dhat-release <br>Red Hat Enterprise Linux Server release 5.4 (Tikanga)<br>
# rpm -q device-mapper<br>device-mapper-1.02.32-1.el5<br># dmsetup version<=
br>Library version:=A0=A0 1.02.32 (2009-05-21)<br>Driver version:=A0=A0=A0 =
4.11.5<br><br>Ideas?<br><br>Thanks,<br>Kevin<br><br><br><br><br>

--001485f5cd9630d7410481d3d667--


--===============8444415667890178106==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8444415667890178106==--
