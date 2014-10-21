From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm raid: pointer math issue in super_sync()
Date: Tue, 21 Oct 2014 09:25:19 -0400
Message-ID: <20141021132519.GD20625@redhat.com>
References: <20141021124336.GA20791@mwanda>
 <20141021124826.GC20625@redhat.com>
 <20141021125729.GC26918@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141021125729.GC26918@mwanda>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, kernel-janitors@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 21 2014 at  8:57am -0400,
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Tue, Oct 21, 2014 at 08:48:26AM -0400, Mike Snitzer wrote:
> > > -	memset(sb + sizeof(*sb), 0, rdev->sb_size - sizeof(*sb));
> > > +	memset(sb + 1, 0, rdev->sb_size - sizeof(*sb));
> > >  
> > >  	sb->magic = cpu_to_le32(DM_RAID_MAGIC);
> > >  	sb->features = cpu_to_le32(0);	/* No features yet */
> > 
> > Not following... sizeof(*sb) != sizeof(sb).  So I'm not seeing a
> > problem.
> > 
> > Nor am I seeing how you think sb + 1 is equivalent to what Heinz
> > intended (zero the memory following the sizeof(struct dm_raid_superblock)).
> 
> It's pointer math.

Yes, I see that now..

> sizeof(*sb) is 512.
> 
> "sb + sizeof(*sb)" is the same as (void *)sb + 512 * 512.
> "sb + 1" is the same as (void *)sb + 512.

Actually, Heinz removed the 452 bytes of padding from struct
dm_raid_superblock, so it is more like:

sizeof(*sb) == sizeof(struct dm_raid_super_block) == 60

"sb + sizeof(*sb)" is the same as (void *)sb + 60 * 60
"sb + 1" is the same as (void *)sb + 60.

But regardless, your broader point on the math stands.  I'll get this
fixed up, thanks!

Mike
