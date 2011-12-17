From: "Rudy Gevaert" <Rudy.Gevaert@UGent.be>
Subject: Re: how to troubleshoot faulty multipath path?
Date: Sat, 17 Dec 2011 11:34:50 +0100
Message-ID: <20111217113450.35436m5i93gv279m@webmail.ugent.be>
References: <4EEB6886.402@UGent.be>
	<47D23AD8469A2B448F33C24BD7A39BD910C56472@RTPMVEXC1-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_6l9l25890qq2"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47D23AD8469A2B448F33C24BD7A39BD910C56472@RTPMVEXC1-PRD.hq.netapp.com>
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

This message is in MIME format.

--=_6l9l25890qq2
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Mr Moger,

Quoting "Moger, Babu" <Babu.Moger@netapp.com>:

> My initial guess is, there could be problem with your configuration.
> Can you paste output of "multipath -ll".  How does your multipath.conf
> look like.  Can you paste that as well.
> You messages file might help also.

I have attached the output of multipath -ll.  My multipath.conf only =20
has some aliases defined, so I didn't attach that.  I'm using the =20
default config.

I've grepped through the messages, dmesg and kern.log files.  I have =20
attached them.  (Adding the full files isn't possible they have other =20
application level output too.)

I forgot to mention, I'm using 0.4.8+git0.761c66f-9 of =20
multipath-tools. (Debian stable)

Thanks in advance!


--=20
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Rudy Gevaert                             e-mail: Rudy.Gevaert@UGent.be
  Directie ICT, Afdeling Infrastructuur
  Groep Systemen                                      tel: +32 9 264 4750
  Universiteit Gent                                   fax: +32 9 264 4994
  Krijgslaan 281, gebouw S9, 9000 Gent, Belgie               www.UGent.be
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

--=_6l9l25890qq2
Content-Type: text/plain;
	charset=UTF-8;
	name="dmesg"
Content-Disposition: attachment;
	filename="dmesg"
Content-Transfer-Encoding: quoted-printable

[1850209.907285] device-mapper: ioctl: unable to remove open device mailstor=
e21
[1850569.600287] device-mapper: ioctl: unable to remove open device mailstor=
e21
[1850892.506649] device-mapper: ioctl: unable to remove open device mailstor=
e21
[1851106.061424] device-mapper: ioctl: device doesn't appear to be in the de=
v hash table.
[4895914.569949] device-mapper: table: 253:31: multipath: error getting devi=
ce
[4895914.569989] device-mapper: ioctl: error adding target to table
[4895914.590736] device-mapper: table: 253:31: multipath: error getting devi=
ce
[4895914.590776] device-mapper: ioctl: error adding target to table
[4896672.904187] device-mapper: table: 253:31: multipath: error getting devi=
ce
[4896672.904226] device-mapper: ioctl: error adding target to table
[4896672.915275] device-mapper: table: 253:31: multipath: error getting devi=
ce
[4896672.915311] device-mapper: ioctl: error adding target to table
[4896999.249946] device-mapper: table: 253:31: multipath: error getting devi=
ce
[4896999.249985] device-mapper: ioctl: error adding target to table
[4896999.289079] device-mapper: table: 253:31: multipath: error getting devi=
ce
[4896999.289116] device-mapper: ioctl: error adding target to table
--=_6l9l25890qq2
Content-Type: text/x-log;
	charset=UTF-8;
	name="kern.log"
Content-Disposition: attachment;
	filename="kern.log"
Content-Transfer-Encoding: quoted-printable

kern.log:Dec 16 16:20:13 cyrprd2 kernel: [4895914.569949] device-mapper: tab=
le: 253:31: multipath: error getting device
kern.log:Dec 16 16:20:13 cyrprd2 kernel: [4895914.569989] device-mapper: ioc=
tl: error adding target to table
kern.log:Dec 16 16:20:13 cyrprd2 kernel: [4895914.590736] device-mapper: tab=
le: 253:31: multipath: error getting device
kern.log:Dec 16 16:20:13 cyrprd2 kernel: [4895914.590776] device-mapper: ioc=
tl: error adding target to table
kern.log:Dec 16 16:32:53 cyrprd2 kernel: [4896672.904187] device-mapper: tab=
le: 253:31: multipath: error getting device
kern.log:Dec 16 16:32:53 cyrprd2 kernel: [4896672.904226] device-mapper: ioc=
tl: error adding target to table
kern.log:Dec 16 16:32:53 cyrprd2 kernel: [4896672.915275] device-mapper: tab=
le: 253:31: multipath: error getting device
kern.log:Dec 16 16:32:53 cyrprd2 kernel: [4896672.915311] device-mapper: ioc=
tl: error adding target to table
kern.log:Dec 16 16:38:20 cyrprd2 kernel: [4896999.249946] device-mapper: tab=
le: 253:31: multipath: error getting device
kern.log:Dec 16 16:38:20 cyrprd2 kernel: [4896999.249985] device-mapper: ioc=
tl: error adding target to table
kern.log:Dec 16 16:38:20 cyrprd2 kernel: [4896999.289079] device-mapper: tab=
le: 253:31: multipath: error getting device
kern.log:Dec 16 16:38:20 cyrprd2 kernel: [4896999.289116] device-mapper: ioc=
tl: error adding target to table
--=_6l9l25890qq2
Content-Type: text/plain;
	charset=UTF-8;
	name="messages"
