From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/2] Fix blkdev_issue_discard()
Date: Wed, 16 Dec 2015 00:12:23 -0500
Message-ID: <20151216051223.GA11688@redhat.com>
References: <567034B3.90104@sandisk.com> <20151215154929.GA10785@lst.de>
	<5670499E.9050501@sandisk.com> <yq1k2ofunha.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1k2ofunha.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Tue, Dec 15 2015 at  9:38pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:
> 
> Bart> Should the caller of blkdev_issue_discard() implement this or
> Bart> should this functionality be added in blkdev_issue_discard()
> Bart> itself ?
> 
> I'm very much against dropping information in the ioctl/filesystem
> submission path. But I am not against having a helper function of some
> sort that DM and target could use to handle heads and tails.
> 
> Right now DM does not handle this and I think it would be worthwhile to
> have. Mike, what are your requirements?

If the discard doesn't conform to the device's stacked discard limits
then yes the head and/or tail will get dropped on the floor.

Not sure why DM is being made the focal point on this.  Are you thinking
specifically about DM-thinp and its discard_granularity?  DM thinp
doesn't support partial thinp block discards -- so misaligned/partial
discards are dropped by DM thinp.  There isn't a compelling case for
fixing this (by adding a bitset for each thinp block to support finer
grained discards) -- at least not that I'm aware of.

But I'm missing exactly what it is your helper function would do... and
yet you're asking me what my requirements are.. sorry ;)
