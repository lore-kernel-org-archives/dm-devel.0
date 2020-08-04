From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH] dm-ebs: Fix incorrect checking for
 REQ_OP_FLUSH.
Date: Tue, 4 Aug 2020 16:53:51 +0200
Message-ID: <4f1d8377-6df2-ec1d-df1b-492d6a192468@redhat.com>
References: <20200731224645.89483-1-jdorminy@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200731224645.89483-1-jdorminy@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Dorminy <jdorminy@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Acked-by: Heinz Mauelshagen <heinzm@redhat.com>

On 8/1/20 12:46 AM, John Dorminy wrote:
> REQ_OP_FLUSH was being treated as a flag, but the operation
> part of bio->bi_opf must be treated as a whole. Change to
> accessing the operation part via bio_op(bio) and checking
> for equality.
>
> Signed-off-by: John Dorminy <jdorminy@redhat.com>
> ---
>   drivers/md/dm-ebs-target.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
> index 44451276f128..cb85610527c2 100644
> --- a/drivers/md/dm-ebs-target.c
> +++ b/drivers/md/dm-ebs-target.c
> @@ -363,7 +363,7 @@ static int ebs_map(struct dm_target *ti, struct bio *bio)
>   	bio_set_dev(bio, ec->dev->bdev);
>   	bio->bi_iter.bi_sector = ec->start + dm_target_offset(ti, bio->bi_iter.bi_sector);
>   
> -	if (unlikely(bio->bi_opf & REQ_OP_FLUSH))
> +	if (unlikely(bio_op(bio) == REQ_OP_FLUSH))
>   		return DM_MAPIO_REMAPPED;
>   	/*
>   	 * Only queue for bufio processing in case of partial
