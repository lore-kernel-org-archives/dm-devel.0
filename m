From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: v4.9, 4.4-final: 28 bioset threads on small notebook,
 36 threads on cellphone
Date: Wed, 8 Feb 2017 11:34:07 -0500
Message-ID: <20170208163407.GA3646@redhat.com>
References: <20151211140841.GA22873@redhat.com> <20160220174035.GA16459@amd>
	<20160220184258.GA3753@amd> <20160220195136.GA27149@redhat.com>
	<20160220200432.GB22120@amd> <20170206125309.GA29395@amd>
	<20170207014724.74tb37jj7u66lww3@moria.home.lan>
	<20170207024906.4oswyuvxfnqkvbhr@moria.home.lan>
	<20170207203911.GA16980@amd>
	<20170207204510.qr2l2rg42ez2hobh@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170207204510.qr2l2rg42ez2hobh@moria.home.lan>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: oleg.drokin@intel.com, ming.l@ssi.samsung.com, andreas.dilger@intel.com, martin.petersen@oracle.com, minchan@kernel.org, jkosina@suse.cz, ming.lei@canonical.com, kernel list <linux-kernel@vger.kernel.org>, jim@jtan.com, pjk1939@linux.vnet.ibm.com, axboe@fb.com, geoff@infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, dpark@posteo.net, Pavel Machek <pavel@ucw.cz>, ngupta@vflare.org, hch@lst.de, agk@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 07 2017 at 11:58pm -0500,
Kent Overstreet <kent.overstreet@gmail.com> wrote:

> On Tue, Feb 07, 2017 at 09:39:11PM +0100, Pavel Machek wrote:
> > On Mon 2017-02-06 17:49:06, Kent Overstreet wrote:
> > > On Mon, Feb 06, 2017 at 04:47:24PM -0900, Kent Overstreet wrote:
> > > > On Mon, Feb 06, 2017 at 01:53:09PM +0100, Pavel Machek wrote:
> > > > > Still there on v4.9, 36 threads on nokia n900 cellphone.
> > > > > 
> > > > > So.. what needs to be done there?
> > > 
> > > > But, I just got an idea for how to handle this that might be halfway sane, maybe
> > > > I'll try and come up with a patch...
> > > 
> > > Ok, here's such a patch, only lightly tested:
> > 
> > I guess it would be nice for me to test it... but what it is against?
> > I tried after v4.10-rc5 and linux-next, but got rejects in both cases.
> 
> Sorry, I forgot I had a few other patches in my branch that touch
> mempool/biosets code.
> 
> Also, after thinking about it more and looking at the relevant code, I'm pretty
> sure we don't need rescuer threads for block devices that just split bios - i.e.
> most of them, so I changed my patch to do that.
> 
> Tested it by ripping out the current->bio_list checks/workarounds from the
> bcache code, appears to work:

Feedback on this patch below, but first:

There are deeper issues with the current->bio_list and rescue workqueues
than thread counts.

I cannot help but feel like you (and Jens) are repeatedly ignoring the
issue that has been raised numerous times, most recently:
https://www.redhat.com/archives/dm-devel/2017-February/msg00059.html

FYI, this test (albeit ugly) can be used to check if the dm-snapshot
deadlock is fixed:
https://www.redhat.com/archives/dm-devel/2017-January/msg00064.html

This situation is the unfortunate pathological worst case for what
happens when changes are merged and nobody wants to own fixing the
unforseen implications/regressions.   Like everyone else in a position
of Linux maintenance I've tried to stay away from owning the
responsibility of a fix -- it isn't working.  Ok, I'll stop bitching
now.. I do bear responsibility for not digging in myself.  We're all
busy and this issue is "hard".

> -- >8 --
> Subject: [PATCH] block: Make rescuer threads per request_queue, not per bioset
> 
> Also, trigger rescuing whenever with bios on current->bio_list, instead
> of only when we block in bio_alloc_bioset(). This is more correct, and
> should result in fewer rescuer threads.
> 
> XXX: The current->bio_list plugging needs to be unified with the
> blk_plug mechanism.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> ---
...
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3086da5664..e1b22a68d9 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1490,7 +1490,7 @@ static struct mapped_device *alloc_dev(int minor)
>  	INIT_LIST_HEAD(&md->table_devices);
>  	spin_lock_init(&md->uevent_lock);
>  
> -	md->queue = blk_alloc_queue_node(GFP_KERNEL, numa_node_id);
> +	md->queue = blk_alloc_queue_node(GFP_KERNEL, numa_node_id, 0);
>  	if (!md->queue)
>  		goto bad;
>  

This should be BLK_QUEUE_NO_RESCUER as DM isn't making direct use of
bio_queue_split() for its own internal spliting (maybe it should and
that'd start to fix the issue I've been harping about?) but as is DM
destroys the rescuer workqueue (since commit dbba42d8a9eb "dm: eliminate
unused "bioset" process for each bio-based DM device").

Mike
