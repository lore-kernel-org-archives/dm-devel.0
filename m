From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 0/5] Failover criteria unification
Date: Thu, 4 Jan 2018 16:47:27 -0700
Message-ID: <20180104234727.GA15654@localhost.localdomain>
References: <20180104224623.8944-1-keith.busch@intel.com>
 <20180104233627.GA16051@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180104233627.GA16051@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>
List-Id: dm-devel.ids

On Thu, Jan 04, 2018 at 06:36:27PM -0500, Mike Snitzer wrote:
> Right, I dropped that patch since it'd have only resulted in conflicts
> come merge time.  As such, this series can easily go through the nvme
> tree to Jens.

It looks like you can also touch up dm to allow it to multipath nvme
even if CONFIG_NVME_MULTIPATH is set. It may be useful since native NVMe
doesn't multipath namespaces across subsystems, and some crack smoking
people want to create something that requires that.
