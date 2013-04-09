From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: dm-crypt parallelization patches
Date: Tue, 9 Apr 2013 17:07:35 -0400
Message-ID: <20130409210735.GR6320@redhat.com>
References: <20130328194443.GG14088@htj.dyndns.org>
 <20130328203808.GC15969@redhat.com>
 <20130328204522.GA25501@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091242350.10025@file.rdu.redhat.com>
 <20130409175753.GA6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091402150.10025@file.rdu.redhat.com>
 <20130409181031.GC6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091450410.26327@file.rdu.redhat.com>
 <20130409195259.GL6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Christian Schmidt <schmidt@digadd.de>
List-Id: dm-devel.ids

On Tue, Apr 09, 2013 at 04:32:28PM -0400, Mikulas Patocka wrote:

[..]
> Generally, we shouldn't associate bios with "current" task in device 
> mapper targets. For example suppose that we have two stacked dm-crypt 
> targets:
>
> In the "current" process pointer in lower dm-crypt target's request 
> function always points to the workqueue of the upper dm-crypt target that 
> submits the bios. So if we associate the bio with "current" in the lower 
> target, we are associating it with a preallocated workqueue and we already 
> lost the information who submitted it.
> 
> You should associate a bio with a task when you create the bio and "md" 
> and "dm" midlayers should just forward this association to lower layer 
> bios.

bio_associate_current() return -EBUSY if bio has already been associated
with an io context.

So in a stack if every driver calls bio_associate_current(), upon bio
submission, it will automatically amke sure bio gets associated with
submitter task in top level device and calls by lower level device
will be ignored.

Lower level devices I think just need to make sure this context
info is propogated to cloned bios.


[..]
> +#ifdef CONFIG_BLK_CGROUP
> +	tio->clone.bi_ioc = ci->bio->bi_ioc;
> +	tio->clone.bi_css = ci->bio->bi_css;

You also need to take references to ioc and css objects. I guess a helper
function will be better. May be something like.

bio_associate_bio_context(bio1, bio2)

And this initialize bio2's context with bio1's context.

Thanks
Vivek
