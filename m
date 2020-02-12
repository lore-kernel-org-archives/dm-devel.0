From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 2/6] dax,iomap,ext4,ext2,xfs: Save dax_offset in "struct iomap"
Date: Wed, 12 Feb 2020 12:07:29 -0500
Message-ID: <20200212170733.8092-3-vgoyal@redhat.com>
References: <20200212170733.8092-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200212170733.8092-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, hch@infradead.org
Cc: vgoyal@redhat.com, dm-devel@redhat.com, jack@suse.cz
List-Id: dm-devel.ids

Add a new field "sector_t dax_offset" to "struct iomap". This will be
filled by filesystems and dax code will make use of this to convert
sector into page offset (dax_pgoff()), instead of bdev_dax_pgoff(). This
removes the dependency of having to pass in block device for dax operatio=
ns.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/ext2/inode.c       | 1 +
 fs/ext4/inode.c       | 1 +
 fs/xfs/xfs_iomap.c    | 2 ++
 include/linux/iomap.h | 1 +
 4 files changed, 5 insertions(+)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index c885cf7d724b..5c3379e78d49 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -823,6 +823,7 @@ static int ext2_iomap_begin(struct inode *inode, loff=
_t offset, loff_t length,
 	iomap->bdev =3D inode->i_sb->s_bdev;
 	iomap->offset =3D (u64)first_block << blkbits;
 	iomap->dax_dev =3D sbi->s_daxdev;
+	iomap->dax_offset =3D get_start_sect(iomap->bdev);
=20
 	if (ret =3D=3D 0) {
 		iomap->type =3D IOMAP_HOLE;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1305b810c44a..0ea7fbb8076f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3330,6 +3330,7 @@ static void ext4_set_iomap(struct inode *inode, str=
uct iomap *iomap,
=20
 	iomap->bdev =3D inode->i_sb->s_bdev;
 	iomap->dax_dev =3D EXT4_SB(inode->i_sb)->s_daxdev;
+	iomap->dax_offset =3D get_start_sect(iomap->bdev);
 	iomap->offset =3D (u64) map->m_lblk << blkbits;
 	iomap->length =3D (u64) map->m_len << blkbits;
=20
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index bb590a267a7f..ad8b18fc96fd 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -80,6 +80,7 @@ xfs_bmbt_to_iomap(
 	iomap->length =3D XFS_FSB_TO_B(mp, imap->br_blockcount);
 	iomap->bdev =3D target->bt_bdev;
 	iomap->dax_dev =3D target->bt_daxdev;
+	iomap->dax_offset =3D get_start_sect(iomap->bdev);
 	iomap->flags =3D flags;
=20
 	if (xfs_ipincount(ip) &&
@@ -103,6 +104,7 @@ xfs_hole_to_iomap(
 	iomap->length =3D XFS_FSB_TO_B(ip->i_mount, end_fsb - offset_fsb);
 	iomap->bdev =3D target->bt_bdev;
 	iomap->dax_dev =3D target->bt_daxdev;
+	iomap->dax_offset =3D get_start_sect(iomap->bdev);
 }
=20
 static inline xfs_fileoff_t
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 8b09463dae0d..cac5d667aa74 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -84,6 +84,7 @@ struct iomap {
 	u16			flags;	/* flags for mapping */
 	struct block_device	*bdev;	/* block device for I/O */
 	struct dax_device	*dax_dev; /* dax_dev for dax operations */
+	sector_t		dax_offset; /* offset in dax device */
 	void			*inline_data;
 	void			*private; /* filesystem private */
 	const struct iomap_page_ops *page_ops;
--=20
2.20.1
