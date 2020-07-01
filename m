From: Mike Snitzer <snitzer@redhat.com>
Subject: NVMe regression, NVMe no longer uses blk_path_error()
Date: Wed, 1 Jul 2020 12:39:42 -0400
Message-ID: <20200701163942.GB27063@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, John Meneghini <johnm@netapp.com>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

IF NVMe's isn't a primary user of blk_path_error() it largely kills
the entire point of blk_path_error(). (And no the response to this must
not be: "that's fine")

This commit shows NVMe's previous continued use of blk_path_error():

  8decf5d5b9f3f7 ("nvme: remove nvme_req_needs_failover")

but then nvme_failover_req() was relatively recently refactored with:

  764e9332098c0 ("nvme-multipath: do not reset on unknown status")

NVMe should've continued to use blk_path_error().  If there was some gap
in error classification that should've been fixed in NVMe.

Instead, with commit 764e9332098c0 NVMe is no longer using retryable
error classifications commonly maintained within block core.  As such it
introduces serious potential for regression with DM multipath no longer
having a shared understanding for what _really_ constitutes a retryable
blk_status_t from NVMe.

Mike
