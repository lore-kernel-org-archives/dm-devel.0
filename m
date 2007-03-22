From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: dm-multipath based engenio-lsi hardware handler
Date: Thu, 22 Mar 2007 13:04:35 -0500
Message-ID: <4602C533.3010908@cs.wisc.edu>
References: <1174589692.22545.33.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1174589692.22545.33.camel@linuxchandra>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com
Cc: Mike Anderson <andmike@us.ibm.com>, dm-devel <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Chandra Seetharaman wrote:

Did you see may later revisions on this or Ed's updated handler? In the
current kernel we do not need to allocate or manage our own bios. That
was a old old hack from when the request did not have a end io. The hack
is probably only needed for old distros. It is not needed upstream.

For dm based hw handlers you want to do something more like this:
http://www.cs.wisc.edu/~michaelc/block/dm/v4/

> static struct bio *get_rdac_bio(struct path *path, unsigned data_size,
> 		bio_end_io_t endio, int rw, struct rdac_handler *h)
> {
> 	struct bio *bio;
> 	struct page *page;
> 	struct rdac_private *p;
> 
> 	bio = bio_alloc(GFP_ATOMIC, 1);
> 	if (!bio)
> 		return NULL;
> 
> 	if (rw == WRITE)
> 		bio->bi_rw |= (1 << BIO_RW);
> 	bio->bi_bdev = path->dev->bdev;
> 	bio->bi_sector = 0;
> 	bio->bi_end_io = endio;
> 
> 	p = kmalloc(sizeof(*p), GFP_ATOMIC);
> 	if (!p)
> 		goto bio;
> 
> 	p->path = path;
> 	p->h = h;
> 	bio->bi_private = p;
> 	page = alloc_page(GFP_ATOMIC);
> 	if (!page)
> 		goto free_private;
> 
> 	if (bio_add_page(bio, page, data_size, 0) == data_size)
> 		return bio;
> 
> 	__free_page(page);
> free_private:
> 	kfree(p);
> bio:
> 	bio_put(bio);
> 	return NULL;
> }



> 
> static void rdac_pg_init(struct hw_handler *hwh, unsigned bypassed,
> 			struct path *path)
> {
> 	struct rdac_handler *h = hwh->context;
> 
> 	switch (h->lun) {
> 	case UNINITIALIZED_LUN:
> 		submit_c8_inquiry(h, path);
> 		break;
> 	case UNSUPPORTED_LUN:
> 		dm_pg_init_complete(path, MP_FAIL_PATH);
> 		break;
> 	default:
> 		submit_c9_inquiry(h, path);
> 	}
> }
> 

Why not just have userspace check and pass the LUN to the create
function? This is not a review comment to do it. I am just asking if it
is difficult to gather info in userspace and pass it down?
