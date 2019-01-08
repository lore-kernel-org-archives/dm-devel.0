From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 1/1] dm: add dust target
Date: Tue, 8 Jan 2019 15:29:20 -0500
Message-ID: <20190108202920.GA22316@redhat.com>
References: <1546889483-6341-1-git-send-email-bgurney@redhat.com>
	<1546889483-6341-2-git-send-email-bgurney@redhat.com>
	<20190108001049.GM11315@octiron.msp.redhat.com>
	<CAHhmqcSLxihW3L+w=MZ22Z9pbU13MLD7Bn6YQey-u1soFp-KJw@mail.gmail.com>
	<20190108162314.GA16936@redhat.com>
	<CAHhmqcTfKniu1eP+fBwHf4gohOfUaz_cgaC3EUezNauUAk6O-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHhmqcTfKniu1eP+fBwHf4gohOfUaz_cgaC3EUezNauUAk6O-Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bryan Gurney <bgurney@redhat.com>
Cc: John Dorminy <jdorminy@redhat.com>, Joe Shimkus <jshimkus@redhat.com>, dm-devel@redhat.com, tjaskiew@redhat.com, John Pittman <jpittman@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Jan 08 2019 at  2:52pm -0500,
Bryan Gurney <bgurney@redhat.com> wrote:

> On Tue, Jan 8, 2019 at 11:23 AM Mike Snitzer <snitzer@redhat.com> wrote:
> >
> > I'm fine with it as is, but I have a different concern: why does this
> > target need to override the queue_limits at all?  What is the benefit to
> > rigidly imposing the provided 512 or 4096 bytes for all of
> > {logical_block,physical_block,minimum_io,optimal_io}_size?
> >
> 
> This is a bit of a complex question, which may cover multiple areas.
> I unfortunately don't have as much expertise in the "backend" of the
> original test target code at the heart of dm-dust; I'm still learning
> it as I go.
> 
> On the "frontend": The "bad block list" has a "grain size" of the
> block size of the device (therefore, "block 1" of a 4096-byte block
> device starts at byte offset 4096, while "block 1" of a 512-byte block
> device starts at byte offset 512.)
> 
> There is definitely value in dm-dust emulating a 4K native device, as
> it will help to reproduce bugs.  In the absence of a real device that
> is 4K native, it can be created on top of a 512-byte logical block
> size device to create a "512-byte write detector", of sorts.
> 
> (An early version of dm-dust was actually a reproducer for the commit
> "isofs: reject hardware sector size > 2048 bytes".)
> 
> > If the underlying device is a 4K native device it simply cannot handle
> > 512b IO.  At a minimum you need to verify that the underlying device can
> > even handle 512b IO.
> >
> 
> This specific case is a bug, and I want to fix it.  (During earlier
> testing, I was wondering why it was possible to set up a 512-byte
> dm-dust device on top of a 4K native device.)
> 
> I need to add a check in the "dmsetup create" process, to verify if
> the underlying device's logical_block_size is small enough to handle
> the minimum I/O size.

Would prefer to see this target accept any "block size" and _not_ use
that size for the queue_limits.  Quite a few DM targets provide such
arbitrary addressing (e.g. dm-stripe, dm-thin, dm-cache).

You'd then just verify that the user provided "block size" isn't smaller
than logical_block_size.

Any novelty of allowing the user to specify 512b vs 4K for the block
size could easily be provided by something basic like scsi_debug as the
underlying device.

Mike
