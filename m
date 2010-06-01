From: NeilBrown <neilb@suse.de>
Subject: [PATCH 02/24] md/raid5: factor out code for changing size of stripe
	cache.
Date: Tue, 01 Jun 2010 19:56:18 +1000
Message-ID: <20100601095618.565.36360.stgit@notabene.brown>
References: <20100601094414.565.3638.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100601094414.565.3638.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Separate the actual 'change' code from the sysfs interface
so that it can eventually be called internally.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |   38 +++++++++++++++++++++++++-------------
 1 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8882da3..8647705 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4480,23 +4480,15 @@ raid5_show_stripe_cache_size(mddev_t *mddev, char *page)
 		return 0;
 }
 
-static ssize_t
-raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
+static int
+raid5_set_cache_size(mddev_t *mddev, int size)
 {
 	raid5_conf_t *conf = mddev->private;
-	unsigned long new;
 	int err;
 
-	if (len >= PAGE_SIZE)
+	if (size <= 16 || size > 32768)
 		return -EINVAL;
-	if (!conf)
-		return -ENODEV;
-
-	if (strict_strtoul(page, 10, &new))
-		return -EINVAL;
-	if (new <= 16 || new > 32768)
-		return -EINVAL;
-	while (new < conf->max_nr_stripes) {
+	while (size < conf->max_nr_stripes) {
 		if (drop_one_stripe(conf))
 			conf->max_nr_stripes--;
 		else
@@ -4505,11 +4497,31 @@ raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
 	err = md_allow_write(mddev);
 	if (err)
 		return err;
-	while (new > conf->max_nr_stripes) {
+	while (size > conf->max_nr_stripes) {
 		if (grow_one_stripe(conf))
 			conf->max_nr_stripes++;
 		else break;
 	}
+	return 0;
+}
+
+static ssize_t
+raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
+{
+	raid5_conf_t *conf = mddev->private;
+	unsigned long new;
+	int err;
+
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (!conf)
+		return -ENODEV;
+
+	if (strict_strtoul(page, 10, &new))
+		return -EINVAL;
+	err = raid5_set_cache_size(mddev, new);
+	if (err)
+		return err;
 	return len;
 }
 


