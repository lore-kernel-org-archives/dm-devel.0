From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: nvme: restore use of blk_path_error() in
	nvme_complete_rq()
Date: Fri, 7 Aug 2020 16:35:42 -0700
Message-ID: <fec745aa-0091-ee1f-cb0f-da9e18cf0aa2@grimberg.me>
References: <20200805152905.GB1982647@dhcp-10-100-145-180.wdl.wdc.com>
	<255d55e3-f824-a968-e478-3efeda095696@huawei.com>
	<20200806142625.GA3075319@dhcp-10-100-145-180.wdl.wdc.com>
	<729820BC-5F38-4E22-A83A-862E57BAE201@netapp.com>
	<E3390A8E-D582-47BA-A085-21663D883365@netapp.com>
	<20200806184057.GA27858@redhat.com> <20200806191943.GA27868@redhat.com>
	<6B826235-C504-4621-B8F7-34475B200979@netapp.com>
	<20200807000755.GA28957@redhat.com>
	<510f5aff-0437-b1ce-f7ab-c812edbea880@grimberg.me>
	<20200807045015.GA29737@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200807045015.GA29737@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Ewan Milne <emilne@redhat.com>, Chao Leng <lengchao@huawei.com>, Keith Busch <kbusch@kernel.org>, "Meneghini,
	John" <John.Meneghini@netapp.com>
List-Id: dm-devel.ids


>> Hey Mike,
>>
>>>> The point is: blk_path_error() has nothing to do with NVMe errors.
>>>> This is dm-multipath logic stuck in the middle of the NVMe error
>>>> handling code.
>>>
>>> No, it is a means to have multiple subsystems (to this point both SCSI
>>> and NVMe) doing the correct thing when translating subsystem specific
>>> error codes to BLK_STS codes.
>>
>> Not exactly, don't find any use of this in scsi. The purpose is to make
>> sure that nvme and dm speak the same language.
> 
> SCSI doesn't need to do additional work to train a multipath layer
> because dm-multipath _is_ SCSI's multipathing in Linux.

Agree.

> So ensuring SCSI properly classifies its error codes happens as a
> side-effect of ensuring continued multipath functionality.
> 
> Hannes introduced all these differentiated error codes in block core
> because of SCSI.  NVMe is meant to build on the infrastructure that was
> established.

Yes, exactly my point. blk_path_error is designed to make nvme and 
dm-multipath speak the same language.

>>> If you, or others you name drop below, understood the point we wouldn't
>>> be having this conversation.  You'd accept the point of blk_path_error()
>>> to be valid and required codification of what constitutes a retryable
>>> path error for the Linux block layer.
>>
>> This incident is a case where the specific nvme status was designed
>> to retry on the same path respecting the controller retry delay.
>> And because nvme used blk_path_error at the time it caused us to use a
>> non-retryable status to get around that. Granted, no one had
>> dm-multipath in mind.
>>
>> So in a sense, there is consensus on changing patch 35038bffa87da
>> _because_ nvme no longer uses blk_path_error. Otherwise it would break.
> 
> "break" meaning it would do failover instead of the more optimal local
> retry to the same controller.
> 
> I see.  Wish the header for commit 35038bffa87da touched on this even a
> little bit ;)

I think it did, but maybe didn't put too much emphasis on it.

> But AFAICT the patch I provided doesn't compromise proper local retry --
> as long as we first fix nvme_error_status() to return a retryable
> BLK_STS for NVME_SC_CMD_INTERRUPTED -- which I assumed as a prereq.
> 
> Think of blk_path_error() as a more coarse-grained "is this retryable or
> a hard failure?" check.  So for NVME_SC_CMD_INTERRUPTED,
> nvme_error_status() _should_ respond with something retryable (I'd
> prefer BLK_STS_RESOURCE to be honest).

But blk_path_error semantically mean "is this a pathing error", or at
least that what its name suggest.

> And then nvme_failover_req() is finer-grained; by returning false it now
> allows short-circuiting failover and reverting back to NVMe's normal
> controller based error recovery -- which it does for
> NVME_SC_CMD_INTERRUPTED due to "default" case in nvme_failover_req().
> 
> And then the previous nvme_error_status() classification of retryable
> BLK_STS obviously never gets returned up the IO stack; it gets thrown
> away.

I see what you are saying. The issue is that the code becomes
convoluted (it's a pathing error, oh wait, no its not a pathing error).

>>> Any BLK_STS mapping of NVMe specific error codes would need to not screw
>>> up by categorizing a retryable error as non-retryable (and vice-versa).
>>
>> But it is a special type of retryable. There is nothing that fits the
>> semantics of the current behavior.
> 
> I agree.  But that's fine actually.
> 
> And this issue is the poster-child for why properly supporting a duality
> of driver-level vs upper level multipathing capabilities is pretty much
> impossible unless a clean design factors out the different error classes
> -- and local error retry is handled before punting to higher level
> failover retry.  Think if NVMe were to adopt a bit more disciplined
> "local then failover" error handling it all gets easier.

I don't think punting before is easier, because we do a local retry if:
- no multipathing sw on top
- request needs retry (e.g. no DNR, notretry is off etc..)
- nvme error is not pathing related (nvme_failover_req returned false)

> This local retry _is_ NVMe specific.  NVMe should just own retrying on
> the same controller no matter what (I'll hope that such retry has
> awareness to not retry indefinitely though!).

it will retry until the retry limit.

>  And this has nothing to
> do with multipathing, so the logic to handle it shouldn't be trapped in
> nvme_failover_req().

Well given that nvme_failover_req already may not actually failover this
makes some sense to me (although I did have some resistance to make it
that way in the first place, but was convinced otherwise).

> I think NVMe can easily fix this by having an earlier stage of checking,
> e.g. nvme_local_retry_req(), that shortcircuits ever getting to
> higher-level multipathing consideration (be it native NVMe or DM
> multipathing) for cases like NVME_SC_CMD_INTERRUPTED.
> To be clear: the "default" case of nvme_failover_req() that returns
> false to fallback to NVMe's "local" normal NVMe error handling -- that
> can stay.. but a more explicit handling of cases like
> NVME_SC_CMD_INTERRUPTED should be added to a nvme_local_retry_req()
> check that happens before nvme_failover_req() in nvme_complete_rq().

I don't necessarily agree with having a dedicated nvme_local_retry_req().
a request that isn't failed over, goes to local error handling (retry or
not). I actually think that just adding the condition to
nvme_complete_req and having nvme_failover_req reject it would work.

Keith?

>>> Anyway, no new BLK_STS is needed at this point.  More discipline with
>>> how NVMe's error handling is changed is.
>>
>> Please read the above.
> 
> I agree we'd need a new BLK_STS only if NVMe cannot be made to trap
> NVME_SC_CMD_INTERRUPTED for local retry _before_ considering path
> failover.

Not sure that is better, but we can see a patch first to determine.

>>> If NVMe wants to ensure its
>>> interface isn't broken regularly it _should_ use blk_path_error() to
>>> validate future nvme_error_status() changes.  Miscategorizing NVMe
>>> errors to upper layers is a bug -- not open for debate.
>>
>> Again, don't agree is a Miscategorization nor a bug, its just something
>> that is NVMe specific.
> 
> Right I understand.
> 
> Think it safe to assume these types of details are why Christoph wanted
> to avoid the notion of native NVMe and DM multipathing having
> compatible error handling.  There was some wisdom with that position
> (especially with native NVMe goals in mind).  But if things are tweaked
> slightly then both camps _can_ be made happy.
> 
> There just needs to be a willingness to work through the details,
> defensiveness needs to be shed on both sides, so constructive
> review/consideration of problems can happen.

Agreed.

> Think that has already
> happened here with our exchange.  I'm open to investing effort here if
> others are up for humoring my attempt to explore fixing the issues in a
> mutually beneficial way.  What's the worst that can happen?  My simple
> patches might continue to be ignored? ;)

I won't ignore it, and I apologize of ignoring the original patch 
posted, I guess it flew under the radar...
