From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH]dm-mpath: fix for race condition between
 multipath_dtr and pg_init_done.
Date: Thu, 17 Oct 2013 23:47:51 +0200
Message-ID: <52605B07.5070007@suse.de>
References: <FB8A412F33166C4A930D37BD63236C902AD2A073@SACEXCMBX02-PRD.hq.netapp.com>
	<20131017185306.GA29909@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131017185306.GA29909@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On 10/17/2013 08:53 PM, Mike Snitzer wrote:
> Thanks for reporting this.  Much appreciated.  More comments below.
>
> On Thu, Oct 17 2013 at  1:31pm -0400,
> Merla, ShivaKrishna <ShivaKrishna.Merla@netapp.com> wrote:
>
>> Whenever multipath_dtr is happening, we should prevent queueing any furt=
her path
>> activation work. There was a kernel panic where after pg_init_done() dec=
rements
>> pg_init_in_progress to 0, wait_for_pg_init_completion call assumes there=
 are no
>> more pending path management commands. But if pg_init_required is set by
>> pg_init_done call due to retriable mode_select errors , then process_que=
ued_ios()
>> will again queue the path activation work. If free_multipath call has be=
en
>> completed by the time activate_path work is called, kernel panic was see=
n on
>> accessing multipath members.
>
> Your locking looks suspect to me, see comment inlined below multipath_dtr
>
> But shouldn't we just train multipath_wait_for_pg_init_completion() to
> look at m->pg_init_required?  Have it wait for both pg_init_required and
> pg_init_in_progress to be zero?  We'd also have to audit that
> pg_init_required cannot be set while pg_init_in_progress.
>
Hmm.

We _could_ try to resolve it by pushing I/O back onto the request queue
(cf my earlier post 'requeue I/O during pg_init').

I was hoping to excite some comments with that, but seems to be my fate =

nowadays to send out patches with no reply.

Anyway, maybe this will be giving it some more attention.
It definitely would avoid this problem, by virtue of not having to queue =

I/O internally during pg_init, so we could easily tear down the queue.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
