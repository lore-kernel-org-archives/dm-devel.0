From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3 3/5] blk-mq: move actual issue into one helper
Date: Thu, 11 Jan 2018 17:09:05 -0500
Message-ID: <20180111220905.GB31944@redhat.com>
References: <20180111060159.12991-1-ming.lei@redhat.com>
 <20180111060159.12991-4-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180111060159.12991-4-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Thu, Jan 11 2018 at  1:01am -0500,
Ming Lei <ming.lei@redhat.com> wrote:

> No functional change, just to clean up code a bit, so that the following
> change of using direct issue for blk_mq_request_bypass_insert() which is
> needed by DM can be easier to do.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>
