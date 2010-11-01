From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: dm: lock bd_mutex when setting device size
Date: Mon, 01 Nov 2010 16:19:00 +0900
Message-ID: <4CCE69E4.9030406@ce.jp.nec.com>
References: <20101019220711.GA25169@redhat.com>
	<20101029215001.GA4827@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101029215001.GA4827@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Mike,

(10/30/10 06:50), Mike Snitzer wrote:
> Avoid taking md->bdev->bd_inode->i_mutex to update the DM block device's
> size.  Using md->bdev->bd_mutex eliminates the potential for deadlock if
> an fsync is racing with a device resize.
> 
> revalidate_disk() was avoided because it would flush_disk() while the DM
> device is suspended.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> ---
>  drivers/md/dm.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> Jun'ichi, was the following your implict Acked-by?  Care to make it
> explicit?
> "Anyway, I think your bd_mutex patch should be fine for now and is
> better than the current code with i_mutex, which has a real deadlock
> issue."

No, it was not an ACK.
(This is not multipath. So I think you don't need my ack.)

I'm reluctant to ack this because, as I wrote, it's prone to
cause deadlock in future.
But I couldn't find a real problem with the patch,
so I'm not NACK-ing either.

-- 
Jun'ichi Nomura, NEC Corporation
