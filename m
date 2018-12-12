From: Mike Snitzer <snitzer@redhat.com>
Subject: xfstests generic/347 was never correct [was: Re: dm: fix
 inflight IO check]
Date: Tue, 11 Dec 2018 21:34:24 -0500
Message-ID: <20181212023424.GA21119@redhat.com>
References: <4fec4b01-35f9-8008-22ec-2ac8af58b854@kernel.dk>
	<20181211003204.GA14673@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181211003204.GA14673@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>, sandeen@redhat.com, fstests@vger.kernel.org
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Mon, Dec 10 2018 at  7:32pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Dec 10 2018 at  5:45pm -0500,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
> > After switching to percpu inflight counters, the inflight check
> > is totally buggy. It's perfectly valid for some counters to be
> > non-zero while having a total inflight IO count of 0, that's how
> > these kinds of counters work (inc on one CPU, dec on another).
> > Fix the md_in_flight() check to sum all counters before returning
> > a false positive, potentially.
> > 
> > While at it, remove the inflight read for IO completion. We don't
> > need it, just wake anyone that's waiting for the IO count to drop
> > to zero. The caller needs to re-check that value anyway when woken,
> > which it does.
> > 
> > Fixes: 6f75723190d8 ("dm: remove the pending IO accounting")
> > Reported-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> I'm seeing that device-mapper-test-suite's "resize_io" test doesn't
> pass.  Glad this resolves the xfstest issue but I think more work is
> needed, so I'll build any additional changes on this fix.

Turns out the device-mapper-test-suite 'resize_io' issue I was seeing is
just a long lingering race that just got much more likely on my newer
testbed.  This fixes what I was seeing:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.20&id=f6c367585d0d851349d3a9e607c43e5bea993fa1

But pivoting back to xfstests generic/347: that test was broken from the
start, if it ever _really_ worked it would've been a bug in dm-thinp.
And even after Jens' fix (above) the test still just times out after 60
secs while in out-of-data-space (OODS) mode and gives a false "Passed
all 1 tests".

generic/347 exhausting the thin-pool's data space and then issuing
"sync" will cause IO to hang for 60 secs unless, in parallel, another
process comes along and grows the thin-pool to have more data space.
But even if xfstests' _dmthin_grow function were to be issued in 
parallel with another process it'll fail because it uses
_dmthin_reload_table which "dmsetup suspend"s the thin device (that was
just used by XFS to fill the thin-pool) _without_ using the --noflush
flag for "dmsetup suspend".  So the thin device will wait forever for
its  outstanding IO to finish before generic/347's _dmthin_grow will be
able to resize the thin-pool.  Leading to deadlock.  Or until the 60
secs (dm_thin_pool.ko "no_space_timeout" modparam default) causes the
thin-pool to switch from OODS "queue IO" to OODS "error IO" mode:

# tail -f /var/log/messages &
# ./check generic/347
Dec 11 21:12:57 thegoat kernel: XFS (dm-1): Mounting V5 Filesystem
Dec 11 21:12:57 thegoat kernel: XFS (dm-1): Ending clean mount
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 thegoat 4.20.0-rc6.snitm+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/mapper/test-metadata
MOUNT_OPTIONS -- /dev/mapper/test-metadata /scratch

Dec 11 21:12:58 thegoat kernel: device-mapper: thin: 253:4: reached low water mark for data device: sending event.
Dec 11 21:12:58 thegoat kernel: device-mapper: thin: 253:4: switching pool to out-of-data-space (queue IO) mode
Dec 11 21:14:01 thegoat kernel: device-mapper: thin: 253:4: switching pool to out-of-data-space (error IO) mode
Dec 11 21:14:01 thegoat kernel: xfs_destroy_ioend: 136 callbacks suppressed
Dec 11 21:14:01 thegoat kernel: XFS (dm-5): writeback error on sector 1354752
Dec 11 21:14:01 thegoat kernel: XFS (dm-5): writeback error on sector 1358592
Dec 11 21:14:01 thegoat kernel: XFS (dm-5): writeback error on sector 1362432
Dec 11 21:14:01 thegoat kernel: XFS (dm-5): writeback error on sector 1366272
Dec 11 21:14:01 thegoat kernel: XFS (dm-5): writeback error on sector 1370112
Dec 11 21:14:01 thegoat kernel: XFS (dm-5): writeback error on sector 1373952
Dec 11 21:14:01 thegoat kernel: XFS (dm-5): writeback error on sector 1377792
Dec 11 21:14:01 thegoat kernel: XFS (dm-5): writeback error on sector 1381632
Dec 11 21:14:01 thegoat kernel: XFS (dm-5): writeback error on sector 1385472
Dec 11 21:14:01 thegoat kernel: XFS (dm-5): writeback error on sector 1389312
Dec 11 21:14:02 thegoat kernel: device-mapper: thin: 253:4: switching pool to write mode
Dec 11 21:14:02 thegoat kernel: device-mapper: thin: 253:4: growing the data device from 1000 to 1200 blocks
Dec 11 21:14:02 thegoat kernel: device-mapper: thin: 253:4: reached low water mark for data device: sending event.
Dec 11 21:14:02 thegoat kernel: XFS (dm-5): Unmounting Filesystem
 65s
Ran: generic/347
Passed all 1 tests

Dec 11 21:14:02 thegoat kernel: XFS (dm-1): Unmounting Filesystem

SO generic/347 needs to account for 2 things:
1) issue $XFS_IO_PROG IO in the background with other process(es)
2) in parallel, in main generic/347 shell, run _dmthin_grow but the
"thin" device must be suspended with dmsetup suspend --noflush

Eric Sandeen: can you or someone else xfstests inclined use this info to
fix generic/347 please?

Thanks,
Mike
