From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH]dm-mpath: fix for race condition between
 multipath_dtr and pg_init_done.
Date: Thu, 17 Oct 2013 17:10:16 -0400
Message-ID: <20131017211014.GA30993@redhat.com>
References: <FB8A412F33166C4A930D37BD63236C902AD2A073@SACEXCMBX02-PRD.hq.netapp.com>
	<20131017185306.GA29909@redhat.com> <52605B07.5070007@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <52605B07.5070007@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "Merla,
	ShivaKrishna" <ShivaKrishna.Merla@netapp.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Oct 17 2013 at  5:47pm -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 10/17/2013 08:53 PM, Mike Snitzer wrote:
> >Thanks for reporting this.  Much appreciated.  More comments below.
> >
> >On Thu, Oct 17 2013 at  1:31pm -0400,
> >Merla, ShivaKrishna <ShivaKrishna.Merla@netapp.com> wrote:
> >
> >>Whenever multipath_dtr is happening, we should prevent queueing any further path
> >>activation work. There was a kernel panic where after pg_init_done() decrements
> >>pg_init_in_progress to 0, wait_for_pg_init_completion call assumes there are no
> >>more pending path management commands. But if pg_init_required is set by
> >>pg_init_done call due to retriable mode_select errors , then process_queued_ios()
> >>will again queue the path activation work. If free_multipath call has been
> >>completed by the time activate_path work is called, kernel panic was seen on
> >>accessing multipath members.
> >
> >Your locking looks suspect to me, see comment inlined below multipath_dtr
> >
> >But shouldn't we just train multipath_wait_for_pg_init_completion() to
> >look at m->pg_init_required?  Have it wait for both pg_init_required and
> >pg_init_in_progress to be zero?  We'd also have to audit that
> >pg_init_required cannot be set while pg_init_in_progress.
> >
> Hmm.
> 
> We _could_ try to resolve it by pushing I/O back onto the request queue
> (cf my earlier post 'requeue I/O during pg_init').
> 
> I was hoping to excite some comments with that, but seems to be my
> fate nowadays to send out patches with no reply.

patchwork caught it:
https://patchwork.kernel.org/patch/2969111/

I've just been distracted with other stuff the past week; but I'll be
looking closer at this issue (and your earlier patch) shortly and we'll
get a fix queued for 3.13.
 
> Anyway, maybe this will be giving it some more attention.
> It definitely would avoid this problem, by virtue of not having to
> queue I/O internally during pg_init, so we could easily tear down
> the queue.

Sounds good.
