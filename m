From: Michael Zugelder <michaelzugelder@googlemail.com>
Subject: Re: [PATCH] PROBLEM: SSD access time with dm-crypt is way too high
Date: Mon, 10 Jan 2011 21:06:24 +0100
Message-ID: <1294689984.2619.21.camel@vpcz1maverick>
References: <1294580107.2076.89.camel@vpcz1maverick>
	 <4D29C0A7.5010209@redhat.com>
	 <Pine.LNX.4.64.1101101216430.26990@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1101101216430.26990@hs20-bc2-1.build.redhat.com>
Sender: linux-net-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Michael Zugelder <michaelzugelder@googlemail.com>, linux-net@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@kernel.dk>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Mon, 2011-01-10 at 12:19 -0500, Mikulas Patocka wrote: 
> Try this patch.

Hi,

just compiled it on top of 2.6.37 without the fb1e753 and ran seeker [1]
for 100 seconds:

raw disk:       0.2173ms
fb1e753 patch:  0.2643ms
your patch:	0.2676ms

Throughput is within 5% of max, even with the 10ms access time.

On Mon, 2011-01-10 at 18:50 +0100, Milan Broz wrote:
> We can now process ios in parallel on different CPUs, that code will
> rewrite the context struct on every IO and at least it will cause cache bouncing.

I should say that those numbers come from a CRYPTO_PCRYPT=n kernel.


Anyone got an idea for a good testcase? I tried replicating the issues
with with a loop'd file on a tmpfs and failed. Using a usb-attached HDD
also didn't work.


Michael

[1] http://www.linuxinsight.com/how_fast_is_your_disk.html

