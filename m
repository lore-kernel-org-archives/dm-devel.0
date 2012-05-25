From: Ondrej Kozina <okozina@redhat.com>
Subject: [RFC PATCH v2 3/3] Adds support for security checks in
	the crypt target
Date: Fri, 25 May 2012 15:22:28 +0200
Message-ID: <1337952148-20888-4-git-send-email-okozina@redhat.com>
References: <1335986033-15236-1-git-send-email-okozina@redhat.com>
	<1337952148-20888-1-git-send-email-okozina@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1337952148-20888-1-git-send-email-okozina@redhat.com>
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
Cc: Ondrej Kozina <okozina@redhat.com>, mgrac@redhat.com, kas@fi.muni.cz, mbroz@redhat.com
List-Id: dm-devel.ids

Just a security check implementation for the crypt target

---
 drivers/md/dm-crypt.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3f06df5..af6f319 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1867,9 +1867,24 @@ static int crypt_iterate_devices(struct dm_target *ti,
 	return fn(ti, cc->dev, cc->start, ti->len, data);
 }
 
+static int crypt_security(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	int r;
+
+	if (argc < 4) {
+		ti->error = "dm-crypt: Security check: invalid number of parameters";
+		return -EINVAL;
+	}
+	r = dm_check_backing_dev_permission(ti, argv[3]);
+	if (r)
+		ti->error = "dm-crypt: Security check failed";
+
+	return r;
+}
+
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 11, 0},
+	.version = {1, 12, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
@@ -1881,6 +1896,7 @@ static struct target_type crypt_target = {
 	.message = crypt_message,
 	.merge  = crypt_merge,
 	.iterate_devices = crypt_iterate_devices,
+	.security = crypt_security
 };
 
 static int __init dm_crypt_init(void)
-- 
1.7.8.6
