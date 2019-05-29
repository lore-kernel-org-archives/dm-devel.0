From: Gen Zhang <blackgod016574@gmail.com>
Subject: Re: [dm-devel] [PATCH] dm-init: fix 2 incorrect use of kstrndup()
Date: Wed, 29 May 2019 23:24:43 +0800
Message-ID: <20190529152443.GA4076@zhanggen-UX430UQ>
References: <20190529013320.GA3307@zhanggen-UX430UQ>
 <fcf2c3c0-e479-9e74-59d5-79cd2a0bade6@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fcf2c3c0-e479-9e74-59d5-79cd2a0bade6@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, May 29, 2019 at 05:23:53AM -0700, Bart Van Assche wrote:
> On 5/28/19 6:33 PM, Gen Zhang wrote:
> > In drivers/md/dm-init.c, kstrndup() is incorrectly used twice.
> > 
> > It should be: char *kstrndup(const char *s, size_t max, gfp_t gfp);
> 
> Should the following be added to this patch?
> 
> Fixes: 6bbc923dfcf5 ("dm: add support to directly boot to a mapped
> device") # v5.1.
> Cc: stable
> 
> Thanks,
> 
> Bart.
Personally, I am not quite sure about this question, because I am not 
the maintainer of this part.

Thanks
Gen
