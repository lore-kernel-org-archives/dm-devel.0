From: Ming Lei <ming.lei@redhat.com>
Subject: Re: dm rq: Avoid that request processing stalls
	sporadically
Date: Fri, 19 Jan 2018 08:26:17 +0800
Message-ID: <20180119002616.GC4712@ming.t460p>
References: <20180118163707.11825-1-bart.vanassche@wdc.com>
	<20180118165050.GA19734@redhat.com>
	<1516295632.2676.16.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1516295632.2676.16.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 18, 2018 at 05:13:53PM +0000, Bart Van Assche wrote:
> On Thu, 2018-01-18 at 11:50 -0500, Mike Snitzer wrote:
> > The issue you say it was originally intended to fix _should_ be
> > addressed with this change:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=4dd6edd23e7ea971efddc303f9e67eb79e95808e
> 
> Hello Mike,
> 
> Sorry but I'm not convinced that that patch is sufficient. That patch helps
> if .end_io() is called with status BLK_STS_RESOURCE and also if
> blk_insert_cloned_request() returns the .queue_rq() return value. It does not
> help if .queue_rq() returns BLK_STS_RESOURCE and that return value gets
> ignored.

The return value from .queue_rq() is handled by blk-mq, why do you think
it can be ignored? Please see blk_mq_dispatch_rq_list().

> I think that can happen as follows:
> - Request cloning in multipath_clone_and_map() succeeds and that function
>   returns DM_MAPIO_REMAPPED.
> - dm_dispatch_clone_request() calls blk_insert_cloned_request().
> - blk_insert_cloned_request() calls blk_mq_request_direct_issue(), which
>   results in a call of __blk_mq_try_issue_directly().
> - __blk_mq_try_issue_directly() calls blk_mq_sched_insert_request(). In this

This only happens iff queue is stopped or quiesced, then we return
BLK_STS_OK to blk-mq via .queue_rq(), please see __blk_mq_try_issue_directly(),
how does this cause IO hang? 

>   case the BLK_STS_RESOURCE returned by the .queue_rq() implementation of the
>   underlying path will be ignored.

No, this case won't return BLK_STS_RESOURCE.

-- 
Ming
