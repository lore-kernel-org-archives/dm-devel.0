From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH] dm-log-writes: invalidate the bdev's for both of our
 devices
Date: Tue, 28 Nov 2017 16:05:55 -0500
Message-ID: <20171128210554.hyqw27egx5kjsv3q@destiny>
References: <1511890225-16601-1-git-send-email-josef@toxicpanda.com>
 <CAOQ4uxi2fqO4-gQVtRmQ6QP0VqXFVMpbYSdh-mrKuivWiOwECQ@mail.gmail.com>
 <CAOQ4uxjpYPEALg1wHcgjP3Q=vQR6oBmnAsrrvkHtj1HznfCRSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjpYPEALg1wHcgjP3Q=vQR6oBmnAsrrvkHtj1HznfCRSQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>
List-Id: dm-devel.ids

On Tue, Nov 28, 2017 at 10:40:24PM +0200, Amir Goldstein wrote:
> On Tue, Nov 28, 2017 at 9:29 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Tue, Nov 28, 2017 at 7:30 PM, Josef Bacik <josef@toxicpanda.com> wrote:
> >> From: Josef Bacik <jbacik@fb.com>
> >>
> >> Amir noticed that sometimes the xfstests using dm-log-writes would fail
> >> randomly but would work fine after trying again manually.  This is
> >> because dm-log-writes writes directly to the device, but the log replay
> >> tools read and write via the block device page cache.  Sometimes this
> >> resulted in stale data being in the block device's page cache which
> >> would result in random failures.  To handle this simply invalidate the
> >> block device page cache on destruction so any replay of the log device
> >> that follows will be forced to read the new real contents.
> >>
> >> Reported-and-tested-by: Amir Goldstein <amir73il@gmail.com>
> >
> > I'm fine with the Reported-by, but let's wait a while with this patch so
> > I have more time to torture it.
> > The incidents I got even before the patch did not happen more than
> > a handful of times after running for a few days, so I need some more
> > days to validate the fix.
> > I had already sent you some weird output. Let's see what else comes
> > along.
> >
> 
> Sorry, no cigar.
> Another run just completed with Malformed log and corrupted fs
> 
> The _check_scratch_fs that fails is the one right after _log_writes_remove
> just like the report that I sent before this patch
> and the LOGWRITES_DEV itself has malformed entry before the "end" mark
> or even the last fsync mark:
> 
> ./src/log-writes/replay-log -v --log $LOGWRITES_DEV --find --end-mark
> testfile1.mark17
> Malformed entry @112134
> 
> For what its worth, I am testing on spinning disks, 100G scratch dev.
> Right now, I zoomed in on the following fsx seeds that managed to fail the test
> a few times already, but in different ways, so I'm not sure the seeds are more
> than voodoo:
> seeds=(4597 4598 4599 4600)
> 
> I'll start running the same test but with fsx running on test partition, just
> to get the feel for running the same fsx threads on bare xfs.
> 
> Any other ideas?
> 

Is there anything special about your devices?  Are they 4k drives?  The corrupt
log is not awesome, was it still corrupt after the test bailed out?  Thanks,

Josef
