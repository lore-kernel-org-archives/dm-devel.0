From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 10/12] block: update request stacking
 methods to support discards
Date: Tue, 27 Jul 2010 10:54:36 -0400
Message-ID: <20100727145436.GA25210@infradead.org>
References: <1279987768-13275-1-git-send-email-snitzer@redhat.com>
	<1279987768-13275-11-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1279987768-13275-11-git-send-email-snitzer@redhat.com>
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

On Sat, Jul 24, 2010 at 12:09:26PM -0400, Mike Snitzer wrote:
> Propagate REQ_DISCARD in cmd_flags when cloning a discard request.
> Skip blk_rq_check_limits's existing checks for discard requests because
> discard limits will have already been checked in blkdev_issue_discard.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>
