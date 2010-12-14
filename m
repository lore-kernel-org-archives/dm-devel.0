From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCHSET] dm: update workqueue usages
Date: Tue, 14 Dec 2010 13:19:31 +0100
Message-ID: <1292329171.30045.2.camel@o>
References: <1292181055-25696-1-git-send-email-tj@kernel.org>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1292181055-25696-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: tj@kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

On Sun, 2010-12-12 at 20:10 +0100, Tejun Heo wrote:
> Hello,

Hi Tejun,

what's the rational behind dropping create_singlethread_workqueue() in
favor of alloc_ordered_workqueue(...WQ_MEM_RECLAIM..) which are
semantically identical?

Heinz

> 
> This patchset updates workqueue usages in dm and contains the
> following six patches.
> 
>  0001-dm-stripe-drop-kstriped.patch
>  0002-dm-snap-kill-unused-dm_snapshot-queued_bios_work-and.patch
>  0003-dm-snap-convert-to-alloc-_ordered-_workqueue.patch
>  0004-dm-don-t-use-flush_scheduled_work.patch
>  0005-dm-use-non-reentrant-workqueues-if-equivalent.patch
>  0006-dm-snap-persistent-make-metadata_wq-multithreaded.patch
> 
> 0001-0002 drop unnecessary workqueues.  0003-0004 conver to the new
> APIs.  0005-0006 relax ordering requirement of some workqueues.
> 
> All patches in this series shouldn't introduce any noticeable
> difference in work execution ordering.  I stayed away from more
> difficult ones like...
> 
> * Can the workqueues converted by 0005 be multithreaded instead of
>   non-reentrant?
> 
> * Does dm-mpath::kmpath_handlerd need WQ_RESCUER?  I suspect not but
>   not sure.  If not, it can be dropped and system_wq or kmultipathd
>   can be used instead.  Another curious thing here is that while
>   activate_path work is queued to kmpath_handlerd, deactivate_path is
>   queued to kmultipathd.  Is this intentional?  If so, it might be a
>   good idea to comment why it's done that way as it's a bit confusing.
> 
> * I'm pretty sure workqueues in dm-crypt would benefit from using
>   multithreaded workqueue but people already seem to be working on it
>   so I left it alone.
> 
> This patchset is on top of 2.6.37-rc5 (6313e3c2).  If it needs to be
> against a different tree, please let me know.  The patches are also
> available in the following git tree.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git update-dm
> 
> and contains the following changes.  Thanks.
> 
>  drivers/md/dm-crypt.c           |    4 ++--
>  drivers/md/dm-delay.c           |    2 +-
>  drivers/md/dm-kcopyd.c          |    3 ++-
>  drivers/md/dm-mpath.c           |    7 ++++---
>  drivers/md/dm-raid1.c           |    5 +++--
>  drivers/md/dm-snap-persistent.c |    4 ++--
>  drivers/md/dm-snap.c            |   38 --------------------------------------
>  drivers/md/dm-stripe.c          |   25 ++++++-------------------
>  drivers/md/dm.c                 |    3 ++-
>  9 files changed, 22 insertions(+), 69 deletions(-)
> 
> --
> tejun
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
