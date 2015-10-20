From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 10/12] block: move blk_integrity to request_queue
Date: Mon, 19 Oct 2015 22:24:27 -0400
Message-ID: <yq1fv16gtus.fsf@sermon.lab.mkp.net>
References: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
	<20151015200034.20721.23425.stgit@dwillia2-desk3.jf.intel.com>
	<1444956139.2737.7.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444956139.2737.7.camel@intel.com> (Dan J. Williams's message of
	"Fri, 16 Oct 2015 00:42:19 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

>>>>> "Dan" == Williams, Dan J <dan.j.williams@intel.com> writes:

Dan> Martin pointed out that I broke compatibility by changing the sysfs
Dan> layout of the integrity attributes.  Rather than add a sysfs-link
Dan> we can make this patch simpler by only moving struct blk_integrity
Dan> to request_queue and leave integrity_kobj where it is in gendisk.

Dan> Also undo the conversion of blk_integrity apis take a
Dan> request_queue.  Through this simplification I also noticed that I
Dan> had broken blk_integrity_compare()

Dan> Here's the much smaller v3, and I also refreshed
Dan> for-4.4/blk-integrity

Much better.

I ran some test on our combined trees over the weekend and tripped a bug
on some SCSI configs. Turned out to be my fault so I'll repost with a
fixed patch 2.

You can either rebase on top of the new series or maybe Jens will merge
my patches first. Either way works for me.

In any case I'm OK with your latest changes. Feel free to add my
Acked-by.

-- 
Martin K. Petersen	Oracle Linux Engineering
