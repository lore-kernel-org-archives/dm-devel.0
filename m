From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/5] Failover criteria unification
Date: Mon, 8 Jan 2018 10:58:51 +0100
Message-ID: <20180108095851.GF4673@lst.de>
References: <20180104224623.8944-1-keith.busch@intel.com> <20180104233627.GA16051@redhat.com> <20180104234727.GA15654@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180104234727.GA15654@localhost.localdomain>
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>
List-Id: dm-devel.ids

On Thu, Jan 04, 2018 at 04:47:27PM -0700, Keith Busch wrote:
> It looks like you can also touch up dm to allow it to multipath nvme
> even if CONFIG_NVME_MULTIPATH is set. It may be useful since native NVMe
> doesn't multipath namespaces across subsystems, and some crack smoking
> people want to create something that requires that.

Right now that is simply not allowed by the spec.  If Dave comes up
with a palatable way to retrofit that into the spec we'll support it.
