From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/3] md:Add a func 'dm_md_stop' for dm-raid to clear up
	md resources.
Date: Thu, 15 Nov 2012 11:45:29 +0000
Message-ID: <20121115114529.GA12798@agk-dp.fab.redhat.com>
References: <201211151646546882035@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201211151646546882035@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: NeilBrown <neilb@suse.de>, agk <agk@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 15, 2012 at 04:46:59PM +0800, majianpeng wrote:
> So add a func dm_md_stop to clear up resource.
 
> +++ b/drivers/md/md.c

> +void dm_md_stop(struct mddev *mddev)
> +{
> +	md_stop(mddev);
> +	bitmap_destroy(mddev);
> +	if (mddev->bio_set)
> +		bioset_free(mddev->bio_set);
> +}
> +EXPORT_SYMBOL_GPL(dm_md_stop);

Let's not put a function with a dm_ prefix in an md file?

Alasdair

