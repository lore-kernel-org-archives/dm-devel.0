From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V5 8/8] blk-mq: improve bio merge from blk-mq sw queue
Date: Tue, 3 Oct 2017 02:21:43 -0700
Message-ID: <20171003092143.GF2771@infradead.org>
References: <20170930112655.31451-1-ming.lei@redhat.com>
 <20170930112655.31451-9-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170930112655.31451-9-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>
List-Id: dm-devel.ids

This looks generally good to me, but I really worry about the impact
on very high iops devices.  Did you try this e.g. for random reads
from unallocated blocks on an enterprise NVMe SSD?
