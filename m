From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 1/5] nvme: Add more command status translation
Date: Mon, 8 Jan 2018 09:12:26 -0700
Message-ID: <20180108161226.GB15154@localhost.localdomain>
References: <20180104224623.8944-1-keith.busch@intel.com>
 <20180104224623.8944-2-keith.busch@intel.com>
 <20180108095512.GC4673@lst.de>
 <2beb72a9-8502-fec8-8892-208cbb0967ac@suse.com>
 <20180108101937.GA5423@lst.de>
 <20180108152933.GA9920@redhat.com>
 <20180108153436.GA11632@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180108153436.GA11632@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.com>, Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Jens Axboe <axboe@kernel.dk>, Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>
List-Id: dm-devel.ids

On Mon, Jan 08, 2018 at 04:34:36PM +0100, Christoph Hellwig wrote:
> It's basically a kernel bug as it tries to access lbas that do not
> exist.  BLK_STS_TARGET should be fine.

Okay, I'll fix this and address your other comments, and resend. Thanks
for the feedback.