Content-Disposition: attachment;
	filename="messages"
Content-Transfer-Encoding: 7bit

messages:Dec 16 16:20:13 cyrprd2 kernel: [4895914.569989] device-mapper: ioctl: error adding target to table
messages:Dec 16 16:20:13 cyrprd2 kernel: [4895914.590776] device-mapper: ioctl: error adding target to table
messages:Dec 16 16:32:53 cyrprd2 kernel: [4896672.904226] device-mapper: ioctl: error adding target to table
messages:Dec 16 16:32:53 cyrprd2 kernel: [4896672.915311] device-mapper: ioctl: error adding target to table
messages:Dec 16 16:38:20 cyrprd2 kernel: [4896999.249985] device-mapper: ioctl: error adding target to table
messages:Dec 16 16:38:20 cyrprd2 kernel: [4896999.289116] device-mapper: ioctl: error adding target to table

--=_6l9l25890qq2
Content-Type: text/plain;
	charset=UTF-8;
	name="multipath_ll"
Content-Disposition: attachment;
	filename="multipath_ll"
Content-Transfer-Encoding: quoted-printable

mail17r-ds3400-1 (3600a0b80005a67b6000004764cac4912) dm-8 IBM,1726-4xx  FASt=
T
size=3D550G features=3D'1 queue_if_no_path' hwhandler=3D'1 rdac' wp=3Drw
|-+- policy=3D'round-robin 0' prio=3D6 status=3Dactive
| `- 5:0:0:17 sdx  65:112 active ready  running
`-+- policy=3D'round-robin 0' prio=3D1 status=3Denabled
  `- 1:0:0:17 sdj  8:144  active ghost  running
mail13-ds3400-1 (3600a0b80005a67b60000046f4cac471e) dm-4 IBM,1726-4xx  FAStT
size=3D550G features=3D'1 queue_if_no_path' hwhandler=3D'1 rdac' wp=3Drw
|-+- policy=3D'round-robin 0' prio=3D6 status=3Dactive
| `- 5:0:0:13 sdt  65:48  active ready  running
`-+- policy=3D'round-robin 0' prio=3D1 status=3Denabled
  `- 1:0:0:13 sdf  8:80   active ghost  running
mail19r-ds3400-1 (3600a0b80005a67b6000004744cac48bd) dm-10 IBM,1726-4xx  FAS=
tT
size=3D550G features=3D'1 queue_if_no_path' hwhandler=3D'1 rdac' wp=3Drw
|-+- policy=3D'round-robin 0' prio=3D6 status=3Dactive
| `- 5:0:0:19 sdz  65:144 active ready  running
`-+- policy=3D'round-robin 0' prio=3D1 status=3Denabled
  `- 1:0:0:19 sdl  8:176  active ghost  running
mail12-ds3400-1 (3600a0b80005a591a0000042d4cac4753) dm-3 IBM,1726-4xx  FAStT
size=3D550G features=3D'1 queue_if_no_path' hwhandler=3D'1 rdac' wp=3Drw
|-+- policy=3D'round-robin 0' prio=3D6 status=3Dactive
| `- 1:0:0:12 sde  8:64   active ready  running
`-+- policy=3D'round-robin 0' prio=3D1 status=3Denabled
  `- 5:0:0:12 sds  65:32  active ghost  running
mail11-ds3400-1 (3600a0b80005a591a0000042b4cac46de) dm-2 IBM,1726-4xx  FAStT
size=3D550G features=3D'1 queue_if_no_path' hwhandler=3D'1 rdac' wp=3Drw
|-+- policy=3D'round-robin 0' prio=3D0 status=3Denabled
| `- 1:0:0:11 sdd  8:48   active faulty running
`-+- policy=3D'round-robin 0' prio=3D3 status=3Dactive
  `- 5:0:0:11 sdr  65:16  active ready  running
mail10-ds3400-1 (3600a0b80005a67b60000046a4cac4613) dm-1 IBM,1726-4xx  FAStT
size=3D550G features=3D'1 queue_if_no_path' hwhandler=3D'1 rdac' wp=3Drw
|-+- policy=3D'round-robin 0' prio=3D0 status=3Denabled
| `- 5:0:0:10 sdq  65:0   active faulty running
`-+- policy=3D'round-robin 0' prio=3D3 status=3Dactive
  `- 1:0:0:10 sdc  8:32   active ready  running
