From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 4/7] dm: prevent DAX mounts if not supported
Date: Fri, 25 May 2018 15:36:47 -0600
Message-ID: <20180525213647.GA3521@linux.intel.com>
References: <20180525025518.11405-1-ross.zwisler@linux.intel.com>
 <20180525025518.11405-5-ross.zwisler@linux.intel.com>
 <20180525195410.GA11008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180525195410.GA11008-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

On Fri, May 25, 2018 at 03:54:10PM -0400, Mike Snitzer wrote:
> On Thu, May 24 2018 at 10:55pm -0400,
> Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> 
> > Currently the code in dm_dax_direct_access() only checks whether the target
> > type has a direct_access() operation defined, not whether the underlying
> > block devices all support DAX.  This latter property can be seen by looking
> > at whether we set the QUEUE_FLAG_DAX request queue flag when creating the
> > DM device.
> > 
> > This is problematic if we have, for example, a dm-linear device made up of
> > a PMEM namespace in fsdax mode followed by a ramdisk from BRD.
> > QUEUE_FLAG_DAX won't be set on the dm-linear device's request queue, but
> > we have a working direct_access() entry point and the first member of the
> > dm-linear set *does* support DAX.
> > 
> > This allows the user to create a filesystem on the dm-linear device, and
> > then mount it with DAX.  The filesystem's bdev_dax_supported() test will
> > pass because it'll operate on the first member of the dm-linear device,
> > which happens to be a fsdax PMEM namespace.
> > 
> > All DAX I/O will then fail to that dm-linear device because the lack of
> > QUEUE_FLAG_DAX prevents fs_dax_get_by_bdev() from working.  This means that
> > the struct dax_device isn't ever set in the filesystem, so
> > dax_direct_access() will always return -EOPNOTSUPP.
> > 
> > By failing out of dm_dax_direct_access() if QUEUE_FLAG_DAX isn't set we let
> > the filesystem know we don't support DAX at mount time.  The filesystem
> > will then silently fall back and remove the dax mount option, causing it to
> > work properly.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Fixes: commit 545ed20e6df6 ("dm: add infrastructure for DAX support")
> > ---
> >  drivers/md/dm.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 0a7b0107ca78..9728433362d1 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -1050,14 +1050,13 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
> >  
> >  	if (!ti)
> >  		goto out;
> > -	if (!ti->type->direct_access)
> > +	if (!blk_queue_dax(md->queue))
> >  		goto out;
> >  	len = max_io_len(sector, ti) / PAGE_SECTORS;
> >  	if (len < 1)
> >  		goto out;
> >  	nr_pages = min(len, nr_pages);
> > -	if (ti->type->direct_access)
> > -		ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
> > +	ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
> 
> So I followed all the rationale for this patch.  But the last change
> doesn't make any sense.  We should still verify that the target has
> ti->type->direct_access before calling it.  So please reinstate that
> check before calling it.

You know that type has direct_access() via the blk_queue_dax() check.  This
tells you not only that the target has direct_access(), but also that you've
successfully checked all members of that DM device and they all have working
DAX I/O paths, etc.  This is all done via the bdev_dax_supported() check and
the rest of the code in dm_table_supports_dax() and device_supports_dax().

If this is too subtle I can add a comment or add the check back.
