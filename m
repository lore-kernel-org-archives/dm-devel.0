From: Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH] compat_ioctl: fix reimplemented SG_IO handling causing -EINVAL from sg_io()
Date: Wed, 18 Sep 2019 17:34:45 +0200
Message-ID: <20190918153445.1241-1-maier@linux.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Doug Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Steffen Maier <maier@linux.ibm.com>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, Thomas Gleixner <tglx@linutronix.de>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Omar Sandoval <osandov@fb.com>, linux-block@vger.kernel.org, linux-next@vger.kernel.org, Mark Brown <broonie@kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

scsi_cmd_ioctl() had hdr as on stack auto variable and called
copy_{from,to}_user with the address operator &hdr and sizeof(hdr).

After the refactoring, {get,put}_sg_io_hdr() takes a pointer &hdr.
So the copy_{from,to}_user within the new helper functions should
just take the given pointer argument hdr and sizeof(*hdr).

I saw -EINVAL from sg_io() done by /usr/lib/udev/scsi_id which could
in turn no longer whitelist SCSI disks for devicemapper multipath.

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Fixes: 4f45155c29fd ("compat_ioctl: reimplement SG_IO handling")
---

Arnd, I'm not sure about the sizeof(hdr32) change in the compat part in
put_sg_io_hdr().

This is for next, probably via Arnd's y2038/y2038,
and it fixes next-20190917 for me regarding SCSI generic.

 block/scsi_ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index cbeb629ee917..650bade5ea5a 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -607,14 +607,14 @@ int put_sg_io_hdr(const struct sg_io_hdr *hdr, void __user *argp)
 			.info		 = hdr->info,
 		};
 
-		if (copy_to_user(argp, &hdr32, sizeof(hdr)))
+		if (copy_to_user(argp, &hdr32, sizeof(hdr32)))
 			return -EFAULT;
 
 		return 0;
 	}
 #endif
 
-	if (copy_to_user(argp, &hdr, sizeof(hdr)))
+	if (copy_to_user(argp, hdr, sizeof(*hdr)))
 		return -EFAULT;
 
 	return 0;
@@ -659,7 +659,7 @@ int get_sg_io_hdr(struct sg_io_hdr *hdr, const void __user *argp)
 	}
 #endif
 
-	if (copy_from_user(&hdr, argp, sizeof(hdr)))
+	if (copy_from_user(hdr, argp, sizeof(*hdr)))
 		return -EFAULT;
 
 	return 0;
-- 
2.17.1
