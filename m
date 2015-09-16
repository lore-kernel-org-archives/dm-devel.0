From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 5/5] block: Inline blk_integrity in struct
	gendisk
Date: Tue, 15 Sep 2015 21:07:21 -0400
Message-ID: <20150916010720.GA21398@redhat.com>
References: <20150721120102.GB1654@infradead.org>
	<1440103314-31610-1-git-send-email-martin.petersen@oracle.com>
	<1440103314-31610-6-git-send-email-martin.petersen@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1440103314-31610-6-git-send-email-martin.petersen@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@fb.com>, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Matthew Wilcox <willy@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: dm-devel.ids

On Thu, Aug 20 2015 at  4:41pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> Up until now the_integrity profile has been dynamically allocated and
> attached to struct gendisk after the disk has been made active.
> 
> This causes problems because NVMe devices need to register the profile
> prior to the partition table being read due to a mandatory metadata
> buffer requirement. In addition, DM goes through hoops to deal with
> preallocating, but not initializing integrity profiles.

Yes, but only if the underlying device(s) actually support bip.  This
change to inlining blk_integrity (purely to make NVMe happy) comes at
the cost of _always_ allocating the memory 'struct blk_integrity' (via
gendisk inline) even if there is absolutely no need for it.

That said, with your changes the blk_integrity structure is no longer
large (previously was 96 bytes).. so I can let that part go.

> Since the integrity profile is small (4 bytes + a pointer), Christoph
> suggested moving it to struct gendisk proper. This requires several
> changes:
> 
>  - Moving the blk_integrity definition to genhd.h.
> 
>  - Inlining blk_integrity in struct gendisk.
> 
>  - Removing the dynamic allocation code.
> 
>  - Adding helper functions which allow gendisk to set up and tear down
>    the integrity sysfs dir when a disk is added/deleted.
> 
>  - Adding a blk_integrity_revalidate() callback for updating the stable
>    pages bdi setting.
> 
>  - The calls that depend on whether a device has an integrity profile or
>    not now key off of the bi->profile pointer.
> 
>  - Simplifying the integrity support routines in DM.

But I cannot let this DM "simplifying" go (vast majority of it breaks
bip for DM).  You missed the fact that DM has inactive and active
tables.  And that the top-level DM device can only be changed once an
inactive table is made active via DM's resume.  The bip for the DM
device cannot be changed during table load.  Such a change can only be
done during table resume.  Reason is an inactive DM table can get thrown
away at any time; so changing the top-level DM device during the load of
an inactive table isn't right.

Please review the commit header from commit a63a5cf84 ("dm: improve
block integrity support").

Long story short, DM changes that eliminate the checks/code for
allocating the blk_integrity structure should be all that is needed for
this patch.

I'll work through this further.  Hope to send an incremental patch that
fixes things up in the next day or so.
