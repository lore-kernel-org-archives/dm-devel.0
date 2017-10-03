From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V5 5/8] block: add check on elevator for supporting bio
 merge via hashtable from blk-mq sw queue
Date: Tue, 3 Oct 2017 02:17:46 -0700
Message-ID: <20171003091746.GC2771@infradead.org>
References: <20170930112655.31451-1-ming.lei@redhat.com>
 <20170930112655.31451-6-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170930112655.31451-6-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>
List-Id: dm-devel.ids

On Sat, Sep 30, 2017 at 07:26:52PM +0800, Ming Lei wrote:
> blk_mq_sched_try_merge() will be reused in following patches
> to support bio merge to blk-mq sw queue, so add checkes to
> related functions which are called from blk_mq_sched_try_merge().

The changes themselves look ok, but don't make sense on their own,
I think this needs to be merged with the code tor actually introduce
the bio merge.
