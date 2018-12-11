From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] dm: fix request-based dm's use of
	dm_wait_for_completion
Date: Tue, 11 Dec 2018 07:40:22 -0700
Message-ID: <f005f3db-a281-1de8-08c1-89464e28b375@kernel.dk>
References: <20181211141026.30174-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181211141026.30174-1-snitzer@redhat.com>
Content-Language: en-US
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 12/11/18 7:10 AM, Mike Snitzer wrote:
> The md->wait waitqueue is used by both bio-based and request-based DM.
> Commit dbd3bbd291 ("dm rq: leverage blk_mq_queue_busy() to check for
> outstanding IO") lost sight of the requirement that
> dm_wait_for_completion() must work with all types of DM devices.
> 
> Fix md_in_flight() to call the blk-mq or bio-based method accordingly.

Applied, thanks.

-- 
Jens Axboe
