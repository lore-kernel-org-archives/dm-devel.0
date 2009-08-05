From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: expose dm-stripe target's topology I/O hints
Date: Wed, 5 Aug 2009 09:07:51 -0400
Message-ID: <20090805130751.GA20921@redhat.com>
References: <1247261592-9803-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1247261592-9803-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Fri, Jul 10 2009 at  5:33pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Add .io_hints to 'struct target_type' to allow the I/O hints portion of
> the 'struct queue_limits' to be set by each target.  Expose dm-stripe
> target's topology I/O hints.
> 
> NOTE: This patch makes use of blk_limits_io_min(); which will be
> upstream, via the block tree, in the near future.

Linus has pulled in the block changes that this patch depends on; see
linux-2.6 commits:
7c958e32649e0c35801762878fb0b6da8c55a515
70dd5bf3b99964d52862ad2810c24cc32a553535

So this .io_hints patch is good to go upstream now.

Mike
