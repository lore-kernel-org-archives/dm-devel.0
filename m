From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH for-4.12] block, dm: use __blk_integrity_register to properly setup integrity profile
Date: Fri, 21 Apr 2017 18:43:56 -0400
Message-ID: <yq1o9vpjs9f.fsf@oracle.com>
References: <20170421222815.45663-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170421222815.45663-1-snitzer@redhat.com> (Mike Snitzer's
        message of "Fri, 21 Apr 2017 18:28:15 -0400")
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-block@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids


Mike/Mikulas,

> Introduce __blk_integrity_register() to allow users more precise control
> over the logical block size used to register the integrity profile.
> blk_integrity_register() now calls __blk_integrity_register().

This seems a bit kludgy. It would be cleaner having the integrity
interval be explicitly specified in the integrity template for all
callers. Maybe with a fallback to qlbs if it's set to 0.

-- 
Martin K. Petersen	Oracle Linux Engineering
