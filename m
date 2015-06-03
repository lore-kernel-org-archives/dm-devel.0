From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH for-4.2 2/3] block,
	dm: don't copy bios for	request clones
Date: Wed, 3 Jun 2015 09:37:25 +0200
Message-ID: <20150603073725.GA12072@lst.de>
References: <1432300445-9543-1-git-send-email-snitzer@redhat.com>
	<1432300445-9543-2-git-send-email-snitzer@redhat.com>
	<556410BB.3000103@ce.jp.nec.com> <20150527082157.GA25993@lst.de>
	<5565935A.4060408@ce.jp.nec.com>
	<5566B7E5.1070101@ce.jp.nec.com> <20150529165451.GA2682@lst.de>
	<556BB1F1.4030404@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <556BB1F1.4030404@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 01, 2015 at 01:14:26AM +0000, Junichi Nomura wrote:
> > But if we only do that once on
> > path fail over it's not an actual issue.
> 
> But with your patch, the fail over happens after full completion
> of the request. Is it ok?

At least for SCSI it is, although the reason why is very subtile:

From scsi_io_completion:

	/*
	 * If we finished all bytes in the request we are done now.
	 */
	if (!scsi_end_request(req, error, good_bytes, 0))
		return;

	/*
	 * Kill remainder if no retrys.
	 */
	if (error && scsi_noretry_cmd(cmd)) {
		if (scsi_end_request(req, error, blk_rq_bytes(req), 0))
			BUG();
		return;
	}

So for a noretry command send from dm-mpath we will never leave a command
that had an error completion around, even if it was a partial completion.

Relying on the LLDDs to get this right seems rather dangerous, though, so
it might make sense to lift the above sequence to core code after a careful
audit of other drivers to see if and how they handle partial completions.
