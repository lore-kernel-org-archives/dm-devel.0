From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/3] offload bios to a thread
Date: Wed, 6 Jul 2016 09:55:13 -0400
Message-ID: <20160706135513.GB28547@redhat.com>
References: <alpine.LRH.2.02.1607041846020.16388@file01.intranet.prod.int.rdu2.redhat.com>
	<20160706133656.GA28547@redhat.com>
	<alpine.LRH.2.02.1607060946530.27982@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1607060946530.27982@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Wed, Jul 06 2016 at  9:53am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Wed, 6 Jul 2016, Mike Snitzer wrote:
> 
> > On Mon, Jul 04 2016 at  6:53pm -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > Hi
> > > 
> > > This is the second version of patches that fix deadlocks by redirecting 
> > > bios from current->bio_list to rescuer workqueues.
> > > 
> > > I found out that the original patches caused deadlock with the loopback 
> > > device. When the loopback device is used, both lower and upper filesystems 
> > > use the same bio set - fs_bio_set. Consequently, bios submitted by both of 
> > > them end up on the same rescuer workqueue. There is a deadlock possibility 
> > > - if generic_make_request for the upper filesystem's bio blocks (because 
> > > there are too many requests in flight on the loop device), it may stall 
> > > processing some bios for the lower filesystem.
> > > 
> > > Ideadlly, each filesystem should have its own bio set. But it doesn't. So 
> > > I fix this problem by not offloading bios allocated from fs_bio_set.
> > 
> > I'd much preferred you just send an incremental fix that built on the
> > tree you know I started, here:
> > http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip
> 
> You need to change three patches in your git:
> * block: flush queued bios when process blocks to avoid deadlock
> * block: prepare for timed offload of queued bios to workqueue
> * block: use timed offload of queued bios to a workqueue
> because this bug is present in all of them.
> 
> When these patches are sent to Linus, the bug should not be present in any 
> of them.

Yes, I'm aware.  Please review:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip
