From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block: fix an integer overflow in logical block size
Date: Wed, 15 Jan 2020 20:59:29 -0500
Message-ID: <yq1sgkgp3em.fsf@oracle.com>
References: <alpine.LRH.2.02.2001150833180.31494@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.2001150833180.31494@file01.intranet.prod.int.rdu2.redhat.com>
        (Mikulas Patocka's message of "Wed, 15 Jan 2020 08:35:25 -0500 (EST)")
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-block@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids


Mikulas,

> This patch changes the logical block size from unsigned short to
> unsigned int to avoid the overflow.

Looks fine.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
