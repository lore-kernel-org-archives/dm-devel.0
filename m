From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/12] blk-integrity lifetime fixes
Date: Thu, 15 Oct 2015 19:53:57 -0400
Message-ID: <yq1io67it7u.fsf@sermon.lab.mkp.net>
References: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
	(Dan Williams's message of "Thu, 15 Oct 2015 15:59:39 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: martin.petersen@oracle.com, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@ml01.01.org, axboe@fb.com, Vishal Verma <vishal.l.verma@intel.com>, James Bottomley <JBottomley@Odin.com>, NeilBrown <neilb@suse.com>, linux-nvme@lists.infradead.org, Sagi Grimberg <sagig@mellanox.com>, dm-devel@redhat.com, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de
List-Id: dm-devel.ids

>>>>> "Dan" == Dan Williams <dan.j.williams@intel.com> writes:

Dan,

Dan> 5/ Fixed up Documentation/ABI/testing/sysfs-block to reflect moving
Dan> "integrity" sysfs attributes from "disk" to "disk/queue".

You can't change an exported interface. Several apps are depending on
it.

-- 
Martin K. Petersen	Oracle Linux Engineering
