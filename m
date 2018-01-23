From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V2] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 23 Jan 2018 09:44:19 -0500
Message-ID: <20180123144419.GA25384@redhat.com>
References: <20180123105611.7389-1-ming.lei@redhat.com>
	<yq1zi54hfcu.fsf@oracle.com> <20180123142709.GC9792@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180123142709.GC9792@ming.t460p>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Laurence Oberman <loberman@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Tue, Jan 23 2018 at  9:27am -0500,
Ming Lei <ming.lei@redhat.com> wrote:

> Hello Martin,
> 
> On Tue, Jan 23, 2018 at 08:30:41AM -0500, Martin K. Petersen wrote:
> > 
> > Ming,
> > 
> > > + * Block layer and block driver specific status, which is ususally returnd
> >                                                                       ^^^^^^^
> > > + * from driver to block layer in IO path.
> > 
> > Given that the comment blurb is long and the flag not defined until
> > later, it is not entirely obvious that you are documenting
> > BLK_STS_DEV_RESOURCE. So please make that clear at the beginning of the
> > comment.
> 
> OK, how about the following document?
> 
> /*
>  * BLK_STS_DEV_RESOURC: Block layer and block driver specific status,
     ^^^^^^^^^^^^^^^^^^^ typo

>  * which is usually returned from driver to block layer in IO path.
>  *
>  * BLK_STS_DEV_RESOURCE is returned from driver to block layer if device
>  * related resource is run out of, but driver can guarantee that queue
>  * will be rerun in future for dispatching the current request when this
>  * resource is available.
>  *
>  * Difference with BLK_STS_RESOURCE:
>  * If driver isn't sure if the queue can be run again for dealing with the
>  * current request after this kind of resource is available, please return
>  * BLK_STS_SOURCE, for example, when memory allocation, DMA Mapping or other
     ^^^^^^^^^^^^^^ typo

>  * system resource allocation fails and IO can't be submitted to device,
>  * BLK_STS_RESOURCE should be used for avoiding IO hang.
>  */

In general the 2nd paragraph is one big run-on sentence.  Needs some
isolation.
