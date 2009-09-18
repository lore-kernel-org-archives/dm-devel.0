From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/3] block: Add blk_queue_copy_limits()
Date: Fri, 18 Sep 2009 22:33:28 +0200
Message-ID: <20090918203328.GT23126@kernel.dk>
References: <4AB3B43D.9000802@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AB3B43D.9000802@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Sat, Sep 19 2009, Jun'ichi Nomura wrote:
> This patch is a preparation for the last patch in this patchset
> which changes blk_set_default_limits() to set 0 to max_sectors.
> 
> dm uses blk_stack_limits() to merge limits of underlying devices
> and copy the end result to the queue.
> But if there's no underlying device (like 'zero' target),
> max_sectors/max_hw_sectors are left unchanged from the default 0
> and just copying it to the queue causes problems.
> 
> Provide blk_queue_copy_limits() to get a safe copy with
> invalid values fixed-up.

Added for 2.6.32.

-- 
Jens Axboe
