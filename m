From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [Bug] kernel oops when running xfstests(ext4)
	generic/081
Date: Tue, 5 Jun 2018 05:30:34 -0400
Message-ID: <20180605093034.GB17780@kmo-pixel>
References: <20180605080835.GH28826@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180605080835.GH28826@ming.t460p>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ming Lei <ming.lei@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 05, 2018 at 04:08:37PM +0800, Ming Lei wrote:
> Hi,
> 
> The following failure is triggered when running xfstests(ext4)
> generic/081 with the linus tree(4.17.0_716a685fdb89).
> 
> It might be related with recent mempool change.

Yeah that would be correct.

I just tested and confirmed and mailed out the patch below, you want to double
check for me?


commit 1678b1f8d46c9f8f52372edfde7b9a94e9b416fe
Author: Kent Overstreet <kent.overstreet@gmail.com>
Date:   Tue Jun 5 05:05:51 2018 -0400

    dm: Use kzalloc for all structs with embedded biosets/mempools
    
    mempool_init()/bioset_init() require that the mempools/biosets be zeroed
    first; they probably should not _require_ this, but not allocating those
    structs with kzalloc is a fairly nonsensical thing to do (calling
    mempool_exit()/bioset_exit() on an uninitialized mempool/bioset is legal
    and safe, but only works if said memory was zeroed.)
    
    Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>

diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
index 8e33a38083..e794e3662f 100644
--- a/drivers/md/dm-bio-prison-v1.c
+++ b/drivers/md/dm-bio-prison-v1.c
@@ -33,7 +33,7 @@ static struct kmem_cache *_cell_cache;
  */
 struct dm_bio_prison *dm_bio_prison_create(void)
 {
-	struct dm_bio_prison *prison = kmalloc(sizeof(*prison), GFP_KERNEL);
+	struct dm_bio_prison *prison = kzalloc(sizeof(*prison), GFP_KERNEL);
 	int ret;
 
 	if (!prison)
diff --git a/drivers/md/dm-bio-prison-v2.c b/drivers/md/dm-bio-prison-v2.c
index 601b156920..f866bc97b0 100644
--- a/drivers/md/dm-bio-prison-v2.c
+++ b/drivers/md/dm-bio-prison-v2.c
@@ -35,7 +35,7 @@ static struct kmem_cache *_cell_cache;
  */
 struct dm_bio_prison_v2 *dm_bio_prison_create_v2(struct workqueue_struct *wq)
 {
-	struct dm_bio_prison_v2 *prison = kmalloc(sizeof(*prison), GFP_KERNEL);
+	struct dm_bio_prison_v2 *prison = kzalloc(sizeof(*prison), GFP_KERNEL);
 	int ret;
 
 	if (!prison)
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 53c6ed0eaa..81ffc59d05 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -51,7 +51,7 @@ struct dm_io_client *dm_io_client_create(void)
 	unsigned min_ios = dm_get_reserved_bio_based_ios();
 	int ret;
 
-	client = kmalloc(sizeof(*client), GFP_KERNEL);
+	client = kzalloc(sizeof(*client), GFP_KERNEL);
 	if (!client)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index c89a675a2a..ce7efc7434 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -882,7 +882,7 @@ struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *thro
 	int r;
 	struct dm_kcopyd_client *kc;
 
-	kc = kmalloc(sizeof(*kc), GFP_KERNEL);
+	kc = kzalloc(sizeof(*kc), GFP_KERNEL);
 	if (!kc)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index 43149eb493..abf3521b80 100644
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -180,7 +180,7 @@ struct dm_region_hash *dm_region_hash_create(
 		;
 	nr_buckets >>= 1;
 
-	rh = kmalloc(sizeof(*rh), GFP_KERNEL);
+	rh = kzalloc(sizeof(*rh), GFP_KERNEL);
 	if (!rh) {
 		DMERR("unable to allocate region hash memory");
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index b11ddc55f2..f745404da7 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1120,7 +1120,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		origin_mode = FMODE_WRITE;
 	}
 
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	s = kzalloc(sizeof(*s), GFP_KERNEL);
 	if (!s) {
 		ti->error = "Cannot allocate private snapshot structure";
 		r = -ENOMEM;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 6c923824ec..5772756c63 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2861,7 +2861,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 		return (struct pool *)pmd;
 	}
 
-	pool = kmalloc(sizeof(*pool), GFP_KERNEL);
+	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool) {
 		*error = "Error allocating memory for pool";
 		err_p = ERR_PTR(-ENOMEM);
