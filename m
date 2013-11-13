From: Vladimir Smolensky <arizal@gmail.com>
Subject: dm-cache fs corruption
Date: Wed, 13 Nov 2013 12:24:03 +0200
Message-ID: <CALwk7=z+Xc8Xrcw5jo8DtKwT9KS2gQMumtaHTws0w4+VDs2NwQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8565477756850957772=="
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

--===============8565477756850957772==
Content-Type: multipart/alternative; boundary=001a11c3657e3b54c104eb0c5d2e

--001a11c3657e3b54c104eb0c5d2e
Content-Type: text/plain; charset=ISO-8859-1

Hello,
I've been testing dm-cache for use with static web content.
It appears that, when using big cache ~3TB(+20TB origin dev) dm-cache
device corrupts the filesystem after block eviction starts to happen.
If I set smaller cache size - single 480GB ssd(again with 20TB origin dev),
the dm-cache dev works just fine.


dmesg error:

XFS (dm-0): Corruption detected. Unmount and run xfs_repair
XFS (dm-0): metadata I/O error: block 0x3d4f534e0
("xfs_trans_read_buf_map") error 117 numblks 16
XFS (dm-0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.
XFS (dm-0): Corruption detected. Unmount and run xfs_repair
XFS (dm-0): Corruption detected. Unmount and run xfs_repair


ext4 also got broken.


Tested with 3.10.11-gentoo, fedora 19- kernel 3.11.something, xfs, ext4,
writeback and writethrough modes.



regards,
Vladimir Smolensky

--001a11c3657e3b54c104eb0c5d2e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>Hello,<br></div>I&#39;ve been testing =
dm-cache for use with static web content.<br></div>It appears that, when us=
ing big cache ~3TB(+20TB origin dev) dm-cache device corrupts the filesyste=
m after block eviction starts to happen.<br>
</div>If I set smaller cache size - single 480GB ssd(again with 20TB origin=
 dev), the dm-cache dev works just fine.<br><br><br></div>dmesg error:<br><=
br>XFS (dm-0): Corruption detected. Unmount and run xfs_repair<br>XFS (dm-0=
): metadata I/O error: block 0x3d4f534e0 (&quot;xfs_trans_read_buf_map&quot=
;) error 117 numblks 16<br>

XFS (dm-0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.<br>XFS=
 (dm-0): Corruption detected. Unmount and run xfs_repair<br>XFS (dm-0): Cor=
ruption detected. Unmount and run xfs_repair<br><div><br><br></div><div>
ext4 also got broken.<br></div><div><br><br></div><div>Tested with 3.10.11-=
gentoo, fedora 19- kernel 3.11.something, xfs, ext4, writeback and writethr=
ough modes.<br><br><br></div><div><br>regards,<br></div><div>Vladimir Smole=
nsky<br>
</div></div>

--001a11c3657e3b54c104eb0c5d2e--


--===============8565477756850957772==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8565477756850957772==--
