From: Christoph Hellwig <hch@lst.de>
Subject: Re: PR API fixes for multipathing
Date: Sun, 17 Jul 2016 03:28:10 +0200
Message-ID: <20160717012809.GB10263@lst.de>
References: <1467980631-18945-1-git-send-email-hch@lst.de> <yq1y452iuzp.fsf@sermon.lab.mkp.net> <20160716010844.GA29087@lst.de> <20160716181007.GA14215@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160716181007.GA14215@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: dm-devel.ids

On Sat, Jul 16, 2016 at 02:10:07PM -0400, Mike Snitzer wrote:
> Christoph, I had to fix this:
> 
> drivers/md/dm.c:2564:12: warning: context imbalance in 'dm_call_pr' - different lock contexts for basic block

That's coming from sparse?  Guess I need to update my sparse version..

> here is the incremental I folded in to the dm patch:

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
