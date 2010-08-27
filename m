From: "Stamper, Brian P. (ARC-D)[Logyx LLC]" <brian.p.stamper@nasa.gov>
Subject: Re: oblem with lvm and multipath on fedora 13
Date: Fri, 27 Aug 2010 13:57:24 -0500
Message-ID: <C89D58A4.10716%brian.p.stamper@nasa.gov>
References: <20100827182634.GB31618@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5361970144082075364=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100827182634.GB31618@us.ibm.com>
Content-Language: en
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============5361970144082075364==
Content-Language: en
Content-Type: multipart/alternative;
	boundary="_000_C89D58A410716brianpstampernasagov_"

--_000_C89D58A410716brianpstampernasagov_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


That works, now how do I stop it?

-Brian

[root@testfs ~]# multipath -ll
op-tst-fsdata01-rw-04Jun2010 (350002ac0021b05d8) dm-0 3PARdata,VV
size=3D2.0T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive
  |- 3:0:0:9  sdk  8:160  active ready running
  `- 4:0:0:9  sdy  65:128 active ready running
testfsdata01 (350002ac000e505d8) dm-8 3PARdata,VV
size=3D2.0T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive
  |- 3:0:0:1  sdc  8:32   active ready running
  `- 4:0:0:1  sdq  65:0   active ready running
op-tst-fsdata03-rw-04Jun2010 (350002ac0021d05d8) dm-16 3PARdata,VV
size=3D2.0T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive
  |- 3:0:0:11 sdm  8:192  active ready running
  `- 4:0:0:11 sdaa 65:160 active ready running
testsnapfslog02 (350002ac001ca05d8) dm-12 3PARdata,VV
size=3D200G features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive
  |- 3:0:0:13 sdo  8:224  active ready running
  `- 4:0:0:13 sdac 65:192 active ready running
testfslog01 (350002ac000e605d8) dm-7 3PARdata,VV
size=3D200G features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive
  |- 3:0:0:0  sdb  8:16   active ready running
  `- 4:0:0:0  sdp  8:240  active ready running
testsnapfslog01 (350002ac0010905d8) dm-11 3PARdata,VV
size=3D200G features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive
  |- 3:0:0:8  sdj  8:144  active ready running
  `- 4:0:0:8  sdx  65:112 active ready running
op-tst-fsdata02-rw-04Jun2010 (350002ac0021c05d8) dm-18 3PARdata,VV
size=3D2.0T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive
  |- 3:0:0:10 sdl  8:176  active ready running
  `- 4:0:0:10 sdz  65:144 active ready running
testnfs02 (350002ac000ea05d8) dm-10 3PARdata,VV
size=3D2.0T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive
  |- 3:0:0:3  sde  8:64   active ready running
  `- 4:0:0:3  sds  65:32  active ready running
testnfs01 (350002ac000e905d8) dm-9 3PARdata,VV
size=3D2.0T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive
  |- 3:0:0:2  sdd  8:48   active ready running
  `- 4:0:0:2  sdr  65:16  active ready running
op-tst-fsdata04-rw-04Jun2010 (350002ac0021e05d8) dm-17 3PARdata,VV
size=3D2.0T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive
  |- 3:0:0:12 sdn  8:208  active ready running
  `- 4:0:0:12 sdab 65:176 active ready running

