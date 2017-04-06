From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: kill req->errors
Date: Thu, 6 Apr 2017 16:00:24 -0400
Message-ID: <20170406200024.GC6140@localhost.localdomain>
References: <20170406153944.10058-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170406153944.10058-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Apr 06, 2017 at 05:39:19PM +0200, Christoph Hellwig wrote:
> Currently the request structure has an errors field that is used in
> various different ways.  The oldest drivers use it as an error count,
> blk-mq and the generic timeout code assume that it holds a Linux
> errno for block completions, and various drivers use it for internal
> status values, often overwriting them with Linux errnos later,
> that is unless they are processing passthrough requests in which
> case they'll leave their errors in it.
> 
> This series kills the ->errors field and replaced it with new fields
> in the drivers (or an odd hack in a union in struct request for
> two bitrotting old drivers).
> 
> Note that this series expects that the patch to remove the mg_disk
> driver has been applied already on top of the block for-next tree.

You wouldn't have a git tree to easily test it? Thanks.
