From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH v3] dm mpath: add a queue_if_no_path
	timeout
Date: Tue, 5 Nov 2013 11:53:26 -0500
Message-ID: <20131105165326.GB25528@redhat.com>
References: <20131030010246.GA3611@redhat.com>
	<1383145687.6677.49.camel@bobble.lax.corp.google.com>
	<20131030154259.GA8206@redhat.com>
	<1383156565.17572.8.camel@bobble.lax.corp.google.com>
	<11AF7C027C4C02408624617A49860784EDC2C1@BPXM12GP.gisp.nec.co.jp>
	<1383229011.17572.12.camel@bobble.lax.corp.google.com>
	<11AF7C027C4C02408624617A49860784EE0B3F@BPXM12GP.gisp.nec.co.jp>
	<11AF7C027C4C02408624617A49860784EE0F5E@BPXM12GP.gisp.nec.co.jp>
	<1383664708.4504.4.camel@bobble.lax.corp.google.com>
	<1383667332.4504.8.camel@bobble.lax.corp.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1383667332.4504.8.camel@bobble.lax.corp.google.com>
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
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 05 2013 at 11:02am -0500,
Frank Mayhar <fmayhar@google.com> wrote:

> This is the patch submitted by Jun'ichi Nomura, originally based on
> Mike's patch with some small changes by me.  Jun'ichi's description
> follows, along with my changes:
> 
> On Tue, 2013-11-05 at 07:18 -0800, Frank Mayhar wrote:
> > On Fri, 2013-11-01 at 04:17 +0000, Junichi Nomura wrote:
> > > I slightly modified the patch:
> > >   - fixed the timeout handler to correctly find
> > >     clone request and "struct multipath"
> > >   - the timeout handler just disables "queue_if_no_path"
> > >     instead of killing the request directly
> > >   - "dmsetup status" to show the parameter
> > >   - changed an interface between dm core and target
> > >   - added some debugging printk (you can remove them)
> > > and checked the timeout occurs, at least.
> > > 
> > > I'm not sure if this feature is good or not though.
> > > (The timer behavior is not intuitive, I think)
> > Thanks!  I integrated your new patch and tested it.  Sure enough, it
> > seems to work.  I've made a few tweaks (added a module tunable and
> > support for setting the timer in multipath_message(), removed your debug
> > printks) and will submit the modified patch for discussion shortly.
> 
> Comments?

My primary concern is that this patch is always establishing a timed_out
method via blk_queue_rq_timed_out() regardless of whether the mpath
device needs it.  I'm also not a fan of adding such a specialized
rq-based only hook (dm_rq_timed_out_fn timed_out).

Could be we'll need to do other things to the queue (be it bio-based or
rq-based) in the future.

So I prefer the approach I took to arming the queue (via new .init_queue
hook) in this patch: https://patchwork.kernel.org/patch/3070391/
