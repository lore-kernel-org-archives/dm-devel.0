From: Yury Konovalov <ykonovalov@gmail.com>
Subject: IBM x460 with directly attached IBM DS4300 (turbo)
	multipathd TUR path checker problem
Date: Mon, 15 Jan 2007 20:17:48 +0300
Message-ID: <200701152017.57247.YKonovalov@gmail.com>
Reply-To: YKonovalov@gmail.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0808452412=="
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

--===============0808452412==
Content-Type: multipart/signed; boundary="nextPart20887667.nTqsMaVrj7";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart20887667.nTqsMaVrj7
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi!

 I faced with weird problem using multipath-tools and IBM DS4300 turbo stor=
age=20
system.

|      Ctrl A |--ptp fc--| qla2400 HBA-->IBM x460 (first brick) |
|DS4300(turbo)|          | IBM x460 (dual brick configuration)  |
|      Ctrl B |--ptp fc--| qla2400 HBA-->IBM x460 (second brick)|=20
=20
 Operating system:              SLES9 SP3 x86 (32-bit)
 HBA drivers:                   Native SuSe kernel driver (qla2400)
 DS4300 target type:            Linux (AVT is enabled)

 The problem: Unpredictable path failures detected by TUR path checker,=20
 which is resulted in suspending IO to corresponding filesystem. The failed=
 =20
path is reinstated by multipathd on the next turn tur checker invoked by=20
multipathd (10 sec).
 If I increase path checking freq (by reducing polling_interval to 2 as it=
=20
shown in config below), it doesn't help. In fact, it becomes even worse: I=
=20
faced with situation when all path to LUN were failed by TUR checker at  th=
e=20
same time. If not specifying "queue_if_no_path" feature, this leads to IO=20
error reported to upper level (FS). It could work quite good for a day or s=
o,=20
and then *bum*.
=46rom DS4300 controller logs I see numerous AVT event happening on various=
 LUNs=20
from time to time. The interesting thing is that, according to Linux logs,=
=20
the majority of volume transfers were not initiated by multipathd (actually=
,=20
they were not even detected by multipathd). Another strange thing is that=20
many of AVT transfers ended up on the same controller on which it was start=
ed=20
(as it seems to me). I have DS4300 controller log, which is just to big to=
=20
paste here.
=20
What I have already tried:
1) Replace 4G HBA's (qla2400) with 2G HBA's (qla2300). Problem remains.
2) IOZONE tests. Works great. No path failures were detected during tests
3) Play with polling_interval. Didn't help.

I have similar configuration working good at some other site. The differenc=
e=20
between two installations:
1) Single brick configuration of IBM x460
2) Different HBA type (qla2300) installed in host.
3) One HBA instead of two.
4) There is FC-switch between DS4300 controllers and HBA.
5) RHEL4 U4 x86_64 instead of SLES9 SP3 x86
=20
 Questions:
