From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch] blk-flush: fix flush policy calculation
Date: Mon, 08 Aug 2011 13:31:22 -0400
Message-ID: <x49bovzizdh.fsf__27941.9096107178$1312826635$gmane$org@segfault.boston.devel.redhat.com>
References: <x49d3go98ku.fsf@segfault.boston.devel.redhat.com>
	<CANejiEXK7NSJo-0vshyX6RSqmRbHmyxAw8_wFQEwvTXrEQF3fg@mail.gmail.com>
	<x4939hju2zh.fsf@segfault.boston.devel.redhat.com>
	<20110804102039.GD2731@htj.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-Message-ID: <20110808175531.GA3146@redhat.com>
Resent-To: dm-devel@redhat.com
In-Reply-To: <20110804102039.GD2731@htj.dyndns.org> (Tejun Heo's message of
	"Thu, 4 Aug 2011 12:20:39 +0200")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, msnitzer@redhat.com, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On Tue, Aug 02, 2011 at 01:39:46PM -0400, Jeff Moyer wrote:
>> OK, sorry for top-posting here, but I chased the problem down further.
>> 
>> Commit ae1b1539622fb46e51b4d13b3f9e5f4c713f86ae, block: reimplement
>> FLUSH/FUA to support merge, introduced a regression when running any
>> sort of fsyncing workload using dm-multipath and certain storage (in our
>> case, an HP EVA).  It turns out that dm-multipath always advertised
>> flush+fua support, and passed commands on down the stack, where they
>> used to get stripped off.  The above commit, unfortunately, changed that
>> behavior:
> ...
>> So, the flush machinery was bypassed in such cases (q->flush_flags == 0
>> && rq->cmd_flags & (REQ_FLUSH|REQ_FUA)).
>> 
>> Now, however, we don't get into the flush machinery at all (which is why
>> my initial patch didn't help this situation).  Instead,
>> __elv_next_request just hands a request with flush and fua bits set to
>> the scsi_request_fn, even though the underlying request_queue does not
>> support flush or fua.
>> 
>> So, where do we fix this?  We could just accept Mike's patch to not send
>> such requests down from dm-mpath, but that seems short-sighted.  We
>> could reinstate some checks in __elv_next_request.  Or, we could put the
>> checks into blk_insert_cloned_request.
>
> Ah, okay, what changed there was where a request is passed into flush
> machinery.  Before, it was while the request was being dispatched from
> elevator to device.  After, it's de-composed when the request enters
> elevator.  The bug is that there are paths which insert new requests
> to elevator but didn't check for REQ_FLUSH|FUA.
>
> I think it would be cleaner to add a wrapper around
> __elv_add_request() which checks for REQ_FLUSH|FUA and enforce
> REQ_INSERT_FLUSH if the request needs it.  Note that this should only
> happen when a request enters the queue for the first time but not on
> requeues - that was the reason why the decision wasn't made inside
> __elv_add_request().

OK, we can do a wrapper, but it probably wouldn't be too horrific to
just fix up blk_insert_cloned_request.

Now, the next issue is that flush requests issued from the dm target
down through the stack have no bio associated with them, so we blow up
on the BUG_ON(!req->bio || req->bio != req->biotail).

Cheers,
Jeff
