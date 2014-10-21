From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: dm raid: pointer math issue in super_sync()
Date: Tue, 21 Oct 2014 15:57:29 +0300
Message-ID: <20141021125729.GC26918@mwanda>
References: <20141021124336.GA20791@mwanda>
 <20141021124826.GC20625@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141021124826.GC20625@redhat.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 21, 2014 at 08:48:26AM -0400, Mike Snitzer wrote:
> > -	memset(sb + sizeof(*sb), 0, rdev->sb_size - sizeof(*sb));
> > +	memset(sb + 1, 0, rdev->sb_size - sizeof(*sb));
> >  
> >  	sb->magic = cpu_to_le32(DM_RAID_MAGIC);
> >  	sb->features = cpu_to_le32(0);	/* No features yet */
> 
> Not following... sizeof(*sb) != sizeof(sb).  So I'm not seeing a
> problem.
> 
> Nor am I seeing how you think sb + 1 is equivalent to what Heinz
> intended (zero the memory following the sizeof(struct dm_raid_superblock)).

It's pointer math.

sizeof(*sb) is 512.

"sb + sizeof(*sb)" is the same as (void *)sb + 512 * 512.
"sb + 1" is the same as (void *)sb + 512.

regards,
dan carpenter
