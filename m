From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 00/12] blk-integrity lifetime fixes
Date: Thu, 15 Oct 2015 17:06:29 -0700
Message-ID: <CAPcyv4gcvPTMQCHeXVt_ECnDM_6bvyFCwATX5e1KCe5eg6sdPA@mail.gmail.com>
References: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
	<yq1io67it7u.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1io67it7u.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-raid <linux-raid@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Jens Axboe <axboe@fb.com>, Vishal Verma <vishal.l.verma@intel.com>, James Bottomley <JBottomley@odin.com>, NeilBrown <neilb@suse.com>, linux-nvme@lists.infradead.org, Sagi Grimberg <sagig@mellanox.com>, dm-devel@redhat.com, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Thu, Oct 15, 2015 at 4:53 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Dan" == Dan Williams <dan.j.williams@intel.com> writes:
>
> Dan,
>
> Dan> 5/ Fixed up Documentation/ABI/testing/sysfs-block to reflect moving
> Dan> "integrity" sysfs attributes from "disk" to "disk/queue".
>
> You can't change an exported interface. Several apps are depending on
> it.

Hmm, add an "integrity" sysfs link for backwards compatibility, or
leave it as a child of the gendisk kobject?  Probably the latter
because it seems fine if the integrity_kobj has follow the gendisk
lifetime even if the struct blk_integrity info follows the
request_queue.
