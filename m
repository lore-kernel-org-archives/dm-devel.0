From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: use noio when sending kobject event
Date: Fri, 10 Jul 2020 14:22:12 -0400
Message-ID: <20200710182211.GA20272@redhat.com>
References: <alpine.LRH.2.02.2007081222500.4103@file01.intranet.prod.int.rdu2.redhat.com>
	<873661g8wq.fsf@collabora.com> <20200708173356.GA8116@redhat.com>
	<87v9ixer30.fsf@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87v9ixer30.fsf@collabora.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Khazhismel Kumykov <khazhy@google.com>
List-Id: dm-devel.ids

On Wed, Jul 08 2020 at  3:37pm -0400,
Gabriel Krisman Bertazi <krisman@collabora.com> wrote:

> Mike Snitzer <snitzer@redhat.com> writes:
> 
> > On Wed, Jul 08 2020 at  2:26pm -0400,
> > Gabriel Krisman Bertazi <krisman@collabora.com> wrote:
> >
> >> If I understand it correctly, considering the deadlock you shared, this
> >> doesn't solve the entire issue. For instance, kobject_uevent_env on the
> >> GFP_NOIO thread waits on uevent_sock_mutex, and another thread with
> >> GFP_IO holding the mutex might have triggered the shrinker from inside
> >> kobject_uevent_net_broadcast.  I believe 7e7cd796f277 ("scsi: iscsi: Fix
> >> deadlock on recovery path during GFP_IO reclaim") solved the one you
> >> shared and other similar cases for iSCSI in a different way.
> >
> > I staged a different fix, from Mikulas, for 5.9 that is meant to address
> > the original report, please see:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.9&id=e5bfe9baf23dca211f4b794b651e871032c427ec
> >
> > I'd appreciate it if you could try this commit to se if it fixes the
> > original issue you reported.
> 
> I reverted 7e7cd796f277 and cherry-picked e5bfe9baf23dc on my tree.
> After a few iterations, I could see the conditions that formerly
> triggered the deadlock happening, but this patch successfully allowed
> the reclaim to succeed and the iscsi recovery thread to run.
> 
> My reproducer is a bit artificial, as I wrote it only from only the
> problem description provided by google.  They were hitting this in
> production and might have a better final word on the fix, though I know
> they don't have a simple way to reproduce it.

Nice job on getting together a reproducer that even begins to model
the issue google's production setup teased out.

Thanks for testing, I've added your Tested-by to the commit.

Mike
