From: Frank Mayhar <fmayhar@google.com>
Subject: Re: dm: Make MIN_IOS, et al, tunable via sysctl.
Date: Mon, 19 Aug 2013 08:04:12 -0700
Message-ID: <1376924652.24869.39.camel@bobble.lax.corp.google.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
	 <20130817123039.GR1762@agk-dp.fab.redhat.com>
	 <20130819134038.GA27167@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130819134038.GA27167@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 2013-08-19 at 09:40 -0400, Mike Snitzer wrote:
> On Sat, Aug 17 2013 at  8:30am -0400,
> Alasdair G Kergon <agk@redhat.com> wrote:
> 
> > On Fri, Aug 16, 2013 at 03:55:21PM -0700, Frank Mayhar wrote:
> > > This patch fixes that by changing the hardcoded MIN_IOS (and certain
> > > other) #defines in dm-crypt, dm-io, dm-mpath, dm-snap and dm itself to
> > > sysctl-modifiable values.  This lets us change the size of these pools
> > > on the fly, we can reduce the size of the pools and reduce memory
> > > pressure.
> >  
> > Did you consider using module_param_named()?
> > (E.g. dm_verity_prefetch_cluster in dm-verity.)
> 
> Right, I'd prefer to see this be implemented in terms of
> module_param_named().  Aside from dm-verity, dm-bufio.c makes the most
> use of it.

Yeah, I can do that.
-- 
Frank Mayhar
310-460-4042
