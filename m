From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: fix infinite loop if the device loses
 discard capability
Date: Fri, 6 Jul 2018 07:50:56 -0600
Message-ID: <aaa019b2-1994-789c-3faa-c38a5b4c86d4@kernel.dk>
References: <alpine.LRH.2.02.1807031332250.22443@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1807031332250.22443@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-block@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On 7/3/18 11:34 AM, Mikulas Patocka wrote:
> If __blkdev_issue_discard is in progress and a device mapper device is
> reloaded with a table that doesn't support discard,
> q->limits.max_discard_sectors is set to zero. This results in infinite
> loop in __blkdev_issue_discard.
> 
> This patch checks if max_discard_sectors is zero and aborts with
> -EOPNOTSUPP.

Applied, thanks.

-- 
Jens Axboe
