From: Jens Axboe <axboe@kernel.dk>
Subject: Re: avoid the ->make_request_fn indirect for blk-mq drivers
Date: Sat, 25 Apr 2020 09:45:34 -0600
Message-ID: <98cd7aac-e4ee-8de0-e7aa-0d3e1a2b20e0@kernel.dk>
References: <20200425075336.721021-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20200425075336.721021-1-hch@lst.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@redhat.com, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 4/25/20 1:53 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this small series avoids an indirect call for every submitted bio that
> eventually ends up being handled by blk-mq drivers.  Let me know what
> you think.

I like it, I've been pondering something like this for a bit, but
I like the simplicity of this one and changing it so that only
non-regular make_request_fn is set.

I'll apply this.

-- 
Jens Axboe
