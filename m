From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V8 01/11] block: clone nr_integrity_segments and write_hint in blk_rq_prep_clone
Date: Fri, 24 Apr 2020 12:11:31 -0400
Message-ID: <yq1zhb0eudo.fsf@oracle.com>
References: <20200424102351.475641-1-ming.lei@redhat.com>
        <20200424102351.475641-2-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200424102351.475641-2-ming.lei@redhat.com> (Ming Lei's message
        of "Fri, 24 Apr 2020 18:23:41 +0800")
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, John Garry <john.garry@huawei.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Thomas Gleixner <tglx@linutronix.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids


Ming,

> So far blk_rq_prep_clone() is only used for setup one underlying
> cloned request from dm-rq request. block intetrity can be enabled for
> both dm-rq and the underlying queues, so it is reasonable to clone
> rq's nr_integrity_segments. Also write_hint is from bio, it should
> have been cloned too.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
