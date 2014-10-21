From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm raid: pointer math issue in super_sync()
Date: Tue, 21 Oct 2014 08:48:26 -0400
Message-ID: <20141021124826.GC20625@redhat.com>
References: <20141021124336.GA20791@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141021124336.GA20791@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 21 2014 at  8:43am -0400,
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> "sb" is a dm_raid_superblock struct pointer so the pointer math doesn't
> work and we will end up corrupting memory.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index b802644..a7cb9dd 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -826,7 +826,7 @@ static void super_sync(struct mddev *mddev, struct md_rdev *rdev)
>  		    test_bit(Faulty, &(rs->dev[i].rdev.flags)))
>  			failed_devices |= (1ULL << i);
>  
> -	memset(sb + sizeof(*sb), 0, rdev->sb_size - sizeof(*sb));
> +	memset(sb + 1, 0, rdev->sb_size - sizeof(*sb));
>  
>  	sb->magic = cpu_to_le32(DM_RAID_MAGIC);
>  	sb->features = cpu_to_le32(0);	/* No features yet */

Not following... sizeof(*sb) != sizeof(sb).  So I'm not seeing a
problem.

Nor am I seeing how you think sb + 1 is equivalent to what Heinz
intended (zero the memory following the sizeof(struct dm_raid_superblock)).
