From: Zach Brown <zab@redhat.com>
Subject: Re: [RFC][PATCH] dm: add dm-power-fail target
Date: Mon, 24 Nov 2014 10:45:35 -0800
Message-ID: <20141124184534.GA24398@lenny.home.zabbo.net>
References: <1416607231-8588-1-git-send-email-jbacik@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1416607231-8588-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, david@fromorbit.com, sandeen@redhat.com, clm@facebook.com, dm-devel@redhat.com, hch@infradead.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu
List-Id: dm-devel.ids

On Fri, Nov 21, 2014 at 05:00:31PM -0500, Josef Bacik wrote:
> Hello,
> 
> I'm hoping some FS guys can weigh in and verify my approach for testing power
> fail conditions, and the DM guys to of course verify I didn't completely fail at
> making a DM target.  All suggestions welcome, I want to have a nice robust tool
> for testing power fail so we can be sure our fsync/commit code is all working
> properly.  Thanks,

*All* suggestions welcome?  OK, I'll put on my skeptic hat.

This implements a writeback cache in kernel data structures so that you
can race to throw away cached blocks that haven't been flushed.  How is
that meaningfully different than using an actual writeback caching dm
target and racing to invalidate it?

Using real caching dm target configurations would let you reuse their
testing and corner case handling that is, presumably, already slightly
more advanced than printk() swearing.

Implementation of this specific mechanism aside, the architectural
observation is that device ram disappearing during a power interruption
is just one, and possibly the most forgiving, outcome.  Pulling the
power out from under concurrnet cached writes can result in any
combination of them being written, or not, or scrambled to the point of
returning read errors.

If we were to justify developing a specific power failure target, I'd
like to see something that tracks write history and can replay the
history to offer a resonably exhaustive set of possible write results.
Verify *those* and you have much more confidence that the file system
can handle reading the results of its interrupted writes.

- z 
