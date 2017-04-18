From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 17/25] blk-mq: remove the error argument to
 blk_mq_complete_request
Date: Tue, 18 Apr 2017 11:06:09 -0400
Message-ID: <20170418150609.GB12001@char.us.oracle.com>
References: <20170406153944.10058-1-hch@lst.de>
 <20170406153944.10058-18-hch@lst.de>
 <20170418150321.s7yqpt63reutbs24@dhcp-3-128.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170418150321.s7yqpt63reutbs24@dhcp-3-128.uk.xensource.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Apr 18, 2017 at 04:03:21PM +0100, Roger Pau Monné wrote:
> On Thu, Apr 06, 2017 at 05:39:36PM +0200, Christoph Hellwig wrote:
> > Now that we always have a ->complete callback we can remove the direct
> > call to blk_mq_end_request, as well as the error argument to
> > blk_mq_complete_request.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> For blkfront:
> 
> Acked-by: Roger Pau Monné <roger.pau@citrix.com>
> 

And also
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
