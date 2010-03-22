From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: shared snapshots release 17
Date: Mon, 22 Mar 2010 18:33:19 -0400
Message-ID: <20100322223318.GA26907@redhat.com>
References: <Pine.LNX.4.64.1003221513150.15382@hs20-bc2-1.build.redhat.com>
	<20100322205433.GB13346@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100322205433.GB13346@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 22 2010 at  4:54pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:


> ... here are your r17 changes relative to r16

<snip>

> diff --git a/drivers/md/dm-multisnap.c b/drivers/md/dm-multisnap.c
> index 1a1a500..5ba1af8 100644
> --- a/drivers/md/dm-multisnap.c
> +++ b/drivers/md/dm-multisnap.c
> @@ -1461,6 +1468,44 @@ poll_for_ios:
>  	mutex_unlock(&all_multisnapshots_lock);
>  }
>  
> +static int multisnap_iterate_devices(struct dm_target *ti, struct dm_multisnap *s,
> +				     iterate_devices_callout_fn fn, void *data)
> +{
> +	int r;
> +
> +	r = fn(ti, s->origin, 0, s->origin_sectors, data);
> +
> +	if (!r)
> +		r = fn(ti, s->snapshot, 0, s->origin_sectors, data);
> +
> +	return r;
> +}
> +
> +static int multisnap_origin_iterate_devices(struct dm_target *ti,
> +					    iterate_devices_callout_fn fn, void *data)
> +{
> +	struct dm_multisnap *s = ti->private;
> +	return multisnap_iterate_devices(ti, s, fn, data);
> +}
> +
> +static int multisnap_snap_iterate_devices(struct dm_target *ti,
> +					  iterate_devices_callout_fn fn, void *data)
> +{
> +	int r;
> +	struct dm_multisnap_snap *sn = ti->private;
> +	struct dm_multisnap *s;
> +
> +	mutex_lock(&all_multisnapshots_lock);
> +	s = sn->s;
> +	if (s)
> +		r = multisnap_iterate_devices(ti, s, fn, data);
> +	else
> +		r = 0;
> +	mutex_unlock(&all_multisnapshots_lock);
> +
> +	return r;
> +}
> +
>  static int multisnap_origin_map(struct dm_target *ti, struct bio *bio,
>  				union map_info *map_context)
>  {
> @@ -1934,6 +1979,7 @@ static struct target_type multisnap_origin_target = {
>  	.message 	= multisnap_origin_message,
>  	.status		= multisnap_origin_status,
>  	.postsuspend	= multisnap_origin_postsuspend,
> +	.iterate_devices = multisnap_origin_iterate_devices,
>  };
>  
>  static struct target_type multisnap_snap_target = {
> @@ -1945,6 +1991,7 @@ static struct target_type multisnap_snap_target = {
>  	.map		= multisnap_snap_map,
>  	.end_io		= multisnap_snap_end_io,
>  	.status		= multisnap_snap_status,
> +	.iterate_devices = multisnap_snap_iterate_devices,
>  };
>  
>  static int __init dm_multisnapshot_init(void)

multisnap_origin_iterate_devices() is failing for me with:
 kernel: device-mapper: table: 253:0: dm-2 too small for target: start=0, len=8388608, dev_size=2097152

After failure to reload the origin, the remaining tables are:
test-testlv1: 0 8388608 linear 254:16 384
test-testlv1-cow: 0 2097152 linear 254:16 8388992
test-testlv1-real: 0 8388608 linear 254:16 384


The following patch fixes it for me, but it needs further cleanup
(duplicates method from the old snapshot code).

diff --git a/drivers/md/dm-multisnap.c b/drivers/md/dm-multisnap.c
index 5ba1af8..0644e19 100644
--- a/drivers/md/dm-multisnap.c
+++ b/drivers/md/dm-multisnap.c
@@ -113,6 +113,15 @@ EXPORT_SYMBOL(dm_multisnap_drop_on_error);
 static DEFINE_MUTEX(all_multisnapshots_lock);
 static LIST_HEAD(all_multisnapshots);
 
+/*
+ * Return the number of sectors in the device.
+ * FIXME: duplicates dm-exception-store.h:get_dev_size
+ */
+static inline sector_t get_dev_size(struct block_device *bdev)
+{
+	return i_size_read(bdev->bd_inode) >> SECTOR_SHIFT;
+}
+
 static chunk_t sector_to_chunk(struct dm_multisnap *s, sector_t sector)
 {
 	return sector >> (s->chunk_shift - SECTOR_SHIFT);
@@ -1476,7 +1485,8 @@ static int multisnap_iterate_devices(struct dm_target *ti, struct dm_multisnap *
 	r = fn(ti, s->origin, 0, s->origin_sectors, data);
 
 	if (!r)
-		r = fn(ti, s->snapshot, 0, s->origin_sectors, data);
+		r = fn(ti, s->snapshot, 0,
+		       get_dev_size(dm_multisnap_snapshot_bdev(s)), data);
 
 	return r;
 }
