From: aaron <aaron@sysdev.oucs.ox.ac.uk>
Subject: multipath, Engenio 6998 and Volume Snapshot
Date: Tue, 17 Jan 2006 15:53:30 +0000
Message-ID: <20060117155330.GA19101@curfew.oucs.ox.ac.uk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0215781037=="
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


--===============0215781037==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline


--98e8jtXdkpgskNou
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


(or depending on your choice of branding an IBM DS4800 (flashcopy),
SGI TP9700 (SnapCopy) and no doubt lots of other brandings)

I'm also having a problem using multipath, the DS4800 and the DS4800's
inbuilt flashcopy feature. I'd like to use the DS4800's inbuilt
flashcopy feature  becuase (i) it is there and (ii) it will push the
load of backing up from the indiviual SAN attached machines to the
DS4800 and backup servers.

The problem is as follows. There are 8 volumes mounted on server A,
which is Debain/Sarge system running a 2.6.15 kernel with multipath
tools built from the git tree on 2005-12-14. If I try to create a
snapshot on the DS4800, not involving any of the mounted volumes, and
there is some disk IOi (*) on one of the mounted volumes then the
following occurs:

1) There are messages like:

 multipathd: 65:160: tur checker reports path is down
 multipathd: checker failed path 65:160 in map imap225-x4
 kernel: device-mapper: dm-multipath: Failing path 65:160.
 multipathd: imap225-x4: remaining active paths: 1
 multipathd: 8:240: tur checker reports path is down
 multipathd: checker failed path 8:240 in map imap224-x4
 kernel: device-mapper: dm-multipath: Failing path 8:240.
 multipathd: imap224-x4: remaining active paths: 1
 multipathd: 65:160: tur checker reports path is up
 multipathd: 65:160: reinstated 3370:Jan 16 18:41:58 imap224 multipathd: im=
ap225-x4: remaining active paths: 2
 multipathd: 8:240: tur checker reports path is up
 multipathd: 8:240: reinstated
 multipathd: imap224-x4: remaining active paths: 2

in syslog for each of the mounted volumes.

2) I've seen errors like  there are SCSI errors for the volume with disk IO:

 kernel: sd 2:0:0:6: rejecting I/O to offline device
 kernel: sd 2:0:0:6: SCSI error: return code =3D 0x10000
 kernel: end_request: I/O error, dev sdw, sector 60402552

(with numberous repititions) and I've also seen errors like:

kernel: qla2300 0000:04:02.0: scsi(1:0:6): Abort command issued -- 188fa3 2=
002.  Abort command issued -- 188fbe 2002.
kernel: qla2300 0000:04:02.0: scsi(1:0:6): Abort command issued -- 188fbf 2=
002.
kernel: qla2300 0000:04:02.0: scsi(1:0:6): Abort command issued -- 188fc0 2=
002.

which result in the IP for this disk stopping=20

The program generating IO is also unhappy, and gives errors like:

(3735) open clients/client42/~dmtmp/PARADOX/__414F2.DB succeeded for handle=
 -1
(49517) ERROR: handle 13114 was not found
(62475) rmdir clients/client71/~dmtmp/ACCESS failed (Directory not empty)
(62476) rmdir clients/client71/~dmtmp failed (Directory not empty)
(62477) rmdir clients/client71 failed (Directory not empty)

which seems to be a bad thing.

The multipath configutation is attached.

Has anyone come accross this before and/or does any one have any hints
as to what (if anything) is going wrong ?

aaron

(*) My favourite form of disk IO at the moment is dbench 100 (where
dbench is part of the Samba benchmarking suite).


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="multipath.conf"
Content-Transfer-Encoding: quoted-printable


multipaths {
  multipath {
    wwid        3600a0b8000114d9a0000953d4396577c
    alias       imap224-x0
  } =20
  multipath {
    wwid        3600a0b8000114e5a0000945c439feea3
    alias       imap224-x1
  } =20
  multipath {
    wwid        3600a0b8000114d9a000095ef43a14230
    alias       imap224-x2
  } =20
  multipath {
    wwid        3600a0b8000114e5a0000946d43a142f5
    alias       imap224-x3
  } =20
  multipath {
    wwid        3600a0b8000114d9a000095f343a1440e
    alias       imap224-x4
  } =20
  multipath {
    wwid        3600a0b8000114e5a0000947043a14483
    alias       imap224-x5
  } =20
  multipath {
    wwid        3600a0b8000114d9a000095f543a1449a
    alias       imap224-x6
  } =20
  multipath {
    wwid        3600a0b8000114e5a0000947143a144ff
    alias       imap224-x7
  } =20
  multipath {
    wwid        3600a0b8000114d9a00009417438d7eaa
    alias       imap225-x0
  } =20
  multipath {
    wwid        3600a0b8000114e5a00009332438d8135
    alias       imap225-x1
  } =20
  multipath {
    wwid        3600a0b8000114d9a00009422438d8142
    alias       imap225-x2
  } =20
  multipath {
    wwid        3600a0b8000114e5a00009333438d8185
    alias       imap225-x3
  } =20
  multipath {
    wwid        3600a0b8000114d9a00009424438d8188
    alias       imap225-x4
  } =20
  multipath {
    wwid        3600a0b8000114e5a00009334438d81c3
    alias       imap225-x5
  }
  multipath {
    wwid        3600a0b8000114d9a00009426438d81c4
    alias       imap225-x6
  } =20
  multipath {
    wwid        3600a0b8000114e5a00009335438d81fd
    alias       imap225-x7
  } =20
}

devices {
  device {
    vendor      "IBM"
    product     "1815      FAStT"
    path_grouping_policy group_by_prio
    prio_callout    "/sbin/mpath_prio_tpc /dev/%n"
    path_checker  tur
  }
}

--HcAYCG3uE/tztfnV--

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDzRL5eYyiwd4skvMRAqoZAKC2/BkTNRx3qS/kfitDk3upRUmZQACbBo4F
SDJCQysY+xXlT5V2W4VfIUU=
=/5Rl
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--


--===============0215781037==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0215781037==--
