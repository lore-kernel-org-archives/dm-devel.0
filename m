From: Jens Axboe <axboe@kernel.dk>
Subject: Re: rename ->make_request_fn and move it to the
 block_device_operations
Date: Tue, 30 Jun 2020 07:57:29 -0600
Message-ID: <bd1443c0-be37-115b-1110-df6f0e661a50@kernel.dk>
References: <20200629193947.2705954-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20200629193947.2705954-1-hch@lst.de>
Content-Language: en-US
Sender: linux-m68k-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
List-Id: dm-devel.ids

On 6/29/20 1:39 PM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series moves the make_request_fn method into block_device_operations
> with the much more descriptive ->submit_bio name.  It then also gives
> generic_make_request a more descriptive name, and further optimize the
> path to issue to blk-mq, removing the need for the direct_make_request
> bypass.

Looks good to me, and it's a nice cleanup as well. Applied.

-- 
Jens Axboe
