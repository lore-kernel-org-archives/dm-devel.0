From: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Subject: Re: [PATCH]dm-mpath: fix for race condition between
 multipath_dtr and pg_init_done.
Date: Thu, 17 Oct 2013 22:03:47 +0000
Message-ID: <FB8A412F33166C4A930D37BD63236C902AD2A12B@SACEXCMBX02-PRD.hq.netapp.com>
References: <FB8A412F33166C4A930D37BD63236C902AD2A073@SACEXCMBX02-PRD.hq.netapp.com>
	<20131017185306.GA29909@redhat.com> <52605B07.5070007@suse.de>
	<20131017211014.GA30993@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131017211014.GA30993@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

> From: Mike Snitzer [mailto:snitzer@redhat.com]
> Sent: Thursday, October 17, 2013 4:10 PM
> To: Hannes Reinecke
> Cc: Merla, ShivaKrishna; dm-devel@redhat.com; agk@redhat.com; Mikulas
> Patocka
> Subject: Re: [PATCH]dm-mpath: fix for race condition between
> multipath_dtr and pg_init_done.
> 
> On Thu, Oct 17 2013 at  5:47pm -0400,
> Hannes Reinecke <hare@suse.de> wrote:
> 
> > On 10/17/2013 08:53 PM, Mike Snitzer wrote:
> > >Thanks for reporting this.  Much appreciated.  More comments below.
> > >
> > >On Thu, Oct 17 2013 at  1:31pm -0400,
> > >Merla, ShivaKrishna <ShivaKrishna.Merla@netapp.com> wrote:
> > >
> > >>Whenever multipath_dtr is happening, we should prevent queueing any
> further path
> > >>activation work. There was a kernel panic where after pg_init_done()
> decrements
> > >>pg_init_in_progress to 0, wait_for_pg_init_completion call assumes
> there are no
> > >>more pending path management commands. But if pg_init_required is
> set by
> > >>pg_init_done call due to retriable mode_select errors , then
> process_queued_ios()
> > >>will again queue the path activation work. If free_multipath call has been
> > >>completed by the time activate_path work is called, kernel panic was
> seen on
> > >>accessing multipath members.
> > >
> > >Your locking looks suspect to me, see comment inlined below
> multipath_dtr
> > >
> > >But shouldn't we just train multipath_wait_for_pg_init_completion() to
> > >look at m->pg_init_required?  Have it wait for both pg_init_required and
> > >pg_init_in_progress to be zero?  We'd also have to audit that
> > >pg_init_required cannot be set while pg_init_in_progress.
> > >
> > Hmm.
> >
> > We _could_ try to resolve it by pushing I/O back onto the request queue
> > (cf my earlier post 'requeue I/O during pg_init').
> >
> > I was hoping to excite some comments with that, but seems to be my
> > fate nowadays to send out patches with no reply.
> 
> patchwork caught it:
> https://patchwork.kernel.org/patch/2969111/
> 
> I've just been distracted with other stuff the past week; but I'll be
> looking closer at this issue (and your earlier patch) shortly and we'll
> get a fix queued for 3.13.
> 
> > Anyway, maybe this will be giving it some more attention.
> > It definitely would avoid this problem, by virtue of not having to
> > queue I/O internally during pg_init, so we could easily tear down
> > the queue.
> 
> Sounds good.

Thanks for your comments.  I agree we should lock while setting dtr_in_progress, I think I overlooked it as its handled in process_queued_ios as well.
We looked into handling this in wait_for_pg_init_completion() but checking for pg_init_required here will not help as well ( until we prevent setting pg_init_required while pg_init_in_progress is set ).
Here due to SCSI_DH_RETRY on mode_select, pg_init_done will set the pg_init_required as activation needs to be retried under normal 
circumstances. But it completely differs when multipath target  is being destroyed.  Apparently I didn't see any pending_ios in our test
while this is happening. Just path activations are held up since controller was returning 5/91/36 CC's. With this condition either one of pg_init_required or pg_init_in_progress flags are set all the time.
Hannes patch will take care of preventing queueing of IO's when pg_init_in_progress is set, but currently running activation commands will not return until controller returns SUCCESS on mode_select.
