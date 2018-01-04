From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/5] Failover criteria unification
Date: Thu, 4 Jan 2018 18:36:27 -0500
Message-ID: <20180104233627.GA16051@redhat.com>
References: <20180104224623.8944-1-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180104224623.8944-1-keith.busch@intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>
List-Id: dm-devel.ids

On Thu, Jan 04 2018 at  5:46pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> The nvme native multipath provided a separate NVMe status decoder,
> complicating maintenance as new statuses need to be accounted for. This
> was already diverging from the generic nvme status decoder, which has
> implications for other components that rely on accurate generic block
> errors.
> 
> This series unifies common code among nvme and device-mapper multipath
> so that user experience regarding the failover fate of a command is the
> same.
> 
> Mike:
> 
> I split this up because I thought there'd be trouble merging the dm
> mpath update with the inverted retry logic, but I think you may have
> rebased the dm-4.16 without that patch, as I'm not seeing it in the most
> current branch.

Right, I dropped that patch since it'd have only resulted in conflicts
come merge time.  As such, this series can easily go through the nvme
tree to Jens.
