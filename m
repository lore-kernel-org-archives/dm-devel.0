From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: nvme: explicitly use normal NVMe error handling when
	appropriate
Date: Tue, 11 Aug 2020 10:12:09 -0400
Message-ID: <20200811141209.GA25261@redhat.com>
References: <6B826235-C504-4621-B8F7-34475B200979@netapp.com>
	<20200807000755.GA28957@redhat.com>
	<510f5aff-0437-b1ce-f7ab-c812edbea880@grimberg.me>
	<20200807045015.GA29737@redhat.com>
	<fec745aa-0091-ee1f-cb0f-da9e18cf0aa2@grimberg.me>
	<20200810143620.GA19127@redhat.com>
	<20200810172209.GA19535@redhat.com>
	<7f99724a-a1eb-6bec-f8ae-f9a4601b0487@huawei.com>
	<20200811042000.GA22692@redhat.com>
	<07bd0219-b39b-dcec-35f0-edc22df0d2ae@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <07bd0219-b39b-dcec-35f0-edc22df0d2ae@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Chao Leng <lengchao@huawei.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Ewan Milne <emilne@redhat.com>, Keith Busch <kbusch@kernel.org>, "Meneghini, John" <John.Meneghini@netapp.com>
List-Id: dm-devel.ids

On Tue, Aug 11 2020 at  2:17am -0400,
Chao Leng <lengchao@huawei.com> wrote:

