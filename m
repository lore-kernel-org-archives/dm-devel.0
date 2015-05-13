From: Mike Snitzer <snitzer@redhat.com>
Subject: linux-next dm-thinp regression due to "bio: skip atomic
 inc/dec of ->bi_remaining for non-chains"
Date: Wed, 13 May 2015 15:28:27 -0400
Message-ID: <20150513192827.GA15831@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk
Cc: dm-devel@redhat.com, hch@lst.de
List-Id: dm-devel.ids

The device-mapper-test-suite (dmts) thinp tests no longer run due to
linux-block.git commit c4cf5261 ("bio: skip atomic inc/dec of
->bi_remaining for non-chains")

That commit has been the focus of some other work I have pending because
I was forced to adapt it due to bi_remaining no longer being accessible
directly.  So it was surprising/interesting for this commit to take
center stage in the context of dm-thinp regression.

bios don't get submitted (simplest reproducer is the 'dd_benchmark' test
in the dmts thin-provisioning suite which just uses dd with oflag=direct
immediately after the DM thin device is created).  The top-level DM
device stays at 100% utilization but no progress is made.  Reverting
the commit in question resolves the problem.

But I'm able to use lvm2 to create thin devices that allow IO to
complete; so I haven't figured out what is so special about dmts (which
uses dmsetup directly instead of lvm2).

I'll see if I can figure out what might be happening... but would
welcome more eyes on this to see if anything stands out relative to the
dm-thin.c changes.
