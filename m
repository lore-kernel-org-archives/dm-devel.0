From: Alex Sudakar <alex.sudakar@gmail.com>
Subject: dm-cache - should origin device and cache be identical
	when quiescent?
Date: Fri, 23 Jan 2015 12:14:33 +1000
Message-ID: <CALq2s-HVaHBGY1BkBkgxmcef36H4KjTGAQoLNJk3JCE5qqe1sA@mail.gmail.com>
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

I'm running Centos7 - kernel 3.10.0.x86_64 - and am testing dm-cache
in a libvert/KVM virtual machine.  I plan to eventually use dm-cache
with a 256GB SSD and an origin device of a 2TB md-raid1 device.

I've written a couple of test programs and am concerned to find that
they are suggesting that my test cache in my VM becomes corrupted over
time.  But before I panic I would like to ask a couple of very basic
questions.  I've tried to find the answers in the kernel-doc and
elsewhere but haven't so far found explanations to what I'm seeing.

I'm setting up a cache using three partitions of a 1GB test disk -
/dev/vdb - in my VM.  vdb1 is the 900MB origin device, vdb2 is the
90MB cache device and vdb3 the 30MB metadata device.  I set up the
cache as follows:

  dd if=/dev/zero of=/dev/vdb3 bs=32k; dd if=/dev/zero of=/dev/vdb2
bs=32k; dd if=/dev/zero of=/dev/vdb1 bs=32k

  dmsetup create cache --table '0 1843200 cache /dev/vdb3 /dev/vdb2
/dev/vdb1 64 1 writeback default 0

At this point the cache and the origin device all have zero bytes
content, so a simple comparison works:

  cmp /dev/mapper/cache /dev/vdb1

Then I invoke my little test program which writes random sectors to
/dev/mapper/cache.  After a minute I terminate the program and try
another comparison:

  # cmp /dev/mapper/cache /dev/vdb1
  /dev/mapper/cache /dev/vdb1 differ: byte 35841, line 1

Using 'od' I confirm that sector #70 in the origin device is still all
zeroes, whereas the sector on the cache device is correct (agreeing
with the values last written by my test program).

Even after 5 minutes a comparison still shows that the sector is full
of zeroes on the origin device.

I shift to the cleaner policy:

  dmsetup suspend cache
  dmsetup reload cache --table '0 1843200 cache /dev/vdb3 /dev/vdb2
/dev/vdb1 64 0 cleaner 0'
  dmsetup resume cache

wait a few seconds (a script monitoring 'dmsetup status cache' shows a
small short burst of reads/writes, then no activity) and then switch
back to the default/mq policy:

  dmsetup suspend cache
  dmsetup reload cache --table '0 1843200 cache /dev/vdb3 /dev/vdb2
/dev/vdb1 64 1 writeback default 0'
  dmsetup resume cache

But the cmp still fails, saying that same sector is different between
origin and cache devices.  Even after I 'dmsetup remove cache' the
origin device's sector is still all zeroes rather than the data
written by the test program.

I'm sure I'm missing something super-basic, but I would appreciate
advice on why this discrepancy exists.  I thought I'd read that dirty
blocks are ultimately written out in a matter of seconds to the origin
device.  The kernel-doc says that the cleaner 'writes back all dirty
blocks in a cache to decommission it'.  I'm at a loss as to why that
apparently isn't happening.

While I'm here I'd like to ask about my 'corruption' problem which I'm
still investigating.  Basically I leave my test program running for a
longer time - an hour or more - and then I find that the sectors in my
*cache device* don't have the data that the test program (which writes
'sector X last written with bytes of value Y' information to a state
file) says it should have.  While the test program is writing random
sectors I have a separate script which approximately every ten minutes
switches from mq to cleaner policy and then, after another period
(random 0 - 10 minutes) switches back again (using the commands listed
above).

My ultimate intent is to switch the cache into using the cleaner
policy during various night-time batch runs which scan all the files
on the system (backups, tripwire, etc) and would typically 'de-prime'
the cache from the state it had acquired during my typical daytime
activities.  I've done some simple tests with mq/cleaner and it
appeared to me that cleaner left the cached blocks alone - after a lot
of data reads with cleaner a switch back to mq would find that the
blocks held in the cache immediately before the move to cleaner were
still cached.  Since I don't believe dm-cache has a 'blacklist pid'
facility like Flashcache (I wish it did!) I thought using cleaner
would be a the next best thing.

But in my hours-long test I experienced the corruption I mentioned
(*not* a discrepancy between origin device and cache, as per my first
question, but between the cache device and what my test program said
it had written).  While I'm double-checking my test program I thought
I'd ask if my practice of switching from mq to cleaner and back again
as a regular operational procedure is supported or if I'm doing
something stupid.

Many thanks for any advice.  I have tried to research
answers/solutions; if I've missed something obvious I'd appreciate any
references.

Thanks!
