From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 for-4.12] block: fix blk_integrity_register to use template's interval_exp if not 0
Date: Sun, 23 Apr 2017 14:42:37 -0400
Message-ID: <yq1inlvj78i.fsf@oracle.com>
References: <20170421222815.45663-1-snitzer@redhat.com>
        <yq1o9vpjs9f.fsf@oracle.com> <20170422151043.GA22651@redhat.com>
        <20170422212209.GA49088@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170422212209.GA49088@redhat.com> (Mike Snitzer's message of
        "Sat, 22 Apr 2017 17:22:09 -0400")
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, linux-block@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids


Mike,

> When registering an integrity profile: if the template's interval_exp is
> not 0 use it, otherwise use the ilog2() of logical block size of the
> provided gendisk.
>
> This fixes a long-standing DM linear target bug where it cannot pass
> integrity data to the underlying device if its logical block size
> conflicts with the underlying device's logical block size.

Looks good!

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
