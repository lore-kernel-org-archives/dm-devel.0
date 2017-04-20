From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 02/23] block: remove the blk_execute_rq return value
Date: Thu, 20 Apr 2017 07:11:12 +0200
Message-ID: <20170420051112.GA10822@lst.de>
References: <20170419192708.22098-1-hch@lst.de> <20170419192708.22098-3-hch@lst.de> <1492636063.2543.18.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1492636063.2543.18.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Apr 19, 2017 at 09:07:45PM +0000, Bart Van Assche wrote:
> > +	blk_execute_rq(or->request->q, NULL, or->request, 0);
> > +	error = or->request ? -EIO : 0;
> 
> Hello Christoph,
> 
> Did you perhaps intend or->request->errors instead of or->request?

Yes, thanks.
