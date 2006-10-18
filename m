From: Andre Noll <maan@systemlinux.org>
Subject: 2.6.18.1, ext3: attempt to access beyond end of device
Date: Wed, 18 Oct 2006 09:47:53 +0200
Message-ID: <20061018074753.GT22487@skl-net.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1634706846=="
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


--===============1634706846==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BVQ1RKc6+nLPB5pT"
Content-Disposition: inline


--BVQ1RKc6+nLPB5pT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

While doing some stress tests on our raid system, we encountered the
following:

[13933.173768] EXT3-fs error (device dm-0): ext3_new_block: Allocating bloc=
k in system zone - blocks from 192708608, length 1
[13933.176790] Aborting journal on device dm-0.
[13934.512464] ext3_abort called.
[13934.514031] EXT3-fs error (device dm-0): ext3_journal_start_sb: Detected=
 aborted journal
[13934.517537] Remounting filesystem read-only
[13934.519438] EXT3-fs error (device dm-0): ext3_free_blocks: Freeing block=
s in system zones - Block =3D 192708608, count =3D 1
[13934.524084] EXT3-fs error (device dm-0) in ext3_free_blocks_sb: Journal =
has aborted
[14585.157319] attempt to access beyond end of device
[14585.159480] dm-1: rw=3D1, want=3D9592553968, limit=3D5292146688

[many of these with different "want" values]

[14586.072700] Buffer I/O error on device dm-1, logical block 1313832302
[14586.076005] lost page write due to I/O error on dm-1
[14586.079177] Aborting journal on device dm-1.
[14586.082161] EXT3-fs error (device dm-1) in ext3_dirty_inode: IO failure
[14586.102836] EXT3-fs error (device dm-1) in ext3_ordered_writepage: IO fa=
ilure
[14586.226243] ext3_abort called.
[14586.226249] EXT3-fs error (device dm-1) in ext3_ordered_commit_write: IO=
 failure
[14586.227872] ext3_abort called.
[14586.227875] EXT3-fs error (device dm-1): ext3_journal_start_sb: Detected=
 aborted journal
[14586.227878] Remounting filesystem read-only
[14586.247468] EXT3-fs error (device dm-1): ext3_journal_start_sb: Detected=
 aborted journal
[14587.486480] __journal_remove_journal_head: freeing b_committed_data
[14587.489821] __journal_remove_journal_head: freeing b_committed_data
[58760.477871] EXT3-fs error (device dm-1): ext3_readdir: bad entry in dire=
ctory #2: rec_len % 4 !=3D 0 - offset=3D0, inode=3D1753114490, rec_len=3D19=
037, name_len=3D53
[145152.943222] EXT3-fs error (device dm-1): ext3_readdir: bad entry in dir=
ectory #2: rec_len % 4 !=3D 0 - offset=3D0, inode=3D1753114490, rec_len=3D1=
9037, name_len=3D53

Further info:

root@ubuntu:~# vgs
  VG   #PV #LV #SN Attr   VSize VFree
  vg     1   2   0 wz--n- 6.36T    0=20
root@ubuntu:~# pvs
  PV         VG   Fmt  Attr PSize PFree
  /dev/md0   vg   lvm2 a-   6.36T    0=20
root@ubuntu:~# lvs
  LV       VG   Attr   LSize Origin Snap%  Move Log Copy%=20
  ext3_lv1 vg   -wi-ao 3.90T                             =20
  ext3_lv2 vg   -wi-ao 2.46T                             =20
root@ubuntu:~# df -h /dev/vg/*
Filesystem            Size  Used Avail Use% Mounted on
/dev/vg/ext3_lv1      3.9T  724G  3.0T  20% /mnt/lv1
/dev/vg/ext3_lv2      2.5T  552G  1.8T  24% /mnt/lv2
root@ubuntu:~# uname -a
Linux ubuntu 2.6.18.1 #1 SMP Sun Oct 15 13:43:51 CDT 2006 ppc64 GNU/Linux
root@ubuntu:~# cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4]=20
md0 : active raid6 sdb[0] sdq[15] sdp[14] sdo[13] sdn[12] sdm[11] sdl[10] s=
dk[9] sdj[8] sdi[7] sdh[6] sdg[5] sdf[4] sde[3] sdd[2] sdc[1]
      6833669248 blocks level 6, 64k chunk, algorithm 2 [16/16] [UUUUUUUUUU=
UUUUUU]

Andre

--=20
The only person who always got his work done by Friday was Robinson Crusoe

--BVQ1RKc6+nLPB5pT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFFNdwpWto1QDEAkw8RAp4GAJsEEwB/2GUY27X47m9xR6549Sr5OgCfebj9
aLfZNCiYSOtDLNWqpv/N6UY=
=HnN4
-----END PGP SIGNATURE-----

--BVQ1RKc6+nLPB5pT--


--===============1634706846==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1634706846==--
