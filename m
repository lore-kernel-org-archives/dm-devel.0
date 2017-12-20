From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [dm-devel] [for-4.16 PATCH 4/5] dm mpath: use NVMe error handling
 to know when an error is retryable
Date: Wed, 20 Dec 2017 22:33:54 +0200
Message-ID: <e00058b2-d94e-3c4e-b2d9-4b00c1e28d80@grimberg.me>
References: <20171219210546.65928-1-snitzer@redhat.com>
 <20171219210546.65928-5-snitzer@redhat.com>
 <20171220165812.GB18255@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171220165812.GB18255@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, hch@lst.de, emilne@redhat.com, james.smart@broadcom.com
Cc: Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids


> But interestingly, with my "mptest" link failure test
> (test_01_nvme_offline) I'm not actually seeing NVMe trigger a failure
> that needs a multipath layer (be it NVMe multipath or DM multipath) to
> fail a path and retry the IO.  The pattern is that the link goes down,
> and nvme waits for it to come back (internalizing any failure) and then
> the IO continues.. so no multipath _really_ needed:
> 
> [55284.011286] nvme nvme0: NVME-FC{0}: controller connectivity lost. Awaiting Reconnect
> [55284.020078] nvme nvme1: NVME-FC{1}: controller connectivity lost. Awaiting Reconnect
> [55284.028872] nvme nvme2: NVME-FC{2}: controller connectivity lost. Awaiting Reconnect
> [55284.037658] nvme nvme3: NVME-FC{3}: controller connectivity lost. Awaiting Reconnect
> [55295.157773] nvmet: ctrl 1 keep-alive timer (15 seconds) expired!
> [55295.157775] nvmet: ctrl 4 keep-alive timer (15 seconds) expired!
> [55295.157778] nvmet: ctrl 3 keep-alive timer (15 seconds) expired!
> [55295.157780] nvmet: ctrl 2 keep-alive timer (15 seconds) expired!
> [55295.157781] nvmet: ctrl 4 fatal error occurred!
> [55295.157784] nvmet: ctrl 3 fatal error occurred!
> [55295.157785] nvmet: ctrl 2 fatal error occurred!
> [55295.199816] nvmet: ctrl 1 fatal error occurred!
> [55304.047540] nvme nvme0: NVME-FC{0}: connectivity re-established. Attempting reconnect
> [55304.056533] nvme nvme1: NVME-FC{1}: connectivity re-established. Attempting reconnect
> [55304.066053] nvme nvme2: NVME-FC{2}: connectivity re-established. Attempting reconnect
> [55304.075037] nvme nvme3: NVME-FC{3}: connectivity re-established. Attempting reconnect
> [55304.373776] nvmet: creating controller 1 for subsystem mptestnqn for NQN nqn.2014-08.org.nvmexpress:uuid:00000000-0000-0000-0000-000000000000.
> [55304.373835] nvmet: creating controller 2 for subsystem mptestnqn for NQN nqn.2014-08.org.nvmexpress:uuid:00000000-0000-0000-0000-000000000000.
> [55304.373873] nvmet: creating controller 3 for subsystem mptestnqn for NQN nqn.2014-08.org.nvmexpress:uuid:00000000-0000-0000-0000-000000000000.
> [55304.373879] nvmet: creating controller 4 for subsystem mptestnqn for NQN nqn.2014-08.org.nvmexpress:uuid:00000000-0000-0000-0000-000000000000.
> [55304.430988] nvme nvme0: NVME-FC{0}: controller reconnect complete
> [55304.433124] nvme nvme3: NVME-FC{3}: controller reconnect complete
> [55304.433705] nvme nvme1: NVME-FC{1}: controller reconnect complete
> 
> It seems if we have multipath ontop (again: either NVMe native multipath
> _or_ DM multipath) we'd prefer to have the equivalent of SCSI's
> REQ_FAILFAST_TRANSPORT support?
> 
> But nvme_req_needs_retry() calls blk_noretry_request() which returns
> true if REQ_FAILFAST_TRANSPORT is set.  Which results in
> nvme_req_needs_retry() returning false.  Which causes nvme_complete_rq()
> to skip the multipath specific nvme_req_needs_failover(), etc.
> 
> So all said:
> 
> 1) why wait for connection recovery if we have other connections to try?
> I think NVMe needs to be plumbed for respecting REQ_FAILFAST_TRANSPORT.

This is specific to FC fail fast logic, nvme-rdma will fail inflight
commands as soon as the transport see an error (or keep alive timeout
expires).

It seems that FC wants to wait for the request retries counter to exceed
but given that the queue isn't unquiesced, the requests are quiesced
until the host will successfully reconnect.
