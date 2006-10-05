From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: 1st of 2 patches for dm_emc.c and dm-multipath
 hardware handler interface
Date: Thu, 05 Oct 2006 13:09:41 -0500
Message-ID: <45254A65.1030003@cs.wisc.edu>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1413@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060601010102060008040208"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D1413@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Goggin <egoggin@emc.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------060601010102060008040208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Edward Goggin wrote:
> On Friday, September 08, 2006 1:21 PM, Mike Christie wrote
>> Edward Goggin wrote:
>>> +
>>> +	rq->buffer = rq->data = h->buffer;
>>> +	rq->data_len = len;
>>> +	rq->bio = rq->biotail = NULL;
>>>  
>> I think I only suggested that you use the block layer map functions in
>> the previous review. Now I will say, use them and fix the core code to
>> not allocate memory or use a mempool since it will also fix the path
>> testers at the same time :) The reason is that the scsi layer 
>> is trying
>> to make every thing run with scatterlists. In 2.6.18, every place is
>> converted (they should be at least), so you should not be 
>> adding another
>> place where we send down a data buffer like this.
>>
> 
> Mike, sorry for the long delay.

No problem.

> 
> I certainly can (and have tried already before submitting the patch
> as is) change the code to call blk_rq_map_kern instead of using the
> code sequence you have identified above.  As you cite, I was trying
> to avoid memory/mempool allocation (for a bio) while servicing the io.
> 
> As far as fixing the code to not allocate memory or use a mempool,
> let me know if the description below is what you have in mind?
> 
> A slightly modified version of __bio_map_kern
> (and modified versions of its callers like blk_rq_map_kern)
> which would accept a ptr to bio as a parameter instead of
> allocating one.  Any kernel resident code like a dm-multipath
> hardware handler could obtain a bio beforehand from a distinct
> bio_set (bio mempool).  In the dm-multipath hardware handler
> case, a single bio_set could be associated with each target
> path (struct path).

So do we need bioset per path or even per module here?

Is the problem we are trying to solve:
1. we would allocate a bio from the same bioset as the layer above dm so
if that bioset is depleted we cannot perform REQ_BLOCK_PC commands (or
whatever they are called in 2.6.19.
2. we need some reserve bio so we can always allocate a bio.

If so could we just make a bio set for all blk pc commands and then for
GFP_NOIO do a wait similar to what ll_rw_blk.c does for requests. See
the attached patch for details. But this approach would solve the
problem for the path testers and hw handlers and sg.c and st.c at the
same time. The problem I see with it is that it is not fair and it is
possible that someone could wait forever, but I am not sure if that is
very realistic and I am not sure if that is a bad enough problem to
justify adding biosets for every driver.

But for all this you should ask/cc Jens Axboe. He is the block layer
maintainer.

--------------060601010102060008040208
Content-Type: text/x-patch;
 name="out.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="out.patch"

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
diff --git a/fs/bio.c b/fs/bio.c
index 6a0b9ad..e120945 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -75,6 +75,7 @@ struct bio_set {
  * IO code that does not need private memory pools.
  */
 static struct bio_set *fs_bio_set;
+static struct bio_set *blk_pc_bio_set; /* TODO rename for what is is now called */
 
 static inline struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned long *idx, struct bio_set *bs)
 {
@@ -119,6 +120,14 @@ void bio_free(struct bio *bio, struct bi
 /*
  * default destructor for a bio allocated with bio_alloc_bioset()
  */
+static void bio_pc_destructor(struct bio *bio)
+{
+	bio_free(bio, blk_pc_bio_set);
+}
+
+/*
+ * default destructor for a bio allocated with bio_alloc_bioset()
+ */
 static void bio_fs_destructor(struct bio *bio)
 {
 	bio_free(bio, fs_bio_set);
@@ -832,9 +841,13 @@ static struct bio *__bio_map_kern(reques
 	int offset, i;
 	struct bio *bio;
 
-	bio = bio_alloc(gfp_mask, nr_pages);
-	if (!bio)
+	/* todo: move so map_user can use */ 
+	bio = bio_alloc_bioset(gfp_mask, nr_pages, blk_pc_bio_set);
+	if (!bio) {
+		/* if GFP_WAIT then retry and wait like in get_request_wait */
 		return ERR_PTR(-ENOMEM);
+	}
+	bio->bi_destructor = bio_pc_destructor;
 
 	offset = offset_in_page(kaddr);
 	for (i = 0; i < nr_pages; i++) {
@@ -1243,7 +1256,11 @@ static int __init init_bio(void)
 
 	fs_bio_set = bioset_create(BIO_POOL_SIZE, bvec_pool_entries, scale);
 	if (!fs_bio_set)
-		panic("bio: can't allocate bios\n");
+		panic("bio: can't allocate fs bios\n");
+
+	blk_pc_bio_set = bioset_create(BIO_POOL_SIZE, bvec_pool_entries, scale)
+	if (!blk_pc_bio_set)
+		panic("bio: can't allocate blk pc bios\n");
 
 	bio_split_pool = mempool_create_kmalloc_pool(BIO_SPLIT_ENTRIES,
 						     sizeof(struct bio_pair));

--------------060601010102060008040208
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------060601010102060008040208--
