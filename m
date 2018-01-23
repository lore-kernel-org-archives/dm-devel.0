From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 23 Jan 2018 22:27:10 +0800
Message-ID: <20180123142709.GC9792@ming.t460p>
References: <20180123105611.7389-1-ming.lei@redhat.com>
 <yq1zi54hfcu.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1zi54hfcu.fsf@oracle.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Laurence Oberman <loberman@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

Hello Martin,

On Tue, Jan 23, 2018 at 08:30:41AM -0500, Martin K. Petersen wrote:
> 
> Ming,
> 
> > + * Block layer and block driver specific status, which is ususally returnd
>                                                                       ^^^^^^^
> > + * from driver to block layer in IO path.
> 
> Given that the comment blurb is long and the flag not defined until
> later, it is not entirely obvious that you are documenting
> BLK_STS_DEV_RESOURCE. So please make that clear at the beginning of the
> comment.

OK, how about the following document?

/*
 * BLK_STS_DEV_RESOURC: Block layer and block driver specific status,
 * which is usually returned from driver to block layer in IO path.
 *
 * BLK_STS_DEV_RESOURCE is returned from driver to block layer if device
 * related resource is run out of, but driver can guarantee that queue
 * will be rerun in future for dispatching the current request when this
 * resource is available.
 *
 * Difference with BLK_STS_RESOURCE:
 * If driver isn't sure if the queue can be run again for dealing with the
 * current request after this kind of resource is available, please return
 * BLK_STS_SOURCE, for example, when memory allocation, DMA Mapping or other
 * system resource allocation fails and IO can't be submitted to device,
 * BLK_STS_RESOURCE should be used for avoiding IO hang.
 */
#define BLK_STS_DEV_RESOURCE	((__force blk_status_t)13)

Thanks,
Ming
