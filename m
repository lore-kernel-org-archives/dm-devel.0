From: Christoph Hellwig <hch@lst.de>
Subject: Re: Patch to issue pure flushes directly (Was: Re:
	[PATCH v6 0/4] ext4: Coordinate data-only flush requests
	sent) by fsync
Date: Sat, 8 Jan 2011 08:45:24 +0100
Message-ID: <20110108074524.GA13024__10258.9307622567$1294472852$gmane$org@lst.de>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
	<20101130164124.GA30858@lst.de> <20110107235449.GT21922@thunk.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110107235449.GT21922@thunk.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ted Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@us.ibm.com>, Jens Axboe <axboe@kernel.dk>, Neil Brown <neilb@suse.de>, Andreas
List-Id: dm-devel.ids

On Fri, Jan 07, 2011 at 06:54:49PM -0500, Ted Ts'o wrote:
> This patch seemed like a good idea to me; I just checked linux-next,
> and looks like nothing like this is planned to be merged.  Just
> thought I would send a prod-o-gram to see what the current thinking
> was around adding something like this.

I haven't really gotten any feedback on the patch, so it fell on the
floor for a while.  I've managed to get some big system resources to
test the impact of it, and once I've got numbers I'll resend it as
separate patches for scsi and the block layer.