Aug 27 11:52:26 | sdk: ownership set to op-tst-fsdata01-rw-04Jun2010
Aug 27 11:52:26 | sdk: not found in pathvec
Aug 27 11:52:26 | sdk: mask =3D 0xc
Aug 27 11:52:26 | sdk: get_state
Aug 27 11:52:26 | sdk: state =3D running
Aug 27 11:52:26 | sdk: state =3D 3
Aug 27 11:52:26 | sdk: const prio =3D 1
Aug 27 11:52:26 | sdy: ownership set to op-tst-fsdata01-rw-04Jun2010
Aug 27 11:52:26 | sdy: not found in pathvec
Aug 27 11:52:26 | sdy: mask =3D 0xc
Aug 27 11:52:26 | sdy: get_state
Aug 27 11:52:26 | sdy: state =3D running
Aug 27 11:52:26 | sdy: state =3D 3
Aug 27 11:52:26 | sdy: const prio =3D 1
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: pgfailback =3D 15 (controll=
er setting)
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: pgpolicy =3D multibus (cont=
roller setting)
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: selector =3D round-robin 0 =
(controller setting)
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: features =3D 0 (controller =
setting)
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: hwhandler =3D 0 (controller=
 setting)
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: rr_weight =3D 2 (controller=
 setting)
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: minio =3D 1000 (controller =
setting)
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: no_path_retry =3D -2 (contr=
oller setting)
Aug 27 11:52:26 | pg_timeout =3D NONE (internal default)
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: set ACT_CREATE (map does no=
t exist)
create: op-tst-fsdata01-rw-04Jun2010 (350002ac0021b05d8) undef 3PARdata,VV
size=3D2.0T features=3D'0' hwhandler=3D'0' wp=3Dundef
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dundef
  |- 3:0:0:9  sdk  8:160  undef ready running
  `- 4:0:0:9  sdy  65:128 undef ready running
Aug 27 11:52:26 | sdm: ownership set to op-tst-fsdata03-rw-04Jun2010
Aug 27 11:52:26 | sdm: not found in pathvec
Aug 27 11:52:26 | sdm: mask =3D 0xc
Aug 27 11:52:26 | sdm: get_state
Aug 27 11:52:26 | sdm: state =3D running
Aug 27 11:52:26 | sdm: state =3D 3
Aug 27 11:52:26 | sdm: const prio =3D 1
Aug 27 11:52:26 | sdaa: ownership set to op-tst-fsdata03-rw-04Jun2010
Aug 27 11:52:26 | sdaa: not found in pathvec
Aug 27 11:52:26 | sdaa: mask =3D 0xc
Aug 27 11:52:26 | sdaa: get_state
Aug 27 11:52:26 | sdaa: state =3D running
Aug 27 11:52:26 | sdaa: state =3D 3
Aug 27 11:52:26 | sdaa: const prio =3D 1
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: pgfailback =3D 15 (controll=
er setting)
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: pgpolicy =3D multibus (cont=
roller setting)
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: selector =3D round-robin 0 =
(controller setting)
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: features =3D 0 (controller =
setting)
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: hwhandler =3D 0 (controller=
 setting)
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: rr_weight =3D 2 (controller=
 setting)
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: minio =3D 1000 (controller =
setting)
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: no_path_retry =3D -2 (contr=
oller setting)
Aug 27 11:52:26 | pg_timeout =3D NONE (internal default)
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: set ACT_CREATE (map does no=
t exist)
create: op-tst-fsdata03-rw-04Jun2010 (350002ac0021d05d8) undef 3PARdata,VV
size=3D2.0T features=3D'0' hwhandler=3D'0' wp=3Dundef
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dundef
  |- 3:0:0:11 sdm  8:192  undef ready running
  `- 4:0:0:11 sdaa 65:160 undef ready running
