From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v2] dm: Check for device sector overflow if
	CONFIG_LBDAF is not set
Date: Wed,  7 Nov 2018 22:24:55 +0100
Message-ID: <20181107212455.7332-1-gmazyland@gmail.com>
References: <alpine.LRH.2.02.1811061641270.9045@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1811061641270.9045@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: mpatocka@redhat.com, Milan Broz <gmazyland@gmail.com>, snitzer@redhat.com
List-Id: dm-devel.ids

Reference to a device in device-mapper table contains offset in sectors.

If the sector_t is 32bit integer (CONFIG_LBDAF is not set), then
several device-mapper targets can overflow this offset and validity
check is then performed on a wrong offset and a wrong table is activated.

See for example (on 32bit without CONFIG_LBDAF) this overflow:

  # dmsetup create test --table "0 2048 linear /dev/sdg 4294967297"
  # dmsetup table test
  0 2048 linear 8:96 1

This patch adds explicit check for overflow if the offset is sector_t type.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-crypt.c    | 2 +-
 drivers/md/dm-delay.c    | 2 +-
 drivers/md/dm-flakey.c   | 2 +-
 drivers/md/dm-linear.c   | 2 +-
 drivers/md/dm-raid1.c    | 3 ++-
 drivers/md/dm-unstripe.c | 2 +-
 6 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 49be7a6a2e81..a41fe7975dc6 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2781,7 +2781,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	ret = -EINVAL;
-	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1) {
+	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1 || tmpll != (sector_t)tmpll) {
 		ti->error = "Invalid device sector";
 		goto bad;
 	}
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 2fb7bb4304ad..fddffe251bf6 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -141,7 +141,7 @@ static int delay_class_ctr(struct dm_target *ti, struct delay_class *c, char **a
 	unsigned long long tmpll;
 	char dummy;
 
-	if (sscanf(argv[1], "%llu%c", &tmpll, &dummy) != 1) {
+	if (sscanf(argv[1], "%llu%c", &tmpll, &dummy) != 1 || tmpll != (sector_t)tmpll) {
 		ti->error = "Invalid device sector";
 		return -EINVAL;
 	}
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 3cb97fa4c11d..8261aa8c7fe1 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -213,7 +213,7 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	devname = dm_shift_arg(&as);
 
 	r = -EINVAL;
-	if (sscanf(dm_shift_arg(&as), "%llu%c", &tmpll, &dummy) != 1) {
+	if (sscanf(dm_shift_arg(&as), "%llu%c", &tmpll, &dummy) != 1 || tmpll != (sector_t)tmpll) {
 		ti->error = "Invalid device sector";
 		goto bad;
 	}
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 8d7ddee6ac4d..ad980a38fb1e 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -45,7 +45,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	ret = -EINVAL;
-	if (sscanf(argv[1], "%llu%c", &tmp, &dummy) != 1) {
+	if (sscanf(argv[1], "%llu%c", &tmp, &dummy) != 1 || tmp != (sector_t)tmp) {
 		ti->error = "Invalid device sector";
 		goto bad;
 	}
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 79eab1071ec2..5a51151f680d 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -943,7 +943,8 @@ static int get_mirror(struct mirror_set *ms, struct dm_target *ti,
 	char dummy;
 	int ret;
 
-	if (sscanf(argv[1], "%llu%c", &offset, &dummy) != 1) {
+	if (sscanf(argv[1], "%llu%c", &offset, &dummy) != 1 ||
+	    offset != (sector_t)offset) {
 		ti->error = "Invalid offset";
 		return -EINVAL;
 	}
diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index 954b7ab4e684..e673dacf6418 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -78,7 +78,7 @@ static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto err;
 	}
 
-	if (sscanf(argv[4], "%llu%c", &start, &dummy) != 1) {
+	if (sscanf(argv[4], "%llu%c", &start, &dummy) != 1 || start != (sector_t)start) {
 		ti->error = "Invalid striped device offset";
 		goto err;
 	}
-- 
2.19.1
