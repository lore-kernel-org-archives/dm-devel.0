From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH v2] dm mpath: add a queue_if_no_path
	timeout
Date: Tue, 29 Oct 2013 21:02:46 -0400
Message-ID: <20131030010246.GA3611@redhat.com>
References: <20130926173814.GB31328@agk-dp.fab.redhat.com>
	<1380217633.25252.46.camel@bobble.lax.corp.google.com>
	<20130926232241.GC31328@agk-dp.fab.redhat.com>
	<20130926234957.GA3658@redhat.com>
	<1382036590.1980.32.camel@bobble.lax.corp.google.com>
	<20131017191511.GA30452@redhat.com>
	<1382042759.1980.40.camel@bobble.lax.corp.google.com>
	<20131017211338.GB30993@redhat.com>
	<1382129515.1980.46.camel@bobble.lax.corp.google.com>
	<20131018225350.GB7553@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131018225350.GB7553@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Mayhar <fmayhar@google.com>
Cc: dm-devel <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 18 2013 at  6:53pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Oct 18 2013 at  4:51pm -0400,
> Frank Mayhar <fmayhar@google.com> wrote:
> 
> > On Thu, 2013-10-17 at 17:13 -0400, Mike Snitzer wrote:
> > > Cannot say that argument wins me over but I will say that if you intend
> > > to take the approach to have the kernel have a timeout; please pursue
> > > the approach Hannes offered:
> > > 
> > > https://patchwork.kernel.org/patch/2953231/
> > > 
> > > It is much cleaner and if it works for your needs we can see about
> > > getting a tested version upstream.
> > 
> > Unfortunately his patch doesn't work as-is; it turns out that it tries
> > to set the timeout only if the target is request-based but at the time
> > he tries to set it the table type hasn't yet been set.
> > 
> > I'm looking into fixing it.
> 
> Ouch, yeah, can't access the DM device's queue from .ctr()
> There were other issues with Hannes RFC patch, wouldn't compile.
> 
> Anyway, looks like we need a new target_type hook (e.g. .init_queue)
> that is called from dm_init_request_based_queue().
> 
> Request-based DM only allows a single DM target per device so we don't
> need the usual multi DM-target iterators.
> 
> But, unfortunately, at the time we call dm_init_request_based_queue()
> the mapped_device isn't yet connected to the inactive table that is
> being loaded (but the table is connected to the mapped_device).
> 
> In dm-ioctl.c:table_load(), the inactive table could be passed directly
> into dm_setup_md_queue().
> 
> Please give the following revised patch a try, if it works we can clean
> it up further (think multipath_status needs updating, we also may want
> to constrain .init_queue to only being called if the target is a
> singleton, which dm-mpath should be, but isn't flagged as such yet).
> 
> It compiles, but I haven't tested it...

Frank,

Any interest in this or should I just table it for >= v3.14?
