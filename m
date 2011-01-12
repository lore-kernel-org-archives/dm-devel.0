From: NeilBrown <neilb@suse.de>
Subject: Fw: linux-next - WARNING: at fs/block_dev.c:824
 bd_link_disk_holder+0x92/0x1ac()
Date: Thu, 13 Jan 2011 07:09:08 +1100
Message-ID: <20110113070908.7b1a0de9@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7169114591768861119=="
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

--===============7169114591768861119==
Content-Type: multipart/signed; micalg=PGP-SHA1;
	boundary="Sig_/SNmP0=JWvHsCHG2XenjkC46";
	protocol="application/pgp-signature"

--Sig_/SNmP0=JWvHsCHG2XenjkC46
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



Begin forwarded message:

Date: Wed, 12 Jan 2011 12:34:33 -0500
From: Valdis.Kletnieks@vt.edu
To: Alexander Viro <viro@zeniv.linux.org.uk>, Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
linux-raid@vger.kernel.org Subject: linux-next - WARNING: at
fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()


Seen in a boot of yesterday's linux-next.   The 'W' flag was due to the
already-reported 'WARNING: at kernel/workqueue.c:1202 worker_enter_idle'.
Not sure if it's a block_dev or dm/LVM issue, so I'm cc:'ing both groups.  I
wonder if the fact I still have 'CONFIG_DEVTMPFS=3Dn' is involved (it's
apparently ticking off dracut before and after the warning).

[   16.840333] dracut: Found volume group "vg_blackice" using metadata type
lvm2 [   16.892282] dracut: The link /dev/vg_blackice/opt should had been
created by udev but it was not found.  Falling back to direct link creation.
[   16.912627] ------------[ cut here ]------------ [   16.912635] WARNING:
at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac() [   16.912638]
Hardware name: Latitude E6500 [   16.912640] Modules linked in:
[   16.912644] Pid: 1920, comm: lvm Tainted: G        W
2.6.37-next-20110111 #1 [   16.912647] Call Trace:
[   16.912653]  [<ffffffff8103a989>] ? warn_slowpath_common+0x80/0x98
[   16.912657]  [<ffffffff8103a9b6>] ? warn_slowpath_null+0x15/0x17
[   16.912660]  [<ffffffff8111fb03>] ? bd_link_disk_holder+0x92/0x1ac
[   16.912665]  [<ffffffff8139b875>] ? open_dev+0x76/0x9e
[   16.912668]  [<ffffffff8139bc9d>] ? dm_get_device+0x147/0x1dc
[   16.912672]  [<ffffffff8139d088>] ? linear_ctr+0x98/0xd4
[   16.912676]  [<ffffffff8139c289>] ? dm_table_add_target+0x149/0x1d4
[   16.912679]  [<ffffffff8139e57c>] ? table_load+0xf0/0x27b
[   16.912683]  [<ffffffff8139e48c>] ? table_load+0x0/0x27b
[   16.912686]  [<ffffffff8139f326>] ? ctl_ioctl+0x1c6/0x21e
[   16.912690]  [<ffffffff8139f38c>] ? dm_ctl_ioctl+0xe/0x12
[   16.912695]  [<ffffffff8110258e>] ? do_vfs_ioctl+0x4c4/0x505
[   16.912699]  [<ffffffff81102626>] ? sys_ioctl+0x57/0x95
[   16.912703]  [<ffffffff8100253b>] ? system_call_fastpath+0x16/0x1b
[   16.912706] ---[ end trace 4eaa2a86a8e2da24 ]---
[   16.925289] dracut: The link /dev/vg_blackice/src should had been created
by udev but it was not found.  Falling back to direct link creation.


--Sig_/SNmP0=JWvHsCHG2XenjkC46
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iD8DBQFNLgppG5fc6gV+Wb0RAuiKAKCSp+Hwl7OsRbZyQKDAbt5eIxG6+wCg1q6u
iZrUiEsCBBI7o46xjs8cMpI=
=WKzW
-----END PGP SIGNATURE-----

--Sig_/SNmP0=JWvHsCHG2XenjkC46--


--===============7169114591768861119==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7169114591768861119==--
