From: "Liuhua Wang" <lwang@suse.com>
Subject: Re: [PATCH] fix mirror device creation with lvcreate
 failed
Date: Thu, 18 Sep 2014 00:56:33 -0600
Message-ID: <541AF2A1020000A00000D113@soto.provo.novell.com>
References: <1409127505-5246-1-git-send-email-lwang@suse.com>
	<20140916232104.GC2407@agk-dp.fab.redhat.com>
	<54198887020000A00000CFC2@soto.provo.novell.com>
	<20140917114151.GF2407@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140917114151.GF2407@agk-dp.fab.redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Neil F Brown <NFBrown@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi, Alasdair
Hi, Neil

>>> On 9/17/2014 at 07:41 PM, in message
<20140917114151.GF2407@agk-dp.fab.redhat.com>, Alasdair G Kergon
<agk@redhat.com> wrote: 
> On Tue, Sep 16, 2014 at 11:11:35PM -0600, Liuhua Wang wrote:
> > There are error messages:
> > ---------------------
> > [22798.077877] end_request: I/O error, dev dasdd, sector 2240
> > [22798.077902] device-mapper: raid: Failed to read superblock of device at 
> position 1
> > [23087.875420] type=1006 audit(1404313201.346:28): pid=1596 uid=0 old 
> auid=4294967295 new auid=0 old ses=4294967295 new ses=27 res=1
> > [23127.707296] dasd-eckd.d2bf98: 0.0.141d: ERP 0000000036ab1e40 has run out 
> of retries and failed
> > ----------------------
>  
> OK, so it sounds like Neil's patch will be enough to fix this.
> Can you test that and confirm it solves the problem?
> 

I tested Neil's patch, lvcreate succeed, the lv created can display,
be written successfully, but only there still are error messages:
--------------------------------
2014-09-18T06:39:52.653239+02:00 s390vsl158 kernel: device-mapper: raid: Superblocks created for new array
2014-09-18T06:39:52.663361+02:00 s390vsl158 kernel: md/raid1:mdX: not clean -- starting background reconstruction
2014-09-18T06:39:52.663366+02:00 s390vsl158 kernel: md/raid1:mdX: active with 2 out of 2 mirrors
2014-09-18T06:39:52.663366+02:00 s390vsl158 kernel: Choosing daemon_sleep default (5 sec)
2014-09-18T06:39:52.663367+02:00 s390vsl158 kernel: created bitmap (1 pages) for device mdX
2014-09-18T06:39:52.663368+02:00 s390vsl158 kernel: end_request: I/O error, dev dasdb, sector 19202144
2014-09-18T06:39:52.663369+02:00 s390vsl158 kernel: md: super_written gets error=-5, uptodate=0
2014-09-18T06:39:52.663369+02:00 s390vsl158 kernel: md/raid1:mdX: Disk failure on dm-3, disabling device.
-------------------------

So I add also roundup to md_super_write() as following,
then the above error messages disappears.
--------------------------
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1294238..18cd2e7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -754,6 +754,8 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 	struct bio *bio = bio_alloc_mddev(GFP_NOIO, 1, mddev);
 
 	bio->bi_bdev = rdev->meta_bdev ? rdev->meta_bdev : rdev->bdev;
+        size = roundup(size, bdev_logical_block_size(bio->bi_bdev));
+	
 	bio->bi_iter.bi_sector = sector;
 	bio_add_page(bio, page, size, 0);
 	bio->bi_private = rdev;
@@ -784,6 +786,10 @@ int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 
 	bio->bi_bdev = (metadata_op && rdev->meta_bdev) ?
 		rdev->meta_bdev : rdev->bdev;
+        size = roundup(size, bdev_logical_block_size(bio->bi_bdev));
+        if (size > PAGE_SIZE)
+                return -EINVAL;
+
 	if (metadata_op)
 		bio->bi_iter.bi_sector = sector + rdev->sb_start;
 	else if (rdev->mddev->reshape_position != MaxSector &&
-- 
--------------------------

I also used this patch and tested with a loop device 
of blocksize 512, there is no problem.


Best regards,
Liuhua
 
