From: Chris Lais <chris+linux@zenthought.org>
Subject: dm-crypt on RAID5/6 write performance - cause & proposed
	solutions
Date: Wed, 11 May 2011 14:11:00 -0500
Message-ID: <BANLkTin82MipJ1t3uExAHkgVP_09Q7+eWQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I've recently installed a system with dm-crypt placed over a software
RAID5 array, and have noticed some very severe issues with write
performance due to the way dm-crypt works.

Almost all of these problems are caused by dm-crypt re-ordering bios
to an extreme degree (as shown by blktrace), such that it is very hard
for the raid layer to merge them in to full stripes, leading to many
extra reads and writes.  There are minor problems with losing
io_context and seeking for CFQ, but they have far less impact.

I've worked around the reordering locally by increasing the size of
the various queues to very nearly their maximum, and preferring to
write full stripes before partial ones by such an extreme amount that
partial stripe writes can take up to ~30 seconds to complete.  Some
partial writes still get through where there should be none.

This is sub-optimal for the intended use of the machine (an
interactive workstation), and I'd like to open some discussion on
possible solutions.

Increasing the queue sizes and preferring full stripe writes has
increased sequential write performance roughly 6-fold, so this is a
MAJOR issue with this configuration (dm-crypt on top of RAID5/6).

Using RAID5/6 without dm-crypt does /not/ have these problems in my
setup, even with standard queue sizes, because the raid layer can
handle the stripe merging when the bios are not so far out of order.
Using lower RAID levels even with dm-crypt also does not have these
problems to such an extreme degree, because they don't need
read-parity-write cycles for partial stripes.

Solution #1 -
Don't re-order bios in dm-crypt.
This would also have the side effect of making barriers work again,
but would probably require a very large sorted queue on the kcryptd_io
thread, would introduce some latency, would probably introduce memory
starvation for some loads, and could potentially introduce deadlocks
if not done properly.  It may also cause bursty output instead of
sustained, even when the input is sustained.

Solution #2 -
Merge stripes in dm-crypt, and submit an entire stripe at once.
This is a huge hack, but it would use much smaller queues than would
be required at a lower layer (i.e., the raid5/6 layer, where it is
currently happening).  It would still produce out-of-order stripe
writes, but the I/O scheduler would probably handle that with a large
enough request queue, and seeking is much cheaper than multiple
read-parity-write cycles per stripe.

Solution #3 -
In the md layer, in addition to preread_bypass_threshold, add a
preread_expire, to allow stripes that need pre-read to be submitted
based on time, rather than skip count.
Nothing more than triage for the partial stripe write delay when
favoring full stripes.

Does anyone have any more ideas, or comments on these?
Need logs?  I can produce them, just ask for what you want.

Setup:
Linux version: 2.6.38
Processor: i7-870 (2.93GHz with 4 cores + HT = 8 logical units)
RAM: 8GB
RAID5: 3x1.5TB w/ 512k chunks
LVM2
dm-crypt: LUKS with aes-cbc-essiv:sha256
All layers are properly aligned.

-- 
Chris
