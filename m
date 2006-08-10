From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: patch to dm-emc.c
Date: Thu, 10 Aug 2006 17:27:39 -0400
Message-ID: <44DBA4CB.8030600@cs.wisc.edu>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1361@CORPUSMX40A.corp.emc.com>
	<44DBA20D.6020507@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44DBA20D.6020507@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com
List-Id: dm-devel.ids

Mike Christie wrote:
> egoggin@emc.com wrote:
>> Thanks Mike.  Changes to reflect these and other comments from
>> Alasdair and Mike Anderson will be delayed since I'm on vacation
>> for a week and a half or so.
>>
> 
> no problem.
> 
>>>> +	struct request req;
>>> You should not have to do this should you? The queue has a mempool of
>>> requests. The only way it could be exhausted is if some app is hogging
>>> them by doing SG_IO (since dm bd_claims the device), you do not use
>>> GFP_WAIT in your allocation, and you really hit some nasty case where
>>> your process is starved because you keep missing the chance 
>>> to allocate
>>> a request that is freed and put back in the pool. If you are that
>>> unlucky and that happens though, you would have problems elsewhere
>>> though so maybe a generic solution to make sure no one gets starved
>>> would be better.
>> I think the use case is not that there are no more request structures
>> to allocate but that enough write requests (think buf sync/flush of
>> the mapped devicce) have piled up on the target device's queue waiting
>> for a pg_init that the queue's write request threshold gets met.  Any
>> further attempt to allocate a request (like one to service the pg_init)
> 
> I think I am missing what a target device queue is. When I wrote my
> comment I was thinking about the kernel code where there is a per device
> request_queue which allocates a request from a mempool and has a write
> threshold. So if for some reason, userspace were to do something silly
> like send down write_threshold+1 requests and so anyone else trying to
> allocate a request would be put to sleep until a request is completed I
> do not see how a request is not eventually completed so we can
> eventually allocate a request from the mempool.

That is I am thinking you are thinking that we block in that request
allocation code which checks the threshold. So I thought you are saying
we hit this bit in get_request_wait:

        if (rl->count[rw]+1 >= queue_congestion_on_threshold(q)) {
                if (rl->count[rw]+1 >= q->nr_requests) {
                        ioc = current_io_context(GFP_ATOMIC);
                        /*
                         * The queue will fill after this allocation, so set
                         * it as full, and mark this process as "batching".
                         * This process will be allowed to complete a
batch of
                         * requests, others will be blocked.
                         */
                        if (!blk_queue_full(q, rw)) {
                                ioc_set_batching(q, ioc);
                                blk_set_queue_full(q, rw);
                        } else {
                                if (may_queue != ELV_MQUEUE_MUST
                                                && !ioc_batching(q, ioc)) {
                                        /*
                                         * The queue is full and the
allocating
                                         * process is not a "batcher",
and not
                                         * exempted by the IO scheduler
                                         */
                                        goto out;
                                }
                        }
                }
                set_queue_congested(q, rw);
        }




But I thought, a request should eventually complete and so we should be
woken up from get_request_wait, and we will try allocate a request again
and then the write request count should have gone down and we should be
able to proceed.
