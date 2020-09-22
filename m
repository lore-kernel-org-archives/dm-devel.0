From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 4/6] block: allow 'chunk_sectors' to be non-power-of-2
Date: Tue, 22 Sep 2020 15:30:34 -0400
Message-ID: <yq1wo0lpq2d.fsf@ca-mkp.ca.oracle.com>
References: <20200922023251.47712-1-snitzer@redhat.com>
        <20200922023251.47712-5-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200922023251.47712-5-snitzer@redhat.com> (Mike Snitzer's
        message of "Mon, 21 Sep 2020 22:32:49 -0400")
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, Vijayendra Suman <vijayendra.suman@oracle.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids


Mike,

> It is possible, albeit more unlikely, for a block device to have a non
> power-of-2 for chunk_sectors (e.g. 10+2 RAID6 with 128K chunk_sectors,
> which results in a full-stripe size of 1280K. This causes the RAID6's
> io_opt to be advertised as 1280K, and a stacked device _could_ then be
> made to use a blocksize, aka chunk_sectors, that matches non
> power-of-2 io_opt of underlying RAID6 -- resulting in stacked device's
> chunk_sectors being a non power-of-2).
>
> Update blk_queue_chunk_sectors() and blk_max_size_offset() to
> accommodate drivers that need a non power-of-2 chunk_sectors.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
