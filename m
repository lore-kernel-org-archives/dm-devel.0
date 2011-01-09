From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] PROBLEM: SSD access time with dm-crypt is way too
 high
Date: Sun, 09 Jan 2011 15:05:27 +0100
Message-ID: <4D29C0A7.5010209@redhat.com>
References: <1294580107.2076.89.camel@vpcz1maverick>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <1294580107.2076.89.camel@vpcz1maverick>
Sender: linux-net-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Michael Zugelder <michaelzugelder@googlemail.com>, linux-net@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: dm-devel.ids

On 01/09/2011 02:35 PM, Michael Zugelder wrote:

Hi,

> Just to be clear: This isn't about a dm-crypt encrypted disk being
> slower that an unencrypted disk. It's about the access time of the same
> encrypted disk rising to >= 10ms, which is at least an order of
> magnitude for an SSD. I suspect with an HDD, the difference isn't much
> noticeable.

yep, it was reported several times, thanks for that bisect.
We will need to retest it with per-cpu dm-crypt patches
(should be in linux-next soon) but I expect that this problem remains.

> I filed a bugreport on the Ubuntu bugtracker with a few pretty graphs,
> vmstat and LatencyTOP output. If that would be useful, see
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/653611 .

(Maybe Ubuntu people can forward issue to upstream list next time?)

> A bisect between .32 and .33 revealed some more information. I arrived
> at 79da064, which is a revert of fb1e753 (block: improve
> queue_should_plug() by looking at IO depths), so I compiled fb1e753.
> With this 2.6.31 kernel, the problem was gone. One step back to 1f98a13,
> the access time was high again.
> 
> So, it seems that fb1e753 (block: improve queue_should_plug() by looking
> at IO depths) improves dm-crypt access time on SSDs (by a factor of over
> 40 here), but (as in the revert commit stated) reduces sequential
> throughput in some cases. I applied fb1e753 to 2.6.37 and the access
> time went down to the .32 value.
> 
> For me, it seems that dm-crypt interferes with queuing, which totally
> destroys access time.

Yes, dm-crypt clones requests and process them in its own queue so there
is some interference.

I am not sure if this is fixable by block layer only patch (like fb1e753),

Maybe dm-crypt should call unplug explicitly, flush crypt workqueue
explicitly or something like that... dunno

Jens, do you have an idea how to improve it and not lose throughput?

Milan
