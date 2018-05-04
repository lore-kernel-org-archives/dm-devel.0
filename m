From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH REPOST] dm rq: remove BUG_ON(!irqs_disabled)
	check
Date: Fri, 4 May 2018 18:33:45 +0200
Message-ID: <20180504163345.mtr2q6jhkn4vrwi4@linutronix.de>
References: <20180504143639.5300-1-bigeasy@linutronix.de>
	<20180504155311.GA4787@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180504155311.GA4787@redhat.com>
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
Cc: Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 2018-05-04 11:53:12 [-0400], Mike Snitzer wrote:
> the queue_lock hasn't been removed for the old .request_fn path in block
> core -- which dm_old_request_fn is providing the hook for.
> 
> This BUG_ON() documents that reality.
> 
> Commit 2eb6e1e3aa87 made it such that work is queued into an irq enabled
> context.   But it never changed the fact that old block core's
> .request_fn (and as such dm_old_request_fn) is called with irqs
> disabled.

As per history it looked different, sorry. Is there a lock that is
supposed to be held?

Sebastian
