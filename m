From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] PROBLEM: SSD access time with dm-crypt is way too high
Date: Mon, 10 Jan 2011 18:50:32 +0100
Message-ID: <4D2B46E8.7070501@redhat.com>
References: <1294580107.2076.89.camel@vpcz1maverick> <4D29C0A7.5010209@redhat.com> <Pine.LNX.4.64.1101101216430.26990@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1101101216430.26990@hs20-bc2-1.build.redhat.com>
Sender: linux-net-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Michael Zugelder <michaelzugelder@googlemail.com>, linux-net@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@kernel.dk>
List-Id: dm-devel.ids

On 01/10/2011 06:19 PM, Mikulas Patocka wrote:
> Try this patch. I coded it long time ago, but it was forgotten somehow.

No, it was not forgotten, I just do not like this approach :)

> +  	/*
> +	 * The last io submitted to io_queue and crypt_queue.
> +	 * This pointers are not protected by any locks and thus must not be
> +	 * dereferenced --- they may contain garbage. The only allowed operation
> +	 * is to compare these pointers with current io being processed. If they
> +	 * match, the block device queue should be unplugged.
> +	 */
> +	struct dm_crypt_io *io_queue_last_io;
> +	struct dm_crypt_io *crypt_queue_last_io;

We can now process ios in parallel on different CPUs, that code will
rewrite the context struct on every IO and at least it will cause cache bouncing.
(it will not apply on current code anyway, see patches in linux-next)

And I think it can kill performance is some cases (if the requests are submitted
such way that you will call unplug after every io.)

We need something clever here - I wonder if fixing the reverted fb1e753 can
help here....

Milan
