From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] nvme: Add more command status translation
Date: Mon, 8 Jan 2018 11:19:37 +0100
Message-ID: <20180108101937.GA5423@lst.de>
References: <20180104224623.8944-1-keith.busch@intel.com> <20180104224623.8944-2-keith.busch@intel.com> <20180108095512.GC4673@lst.de> <2beb72a9-8502-fec8-8892-208cbb0967ac@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2beb72a9-8502-fec8-8892-208cbb0967ac@suse.com>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>
List-Id: dm-devel.ids

On Mon, Jan 08, 2018 at 11:09:03AM +0100, Hannes Reinecke wrote:
> >>  	case NVME_SC_SUCCESS:
> >>  		return BLK_STS_OK;
> >>  	case NVME_SC_CAP_EXCEEDED:
> >> +	case NVME_SC_LBA_RANGE:
> >>  		return BLK_STS_NOSPC;
> > 
> > lba range isn't really enospc.  It is returned when the lba in
> > the command is outside the logical size of the namespace.
> > 
> Isn't that distinction pretty academic?
> The entire block-to-POSIX error mapping is pretty much ad-hoc anyway...

Yes, BLK_STS_NOSPC matters.  And the fix is pretty trivial, so there is
no point in arguing.
