From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: patch to dm-emc.c
Date: Thu, 10 Aug 2006 17:15:57 -0400
Message-ID: <44DBA20D.6020507@cs.wisc.edu>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1361@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D1361@CORPUSMX40A.corp.emc.com>
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

egoggin@emc.com wrote:
> Thanks Mike.  Changes to reflect these and other comments from
> Alasdair and Mike Anderson will be delayed since I'm on vacation
> for a week and a half or so.
> 

no problem.

>>> +	struct request req;
>> You should not have to do this should you? The queue has a mempool of
>> requests. The only way it could be exhausted is if some app is hogging
>> them by doing SG_IO (since dm bd_claims the device), you do not use
>> GFP_WAIT in your allocation, and you really hit some nasty case where
>> your process is starved because you keep missing the chance 
>> to allocate
>> a request that is freed and put back in the pool. If you are that
>> unlucky and that happens though, you would have problems elsewhere
>> though so maybe a generic solution to make sure no one gets starved
>> would be better.
> 
> I think the use case is not that there are no more request structures
> to allocate but that enough write requests (think buf sync/flush of
> the mapped devicce) have piled up on the target device's queue waiting
> for a pg_init that the queue's write request threshold gets met.  Any
> further attempt to allocate a request (like one to service the pg_init)

I think I am missing what a target device queue is. When I wrote my
comment I was thinking about the kernel code where there is a per device
request_queue which allocates a request from a mempool and has a write
threshold. So if for some reason, userspace were to do something silly
like send down write_threshold+1 requests and so anyone else trying to
allocate a request would be put to sleep until a request is completed I
do not see how a request is not eventually completed so we can
eventually allocate a request from the mempool.

For the pg_init comment, I would think that since the path/device is
bd_claimed by dm and so we can only do SG_IO to it, there should not be
many commands on the devices's queue. What IO would be in that devices's
queue normally anyway?

We should probably add code so that we do not send a flush command
through a inactive path right (there is no need to I mean)? Even if we
did put a command in a path that was not active, the LLD would
eventually pluck it from the request_queue, try to execute  it, and this
would eventually fail or succeed and then be completed and freed and
then open space in the threshold accounting right? The only time I would
think this would not be the case is if, you were to block a request
queue forever and in that case the pg_init command is not getting
through so you are screwed.

But I think we rely on the LLDs eventually making forward progress. If
this did not happen the main IO path would not work. And the SG_IO
paths, for path testing/fallback would not work. So are you sure this is
not working and are we sure I am understanding the problem :)
