From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Sun, 12 Nov 2006 23:43:05 +0100
Message-ID: <200611122343.06625.rjw@sisk.pl>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<20061110103942.GG3196@elf.ucw.cz>
	<20061112223012.GH11034@melbourne.sgi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061112223012.GH11034@melbourne.sgi.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Chinner <dgc@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, Eric Sandeen <sandeen@redhat.com>, Nigel Cunningham <nigel@suspend2.net>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Pavel Machek <pavel@ucw.cz>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Sunday, 12 November 2006 23:30, David Chinner wrote:
> On Fri, Nov 10, 2006 at 11:39:42AM +0100, Pavel Machek wrote:
> > On Fri 2006-11-10 11:57:49, David Chinner wrote:
> > > On Thu, Nov 09, 2006 at 11:21:46PM +0100, Rafael J. Wysocki wrote:
> > > > I think we can add a flag to __create_workqueue() that will indicate if
> > > > this one is to be running with PF_NOFREEZE and a corresponding macro like
> > > > create_freezable_workqueue() to be used wherever we want the worker thread
> > > > to freeze (in which case it should be calling try_to_freeze() somewhere).
> > > > Then, we can teach filesystems to use this macro instead of
> > > > create_workqueue().
> > > 
> > > At what point does the workqueue get frozen? i.e. how does this
> > > guarantee an unfrozen filesystem will end up in a consistent
> > > state?
> > 
> > Snapshot is atomic; workqueue will be unfrozen with everyone else, but
> > as there were no writes in the meantime, there should be no problems.
> 
> That doesn't answer my question - when in the sequence of freezing
> do you propose diasbling the workqueues? before the kernel threads,
> after the kernel threads, before you sync the filesystem?

After the sync, along with the freezing of kernel threads.

> And how does freezing them at that point in time guarantee consistent
> filesystem state?

If the work queues are frozen, there won't be any fs-related activity _after_
we create the suspend image.  The sync is done after the userland has been
frozen, so if the resume is unsuccessful, we'll be able to recover the state
of the fs right before the sync, and if the resume is successful, we'll be
able to continue (the state of memory will be the same as before the creation
of the suspend image and the state of the disk will be the same as before the
creation of the suspend image).

Greetings,
Rafael


-- 
You never change things by fighting the existing reality.
		R. Buckminster Fuller
