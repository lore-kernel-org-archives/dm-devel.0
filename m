From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 23 Jan 2018 08:30:41 -0500
Message-ID: <yq1zi54hfcu.fsf@oracle.com>
References: <20180123105611.7389-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180123105611.7389-1-ming.lei@redhat.com> (Ming Lei's message
        of "Tue, 23 Jan 2018 18:56:11 +0800")
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Laurence Oberman <loberman@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids


Ming,

> + * Block layer and block driver specific status, which is ususally returnd
                                                                      ^^^^^^^
> + * from driver to block layer in IO path.

Given that the comment blurb is long and the flag not defined until
later, it is not entirely obvious that you are documenting
BLK_STS_DEV_RESOURCE. So please make that clear at the beginning of the
comment.

> + * If driver isn't sure if the queue can be run again for dealing with the
> + * current request after this kind of resource is available, please return
> + * BLK_STS_SOURCE, for example, when memory allocation, DMA Mapping or other
      ^^^^^^^^^^^^^^

-- 
Martin K. Petersen	Oracle Linux Engineering
