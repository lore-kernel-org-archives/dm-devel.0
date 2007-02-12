From: Andre Noll <maan@systemlinux.org>
Subject: more than 10 shapshots freeze system
Date: Mon, 12 Feb 2007 18:47:02 +0100
Message-ID: <20070212174702.GG19569@skl-net.de>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0471236156=="
Return-path: <linux-lvm-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, LVM general discussion and development <linux-lvm@redhat.com>, Heinz Mauelshagen <mauelshagen@redhat.com>
List-Id: dm-devel.ids


--===============0471236156==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vA66WO2vHvL/CRSR"
Content-Disposition: inline


--vA66WO2vHvL/CRSR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

last week I was experimenting a bit with lvm snapshots. What I tried
to do was to create 2 snapshots per day from our ~5T "backup" ext3
filesystem which gets rsynced twice a day from the (remote) "real"
production filesystem.

Our workload changes at most 50G of data a day, so I chose an initial
snapshot size of 50G. After each rsync run, the snapshot lvs were
extended so that each of them had again 50G free space available.

This worked very well for about three days, i.e. six snapshots. From
this day on, the system [1] became more and more sluggish during
the rsync runs. Hitting return in bash on the otherwise idle system
began to take as much as several seconds. Simple lvm commands like
lvdisplay took up to several minutes.

Two or three days later (i.e. 10+ snapshots) the system froze totally
during the rsync. Nothing made it to the system log. I could easily
reproduce this by running rsync again or by simply creating a 100M
file.

Is this an expected behaviour?

If so, is there a formula in terms of filesytem/snapshot/ram size to
compute the maximal number of snapshots that may be created from the
same filesystem without risking to freeze the system?

If this behaviour is not expected, what can I do to improve the
situation or to debug this problem?

Thanks
Andre

[1] HP Proliant, 2-way AMD Opteron, 5G Ram, linux-2.6.19.x and
linux-2.6.20, ubuntu server lvm tools based on libdevmapper-1.02
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--vA66WO2vHvL/CRSR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF0KgWWto1QDEAkw8RAl0JAKCDVibgKUIOc6qb8p9XXknV7RzeDQCgiA+x
WEHncJLfcevG7oz1t5DO++Y=
=CikV
-----END PGP SIGNATURE-----

--vA66WO2vHvL/CRSR--


--===============0471236156==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
--===============0471236156==--
