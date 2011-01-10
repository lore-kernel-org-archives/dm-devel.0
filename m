From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH] PROBLEM: SSD access time with dm-crypt is way
 too high
Date: Mon, 10 Jan 2011 13:47:35 -0500
Message-ID: <20110110184734.GA31325@infradead.org>
References: <1294580107.2076.89.camel@vpcz1maverick>
 <4D29C0A7.5010209@redhat.com>
 <Pine.LNX.4.64.1101101216430.26990@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-net-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1101101216430.26990@hs20-bc2-1.build.redhat.com>
Sender: linux-net-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Michael Zugelder <michaelzugelder@googlemail.com>, linux-net@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Mon, Jan 10, 2011 at 12:19:25PM -0500, Mikulas Patocka wrote:
> There are two approaches that I considered:
> 
> 1. make a special work for unplug. After queuing each IO's work, cancel the
> unplug work and queue it again (so that it will always be queued as a last
> entry). Unfortunatelly, canceling a work is rather slow operation so I decided
> to not use this approach.
> 
> 2. use a special pointer that points to the last IO. When the IO is finished
> and the pointer matches this IO, we know that it was the last IO and we should
> unplug. This patch implements this approach.

What about keeping a reference count of pending I/O requests in a shared
structure, with the last decrement doing the unplug?

