From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/3] block: Improve bio_set_op_attrs() robustness
Date: Wed, 14 Sep 2016 10:55:27 +0200
Message-ID: <20160914085527.mjcurbe2zkbuqzwy@linux-x5ow.site>
References: <35e3cdd6-8983-6c84-cb4c-9a7be15aea55@sandisk.com>
 <2a6c6cbd-ccc6-ee89-99ca-c0267cf17ec0@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2a6c6cbd-ccc6-ee89-99ca-c0267cf17ec0@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Damien Le Moal <Damien.LeMoal@hgst.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Sep 14, 2016 at 10:46:22AM +0200, Bart Van Assche wrote:
> Since REQ_OP_BITS == 3 and __REQ_NR_BITS == 30 it is not that hard
> to pass an op_flags argument to bio_set_op_attrs() that is larger
> than the number of bits reserved for the op_flags argument. Complain
> if this happens. Additionally, ensure that negative arguments trigger
> a complaint (1 << ... is signed while 1U << ... is unsigned; adding
> 0U to an integer expression causes it to be promoted to an unsigned
> type).
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Damien Le Moal <damien.lemoal@hgst.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