> 
> 
> On 2020/8/11 12:20, Mike Snitzer wrote:
> >On Mon, Aug 10 2020 at 11:32pm -0400,
> >Chao Leng <lengchao@huawei.com> wrote:
> >
> >>
> >>
> >>On 2020/8/11 1:22, Mike Snitzer wrote:
> >>>On Mon, Aug 10 2020 at 10:36am -0400,
> >>>Mike Snitzer <snitzer@redhat.com> wrote:
> >>>
> >>>>On Fri, Aug 07 2020 at  7:35pm -0400,
> >>>>Sagi Grimberg <sagi@grimberg.me> wrote:
> >>>>
> >>>>>
> >>>>>>>Hey Mike,
> >>>...
> >>>>>>I think NVMe can easily fix this by having an earlier stage of checking,
> >>>>>>e.g. nvme_local_retry_req(), that shortcircuits ever getting to
> >>>>>>higher-level multipathing consideration (be it native NVMe or DM
> >>>>>>multipathing) for cases like NVME_SC_CMD_INTERRUPTED.
> >>>>>>To be clear: the "default" case of nvme_failover_req() that returns
> >>>>>>false to fallback to NVMe's "local" normal NVMe error handling -- that
> >>>>>>can stay.. but a more explicit handling of cases like
> >>>>>>NVME_SC_CMD_INTERRUPTED should be added to a nvme_local_retry_req()
> >>>>>>check that happens before nvme_failover_req() in nvme_complete_rq().
> >>>>>
> >>>>>I don't necessarily agree with having a dedicated nvme_local_retry_req().
> >>>>>a request that isn't failed over, goes to local error handling (retry or
> >>>>>not). I actually think that just adding the condition to
> >>>>>nvme_complete_req and having nvme_failover_req reject it would work.
> >>>>>
> >>>>>Keith?
> >>>>
> >>>>I think that is basically what I'm thinking too.
> >>>
> >>>From: Mike Snitzer <snitzer@redhat.com>
> >>>Subject: nvme: explicitly use normal NVMe error handling when appropriate
> >>>
> >>>Commit 764e9332098c0 ("nvme-multipath: do not reset on unknown
> >>>status"), among other things, fixed NVME_SC_CMD_INTERRUPTED error
> >>>handling by changing multipathing's nvme_failover_req() to short-circuit
> >>>path failover and then fallback to NVMe's normal error handling (which
> >>>takes care of NVME_SC_CMD_INTERRUPTED).
> >>>
> >>>This detour through native NVMe multipathing code is unwelcome because
> >>>it prevents NVMe core from handling NVME_SC_CMD_INTERRUPTED independent
> >>>of any multipathing concerns.
> >>>
> >>>Introduce nvme_status_needs_local_error_handling() to prioritize
> >>>non-failover retry, when appropriate, in terms of normal NVMe error
> >>>handling.  nvme_status_needs_local_error_handling() will naturely evolve
> >>>to include handling of any other errors that normal error handling must
> >>>be used for.
> >>>
> >>>nvme_failover_req()'s ability to fallback to normal NVMe error handling
> >>>has been preserved because it may be useful for future NVME_SC that
> >>>nvme_status_needs_local_error_handling() hasn't yet been trained for.
> >>>
> >>>Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> >>>---
> >>>  drivers/nvme/host/core.c | 16 ++++++++++++++--
> >>>  1 file changed, 14 insertions(+), 2 deletions(-)
> >>>
> >>>diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> >>>index 88cff309d8e4..be749b690af7 100644
> >>>--- a/drivers/nvme/host/core.c
> >>>+++ b/drivers/nvme/host/core.c
> >>>@@ -252,6 +252,16 @@ static inline bool nvme_req_needs_retry(struct request *req)
> >>>  	return true;
> >>>  }
> >>>+static inline bool nvme_status_needs_local_error_handling(u16 status)
> >>>+{
> >>>+	switch (status & 0x7ff) {
> >>>+	case NVME_SC_CMD_INTERRUPTED:
> >>>+		return true;
> >>>+	default:
> >>>+		return false;
> >>>+	}
> >>>+}
> >>>+
> >>>  static void nvme_retry_req(struct request *req)
> >>>  {
> >>>  	struct nvme_ns *ns = req->q->queuedata;
> >>>@@ -270,7 +280,8 @@ static void nvme_retry_req(struct request *req)
> >>>  void nvme_complete_rq(struct request *req)
> >>>  {
> >>>-	blk_status_t status = nvme_error_status(nvme_req(req)->status);
> >>>+	u16 nvme_status = nvme_req(req)->status;
> >>>+	blk_status_t status = nvme_error_status(nvme_status);
> >>>  	trace_nvme_complete_rq(req);
> >>>@@ -280,7 +291,8 @@ void nvme_complete_rq(struct request *req)
> >>>  		nvme_req(req)->ctrl->comp_seen = true;
> >>>  	if (unlikely(status != BLK_STS_OK && nvme_req_needs_retry(req))) {
> >>>-		if ((req->cmd_flags & REQ_NVME_MPATH) && nvme_failover_req(req))
> >>>+		if (!nvme_status_needs_local_error_handling(nvme_status) &&
> >>>+		    (req->cmd_flags & REQ_NVME_MPATH) && nvme_failover_req(req))
> >>
> >>This looks no affect. if work with nvme multipath, now is already retry local.
> >
> >Not if NVMe is built without multipathing configured.
>
> If without nvme multipathing configured, now is also retry local, do not need
> !nvme_status_needs_local_error_handling(nvme_status).

True, REQ_NVME_MPATH won't be set, so it'll fall through.

The real benefit of my patch is that there is a cleaner code flow for
handling errors with normal NVMe retry (without bouncing into failover
code and then falling back to normal retry -- code that your patch does
remove).

SO my change is an obvious yet small improvement that makes the NVMe
core error handling clearer -- yet preserves that fallback from
failover_retry to help future-proof NVMe from new NVME_SC: which John
M. is very clear about needing.

> >>If work with dm-multipath, still return error.
> >
> >Yes, I'm aware.  Use of REQ_FAILFAST_TRANSPORT isn't something that is
> >needed for NVMe, so why are you proposing hacks in NVMe to deal with it?
> I just describe the possible scenarios:1.nvme multipathing configured.
> 2.without any multipath.3. with dm-multipath.

I understand.

> >
> >>>  			return;
> >>>  		if (!blk_queue_dying(req->q)) {
> >>>
> >>
> >>Suggest:
> >>REQ_FAILFAST_TRANSPORT may be designed for scsi, because scsi protocol
> >>do not difine the local retry mechanism. SCSI implements a fuzzy local
> >>retry mechanism, so need the REQ_FAILFAST_TRANSPORT for multipath
> >>software, multipath software retry according error code is expected.
> >>nvme is different with scsi about this. It define local retry mechanism
> >>and path error code, so nvme should not care REQ_FAILFAST_TRANSPORT.
> >
> >Exactly.  Except by "nvme should not care REQ_FAILFAST_TRANSPORT." your
> >patch says you mean "nvme shouldn't disallow retry if
> >REQ_FAILFAST_TRANSPORT is it".  I'm saying: don't try to get such
> >changes into NVMe.
>
> no. the patch just mean: if path error, fail over to retry by multipath
> (nvme multipath or dm-multipath). Other need local retry local, retry
> after a defined time according to status(CRD) and CRDT. Now nvme multipath
> is already do like this, the patch make dm-multipath work like nvme multipath.

I appreciate your enthusiasm for making native NVMe multipathing and
dm-multipath coexist.

But I think you're naive about the willingness to make that a reality.

As such, any change that only benefits dm-multipath is dead on arrival.
Your patch is mixed with various changes like that.  I'd be stunned if
Christoph accepted it.

Thanks,
Mike
