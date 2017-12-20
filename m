From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH 4/5] dm mpath: use NVMe error handling to know
 when an error is retryable
Date: Wed, 20 Dec 2017 11:58:13 -0500
Message-ID: <20171220165812.GB18255@redhat.com>
References: <20171219210546.65928-1-snitzer@redhat.com>
 <20171219210546.65928-5-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171219210546.65928-5-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de, emilne@redhat.com, james.smart@broadcom.com
Cc: Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids

On Tue, Dec 19 2017 at  4:05pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> Like NVMe's native multipath support, DM multipath's NVMe bio-based
> support now allows NVMe core's error handling to requeue an NVMe blk-mq
> request's bios onto DM multipath's queued_bios list for resubmission
> once fail_path() occurs.  multipath_failover_rq() serves as a
> replacement for the traditional multipath_end_io_bio().
> 
> DM multipath's bio submission to NVMe must be done in terms that allow
> the reuse of NVMe core's error handling.  The following care is taken to
> realize this reuse:
> 
> - NVMe core won't attempt to retry an IO if it has
>   REQ_FAILFAST_TRANSPORT set; so only set it in __map_bio().
> 
> - Setup bio's bi_failover_rq hook, to use multipath_failover_rq, so that
>   NVMe blk-mq requests inherit it for use as the failover_rq callback
>   if/when NVMe core determines a request must be retried.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

But interestingly, with my "mptest" link failure test
(test_01_nvme_offline) I'm not actually seeing NVMe trigger a failure
that needs a multipath layer (be it NVMe multipath or DM multipath) to
fail a path and retry the IO.  The pattern is that the link goes down,
and nvme waits for it to come back (internalizing any failure) and then
the IO continues.. so no multipath _really_ needed:

[55284.011286] nvme nvme0: NVME-FC{0}: controller connectivity lost. Awaiting Reconnect
[55284.020078] nvme nvme1: NVME-FC{1}: controller connectivity lost. Awaiting Reconnect
[55284.028872] nvme nvme2: NVME-FC{2}: controller connectivity lost. Awaiting Reconnect
[55284.037658] nvme nvme3: NVME-FC{3}: controller connectivity lost. Awaiting Reconnect
[55295.157773] nvmet: ctrl 1 keep-alive timer (15 seconds) expired!
[55295.157775] nvmet: ctrl 4 keep-alive timer (15 seconds) expired!
[55295.157778] nvmet: ctrl 3 keep-alive timer (15 seconds) expired!
[55295.157780] nvmet: ctrl 2 keep-alive timer (15 seconds) expired!
[55295.157781] nvmet: ctrl 4 fatal error occurred!
[55295.157784] nvmet: ctrl 3 fatal error occurred!
[55295.157785] nvmet: ctrl 2 fatal error occurred!
[55295.199816] nvmet: ctrl 1 fatal error occurred!
[55304.047540] nvme nvme0: NVME-FC{0}: connectivity re-established. Attempting reconnect
[55304.056533] nvme nvme1: NVME-FC{1}: connectivity re-established. Attempting reconnect
[55304.066053] nvme nvme2: NVME-FC{2}: connectivity re-established. Attempting reconnect
[55304.075037] nvme nvme3: NVME-FC{3}: connectivity re-established. Attempting reconnect
[55304.373776] nvmet: creating controller 1 for subsystem mptestnqn for NQN nqn.2014-08.org.nvmexpress:uuid:00000000-0000-0000-0000-000000000000.
[55304.373835] nvmet: creating controller 2 for subsystem mptestnqn for NQN nqn.2014-08.org.nvmexpress:uuid:00000000-0000-0000-0000-000000000000.
[55304.373873] nvmet: creating controller 3 for subsystem mptestnqn for NQN nqn.2014-08.org.nvmexpress:uuid:00000000-0000-0000-0000-000000000000.
[55304.373879] nvmet: creating controller 4 for subsystem mptestnqn for NQN nqn.2014-08.org.nvmexpress:uuid:00000000-0000-0000-0000-000000000000.
[55304.430988] nvme nvme0: NVME-FC{0}: controller reconnect complete
[55304.433124] nvme nvme3: NVME-FC{3}: controller reconnect complete
[55304.433705] nvme nvme1: NVME-FC{1}: controller reconnect complete

It seems if we have multipath ontop (again: either NVMe native multipath
_or_ DM multipath) we'd prefer to have the equivalent of SCSI's
REQ_FAILFAST_TRANSPORT support?

But nvme_req_needs_retry() calls blk_noretry_request() which returns
true if REQ_FAILFAST_TRANSPORT is set.  Which results in
nvme_req_needs_retry() returning false.  Which causes nvme_complete_rq()
to skip the multipath specific nvme_req_needs_failover(), etc.

So all said:

1) why wait for connection recovery if we have other connections to try?
I think NVMe needs to be plumbed for respecting REQ_FAILFAST_TRANSPORT.

2) this avoidance of NVMe retries, or failover, in response to
REQ_FAILFAST_TRANSPORT seems exactly the opposite of desired behaviour
when multipath is available?

Thoughts?

Thanks,
Mike

p.s. given NVMe FC transport isn't letting go of the IO, not failing up
to NVMe core while "awaiting reconnect".. even if "keep-alive timer (15
seconds) expired": I hacked test coverage to verify the correctness and
stability of this patch's multipath_failover_rq() hook by testing
against a dm-flakey device (up 10 sec, down 10 sec) and applying this
patch:

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 5b4c88c..d6df7010 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1685,6 +1685,8 @@ static void multipath_failover_rq(struct request *rq)
 	struct pgpath *pgpath = mpio->pgpath;
 	unsigned long flags;
 
+	WARN_ON_ONCE(1);
+
 	if (pgpath) {
 		if (!ti->skip_end_io_hook) {
 			struct path_selector *ps = &pgpath->pg->ps;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ad4ac29..3b8bc20 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -927,6 +927,7 @@ static int dm_table_determine_type(struct dm_table *t)
 		if (t->type == DM_TYPE_BIO_BASED)
 			return 0;
 		else if (t->type == DM_TYPE_NVME_BIO_BASED) {
+			return 0;
 			if (!dm_table_does_not_support_partial_completion(t)) {
 				DMERR("nvme bio-based is only possible with devices"
 				      " that don't support partial completion");
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 592a018..da88e4c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -182,7 +182,7 @@ static inline bool nvme_req_needs_retry(struct request *req)
 	if (blk_noretry_request(req))
 		return false;
 	if (nvme_req(req)->status & NVME_SC_DNR)
-		return false;
+		return true;
 	if (nvme_req(req)->retries >= nvme_max_retries)
 		return false;
 	return true;
