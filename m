From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm table: improve terse warning messages
	with more context
Date: Thu, 27 Aug 2009 13:21:23 +0100
Message-ID: <20090827122123.GM643@agk-dp.fab.redhat.com>
References: <1249057524-20911-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1249057524-20911-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Jul 31, 2009 at 12:25:24PM -0400, Mike Snitzer wrote:
> @@ -496,8 +500,13 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
>  	}
>  
>  	if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
> -		DMWARN("%s: target device %s is misaligned",
> -		       dm_device_name(ti->table->md), bdevname(bdev, b));
> +		DMWARN("%s: target device %s is misaligned: "
> +		       "physical_block_size=%hu, alignment_offset=%hu, "
> +		       "start=%llu",
> +		       dm_device_name(ti->table->md), bdevname(bdev, b),
> +		       q->limits.physical_block_size,
> +		       q->limits.alignment_offset,
> +		       (unsigned long long) start << 9);
  
        unsigned int            physical_block_size;
        unsigned int            alignment_offset;

Presumably those should be just %u.

Alasdair
