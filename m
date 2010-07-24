From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/12] block: update request stacking methods
 to support discards
Date: Sat, 24 Jul 2010 02:43:25 -0400
Message-ID: <20100724064325.GA11186@infradead.org>
References: <1279927443-1780-1-git-send-email-snitzer@redhat.com>
	<1279927443-1780-11-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1279927443-1780-11-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@lst.de>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
List-Id: dm-devel.ids

> +	if (blk_discard_rq(rq))
> +		return 0;

The blk_discard_rq helper is gone in the block tree.
