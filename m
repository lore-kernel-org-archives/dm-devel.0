From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs
Date: Mon, 31 May 2010 19:46:11 +0200
Message-ID: <20100531174611.GF10766@basil.fritz.box>
References: <20100531160425.GA20344@basil.fritz.box> <1275323695.3291.122.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1275323695.3291.122.camel@edumazet-laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, herbert@gondor.apana.org.au, dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
List-Id: dm-devel.ids

On Mon, May 31, 2010 at 06:34:55PM +0200, Eric Dumazet wrote:

Yes seems like I'm behind on per cpu innovations.

> Since commit e0fdb0e050eae331, we have a __percpu annotation so that
> sparse can be augmented. This would also make the comment unnecessary...

I think the comment is still necessary.

> 
> > +       __get_cpu_var(io_wq_cpu) = current;
> 
> 	this_cpu_write(io_wq_cpu, current)

And this one looks more ugly than before and does not seem
to generate better code, so I decided to skip it.

Thanks.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