1) What else I can try to resolve this problem?
2) Is it true, that AVT mode could not be used in cluster environment (when=
=20
two or more nodes are accessing the same LUN's, and thus can trigger AVT) ?
3) Is there any hope (or need) to add RDAC hw handler to dm-multipath? It=20
seems like some part of the work already done by Mike Christie=20
(http://www.redhat.com/archives/dm-devel/2005-October/msg00020.html).
Do you have any plans to include this code? Is it in usable state?

=20
 /var/log/messages
 -------------
 Dec 27 07:30:08 tpc1 multipathd: 8:48: tur checker reports path is down
  Dec 27 07:30:08 tpc1 multipathd: checker failed path 8:48 in map oradata1
 Dec 27 07:30:08 tpc1 kernel: device-mapper: dm-multipath: Failing path 8:48
 Dec 27 07:30:08 tpc1 multipathd: 8:96: tur checker reports path is down=20
 Dec 27 07:30:08 tpc1 multipathd: checker failed path 8:96 in map oradata1
  Dec 27 07:30:08 tpc1 kernel: device-mapper: dm-multipath: Failing path 8:=
96
 Dec 27 07:30:09 tpc1 multipathd: 8:112: tur checker reports path is down
 Dec 27 07:30:09 tpc1 multipathd: checker failed path 8:112 in map oraredo=
=20
 Dec 27 07:30:09 tpc1 kernel: device-mapper: dm-multipath: Failing path 8:1=
12
  Dec 27 07:30:09 tpc1 kernel: Buffer I/O error on device dm-9, logical blo=
ck=20
27696
 Dec 27 07:30:09 tpc1 kernel: lost page write due to I/O error on dm-9
 Dec 27 07:30:09 tpc1 kernel: Aborting journal on device dm-9.=20
 Dec 27 07:30:11 tpc1 kernel: ext3_abort called.
 Dec 27 07:30:11 tpc1 kernel: EXT3-fs abort (device dm-9): ext3_journal_sta=
rt:=20
Detected aborted journal
 Dec 27 07:30:11 tpc1 kernel: Remounting filesystem read-only=20
 Dec 27 07:30:12 tpc1 multipathd: 8:64: tur checker reports path is down
  Dec 27 07:30:12 tpc1 kernel: device-mapper: dm-multipath: Failing path 8:=
64
 Dec 27 07:30:12 tpc1 multipathd: checker failed path 8:64 in map oraredo
 Dec 27 07:30:13 tpc1 multipathd: 8:48: tur checker reports path is up=20
 Dec 27 07:30:13 tpc1 multipathd: 8:48: reinstated
 Dec 27 07:30:13 tpc1 multipathd: oradata1: switch to path group #2
 Dec 27 07:30:13 tpc1 multipathd: oradata1: switch to path group #2=20
 Dec 27 07:30:13 tpc1 multipathd: 8:96: tur checker reports path is up
  Dec 27 07:30:13 tpc1 multipathd: 8:96: reinstated
 Dec 27 07:30:13 tpc1 multipathd: oradata1: switch to path group #1=20
 Dec 27 07:30:14 tpc1 multipathd: oradata1: switch to path group #1
  -------------
=20
 multipath.conf :
 ---------------
 defaults {
         udev_dir        /dev
          multipath_tool  "/sbin/multipath -v 0 -S"
         polling_interval 2
          default_path_grouping_policy    multibus
         default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"=20
=20
         rr_min_io 100
          failback                immediate
         no_path_retry           fail=20
 }
=20
 devnode_blacklist {
         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
          devnode "^hd[a-z][[0-9]*]"
         devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"=20
         devnode sda
          devnode fd
         devnode hd
          devnode md
         devnode dm
          devnode sr
         devnode scd
          devnode st
         devnode ram
          devnode raw
         devnode loop
 }
=20
 devices {
=20
         device {
                  vendor                  "IBM     "
                 product                 "1722-600        "=20
                 path_grouping_policy    group_by_prio
                  path_checker            tur
                 path_selector           "round-robin 0"=20
                 prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
                  failback                immediate
                 rr_min_io               1000=20
                  features                "1 queue_if_no_path"
                  no_path_retry           300
         }
  }
=20
 multipaths {=20
     multipath {
         wwid    3600a0b80001ff32a000020c2456bf8a0=20
         alias   oradata1
      }
     multipath {
          wwid    3600a0b80001ff3de000042ba456bfcbc
         alias   oradata2
      }
     multipath {
          wwid    3600a0b80001ff32a000020c5456bf952
         alias   oraredo=20
     }
     multipath {=20
         wwid    3600a0b80001ff32a000020c7456bf980
          alias   oraarch1
     }
      multipath {
         wwid    3600a0b80001ff3de000042bc456bfcf0
          alias   oraarch2
     }
  }

multipath -ll output (with no "queue_if_no_path" feature)
=2D--------------------------------------------------------
dm names   N
 dm table oraarch2  N
dm table oraarch2  N
 dm status oraarch2  N
dm info oraarch2  O
 dm table oraredo  N
dm table oraredo  N
 dm status oraredo  N
dm info oraredo  O
 dm table oraarch1  N
dm table oraarch1  N
 dm status oraarch1  N
dm info oraarch1  O
 dm table oradata2  N
dm table oradata2  N
 dm status oradata2  N
dm info oradata2  O
 dm table oraarch1p1  N
dm table oradata1  N
 dm table oradata1  N
dm status oradata1  N
 dm info oradata1  O
dm table oraarch2p1  N
 dm table oradata1p1  N
dm table oradata2p1  N
 dm table oraredo1  N
oraarch2 (3600a0b80001ff3de000042bc456bfcf0)=20
[size=3D136 GB][features=3D"0"][hwhandler=3D"0"]
 \_ round-robin 0 [prio=3D6][active]
 \_ 1:0:0:4 sdc 8:32  [active][ready]
 \_ round-robin 0 [prio=3D1][enabled]
 \_ 4:0:0:4 sdk 8:160 [active][ready]=20

oraredo (3600a0b80001ff32a000020c5456bf952)
 [size=3D136 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [prio=3D6][active]=20
 \_ 3:0:0:1 sdh 8:112 [active][ready]
 \_ round-robin 0 [prio=3D1][enabled]
 \_ 2:0:0:1 sde 8:64  [active][ready]
=20
oraarch1 (3600a0b80001ff32a000020c7456bf980)
 [size=3D136 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [prio=3D6][active]
  \_ 2:0:0:2 sdf 8:80  [active][ready]
\_ round-robin 0 [prio=3D1][enabled]=20
 \_ 3:0:0:2 sdi 8:128 [active][ready]

 oradata2 (3600a0b80001ff3de000042ba456bfcbc)
[size=3D817 GB][features=3D"0"][hwhandler=3D"0"]=20
\_ round-robin 0 [prio=3D6][active]
  \_ 4:0:0:3 sdj 8:144 [active][ready]
\_ round-robin 0 [prio=3D1][enabled]
  \_ 1:0:0:3 sdb 8:16  [active][ready]

 oradata1 (3600a0b80001ff32a000020c2456bf8a0)
[size=3D681 GB][features=3D"0"][hwhandler=3D"0"]
 \_ round-robin 0 [prio=3D6][enabled]
 \_ 3:0:0:0 sdg 8:96  [active][ready]=20
\_ round-robin 0 [prio=3D1][enabled]
  \_ 2:0:0:0 sdd 8:48  [active][ready]


Best Regards,
Yury.

--nextPart20887667.nTqsMaVrj7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQBFq7dFBMpuqP3w7LgRApq2AJsFEhdWPcOfsgFMWNNyoy2feTQ6KACfZybY
4a+Zz83UC+t7GnLnYtwXLZA=
=JUT6
-----END PGP SIGNATURE-----

--nextPart20887667.nTqsMaVrj7--


--===============0808452412==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0808452412==--
