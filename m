From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] Fix blkdev_issue_discard()
Date: Wed, 16 Dec 2015 17:48:41 -0500
Message-ID: <yq1poy6t3g6.fsf@sermon.lab.mkp.net>
References: <567034B3.90104@sandisk.com> <20151215154929.GA10785@lst.de>
	<5670499E.9050501@sandisk.com> <yq1k2ofunha.fsf@sermon.lab.mkp.net>
	<20151216051223.GA11688@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151216051223.GA11688@redhat.com> (Mike Snitzer's message of
	"Wed, 16 Dec 2015 00:12:23 -0500")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike,

Mike> DM thinp doesn't support partial thinp block discards -- so
Mike> misaligned/partial discards are dropped by DM thinp.  There isn't
Mike> a compelling case for fixing this (by adding a bitset for each
Mike> thinp block to support finer grained discards) -- at least not
Mike> that I'm aware of.

Mike> But I'm missing exactly what it is your helper function would
Mike> do... and yet you're asking me what my requirements are.. sorry ;)

This came up because the SCSI target would like to support
discard_zeroes_data on top of a backing store that has a discard
granularity bigger than a logical block.

This means that the target code will have to be able to explicitly zero
out head and tail ends of a request. Since you have the same "problem"
in thinp I was wondering if it would make sense to have a common
block layer function for this?

Because the discard granularity is a hint I don't like the idea of
blkdev_issue_zeroout() having to slice and dice. I really think the
decision about what to zero and what to unmap belongs in the entity
managing the allocation units. I.e. target or thinp. But that doesn't
mean that some of the required logic could not be shared in blk-lib.c.

-- 
Martin K. Petersen	Oracle Linux Engineering
