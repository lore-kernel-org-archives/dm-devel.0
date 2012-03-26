From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm thin: fix pool target flags that control
 discard
Date: Mon, 26 Mar 2012 16:34:39 +0100
Message-ID: <20120326153438.GA26558@ubuntu>
References: <20120316152156.GA8836@ubuntu>
	<1331911358-8848-1-git-send-email-ejt@redhat.com>
	<1331911358-8848-11-git-send-email-ejt@redhat.com>
	<20120323123747.GB16214@agk-dp.fab.redhat.com>
	<20120323215502.GB11054@redhat.com> <20120326141520.GA24249@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120326141520.GA24249@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 26, 2012 at 03:15:21PM +0100, Joe Thornber wrote:
> > o disallow disabling discards if a pool was already configured with
> >   discards enabled (the default)
> >   - justification is inlined in the code
> >   - required pool_ctr knowing whether pool was created or not; so added
> >     'created' flag to __pool_find()
> 
> ack, this needs fixing.

The following patch prevents people changing the top-level discard
flag when reloading a pool target.

I'll push this test in a bit (dm-cache changes holding things up).

  # we don't allow people to change their minds about top level                                                                                                    
  # discard support.                                                                                                                                               
  def test_change_discard_with_reload_fails
    with_standard_pool(@size, :discard => true) do |pool|
      assert_raise(ExitError) do
        table = Table.new(ThinPool.new(@size, @metadata_dev, @data_dev,
                                       @data_block_size, @low_water_mark, false, false, false))
        pool.load(table)
      end
    end

    with_standard_pool(@size, :discard => false) do |pool|
      assert_raise(ExitError) do
        table = Table.new(ThinPool.new(@size, @metadata_dev, @data_dev,
                                       @data_block_size, @low_water_mark, false, true, false))
        pool.load(table)
      end
    end
  end


- Joe


commit 9f075e7f5330039addba213a0f512ab7c0ea3ecf
Author: Joe Thornber <ejt@redhat.com>
Date:   Mon Mar 26 16:26:33 2012 +0100

    dm-thin: don't allow the top level discard flag to be changed on reload.

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index e8fe5db..e5a6ed4 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1445,10 +1445,12 @@ static void __pool_dec(struct pool *pool)
 
 static struct pool *__pool_find(struct mapped_device *pool_md,
 				struct block_device *metadata_dev,
-				unsigned long block_size, char **error)
+				unsigned long block_size, char **error,
+				int *created)
 {
 	struct pool *pool = __pool_table_lookup_metadata_dev(metadata_dev);
 
+	*created = 0;
 	if (pool) {
 		if (pool->pool_md != pool_md)
 			return ERR_PTR(-EBUSY);
@@ -1461,8 +1463,10 @@ static struct pool *__pool_find(struct mapped_device *pool_md,
 				return ERR_PTR(-EINVAL);
 			__pool_inc(pool);
 
-		} else
+		} else {
 			pool = pool_create(pool_md, metadata_dev, block_size, error);
+			*created = 1;
+		}
 	}
 
 	return pool;
@@ -1542,7 +1546,7 @@ static int parse_pool_features(struct dm_arg_set *as, struct pool_features *pf,
  */
 static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
-	int r;
+	int r, pool_created;
 	struct pool_c *pt;
 	struct pool *pool;
 	struct pool_features pf;
@@ -1617,12 +1621,24 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	pool = __pool_find(dm_table_get_md(ti->table), metadata_dev->bdev,
-			   block_size, &ti->error);
+			   block_size, &ti->error, &pool_created);
 	if (IS_ERR(pool)) {
 		r = PTR_ERR(pool);
 		goto out_free_pt;
 	}
 
+	/*
+	 * 'pool_created' reflects whether this is the first table load.
+	 * Top level discard support is not allowed to be changed after
+	 * initial load.  This would require a pool reload to trigger thin
+	 * device changes.
+	 */
+	if (!pool_created && pf.discard_enabled != pool->pf.discard_enabled) {
+		ti->error = "Discard support cannot be changed once enabled";
+		r = -EINVAL;
+		goto out_flags_changed;
+	}
+
 	pt->pool = pool;
 	pt->ti = ti;
 	pt->metadata_dev = metadata_dev;
@@ -1643,6 +1659,8 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	return 0;
 
+out_flags_changed:
+	__pool_dec(pool);
 out_free_pt:
 	kfree(pt);
 out:
