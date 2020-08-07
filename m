From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: nvme: restore use of blk_path_error() in
	nvme_complete_rq()
Date: Thu, 6 Aug 2020 18:21:03 -0700
Message-ID: <510f5aff-0437-b1ce-f7ab-c812edbea880@grimberg.me>
References: <43e5dee8-1a91-4d8b-fdb5-91f9679ddeb3@huawei.com>
	<8d01b123-478f-f057-1598-8283dd099b03@huawei.com>
	<20200805152905.GB1982647@dhcp-10-100-145-180.wdl.wdc.com>
	<255d55e3-f824-a968-e478-3efeda095696@huawei.com>
	<20200806142625.GA3075319@dhcp-10-100-145-180.wdl.wdc.com>
	<729820BC-5F38-4E22-A83A-862E57BAE201@netapp.com>
	<E3390A8E-D582-47BA-A085-21663D883365@netapp.com>
	<20200806184057.GA27858@redhat.com> <20200806191943.GA27868@redhat.com>
	<6B826235-C504-4621-B8F7-34475B200979@netapp.com>
	<20200807000755.GA28957@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200807000755.GA28957@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>, "Meneghini, John" <John.Meneghini@netapp.com>
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Ewan Milne <emilne@redhat.com>, Chao Leng <lengchao@huawei.com>, Keith Busch <kbusch@kernel.org>
List-Id: dm-devel.ids

Hey Mike,

>> The point is: blk_path_error() has nothing to do with NVMe errors.
>> This is dm-multipath logic stuck in the middle of the NVMe error
>> handling code.
> 
> No, it is a means to have multiple subsystems (to this point both SCSI
> and NVMe) doing the correct thing when translating subsystem specific
> error codes to BLK_STS codes.

Not exactly, don't find any use of this in scsi. The purpose is to make
sure that nvme and dm speak the same language.

> If you, or others you name drop below, understood the point we wouldn't
> be having this conversation.  You'd accept the point of blk_path_error()
> to be valid and required codification of what constitutes a retryable
> path error for the Linux block layer.

This incident is a case where the specific nvme status was designed
to retry on the same path respecting the controller retry delay.
And because nvme used blk_path_error at the time it caused us to use a
non-retryable status to get around that. Granted, no one had 
dm-multipath in mind.

So in a sense, there is consensus on changing patch 35038bffa87da
_because_ nvme no longer uses blk_path_error. Otherwise it would break.

> Any BLK_STS mapping of NVMe specific error codes would need to not screw
> up by categorizing a retryable error as non-retryable (and vice-versa).

But it is a special type of retryable. There is nothing that fits the
semantics of the current behavior.

> Again, assuming proper testing, commit 35038bffa87 wouldn't have made it
> upstream if NVMe still used blk_path_error().

Agree.

> Yes, your commit 764e9332098c0 needlessly removed NVMe's use of
> blk_path_error().  If you're saying it wasn't needless please explain
> why.
> 
>>      Fixes: 764e9332098c0 ("nvme-multipath: do not reset on unknown status")
>>      Cc: stable@vger.kerneel.org
>>      Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>>      ---
>>      drivers/nvme/host/core.c | 9 +++++++--
>>      1 file changed, 7 insertions(+), 2 deletions(-)
>>
>>      diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
>>      index 6585d57112ad..072f629da4d8 100644
>>      --- a/drivers/nvme/host/core.c
>>      +++ b/drivers/nvme/host/core.c
>>      @@ -290,8 +290,13 @@ void nvme_complete_rq(struct request *req)
>>                      nvme_req(req)->ctrl->comp_seen = true;
>>
>>              if (unlikely(status != BLK_STS_OK && nvme_req_needs_retry(req))) {
>>      -               if ((req->cmd_flags & REQ_NVME_MPATH) && nvme_failover_req(req))
>>      -                       return;
>>      +               if (blk_path_error(status)) {
>>      +                       if (req->cmd_flags & REQ_NVME_MPATH) {
>>      +                               if (nvme_failover_req(req))
>>      +                                       return;
>>      +                               /* fallthru to normal error handling */
>>      +                       }
>>      +               }
>>
>> This would basically undo the patch Hannes, Christoph, and I put together in
>> commit 764e9332098c0.  This patch greatly simplified and improved the
>> whole nvme_complete_rq() code path, and I don't support undoing that change.
> 
> Please elaborate on how I've undone anything?

I think you're right, this hasn't undone the patch from John, but it
breaks NVME_SC_CMD_INTERRUPTED error handling behavior.

> The only thing I may have done is forced NVMe to take more care about
> properly translating its NVME_SC to BLK_STS in nvme_error_status().
> Which is a good thing.

I don't think there is an issue here of mistakenly converting an nvme
status code to a wrong block status code. This conversion is there
because there is no block status that give us the semantics we need
which is apparently specific to nvme.

I personally don't mind restoring blk_path_error to nvme, I don't
particularly feel strong about it either. But for sure blk_path_error
needs to first provide the semantics needed for NVME_SC_CMD_INTERRUPTED.

...

> Anyway, no new BLK_STS is needed at this point.  More discipline with
> how NVMe's error handling is changed is.

Please read the above.

> If NVMe wants to ensure its
> interface isn't broken regularly it _should_ use blk_path_error() to
> validate future nvme_error_status() changes.  Miscategorizing NVMe
> errors to upper layers is a bug -- not open for debate.

Again, don't agree is a Miscategorization nor a bug, its just something
that is NVMe specific.
