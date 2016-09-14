From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/3] blk-mq: introduce blk_mq_delay_kick_requeue_list()
Date: Wed, 14 Sep 2016 09:45:46 -0400
Message-ID: <20160914134545.GA29338@redhat.com>
References: <1473782495-44128-1-git-send-email-snitzer@redhat.com>
 <1473782495-44128-2-git-send-email-snitzer@redhat.com>
 <7745fd2a-b8e3-f2c8-5154-4f0bcd263338@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7745fd2a-b8e3-f2c8-5154-4f0bcd263338@acm.org>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: axboe@kernel.dk, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Sep 14 2016 at  7:28am -0400,
Bart Van Assche <bart.vanassche@gmail.com> wrote:

> On 09/13/2016 06:01 PM, Mike Snitzer wrote:
> >+void blk_mq_delay_kick_requeue_list(struct request_queue *q,
> >+				    unsigned long msecs)
> >+{
> >+	kblockd_schedule_delayed_work(&q->requeue_work, msecs);
> >+}
> >+EXPORT_SYMBOL(blk_mq_delay_kick_requeue_list);
> 
> Hello Mike,
> 
> I think kblockd_schedule_delayed_work() expects that the second
> argument is a number of jiffies instead of a number of milliseconds.

Yeap, you're right.  An earlier version was using msecs_to_jiffies() in
the DM caller.  I'll submit v2.