Aug 27 11:52:26 | sdn: ownership set to op-tst-fsdata04-rw-04Jun2010
Aug 27 11:52:26 | sdn: not found in pathvec
Aug 27 11:52:26 | sdn: mask =3D 0xc
Aug 27 11:52:26 | sdn: get_state
Aug 27 11:52:26 | sdn: state =3D running
Aug 27 11:52:26 | sdn: state =3D 3
Aug 27 11:52:26 | sdn: const prio =3D 1
Aug 27 11:52:26 | sdab: ownership set to op-tst-fsdata04-rw-04Jun2010
Aug 27 11:52:26 | sdab: not found in pathvec
Aug 27 11:52:26 | sdab: mask =3D 0xc
Aug 27 11:52:26 | sdab: get_state
Aug 27 11:52:26 | sdab: state =3D running
Aug 27 11:52:26 | sdab: state =3D 3
Aug 27 11:52:26 | sdab: const prio =3D 1
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: pgfailback =3D 15 (controll=
er setting)
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: pgpolicy =3D multibus (cont=
roller setting)
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: selector =3D round-robin 0 =
(controller setting)
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: features =3D 0 (controller =
setting)
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: hwhandler =3D 0 (controller=
 setting)
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: rr_weight =3D 2 (controller=
 setting)
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: minio =3D 1000 (controller =
setting)
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: no_path_retry =3D -2 (contr=
oller setting)
Aug 27 11:52:26 | pg_timeout =3D NONE (internal default)
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: set ACT_CREATE (map does no=
t exist)
create: op-tst-fsdata04-rw-04Jun2010 (350002ac0021e05d8) undef 3PARdata,VV
size=3D2.0T features=3D'0' hwhandler=3D'0' wp=3Dundef
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dundef
  |- 3:0:0:12 sdn  8:208  undef ready running
  `- 4:0:0:12 sdab 65:176 undef ready running
Aug 27 11:52:26 | sdl: ownership set to op-tst-fsdata02-rw-04Jun2010
Aug 27 11:52:26 | sdl: not found in pathvec
Aug 27 11:52:26 | sdl: mask =3D 0xc
Aug 27 11:52:26 | sdl: get_state
Aug 27 11:52:26 | sdl: state =3D running
Aug 27 11:52:26 | sdl: state =3D 3
Aug 27 11:52:26 | sdl: const prio =3D 1
Aug 27 11:52:26 | sdz: ownership set to op-tst-fsdata02-rw-04Jun2010
Aug 27 11:52:26 | sdz: not found in pathvec
Aug 27 11:52:26 | sdz: mask =3D 0xc
Aug 27 11:52:26 | sdz: get_state
Aug 27 11:52:26 | sdz: state =3D running
Aug 27 11:52:26 | sdz: state =3D 3
Aug 27 11:52:26 | sdz: const prio =3D 1
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: pgfailback =3D 15 (controll=
er setting)
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: pgpolicy =3D multibus (cont=
roller setting)
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: selector =3D round-robin 0 =
(controller setting)
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: features =3D 0 (controller =
setting)
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: hwhandler =3D 0 (controller=
 setting)
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: rr_weight =3D 2 (controller=
 setting)
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: minio =3D 1000 (controller =
setting)
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: no_path_retry =3D -2 (contr=
oller setting)
Aug 27 11:52:26 | pg_timeout =3D NONE (internal default)
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: set ACT_CREATE (map does no=
t exist)
create: op-tst-fsdata02-rw-04Jun2010 (350002ac0021c05d8) undef 3PARdata,VV
size=3D2.0T features=3D'0' hwhandler=3D'0' wp=3Dundef
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dundef
  |- 3:0:0:10 sdl  8:176  undef ready running
  `- 4:0:0:10 sdz  65:144 undef ready running



On 8/27/10 11:26 AM, "Malahal Naineni" <malahal@us.ibm.com> wrote:

Stamper, Brian P. (ARC-D)[Logyx LLC] [brian.p.stamper@nasa.gov] wrote:
> Last night I upgraded a box from Fedora 11 to Fedora 13, which upgraded
> multipath from 4.8-10 to 4.9-14.  After the upgrade, multipath is failing=
 to
> create maps for some of my volumes.  The volumes are coming from a 3par
> system, which is directly attached to Qlogic HBAs.
>
> The volumes I'm having problems with contain vgs and lvms.  They're also
> snapshot volumes.  I have a base volume (non-snapshot) that contains a vg
> that is working fine.  I would not expect that these volumes being snapsh=
ots
> would be significant, but it's the only common thread I've found so far.
>
> It seems almost like a timing issue, where lvm is grabbing the disks befo=
re
> multipath has a chance to create the maps.  What I can't figure is why it
> only affects these volumes.  Looking through /var/log/messages from start=
up,
> I am seeing some "unknown partition type" messages that do seem to
> correspond to the volumes that dracut is reporting as duplicate PVs, so I=
'll
> investigate that.
>
> Help would be much appreciated.

If you can, deactivate the affected VG, restart multipath (it should be
able to load maps now) and then activate the VG. If this works, then
there is something that is causing LVM to claim devices before multipath
does.

Thanks, Malahal.
PS: If you don't have multipath in initrd, LVM *may* claim paths as PV's
before the multipath from active root can claim them. Don't have enough
info on Fedora13 initrd if this can happen though.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


