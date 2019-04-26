From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH dm] dm: dust_rb_search() can be static
Date: Sat, 27 Apr 2019 07:12:48 +0800
Message-ID: <20190426231248.GA44578@ivb42>
References: <201904270727.g6e3MBmi%lkp@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201904270727.g6e3MBmi%lkp@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bryan Gurney <bgurney@redhat.com>
Cc: dm-devel@redhat.com, kbuild-all@01.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids


Fixes: cefb8eb074c8 ("dm: add dust target")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 dm-dust.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index f5434ada..dd56284 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -32,7 +32,7 @@ struct dust_device {
 	bool quiet_mode:1;
 };
 
-struct badblock *dust_rb_search(struct rb_root *root, sector_t blk)
+static struct badblock *dust_rb_search(struct rb_root *root, sector_t blk)
 {
 	struct rb_node *node = root->rb_node;
 
@@ -50,7 +50,7 @@ struct badblock *dust_rb_search(struct rb_root *root, sector_t blk)
 	return NULL;
 }
 
-bool dust_rb_insert(struct rb_root *root, struct badblock *new)
+static bool dust_rb_insert(struct rb_root *root, struct badblock *new)
 {
 	struct badblock *bblk;
 	struct rb_node **link = &root->rb_node, *parent = NULL;
@@ -492,7 +492,7 @@ static struct target_type dust_target = {
 	.prepare_ioctl = dust_prepare_ioctl,
 };
 
-int __init dm_dust_init(void)
+static int __init dm_dust_init(void)
 {
 	int result = dm_register_target(&dust_target);
 
@@ -502,7 +502,7 @@ int __init dm_dust_init(void)
 	return result;
 }
 
-void __exit dm_dust_exit(void)
+static void __exit dm_dust_exit(void)
 {
 	dm_unregister_target(&dust_target);
 }
