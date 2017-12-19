From: Scott Bauer <scott.bauer@intel.com>
Subject: Re: [PATCH v5] dm: add unstriped target
Date: Tue, 19 Dec 2017 11:13:30 -0700
Message-ID: <20171219181329.u3oupyamx7nwscfy@sbauer-Z170X-UD5>
References: <cover.1513618685.git.heinzm@redhat.com>
	<1513639353-7231-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1513639353-7231-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Keith Busch <keith.busch@intel.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

> +static sector_t map_to_core(struct dm_target *ti, struct bio *bio)
> +{
> +	struct unstripe_c *uc = ti->private;
> +	sector_t sector = bio->bi_iter.bi_sector;
> +
> +	/* Account for what stripe we're operating on */
> +	sector += uc->unstripe_offset;
> +
> +	/* Shift us up to the right "row" on the stripe */
> +	sector += uc->unstripe_width * (sector >> uc->chunk_shift);
> +	return sector;
> +}

This doesn't work anymore, previously we had a "group" local variable,
but removed it out. Now we're calculating the group based *after* we
switch up the stripe.

we need to swap the two sector +=  then it will work:

     /* Shift us up to the right "row" on the stripe */
     sector += uc->unstripe_width * (sector >> uc->chunk_shift);

     /* Account for what stripe we're operating on */
     sector += uc->unstripe_offset;
