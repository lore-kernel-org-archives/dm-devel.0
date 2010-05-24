From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/6] block: Adjust elv_iosched_show to return
	"none"	for bio-based DM
Date: Mon, 24 May 2010 09:06:39 +0200
Message-ID: <20100524070638.GS23411@kernel.dk>
References: <1274651101-9784-1-git-send-email-snitzer@redhat.com>
	<1274651101-9784-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1274651101-9784-2-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Sun, May 23 2010, Mike Snitzer wrote:
> Bio-based DM doesn't use an elevator (queue is !blk_queue_stackable()).
> 
> Longer-term DM will not allocate an elevator for bio-based DM.  But even
> then there will be small potential for an elevator to be allocated for
> a request-based DM table only to have a bio-based table be loaded in the
> end.
> 
> Displaying "none" for bio-based DM will help avoid user confusion.

Thanks, applied for 2.6.35.

-- 
Jens Axboe
