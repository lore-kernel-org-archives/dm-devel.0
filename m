From: Gen Zhang <blackgod016574@gmail.com>
Subject: Re: dm-init: fix 2 incorrect use of kstrndup()
Date: Thu, 6 Jun 2019 17:27:25 +0800
Message-ID: <20190606092725.GA21792@zhanggen-UX430UQ>
References: <20190529013320.GA3307@zhanggen-UX430UQ>
 <fcf2c3c0-e479-9e74-59d5-79cd2a0bade6@acm.org>
 <20190529152443.GA4076@zhanggen-UX430UQ>
 <20190530161103.GA30026@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190530161103.GA30026@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, dm-devel@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, May 30, 2019 at 12:11:03PM -0400, Mike Snitzer wrote:
> On Wed, May 29 2019 at 11:24am -0400,
> Gen Zhang <blackgod016574@gmail.com> wrote:
> 
> > On Wed, May 29, 2019 at 05:23:53AM -0700, Bart Van Assche wrote:
> > > On 5/28/19 6:33 PM, Gen Zhang wrote:
> > > > In drivers/md/dm-init.c, kstrndup() is incorrectly used twice.
> > > > 
> > > > It should be: char *kstrndup(const char *s, size_t max, gfp_t gfp);
> > > 
> > > Should the following be added to this patch?
> > > 
> > > Fixes: 6bbc923dfcf5 ("dm: add support to directly boot to a mapped
> > > device") # v5.1.
> > > Cc: stable
> > > 
> > > Thanks,
> > > 
> > > Bart.
> > Personally, I am not quite sure about this question, because I am not 
> > the maintainer of this part.
> 
> Yes, it should have the tags Bart suggested.
> 
> I'll take care it.
> 
> Thanks,
> Mike
Hi,
Is there any updates about this patch? I want to check if it is apllied
beacause I have to write it down in my paper and the deadline is close.

Thanks
Gen