mail14r-ds3400-1 (3600a0b80005a591a000004294cac468b) dm-5 IBM,1726-4xx  FASt=
T
size=3D550G features=3D'1 queue_if_no_path' hwhandler=3D'1 rdac' wp=3Drw
|-+- policy=3D'round-robin 0' prio=3D6 status=3Dactive
| `- 1:0:0:14 sdg  8:96   active ready  running
`-+- policy=3D'round-robin 0' prio=3D1 status=3Denabled
  `- 5:0:0:14 sdu  65:64  active ghost  running
mail8-ds3400-1 (3600a0b80005a591a000004264cac464b) dm-0 IBM,1726-4xx  FAStT
size=3D550G features=3D'1 queue_if_no_path' hwhandler=3D'1 rdac' wp=3Drw
|-+- policy=3D'round-robin 0' prio=3D6 status=3Dactive
| `- 1:0:0:8  sdb  8:16   active ready  running
`-+- policy=3D'round-robin 0' prio=3D1 status=3Denabled
  `- 5:0:0:8  sdp  8:240  active ghost  running
mail16r-ds3400-1 (3600a0b80005a591a000004304cac47f7) dm-7 IBM,1726-4xx  FASt=
T
size=3D550G features=3D'1 queue_if_no_path' hwhandler=3D'1 rdac' wp=3Drw
|-+- policy=3D'round-robin 0' prio=3D6 status=3Dactive
| `- 1:0:0:16 sdi  8:128  active ready  running
`-+- policy=3D'round-robin 0' prio=3D1 status=3Denabled
  `- 5:0:0:16 sdw  65:96  active ghost  running
mail22r-ds3400-1 (3600a0b80005a591a000004374cac49dd) dm-13 IBM,1726-4xx  FAS=
tT
size=3D550G features=3D'1 queue_if_no_path' hwhandler=3D'1 rdac' wp=3Drw
|-+- policy=3D'round-robin 0' prio=3D6 status=3Dactive
| `- 1:0:0:22 sdo  8:224  active ready  running
`-+- policy=3D'round-robin 0' prio=3D1 status=3Denabled
  `- 5:0:0:22 sdac 65:192 active ghost  running
mail18r-ds3400-1 (3600a0b80005a591a000004324cac4953) dm-9 IBM,1726-4xx  FASt=
T
size=3D550G features=3D'1 queue_if_no_path' hwhandler=3D'1 rdac' wp=3Drw
|-+- policy=3D'round-robin 0' prio=3D6 status=3Dactive
| `- 1:0:0:18 sdk  8:160  active ready  running
`-+- policy=3D'round-robin 0' prio=3D1 status=3Denabled
  `- 5:0:0:18 sdy  65:128 active ghost  running
mail21-ds3400-1 (3600a0b80005a67b6000004714cac4771) dm-12 IBM,1726-4xx  FASt=
T
size=3D550G features=3D'1 queue_if_no_path' hwhandler=3D'1 rdac' wp=3Drw
|-+- policy=3D'round-robin 0' prio=3D6 status=3Dactive
| `- 5:0:0:21 sdab 65:176 active ready  running
`-+- policy=3D'round-robin 0' prio=3D1 status=3Denabled
  `- 1:0:0:21 sdn  8:208  active ghost  running
mail20-ds3400-1 (3600a0b80005a591a000004344cac49a6) dm-11 IBM,1726-4xx  FASt=
T
size=3D550G features=3D'1 queue_if_no_path' hwhandler=3D'1 rdac' wp=3Drw
|-+- policy=3D'round-robin 0' prio=3D6 status=3Dactive
| `- 1:0:0:20 sdm  8:192  active ready  running
`-+- policy=3D'round-robin 0' prio=3D1 status=3Denabled
  `- 5:0:0:20 sdaa 65:160 active ghost  running
mail15r-ds3400-1 (3600a0b80005a67b60000046d4cac464f) dm-6 IBM,1726-4xx  FASt=
T
size=3D550G features=3D'1 queue_if_no_path' hwhandler=3D'1 rdac' wp=3Drw
|-+- policy=3D'round-robin 0' prio=3D0 status=3Denabled
| `- 5:0:0:15 sdv  65:80  active faulty running
`-+- policy=3D'round-robin 0' prio=3D3 status=3Dactive
  `- 1:0:0:15 sdh  8:112  active ready  running
--=_6l9l25890qq2
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=_6l9l25890qq2--
