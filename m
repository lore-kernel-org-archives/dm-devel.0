From: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Subject: Re: [PATCH][RESEND]dm-mpath: fix for race condition
 between multipath_dtr and pg_init_done.
Date: Thu, 31 Oct 2013 14:29:35 +0000
Message-ID: <FB8A412F33166C4A930D37BD63236C902AD327E5@SACEXCMBX02-PRD.hq.netapp.com>
References: <FB8A412F33166C4A930D37BD63236C902AD3247A@SACEXCMBX02-PRD.hq.netapp.com>
	<11AF7C027C4C02408624617A49860784EDC174@BPXM12GP.gisp.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11AF7C027C4C02408624617A49860784EDC174@BPXM12GP.gisp.nec.co.jp>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids



> -----Original Message-----
> From: Junichi Nomura [mailto:j-nomura@ce.jp.nec.com]
> Sent: Thursday, October 31, 2013 4:04 AM
> To: device-mapper development; Merla, ShivaKrishna
> Cc: agk@redhat.com; snitzer@redhat.com
> Subject: Re: [dm-devel] [PATCH][RESEND]dm-mpath: fix for race condition
> between multipath_dtr and pg_init_done.
> 
> On 10/30/13 12:26, Merla, ShivaKrishna wrote:
> > Whenever multipath_dtr is happening, we should prevent queueing any
> further path
> > activation work. There was a kernel panic where after pg_init_done()
> decrements
> > pg_init_in_progress to 0, wait_for_pg_init_completion call assumes there
> are no
> > more pending path management commands. But if pg_init_required is set
> by
> > pg_init_done call due to retriable mode_select errors , then
> process_queued_ios()
> > will again queue the path activation work. If free_multipath call has been
> > completed by the time activate_path work is called, kernel panic was seen
> on
> > accessing multipath members.
> >
> > BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000090
> > RIP: 0010:[<ffffffffa003db1b>]  [<ffffffffa003db1b>]
> activate_path+0x1b/0x30 [dm_multipath]
> > [<ffffffff81090ac0>] worker_thread+0x170/0x2a0
> > [<ffffffff81096c80>] ? autoremove_wake_function+0x0/0x40
> >
> > Signed-off-by: Shiva Krishna Merla<shivakrishna.merla@netapp.com>
> > Reviewed-by: Krishnasamy
> Somasundaram<somasundaram.krishnasamy@netapp.com>
> > Tested-by: Speagle Andy<Andy.Speagle@netapp.com>
> >
> > ---
> > --- a/drivers/md/dm-mpath.c	2013-01-29 10:12:10.000000000 -0600
> > +++ b/drivers/md/dm-mpath.c	2013-10-29 21:02:03.267685017 -0500
> > @@ -73,6 +73,7 @@ struct multipath {
> >
> >  	wait_queue_head_t pg_init_wait;	/* Wait for pg_init
> completion */
> >
> > +	unsigned dtr_in_progress;	/* multipath destroy in progress */
> >  	unsigned pg_init_required;	/* pg_init needs calling? */
> >  	unsigned pg_init_in_progress;	/* Only one pg_init allowed at once
> */
> >  	unsigned pg_init_delay_retry;	/* Delay pg_init retry? */
> > @@ -498,7 +499,8 @@ static void process_queued_ios(struct wo
> >  	    (!pgpath && !m->queue_if_no_path))
> >  		must_queue = 0;
> >
> > -	if (m->pg_init_required && !m->pg_init_in_progress && pgpath)
> > +	if (m->pg_init_required && !m->pg_init_in_progress && pgpath &&
> > +	    !m->dtr_in_progress)
> >  		__pg_init_all_paths(m);
> >
> >  	spin_unlock_irqrestore(&m->lock, flags);
> > @@ -951,6 +953,11 @@ static void flush_multipath_work(struct
> >  static void multipath_dtr(struct dm_target *ti)
> >  {
> >  	struct multipath *m = ti->private;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&m->lock, flags);
> > +	m->dtr_in_progress = 1;
> > +	spin_unlock_irqrestore(&m->lock, flags);
> 
> Hi,
> 
> how about moving this to flush_multipath_work(), which is supposed
> to silence background activities?
> I.e.
>   flush_multipath_work() {
>      <disable pg_init retry>
>      ...
>      <enable pg_init retry>
>   }
> 
> Then it not only fixes the crash you hit, it also fixes the hidden bug
> that pg_init continues retrying while the device is suspended.
We looked into adding checks for pg_init_required as well in
multipath_wait_for_pg_init_completion(), but none of these will prevent
pg_init_limit_reached() i.e from pg_init_done() from setting pg_init_required.
From code I see we end up waiting indefinitely for its completion. The reason 
for adding check in process_queued_ios() is __choose_pgpath() might again
trigger pg_init_required and end up calling __pg_init_all_paths() which will unset
pg_init_required and sets pg_init_in_progress within a lock. Also I believe the
patch given above will prevent further path activations and no work will be queued
again with dtr_in_progress. With Hannes patch IO's will not be queued in when
pg_init_in_progress so we are clean there as well.  Let me know your thoughts.
