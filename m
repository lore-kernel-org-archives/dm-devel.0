From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 5/6] drivers/dax: Use dax_pgoff() instead of bdev_dax_pgoff()
Date: Wed, 12 Feb 2020 12:07:32 -0500
Message-ID: <20200212170733.8092-6-vgoyal@redhat.com>
References: <20200212170733.8092-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200212170733.8092-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, hch@infradead.org
Cc: vgoyal@redhat.com, dm-devel@redhat.com, jack@suse.cz
List-Id: dm-devel.ids

Start using dax_pgoff() instead of bdev_dax_pgoff().

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/dax/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index e9daa30e4250..ee35ecc61545 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -97,7 +97,7 @@ bool __generic_fsdax_supported(struct dax_device *dax_d=
ev,
 		return false;
 	}
=20
-	err =3D bdev_dax_pgoff(bdev, start, PAGE_SIZE, &pgoff);
+	err =3D dax_pgoff(get_start_sect(bdev), start, PAGE_SIZE, &pgoff);
 	if (err) {
 		pr_debug("%s: error: unaligned partition for dax\n",
 				bdevname(bdev, buf));
@@ -105,7 +105,7 @@ bool __generic_fsdax_supported(struct dax_device *dax=
_dev,
 	}
=20
 	last_page =3D PFN_DOWN((start + sectors - 1) * 512) * PAGE_SIZE / 512;
-	err =3D bdev_dax_pgoff(bdev, last_page, PAGE_SIZE, &pgoff_end);
+	err =3D dax_pgoff(get_start_sect(bdev), last_page, PAGE_SIZE, &pgoff_en=
d);
 	if (err) {
 		pr_debug("%s: error: unaligned partition for dax\n",
 				bdevname(bdev, buf));
--=20
2.20.1
