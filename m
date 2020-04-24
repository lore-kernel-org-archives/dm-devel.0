From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V8 02/11] block: add helper for copying request
Date: Fri, 24 Apr 2020 12:12:25 -0400
Message-ID: <yq1v9loeuc6.fsf@oracle.com>
References: <20200424102351.475641-1-ming.lei@redhat.com>
        <20200424102351.475641-3-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200424102351.475641-3-ming.lei@redhat.com> (Ming Lei's message
        of "Fri, 24 Apr 2020 18:23:42 +0800")
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, John Garry <john.garry@huawei.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Thomas Gleixner <tglx@linutronix.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids


Ming,

> Add one new helper of blk_rq_copy_request() to copy request, and the
> helper will be used in this patch for re-submitting request, so make
> it as a block layer internal helper.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
