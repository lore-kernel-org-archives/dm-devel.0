From: Ondrej Kozina <okozina@redhat.com>
Subject: [RFC PATCH v2 2/3] Adds support for security checks in
	the linear target
Date: Fri, 25 May 2012 15:22:27 +0200
Message-ID: <1337952148-20888-3-git-send-email-okozina@redhat.com>
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

Just a security check implementation for linear target

---
 drivers/md/dm-linear.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 3639eea..b04aa00 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -153,9 +153,25 @@ static int linear_iterate_devices(struct dm_target *ti,
 	return fn(ti, lc->dev, lc->start, ti->len, data);
 }
 
+static int linear_security(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	int r;
+
+	if (argc < 1) {
+		ti->error = "dm-linear: Security check: invalid number of parameters";
+		return -EINVAL;
+	}
+
+	r = dm_check_backing_dev_permission(ti, argv[0]);
+	if (r)
+		ti->error = "dm-linear: Security check failed";
+
+	return r;
+}
+
 static struct target_type linear_target = {
 	.name   = "linear",
-	.version = {1, 1, 0},
+	.version = {1, 2, 0},
 	.module = THIS_MODULE,
 	.ctr    = linear_ctr,
 	.dtr    = linear_dtr,
@@ -164,6 +180,7 @@ static struct target_type linear_target = {
 	.ioctl  = linear_ioctl,
 	.merge  = linear_merge,
 	.iterate_devices = linear_iterate_devices,
+	.security = linear_security
 };
 
 int __init dm_linear_init(void)
-- 
1.7.8.6
