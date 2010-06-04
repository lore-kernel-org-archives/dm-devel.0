From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH v4] block: avoid unconditionally freeing previously  allocated
 request_queue
Date: Fri, 04 Jun 2010 13:44:59 +0200
Message-ID: <4C08E73B.8050806@fusionio.com>
References: <1274744795-9825-1-git-send-email-snitzer@redhat.com> <1274744795-9825-3-git-send-email-snitzer@redhat.com> <4BFBB21A.3030105@ct.jp.nec.com> <20100525124912.GA7447@redhat.com> <20100525163455.GA10155@redhat.com> <20100526045219.GB24702@redhat.com> <20100603165809.GA6730@redhat.com> <20100603173452.GC6730@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100603173452.GC6730@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 2010-06-03 19:34, Mike Snitzer wrote:
> block: avoid unconditionally freeing previously allocated request_queue
> 
> On blk_init_allocated_queue_node failure, only free the request_queue if
> it is wasn't previously allocated outside the block layer
> (e.g. blk_init_queue_node was blk_init_allocated_queue_node caller).
> 
> This addresses an interface bug introduced by the following commit:
> 01effb0 block: allow initialization of previously allocated
> request_queue
> 
> Otherwise the request_queue may be free'd out from underneath a caller
> that is managing the request_queue directly (e.g. caller uses
> blk_alloc_queue + blk_init_allocated_queue_node).

Thanks Mike, this looks a lot better. I have applied this one and
2/2 of the original posting.

-- 
Jens Axboe
