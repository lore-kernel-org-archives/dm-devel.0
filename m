From: Michael Zugelder <michaelzugelder@googlemail.com>
Subject: PROBLEM: SSD access time with dm-crypt is way too high
Date: Sun, 09 Jan 2011 14:35:07 +0100
Message-ID: <1294580107.2076.89.camel@vpcz1maverick>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-net-owner@vger.kernel.org>
Sender: linux-net-owner@vger.kernel.org
To: linux-net@vger.kernel.org, dm-devel@redhat.com
Cc: jens.axboe@oracle.com, Neil Brown <neilb@suse.de>
List-Id: dm-devel.ids

Hello,

from kernel 2.6.33 on (at least up to 2.6.37) the access time when using
dm-crypt on SSD is way too high. I would expect it to be a bit worse
than directly accessing the device (~0.2ms here), but currently it's at
exactly 10ms (except a few outlines). This corresponds to CONFIG_HZ=100.

The high access time makes the system feel very slow (if you're
expecting SSD performance). On kernel 2.6.32 this wasn't an issue,
access time stayed below 0.3ms. Those numbers are from palimpsest, but
the difference is so drastic, that pretty much everything you can think
of shows a difference (e. g. find-ing all files on the disk goes up from
tens of seconds to multiple minutes). 
Just to be clear: This isn't about a dm-crypt encrypted disk being
slower that an unencrypted disk. It's about the access time of the same
encrypted disk rising to >= 10ms, which is at least an order of
magnitude for an SSD. I suspect with an HDD, the difference isn't much
noticeable.

I filed a bugreport on the Ubuntu bugtracker with a few pretty graphs,
vmstat and LatencyTOP output. If that would be useful, see
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/653611 .

A bisect between .32 and .33 revealed some more information. I arrived
at 79da064, which is a revert of fb1e753 (block: improve
queue_should_plug() by looking at IO depths), so I compiled fb1e753.
With this 2.6.31 kernel, the problem was gone. One step back to 1f98a13,
the access time was high again.

So, it seems that fb1e753 (block: improve queue_should_plug() by looking
at IO depths) improves dm-crypt access time on SSDs (by a factor of over
40 here), but (as in the revert commit stated) reduces sequential
throughput in some cases. I applied fb1e753 to 2.6.37 and the access
time went down to the .32 value.

For me, it seems that dm-crypt interferes with queuing, which totally
destroys access time. If the disk empties the queue after a few
fractions of a millisecond, and it only gets refilled every tick (10ms),
wouldn't this explain the observed behavior? Correspondingly, a 300HZ
kernel achieves about 3ms access time Going all the way up to 1000HZ
hardly improves that number.

Please keep me on CC, since I am not subscribed.

Thanks
Michael

