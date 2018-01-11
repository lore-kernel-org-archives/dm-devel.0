From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3 4/5] blk-mq: return dispatch result to caller in
 blk_mq_try_issue_directly
Date: Thu, 11 Jan 2018 17:10:08 -0500
Message-ID: <20180111221007.GC31944@redhat.com>
References: <20180111060159.12991-1-ming.lei@redhat.com>
 <20180111060159.12991-5-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180111060159.12991-5-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Thu, Jan 11 2018 at  1:01am -0500,
Ming Lei <ming.lei@redhat.com> wrote:

> In the following patch, we will use blk_mq_try_issue_directly() for DM
> to return the dispatch result, and DM need this informatin to improve
> IO merge.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>
