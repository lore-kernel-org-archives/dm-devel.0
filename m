From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] dm verity fec: fix hash block number in
	verity_fec_decode
Date: Fri, 10 Apr 2020 08:41:26 -0700
Message-ID: <CABCJKueSJ4sXHL5xnB5LQVW_6od2+_TEp0y_vv1gdi=yBB1Zfg@mail.gmail.com>
References: <CGME20200410035424epcas1p2d47ca3a171af6a895af17d86e2838269@epcas1p2.samsung.com>
	<b8de2c4b-d8cf-2bdb-f4cf-5b10faf48955@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b8de2c4b-d8cf-2bdb-f4cf-5b10faf48955@samsung.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sunwook Eom <speed.eom@samsung.com>
Cc: =?UTF-8?B?6rCV66y47LKg?= <mcneo.kang@samsung.com>, device-mapper development <dm-devel@redhat.com>, sunwook5492@gmail.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Apr 9, 2020 at 8:54 PM Sunwook Eom <speed.eom@samsung.com> wrote:
>
> The error correction data is computed as if data and hash blocks
> were concatenated. But hash block number is start from v->hash_start.
> So, we have to calculate hash block number based on that.
>
> Fixes: a739ff3f543af ("dm verity: add support for forward error correction")
> Signed-off-by: Sunwook Eom <speed.eom@samsung.com>
> ---
>   drivers/md/dm-verity-fec.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
> index 49147e634046..fb41b4f23c48 100644
> --- a/drivers/md/dm-verity-fec.c
> +++ b/drivers/md/dm-verity-fec.c
> @@ -435,7 +435,7 @@ int verity_fec_decode(struct dm_verity *v, struct
> dm_verity_io *io,
>       fio->level++;
>
>       if (type == DM_VERITY_BLOCK_TYPE_METADATA)
> -        block += v->data_blocks;
> +        block = block - v->hash_start + v->data_blocks;
>
>       /*
>        * For RS(M, N), the continuous FEC data is divided into blocks of N

Thank you for the patch!

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
