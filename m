From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: make discard killable
Date: Fri, 6 Jul 2018 07:51:30 -0600
Message-ID: <8163a50c-06a1-1b56-7927-7d5cc56d1038@kernel.dk>
References: <alpine.LRH.2.02.1807031334400.22443@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1807031334400.22443@file01.intranet.prod.int.rdu2.redhat.com>
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

On 7/3/18 11:35 AM, Mikulas Patocka wrote:
> Discarding can take very long time for some device mapper targets, this
> patch makes it possible to kill a process that issues the BLKDISCARD
> ioctl.
> 
> Note that some filesystems call blkdev_issue_discard or
> __blkdev_issue_discard directly, they may not be prepared to handle the
> failure, so this patch introduces a flag BLKDEV_DISCARD_KILLABLE that is
> only set when the discard is initiated by an ioctl.

This might be cleaner as a regular request flag, since killable can
apply to other types of IO as well - like readahead.

-- 
Jens Axboe
