From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm mpath: fix race condition
 between	multipath_dtr and pg_init_done
Date: Tue, 5 Nov 2013 12:12:54 -0500
Message-ID: <20131105171253.GD25528@redhat.com>
References: <FB8A412F33166C4A930D37BD63236C902AD3247A@SACEXCMBX02-PRD.hq.netapp.com>
	<11AF7C027C4C02408624617A49860784EDC174@BPXM12GP.gisp.nec.co.jp>
	<20131031144811.GA15712@redhat.com>
	<20131105155624.GB30366@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131105155624.GB30366@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>, Shiva Krishna Merla <shivakrishna.merla@netapp.com>, device-mapper development <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 05 2013 at 10:56am -0500,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Thu, Oct 31, 2013 at 10:48:13AM -0400, Mike Snitzer wrote:
> > --- linux.orig/drivers/md/dm-mpath.c
> > +++ linux/drivers/md/dm-mpath.c
> 
> > +	unsigned pg_init_disabled:1;	/* pginit is currently not allowed */
> 
> > +	if (m->pg_init_required && !m->pg_init_in_progress && pgpath &&
> > +	    !m->pg_init_disabled)
> 
> So we're accepting that pg_init might be both "disabled" and "required"
> simultaneously (otherwise we wouldn't need this test)?

Yes, needs to be independent of pg_init_required.

> > @@ -942,10 +944,20 @@ static void multipath_wait_for_pg_init_c
> >  static void flush_multipath_work(struct multipath *m)
> >  {
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&m->lock, flags);
> > +	m->pg_init_disabled = 1;
> > +	spin_unlock_irqrestore(&m->lock, flags);
> > +
> >  	flush_workqueue(kmpath_handlerd);
> >  	multipath_wait_for_pg_init_completion(m);
> 
> So this implies pg_init could even still be running while it is disabled?

pg_init_disabled doesn't allow pg_init to be initiated once set (even if
pg_init_required is).  Hence pg_init is disabled.

> If the logic is correct, then I find the new variable name quite confusing and
> think it should be changed, or as a minimum have inline comments explaining
> the apparent contradictions!

I'm not seeing a contradiction.
