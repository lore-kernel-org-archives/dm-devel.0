From: Jens Axboe <axboe@kernel.dk>
Subject: Re: fix block device size update serialization v2
Date: Sat, 29 Aug 2020 10:47:11 -0600
Message-ID: <b1960016-c265-1e1d-cfd7-de2330bc5eac@kernel.dk>
References: <20200823091043.2600261-1-hch@lst.de>
 <20200827074758.GA8009@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200827074758.GA8009@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Justin Sanders <justin@coraid.com>, Josef Bacik <josef@toxicpanda.com>, Xianting Tian <xianting_tian@126.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
List-Id: dm-devel.ids

On 8/27/20 1:47 AM, Christoph Hellwig wrote:
> Jens, can you consider this for 5.9?  It reliably fixes the reported
> hangs with nvme hotremoval that we've had for a few releases.

I've queued this up for 5.10. I think it's too late for 5.9 at this
point, and it's not a regression in this release.

-- 
Jens Axboe