--_000_C89D58A410716brianpstampernasagov_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML>
<HEAD>
<TITLE>Re: [dm-devel] oblem with lvm and multipath on fedora 13</TITLE>
</HEAD>
<BODY>
<FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><SPAN STYLE=3D'font-size:=
11pt'><BR>
That works, now how do I stop it?<BR>
<BR>
-Brian<BR>
<BR>
[root@testfs ~]# multipath -ll<BR>
<B>op-tst-fsdata01-rw-04Jun2010 (350002ac0021b05d8) dm-0 3PARdata,VV<BR>
size=3D2.0T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw<BR>
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive<BR>
&nbsp;&nbsp;|- 3:0:0:9 &nbsp;sdk &nbsp;8:160 &nbsp;active ready running<BR>
&nbsp;&nbsp;`- 4:0:0:9 &nbsp;sdy &nbsp;65:128 active ready running<BR>
</B>testfsdata01 (350002ac000e505d8) dm-8 3PARdata,VV<BR>
size=3D2.0T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw<BR>
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive<BR>
&nbsp;&nbsp;|- 3:0:0:1 &nbsp;sdc &nbsp;8:32 &nbsp;&nbsp;active ready runnin=
g<BR>
&nbsp;&nbsp;`- 4:0:0:1 &nbsp;sdq &nbsp;65:0 &nbsp;&nbsp;active ready runnin=
g<BR>
<B>op-tst-fsdata03-rw-04Jun2010 (350002ac0021d05d8) dm-16 3PARdata,VV<BR>
size=3D2.0T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw<BR>
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive<BR>
&nbsp;&nbsp;|- 3:0:0:11 sdm &nbsp;8:192 &nbsp;active ready running<BR>
&nbsp;&nbsp;`- 4:0:0:11 sdaa 65:160 active ready running<BR>
</B>testsnapfslog02 (350002ac001ca05d8) dm-12 3PARdata,VV<BR>
size=3D200G features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw<BR>
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive<BR>
&nbsp;&nbsp;|- 3:0:0:13 sdo &nbsp;8:224 &nbsp;active ready running<BR>
&nbsp;&nbsp;`- 4:0:0:13 sdac 65:192 active ready running<BR>
testfslog01 (350002ac000e605d8) dm-7 3PARdata,VV<BR>
size=3D200G features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw<BR>
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive<BR>
&nbsp;&nbsp;|- 3:0:0:0 &nbsp;sdb &nbsp;8:16 &nbsp;&nbsp;active ready runnin=
g<BR>
&nbsp;&nbsp;`- 4:0:0:0 &nbsp;sdp &nbsp;8:240 &nbsp;active ready running<BR>
testsnapfslog01 (350002ac0010905d8) dm-11 3PARdata,VV<BR>
size=3D200G features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw<BR>
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive<BR>
&nbsp;&nbsp;|- 3:0:0:8 &nbsp;sdj &nbsp;8:144 &nbsp;active ready running<BR>
&nbsp;&nbsp;`- 4:0:0:8 &nbsp;sdx &nbsp;65:112 active ready running<BR>
<B>op-tst-fsdata02-rw-04Jun2010 (350002ac0021c05d8) dm-18 3PARdata,VV<BR>
size=3D2.0T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw<BR>
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive<BR>
&nbsp;&nbsp;|- 3:0:0:10 sdl &nbsp;8:176 &nbsp;active ready running<BR>
&nbsp;&nbsp;`- 4:0:0:10 sdz &nbsp;65:144 active ready running<BR>
</B>testnfs02 (350002ac000ea05d8) dm-10 3PARdata,VV<BR>
size=3D2.0T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw<BR>
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive<BR>
&nbsp;&nbsp;|- 3:0:0:3 &nbsp;sde &nbsp;8:64 &nbsp;&nbsp;active ready runnin=
g<BR>
&nbsp;&nbsp;`- 4:0:0:3 &nbsp;sds &nbsp;65:32 &nbsp;active ready running<BR>
testnfs01 (350002ac000e905d8) dm-9 3PARdata,VV<BR>
size=3D2.0T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw<BR>
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive<BR>
&nbsp;&nbsp;|- 3:0:0:2 &nbsp;sdd &nbsp;8:48 &nbsp;&nbsp;active ready runnin=
g<BR>
&nbsp;&nbsp;`- 4:0:0:2 &nbsp;sdr &nbsp;65:16 &nbsp;active ready running<BR>
<B>op-tst-fsdata04-rw-04Jun2010 (350002ac0021e05d8) dm-17 3PARdata,VV<BR>
size=3D2.0T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw<BR>
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive<BR>
&nbsp;&nbsp;|- 3:0:0:12 sdn &nbsp;8:208 &nbsp;active ready running<BR>
&nbsp;&nbsp;`- 4:0:0:12 sdab 65:176 active ready running<BR>
</B><BR>
Aug 27 11:52:26 | sdk: ownership set to op-tst-fsdata01-rw-04Jun2010<BR>
Aug 27 11:52:26 | sdk: not found in pathvec<BR>
Aug 27 11:52:26 | sdk: mask =3D 0xc<BR>
Aug 27 11:52:26 | sdk: get_state<BR>
Aug 27 11:52:26 | sdk: state =3D running<BR>
Aug 27 11:52:26 | sdk: state =3D 3<BR>
Aug 27 11:52:26 | sdk: const prio =3D 1<BR>
Aug 27 11:52:26 | sdy: ownership set to op-tst-fsdata01-rw-04Jun2010<BR>
Aug 27 11:52:26 | sdy: not found in pathvec<BR>
Aug 27 11:52:26 | sdy: mask =3D 0xc<BR>
Aug 27 11:52:26 | sdy: get_state<BR>
Aug 27 11:52:26 | sdy: state =3D running<BR>
Aug 27 11:52:26 | sdy: state =3D 3<BR>
Aug 27 11:52:26 | sdy: const prio =3D 1<BR>
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: pgfailback =3D 15 (controll=
er setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: pgpolicy =3D multibus (cont=
roller setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: selector =3D round-robin 0 =
(controller setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: features =3D 0 (controller =
setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: hwhandler =3D 0 (controller=
 setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: rr_weight =3D 2 (controller=
 setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: minio =3D 1000 (controller =
setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: no_path_retry =3D -2 (contr=
oller setting)<BR>
Aug 27 11:52:26 | pg_timeout =3D NONE (internal default)<BR>
Aug 27 11:52:26 | op-tst-fsdata01-rw-04Jun2010: set ACT_CREATE (map does no=
t exist)<BR>
create: op-tst-fsdata01-rw-04Jun2010 (350002ac0021b05d8) undef 3PARdata,VV<=
BR>
size=3D2.0T features=3D'0' hwhandler=3D'0' wp=3Dundef<BR>
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dundef<BR>
&nbsp;&nbsp;|- 3:0:0:9 &nbsp;sdk &nbsp;8:160 &nbsp;undef ready running<BR>
&nbsp;&nbsp;`- 4:0:0:9 &nbsp;sdy &nbsp;65:128 undef ready running<BR>
Aug 27 11:52:26 | sdm: ownership set to op-tst-fsdata03-rw-04Jun2010<BR>
Aug 27 11:52:26 | sdm: not found in pathvec<BR>
Aug 27 11:52:26 | sdm: mask =3D 0xc<BR>
Aug 27 11:52:26 | sdm: get_state<BR>
Aug 27 11:52:26 | sdm: state =3D running<BR>
Aug 27 11:52:26 | sdm: state =3D 3<BR>
Aug 27 11:52:26 | sdm: const prio =3D 1<BR>
Aug 27 11:52:26 | sdaa: ownership set to op-tst-fsdata03-rw-04Jun2010<BR>
Aug 27 11:52:26 | sdaa: not found in pathvec<BR>
Aug 27 11:52:26 | sdaa: mask =3D 0xc<BR>
Aug 27 11:52:26 | sdaa: get_state<BR>
Aug 27 11:52:26 | sdaa: state =3D running<BR>
Aug 27 11:52:26 | sdaa: state =3D 3<BR>
Aug 27 11:52:26 | sdaa: const prio =3D 1<BR>
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: pgfailback =3D 15 (controll=
er setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: pgpolicy =3D multibus (cont=
roller setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: selector =3D round-robin 0 =
(controller setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: features =3D 0 (controller =
setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: hwhandler =3D 0 (controller=
 setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: rr_weight =3D 2 (controller=
 setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: minio =3D 1000 (controller =
setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: no_path_retry =3D -2 (contr=
oller setting)<BR>
Aug 27 11:52:26 | pg_timeout =3D NONE (internal default)<BR>
Aug 27 11:52:26 | op-tst-fsdata03-rw-04Jun2010: set ACT_CREATE (map does no=
t exist)<BR>
create: op-tst-fsdata03-rw-04Jun2010 (350002ac0021d05d8) undef 3PARdata,VV<=
BR>
size=3D2.0T features=3D'0' hwhandler=3D'0' wp=3Dundef<BR>
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dundef<BR>
&nbsp;&nbsp;|- 3:0:0:11 sdm &nbsp;8:192 &nbsp;undef ready running<BR>
&nbsp;&nbsp;`- 4:0:0:11 sdaa 65:160 undef ready running<BR>
Aug 27 11:52:26 | sdn: ownership set to op-tst-fsdata04-rw-04Jun2010<BR>
Aug 27 11:52:26 | sdn: not found in pathvec<BR>
Aug 27 11:52:26 | sdn: mask =3D 0xc<BR>
Aug 27 11:52:26 | sdn: get_state<BR>
Aug 27 11:52:26 | sdn: state =3D running<BR>
Aug 27 11:52:26 | sdn: state =3D 3<BR>
Aug 27 11:52:26 | sdn: const prio =3D 1<BR>
Aug 27 11:52:26 | sdab: ownership set to op-tst-fsdata04-rw-04Jun2010<BR>
Aug 27 11:52:26 | sdab: not found in pathvec<BR>
Aug 27 11:52:26 | sdab: mask =3D 0xc<BR>
Aug 27 11:52:26 | sdab: get_state<BR>
Aug 27 11:52:26 | sdab: state =3D running<BR>
Aug 27 11:52:26 | sdab: state =3D 3<BR>
Aug 27 11:52:26 | sdab: const prio =3D 1<BR>
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: pgfailback =3D 15 (controll=
er setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: pgpolicy =3D multibus (cont=
roller setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: selector =3D round-robin 0 =
(controller setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: features =3D 0 (controller =
setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: hwhandler =3D 0 (controller=
 setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: rr_weight =3D 2 (controller=
 setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: minio =3D 1000 (controller =
setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: no_path_retry =3D -2 (contr=
oller setting)<BR>
Aug 27 11:52:26 | pg_timeout =3D NONE (internal default)<BR>
Aug 27 11:52:26 | op-tst-fsdata04-rw-04Jun2010: set ACT_CREATE (map does no=
t exist)<BR>
create: op-tst-fsdata04-rw-04Jun2010 (350002ac0021e05d8) undef 3PARdata,VV<=
BR>
size=3D2.0T features=3D'0' hwhandler=3D'0' wp=3Dundef<BR>
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dundef<BR>
&nbsp;&nbsp;|- 3:0:0:12 sdn &nbsp;8:208 &nbsp;undef ready running<BR>
&nbsp;&nbsp;`- 4:0:0:12 sdab 65:176 undef ready running<BR>
Aug 27 11:52:26 | sdl: ownership set to op-tst-fsdata02-rw-04Jun2010<BR>
Aug 27 11:52:26 | sdl: not found in pathvec<BR>
Aug 27 11:52:26 | sdl: mask =3D 0xc<BR>
Aug 27 11:52:26 | sdl: get_state<BR>
Aug 27 11:52:26 | sdl: state =3D running<BR>
Aug 27 11:52:26 | sdl: state =3D 3<BR>
Aug 27 11:52:26 | sdl: const prio =3D 1<BR>
Aug 27 11:52:26 | sdz: ownership set to op-tst-fsdata02-rw-04Jun2010<BR>
Aug 27 11:52:26 | sdz: not found in pathvec<BR>
Aug 27 11:52:26 | sdz: mask =3D 0xc<BR>
Aug 27 11:52:26 | sdz: get_state<BR>
Aug 27 11:52:26 | sdz: state =3D running<BR>
Aug 27 11:52:26 | sdz: state =3D 3<BR>
Aug 27 11:52:26 | sdz: const prio =3D 1<BR>
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: pgfailback =3D 15 (controll=
er setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: pgpolicy =3D multibus (cont=
roller setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: selector =3D round-robin 0 =
(controller setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: features =3D 0 (controller =
setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: hwhandler =3D 0 (controller=
 setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: rr_weight =3D 2 (controller=
 setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: minio =3D 1000 (controller =
setting)<BR>
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: no_path_retry =3D -2 (contr=
oller setting)<BR>
Aug 27 11:52:26 | pg_timeout =3D NONE (internal default)<BR>
Aug 27 11:52:26 | op-tst-fsdata02-rw-04Jun2010: set ACT_CREATE (map does no=
t exist)<BR>
create: op-tst-fsdata02-rw-04Jun2010 (350002ac0021c05d8) undef 3PARdata,VV<=
BR>
size=3D2.0T features=3D'0' hwhandler=3D'0' wp=3Dundef<BR>
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dundef<BR>
&nbsp;&nbsp;|- 3:0:0:10 sdl &nbsp;8:176 &nbsp;undef ready running<BR>
&nbsp;&nbsp;`- 4:0:0:10 sdz &nbsp;65:144 undef ready running<BR>
<BR>
<BR>
<BR>
On 8/27/10 11:26 AM, &quot;Malahal Naineni&quot; &lt;<a href=3D"malahal@us.=
ibm.com">malahal@us.ibm.com</a>&gt; wrote:<BR>
<BR>
</SPAN></FONT><BLOCKQUOTE><FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"=
><SPAN STYLE=3D'font-size:11pt'>Stamper, Brian P. (ARC-D)[Logyx LLC] [<a hr=
ef=3D"brian.p.stamper@nasa.gov">brian.p.stamper@nasa.gov</a>] wrote:<BR>
&gt; Last night I upgraded a box from Fedora 11 to Fedora 13, which upgrade=
d<BR>
&gt; multipath from 4.8-10 to 4.9-14. &nbsp;After the upgrade, multipath is=
 failing to<BR>
&gt; create maps for some of my volumes. &nbsp;The volumes are coming from =
a 3par<BR>
&gt; system, which is directly attached to Qlogic HBAs.<BR>
&gt;<BR>
&gt; The volumes I'm having problems with contain vgs and lvms. &nbsp;They'=
re also<BR>
&gt; snapshot volumes. &nbsp;I have a base volume (non-snapshot) that conta=
ins a vg<BR>
&gt; that is working fine. &nbsp;I would not expect that these volumes bein=
g snapshots<BR>
&gt; would be significant, but it's the only common thread I've found so fa=
r.<BR>
&gt;<BR>
&gt; It seems almost like a timing issue, where lvm is grabbing the disks b=
efore<BR>
&gt; multipath has a chance to create the maps. &nbsp;What I can't figure i=
s why it<BR>
&gt; only affects these volumes. &nbsp;Looking through /var/log/messages fr=
om startup,<BR>
&gt; I am seeing some &quot;unknown partition type&quot; messages that do s=
eem to<BR>
&gt; correspond to the volumes that dracut is reporting as duplicate PVs, s=
o I'll<BR>
&gt; investigate that.<BR>
&gt;<BR>
&gt; Help would be much appreciated.<BR>
<BR>
If you can, deactivate the affected VG, restart multipath (it should be<BR>
able to load maps now) and then activate the VG. If this works, then<BR>
there is something that is causing LVM to claim devices before multipath<BR=
>
does.<BR>
<BR>
Thanks, Malahal.<BR>
PS: If you don't have multipath in initrd, LVM *may* claim paths as PV's<BR=
>
before the multipath from active root can claim them. Don't have enough<BR>
info on Fedora13 initrd if this can happen though.<BR>
<BR>
--<BR>
dm-devel mailing list<BR>
<a href=3D"dm-devel@redhat.com">dm-devel@redhat.com</a><BR>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel">https://www.re=
dhat.com/mailman/listinfo/dm-devel</a><BR>
<BR>
</SPAN></FONT></BLOCKQUOTE>
</BODY>
</HTML>


--_000_C89D58A410716brianpstampernasagov_--


--===============5361970144082075364==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5361970144082075364==--
