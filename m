From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-statistics: report precise timestamps and
	histogram
Date: Wed, 19 Aug 2015 09:03:15 -0400
Message-ID: <20150819130315.GA24798@redhat.com>
References: <alpine.LRH.2.02.1508181618100.19666@file01.intranet.prod.int.rdu2.redhat.com>
	<20150818210727.GA17473@redhat.com>
	<alpine.LRH.2.02.1508190650430.7633@file01.intranet.prod.int.rdu2.redhat.com>
	<20150819111122.GE7891@bmr.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150819111122.GE7891@bmr.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: dm-devel@redhat.com, Bryn Reeves <breeves@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Aug 19 2015 at  7:11am -0400,
Bryn M. Reeves <bmr@redhat.com> wrote:

> On Wed, Aug 19, 2015 at 06:53:41AM -0400, Mikulas Patocka wrote:
> > On Tue, 18 Aug 2015, Mike Snitzer wrote:
> > > On Tue, Aug 18 2015 at  4:26pm -0400,
> > > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > > > Mike, please submit this patch to the upstream kernel before 4.2 is 
> > > > released, so that the all the kernels that support the options 
> > > > "precise_timestamps" and "histogram" also report these values back.
> > > 
> > > Userspace will have to check the DM ioctl version to know if DM provides
> > > these extra keywords.
> > > 
> > > Mike
> > 
> > But if you don't send it, userspace will forever have to deal with kernels 
> > that don't report this feature back.
> 
> We'd either end up saying some kernels can't support it when they can, or
> have to carry some additional userspace clutter forever to provide a 
> workaround.

As much as I'd like to push this in the final hour of 4.2's release I'm
sorry that I cannot.  It is too late given it is _not_ a critical fix.

I've bumped the version to .33 and marked this change for stable, just
have lvm2 check for that version in order to support these features.
Yes, it translates to the Linux 4.2.0 release not being supported but
any stable 4.2-stable release will be.

Mike
