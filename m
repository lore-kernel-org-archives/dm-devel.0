From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v3 00/10] dm: zoned block device support
Date: Thu, 18 May 2017 08:47:10 -0700
Message-ID: <0b55c380-0ca2-94a0-33c6-1b1831e18cf9@wdc.com>
References: <20170508234052.32375-1-bart.vanassche@sandisk.com>
	<20170516200356.GA17063@redhat.com>
	<20170517185434.GC21862@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517185434.GC21862@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Note: I'm resending this e-mail on Damien's behalf because Damien's ]
[ e-mails apparently do not reach the dm-devel mailing list - Bart.   ]

Mike,

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
vendor that those disk are supported correctly in Linux. So we will
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
