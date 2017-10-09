From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V5 8/8] blk-mq: improve bio merge from blk-mq sw queue
Date: Mon, 9 Oct 2017 12:28:37 +0800
Message-ID: <20171009042835.GA19029@ming.t460p>
References: <20170930112655.31451-1-ming.lei@redhat.com>
 <20170930112655.31451-9-ming.lei@redhat.com>
 <20171003092143.GF2771@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171003092143.GF2771@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>
List-Id: dm-devel.ids

On Tue, Oct 03, 2017 at 02:21:43AM -0700, Christoph Hellwig wrote:
> This looks generally good to me, but I really worry about the impact
> on very high iops devices.  Did you try this e.g. for random reads
> from unallocated blocks on an enterprise NVMe SSD?

Looks no such impact, please see the following data
in the fio test(libaio, direct, bs=4k, 64jobs, randread, none scheduler)

[root@storageqe-62 results]# ../parse_fio 4.14.0-rc2.no_blk_mq_perf+-nvme-64jobs-mq-none.log 4.14.0-rc2.BLK_MQ_PERF_V5+-nvme-64jobs-mq-none.log
---------------------------------------
 IOPS(K)  |    NONE     |    NONE
---------------------------------------
randread  |      650.98 |      653.15
---------------------------------------

OR:

If you worry about this impact, can we simply disable merge on NVMe
for none scheduler? It is basically impossible to merge NVMe's
request/bio when none is used, but it can be doable in case of kyber
scheduler.

-- 
Ming
