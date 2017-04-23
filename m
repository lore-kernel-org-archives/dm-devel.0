From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 for-4.12] block: fix blk_integrity_register to use
 template's interval_exp if not 0
Date: Sun, 23 Apr 2017 13:00:37 -0600
Message-ID: <f4d58699-3ae7-1a89-8366-75a4c50c6b53@kernel.dk>
References: <20170421222815.45663-1-snitzer@redhat.com>
 <yq1o9vpjs9f.fsf@oracle.com> <20170422151043.GA22651@redhat.com>
 <20170422212209.GA49088@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170422212209.GA49088@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On 04/22/2017 03:22 PM, Mike Snitzer wrote:
> When registering an integrity profile: if the template's interval_exp is
> not 0 use it, otherwise use the ilog2() of logical block size of the
> provided gendisk.
> 
> This fixes a long-standing DM linear target bug where it cannot pass
> integrity data to the underlying device if its logical block size
> conflicts with the underlying device's logical block size.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-integrity.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Jens, please feel free to pick this up for 4.12 and I'll just make the
> dm-integrity commit Depends-on it once you've staged it.

OK, I'll commit it. I'll send out my pull request as soon as the merge
window opens, so you should not have any delays.

-- 
Jens Axboe
