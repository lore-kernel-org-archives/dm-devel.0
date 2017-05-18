From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v3 00/10] dm: zoned block device support
Date: Thu, 18 May 2017 01:55:15 +0000
Message-ID: <22BA92ED-D53B-4206-9DF3-BDFBB6F3E1DB@hgst.com>
References: <20170508234052.32375-1-bart.vanassche@sandisk.com>
	<20170516200356.GA17063@redhat.com> <20170517185434.GC21862@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517185434.GC21862@redhat.com>
Content-Language: en-US
Content-ID: <9C05229588641444B9496B1B042B90C2@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Mike,

(resending using outlook as I am still having troubles reaching
@redhat.com email domain with any other email client. My apologies
if multiple copies of this email show up)

On 5/18/17 03:54, Mike Snitzer wrote:
> On Tue, May 16 2017 at  4:03pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
>> I see quite a few issues with this patchset (only gotten through patches
>> 1 - 6).  I'll work through it in more detail and share my
>> feedback/revisions tomorrow.  Mostly just cleanups, renames, etc.  But
>> "the fun" is obviously once I get to the last patch.
>
> FYI, couldn't get to this like I planned.  And I'm taking some time off,
> won't get back to this until next Tuesday (5/23).  To be clear, the
> things I noticed in the preliminary patches were very benign, but do
> need cleaning up.

Thank you for the review. Let me know the changes you would like to see
and I will send an updated series.

> I have every intention of getting this reviewed and staged for 4.13.

That's great. Thanks.

> But would be useful to understand:
> 1) who will be regression testing this target once it is merged?

Myself, Bart, and all other members of my team will be involved in
maintaining and testing this. It is critical for us as an SMR disk
vendor that those disks are supported correctly in Linux. So we will
maintain and regression test all aspects of the zoned block device
support constantly.

> 2) what is needed to test it? (I assume SMR drives?)

Yes, SMR drives, but not necessarily physical ones. We are working on
adding ZBC support to the SCSI target (that is missing). With that, we
are planning to create a tcm (or tcmu) driver to emulate a host-aware or
host-managed disk for testing, with a regular disk or file as back-end
storage. This was also requested by file system maintainers (BtrFS) to
allow testing of zoned block device support even without physical SMR
disks available.

Since zoned block device support spans the entire block I/O stack (from
block layer API down to LLD, with device mapper and SCSI/libata in the
middle) we are also starting to design new test cases for the newly
released blktests infrastructure. This will allow automated testing,
including device mapper targets that supports zoned block devices.

Ideally, we will try to release everything for inclusion in 4.13,
together with the device mapper support. But all the test parts may get
spread over one or two release cycles. But again, the goal is to have a
comprehensive automated test suite for zoned block device, similar to
what is available for regular block devices.

Best regards.

-- 
Damien Le Moal,
Western Digital Research


Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
