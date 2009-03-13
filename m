From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 0/8] dm: request-based dm-multipath
Date: Fri, 13 Mar 2009 10:03:18 +0900
Message-ID: <49B9B0D6.9070003@ct.jp.nec.com>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>	<20090128154019.GB23158@agk.fab.redhat.com>	<49815863.8040806@ct.jp.nec.com>	<20090129104147.GB9870@pentland.suse.de>	<4982B4C6.8050904@ct.jp.nec.com>	<49B60444.2090008@ct.jp.nec.com>
	<49B613FE.3060501@suse.de> <49B8CEBB.7070701@ct.jp.nec.com>
	<49B8D114.6040200@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49B8D114.6040200@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Hannes,

On 2009/03/12 18:08 +0900, Hannes Reinecke wrote:
> Do you have an updated patch of your suspend fixes? We've run into an issue
> here which looks suspiciously close to that one (I/O is completed on a
> deleted pgpath), so we would be happy to test it these out.

You mean that the issue occurs WITHOUT the suspend fix patch which
I sent.  Is it right?
If so, you can use it, since I haven't added any big change about
suspend fix since then.
Logic changes I added about suspend fix since then are only in
rq_complete() to follow your comment.  The updated rq_complete()
is below:

static void rq_completed(struct mapped_device *md)
{
	struct request_queue *q = md->queue;
	unsigned long flags;

	spin_lock_irqsave(q->queue_lock, flags);
	if (q->in_flight) {
		spin_unlock_irqrestore(q->queue_lock, flags);
		return;
	}
	spin_unlock_irqrestore(q->queue_lock, flags);

	/* nudge anyone waiting on suspend queue */
	wake_up(&md->wait);
}


I merged the previous suspend fix patch into the request-based dm
core patch, and I've been changing the core patch after that.
So I don't have a patch which addresses only suspend fix update.
Sorry about that.

Thanks,
Kiyoshi Ueda
