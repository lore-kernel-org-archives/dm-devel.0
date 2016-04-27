From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/57] kpartx: parse emulated DASD devices
Date: Wed, 27 Apr 2016 13:10:04 +0200
Message-ID: <1461755458-29225-4-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Emulated DASD devices do not support the DASDINFO ioctl, so we
need to generate the information by hand. After all, fdasd
does the same.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/dasd.c | 39 +++++++++++++++++++++++++++++++++------
 kpartx/dasd.h |  1 +
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index 1fcf778..14c35b1 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -46,6 +46,21 @@ unsigned long long sectors512(unsigned long long sectors, int blocksize)
 	return sectors * (blocksize >> 9);
 }
 
+/*
+ * Magic records per track calculation, copied from fdasd.c
+ */
+static unsigned int ceil_quot(unsigned int d1, unsigned int d2)
+{
+	return (d1 + (d2 - 1)) / d2;
+}
+
+unsigned int recs_per_track(unsigned int dl)
+{
+	int dn = ceil_quot(dl + 6, 232) + 1;
+	return 1729 / (10 + 9 + ceil_quot(dl + 6 * dn, 34));
+}
+
+
 typedef unsigned int __attribute__((__may_alias__)) label_ints_t;
 
 /*
@@ -124,19 +139,31 @@ read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 	}
 
 	if (ioctl(fd_dasd, BIODASDINFO, (unsigned long)&info) != 0) {
-		goto out;
+		info.label_block = 2;
+		info.FBA_layout = 0;
+		memcpy(info.type, "ECKD", sizeof(info.type));
 	}
 
-	if (ioctl(fd_dasd, HDIO_GETGEO, (unsigned long)&geo) != 0) {
+	if (ioctl(fd_dasd, BLKSSZGET, &blocksize) != 0)
 		goto out;
-	}
 
 	if (ioctl(fd_dasd, BLKGETSIZE64, &disksize) != 0)
 		goto out;
-	disksize >>= 9;
 
-	if (ioctl(fd_dasd, BLKSSZGET, &blocksize) != 0)
-		goto out;
+	if (ioctl(fd_dasd, HDIO_GETGEO, (unsigned long)&geo) != 0) {
+		unsigned int cyl;
+
+		geo.heads = 15;
+		geo.sectors = recs_per_track(blocksize);
+		cyl = disksize / (blocksize * geo.heads * geo.sectors);
+		if (cyl < LV_COMPAT_CYL)
+			geo.cylinders = cyl;
+		else
+			geo.cylinders = LV_COMPAT_CYL;
+		geo.start = 0;
+	}
+
+	disksize >>= 9;
 
 	if (blocksize < 512 || blocksize > 4096)
 		goto out;
diff --git a/kpartx/dasd.h b/kpartx/dasd.h
index 42f94db..6fa64e6 100644
--- a/kpartx/dasd.h
+++ b/kpartx/dasd.h
@@ -164,6 +164,7 @@ typedef struct dasd_information_t {
 #define BLKGETSIZE _IO(0x12,96)
 #define BLKSSZGET _IO(0x12,104)
 #define BLKGETSIZE64 _IOR(0x12,114,size_t) /* device size in bytes (u64 *arg)*/
+#define LV_COMPAT_CYL 0xFFFE
 
 /*
  * Only compile this on S/390. Doesn't make any sense
-- 
2.6.6
