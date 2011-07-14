From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] dm-crypt: add mapping table option to allowing
	discard requests
Date: Thu, 14 Jul 2011 13:56:30 +0200
Message-ID: <1310644590-14438-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Add optional parameter field to dmcrypt table and support
"allow_discards" option.

Discard requests bypass crypt queue processing, bio
request is simple remapped to underlying device.

Note that discard will be never enabled by default because
of security consequences, it is up to administrator
to enable it for encrypted devices.

(Note that userspace cryptsetup will not understand new
optional parameters yet, support for this will come later.)

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 Documentation/device-mapper/dm-crypt.txt |   19 +++++++++++++-
 drivers/md/dm-crypt.c                    |   39 ++++++++++++++++++++++++++---
 2 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/Documentation/device-mapper/dm-crypt.txt b/Documentation/device-mapper/dm-crypt.txt
index 6b5c42d..08a36a7 100644
--- a/Documentation/device-mapper/dm-crypt.txt
+++ b/Documentation/device-mapper/dm-crypt.txt
@@ -4,7 +4,7 @@ dm-crypt
 Device-Mapper's "crypt" target provides transparent encryption of block devices
 using the kernel crypto API.
 
-Parameters: <cipher> <key> <iv_offset> <device path> <offset>
+Parameters: <cipher> <key> <iv_offset> <device path> <offset> [<#opt_params> <opt_params>]
 
 <cipher>
     Encryption cipher and an optional IV generation mode.
@@ -37,6 +37,23 @@ Parameters: <cipher> <key> <iv_offset> <device path> <offset>
 <offset>
     Starting sector within the device where the encrypted data begins.
 
+<#opt_params>
+    Number of optional parameters. If there are no optional parameters,
+    the optional paramaters section can be skipped or #opt_params can be zero.
+    Otherwise #opt_params indicates count of following arguments.
+
+    Examples of optional parameters section:
+        1 allow_discards
+
+allow_discards
+    The block discards requests are passed through the crypt device.
+    (Default is to block discards requests.)
+
+    WARNING: allowing discard on encrypted device has serious irreversible
+    security consequences, discarded blocks can be easily located on device
+    later. This can lead to leak of information from ciphertext device
+    (unique pattern for detecting filesystem type, used space etc).
+
 Example scripts
 ===============
 LUKS (Linux Unified Key Setup) is now the preferred way to set up disk
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index c8827ff..2747483 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1575,11 +1575,11 @@ bad_mem:
 static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct crypt_config *cc;
-	unsigned int key_size;
+	unsigned int key_size, opt_params;
 	unsigned long long tmpll;
 	int ret;
 
-	if (argc != 5) {
+	if (argc < 5) {
 		ti->error = "Not enough arguments";
 		return -EINVAL;
 	}
@@ -1648,6 +1648,26 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	cc->start = tmpll;
 
+	/* Optional parameters */
+	if (argc > 5) {
+		if (sscanf(argv[5], "%u", &opt_params) < 0) {
+			ti->error = "Invalid optional parameters";
+			goto bad;
+		}
+
+		if (opt_params + 6 > argc) {
+			ti->error = "Arguments do not agree with counts given";
+			goto bad;
+		}
+
+		if (opt_params == 1 && !strcmp(argv[6], "allow_discards"))
+			ti->num_discard_requests = 1;
+		else if (opt_params) {
+			ti->error = "Invalid optional parameters";
+			goto bad;
+		}
+	}
+
 	ret = -ENOMEM;
 	cc->io_queue = alloc_workqueue("kcryptd_io",
 				       WQ_NON_REENTRANT|
@@ -1682,9 +1702,16 @@ static int crypt_map(struct dm_target *ti, struct bio *bio,
 	struct dm_crypt_io *io;
 	struct crypt_config *cc;
 
-	if (bio->bi_rw & REQ_FLUSH) {
+	/*
+	 * If bio is REQ_FLUSH or REQ_DISCARD, just bypass crypt queues.
+	 * - for REQ_FLUSH device-mapper core ensures that no IO is in-flight
+	 * - for REQ_DISCARD caller must use flush if IO ordering matters
+	 */
+	if (unlikely(bio->bi_rw & (REQ_FLUSH | REQ_DISCARD))) {
 		cc = ti->private;
 		bio->bi_bdev = cc->dev->bdev;
+		if (bio_sectors(bio))
+			bio->bi_sector = cc->start + dm_target_offset(ti, bio->bi_sector);
 		return DM_MAPIO_REMAPPED;
 	}
 
@@ -1727,6 +1754,10 @@ static int crypt_status(struct dm_target *ti, status_type_t type,
 
 		DMEMIT(" %llu %s %llu", (unsigned long long)cc->iv_offset,
 				cc->dev->name, (unsigned long long)cc->start);
+
+		if (ti->num_discard_requests)
+			DMEMIT(" 1 allow_discards");
+
 		break;
 	}
 	return 0;
@@ -1823,7 +1854,7 @@ static int crypt_iterate_devices(struct dm_target *ti,
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 10, 0},
+	.version = {1, 11, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
-- 
1.7.5.4
