From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH 21/24] dm-dirty-log: allow log size to be
 different from target size.
Date: Wed, 02 Jun 2010 16:57:21 +0200
Message-ID: <1275490641.30896.40.camel@o>
References: <20100601094414.565.3638.stgit@notabene.brown>
	<20100601095620.565.10070.stgit@notabene.brown>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100601095620.565.10070.stgit@notabene.brown>
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
List-Id: dm-devel.ids

Neil,

I had a first review through your patch series, which look mostly good
to me.

I've got 2 points so far before I go for tests and further review:

o there's actually no need to change the dm-dirty-log interface in an
  incompatible way to allow for what's needed (see patch attached on top
  of your series) which we can't do in RHEL/SUSE/... anyway.

  Notwithstanding, we need a discussion on dm-devel to justify if we
  should change the API upstream in order to avoid such workaround as in
  my attached patched.

o any reason you limit the dm-dirty-log type to 'core' ?

Heinz

On Tue, 2010-06-01 at 19:56 +1000, NeilBrown wrote:
> With RAID1, the dirty log covers the size of the target - the number
> of bits is the target size divided by the region size.
> 
> For RAID5 and similar the dirty log needs to cover the parity blocks,
> so it is best to base the dirty log size on the size of the component
> devices rather than the size of the array.
> 
> So when creating a dirty log, allow the log_size to be specified
> separately from the target, and in raid1, set it to the target length.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  drivers/md/dm-log-userspace-base.c |   11 +++++++----
>  drivers/md/dm-log.c                |   18 +++++++++++-------
>  drivers/md/dm-raid1.c              |    4 ++--
>  include/linux/dm-dirty-log.h       |    3 ++-
>  4 files changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
> index 1ed0094..935a49b 100644
> --- a/drivers/md/dm-log-userspace-base.c
> +++ b/drivers/md/dm-log-userspace-base.c
> @@ -94,7 +94,7 @@ retry:
<SNIP>


 drivers/md/dm-log.c          |   18 +++++++-----------
 drivers/md/dm-raid1.c        |    4 ++--
 drivers/md/dm-raid456.c      |    8 +++++---
 include/linux/dm-dirty-log.h |    3 +--
 4 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index a232c14..5a08be0 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -146,7 +146,6 @@ EXPORT_SYMBOL(dm_dirty_log_type_unregister);
 
 struct dm_dirty_log *dm_dirty_log_create(const char *type_name,
 			struct dm_target *ti,
-			sector_t log_size,
 			int (*flush_callback_fn)(struct dm_target *ti),
 			unsigned int argc, char **argv)
 {
@@ -165,7 +164,7 @@ struct dm_dirty_log *dm_dirty_log_create(const char *type_name,
 
 	log->flush_callback_fn = flush_callback_fn;
 	log->type = type;
-	if (type->ctr(log, ti, log_size, argc, argv)) {
+	if (type->ctr(log, ti, argc, argv)) {
 		kfree(log);
 		put_type(type);
 		return NULL;
@@ -336,9 +335,9 @@ static int read_header(struct log_c *log)
 	return 0;
 }
 
-static int _check_region_size(sector_t log_size, uint32_t region_size)
+static int _check_region_size(struct dm_target *ti, uint32_t region_size)
 {
-	if (region_size < 2 || region_size > log_size)
+	if (region_size < 2 || region_size > ti->len)
 		return 0;
 
 	if (!is_power_of_2(region_size))
@@ -354,7 +353,6 @@ static int _check_region_size(sector_t log_size, uint32_t region_size)
  *--------------------------------------------------------------*/
 #define BYTE_SHIFT 3
 static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
-			      sector_t log_size,
 			      unsigned int argc, char **argv,
 			      struct dm_dev *dev)
 {
@@ -384,12 +382,12 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 	}
 
 	if (sscanf(argv[0], "%u", &region_size) != 1 ||
-	    !_check_region_size(log_size, region_size)) {
+	    !_check_region_size(ti, region_size)) {
 		DMWARN("invalid region size %s", argv[0]);
 		return -EINVAL;
 	}
 
-	region_count = dm_sector_div_up(log_size, region_size);
+	region_count = dm_sector_div_up(ti->len, region_size);
 
 	lc = kmalloc(sizeof(*lc), GFP_KERNEL);
 	if (!lc) {
@@ -509,10 +507,9 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 }
 
 static int core_ctr(struct dm_dirty_log *log, struct dm_target *ti,
-		    sector_t log_size,
 		    unsigned int argc, char **argv)
 {
-	return create_log_context(log, ti, log_size, argc, argv, NULL);
+	return create_log_context(log, ti, argc, argv, NULL);
 }
 
 static void destroy_log_context(struct log_c *lc)
@@ -536,7 +533,6 @@ static void core_dtr(struct dm_dirty_log *log)
  * argv contains log_device region_size followed optionally by [no]sync
  *--------------------------------------------------------------*/
 static int disk_ctr(struct dm_dirty_log *log, struct dm_target *ti,
-		    sector_t log_size,
 		    unsigned int argc, char **argv)
 {
 	int r;
@@ -551,7 +547,7 @@ static int disk_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 	if (r)
 		return r;
 
-	r = create_log_context(log, ti, log_size, argc - 1, argv + 1, dev);
+	r = create_log_context(log, ti, argc - 1, argv + 1, dev);
 	if (r) {
 		dm_put_device(ti, dev);
 		return r;
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index ea732fc..ddda531 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -968,8 +968,8 @@ static struct dm_dirty_log *create_dirty_log(struct dm_target *ti,
 		return NULL;
 	}
 
-	dl = dm_dirty_log_create(argv[0], ti, ti->len, mirror_flush,
-				 param_count, argv + 2);
+	dl = dm_dirty_log_create(argv[0], ti, mirror_flush, param_count,
+				 argv + 2);
 	if (!dl) {
 		ti->error = "Error creating mirror dirty log";
 		return NULL;
diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
index 3dcbc4a..33d2be8 100644
--- a/drivers/md/dm-raid456.c
+++ b/drivers/md/dm-raid456.c
@@ -192,7 +192,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	int recovery = 1;
 	long raid_devs;
 	long rebuildA, rebuildB;
-	sector_t sectors_per_dev, chunks;
+	sector_t sectors_per_dev, chunks, ti_len_sav;
 	struct raid_set *rs = NULL;
 	int in_sync, i;
 	struct dm_dirty_log *log = NULL;
@@ -281,8 +281,10 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (sector_div(chunks, chunk_size))
 		goto err;
 
-	log = dm_dirty_log_create(log_argv[0], ti, sectors_per_dev,
-				  NULL, log_cnt, log_argv+2);
+	ti_len_sav = ti->len;
+	ti->len = sectors_per_dev;
+	log = dm_dirty_log_create(log_argv[0], ti, NULL, log_cnt, log_argv+2);
+	ti->len = ti_len_sav;
 	err = "Error creating dirty log";
 	if (!log)
 		goto err;
diff --git a/include/linux/dm-dirty-log.h b/include/linux/dm-dirty-log.h
index 641419f..7084503 100644
--- a/include/linux/dm-dirty-log.h
+++ b/include/linux/dm-dirty-log.h
@@ -33,7 +33,6 @@ struct dm_dirty_log_type {
 	struct list_head list;
 
 	int (*ctr)(struct dm_dirty_log *log, struct dm_target *ti,
-		   sector_t log_size,
 		   unsigned argc, char **argv);
 	void (*dtr)(struct dm_dirty_log *log);
 
@@ -138,7 +137,7 @@ int dm_dirty_log_type_unregister(struct dm_dirty_log_type *type);
  * type->constructor/destructor() directly.
  */
 struct dm_dirty_log *dm_dirty_log_create(const char *type_name,
-			struct dm_target *ti, sector_t log_size,
+			struct dm_target *ti,
 			int (*flush_callback_fn)(struct dm_target *ti),
 			unsigned argc, char **argv);
 void dm_dirty_log_destroy(struct dm_dirty_log *log);
