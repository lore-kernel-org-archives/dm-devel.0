From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] dm verity: fix no salt used use case
Date: Thu, 18 May 2017 13:03:06 +0200
Message-ID: <9b872fad-6ae3-4709-d744-1f4686f070b9@gmail.com>
References: <1495104445-29753-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1495104445-29753-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gilad Ben-Yossef <gilad@benyossef.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Marian Csontos <mcsontos@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


On 05/18/2017 12:47 PM, Gilad Ben-Yossef wrote:
> DM-Verity has an (undocumented) mode where no salt is used.
> This was never handled directly by the DM-Verity code, instead working due
> to the fact that calling crypto_shash_update() with a zero length data is
> an implicit noop.
> 
> This is no longer the case now that we have switched to
> crypto_ahash_update(). Fix the issue by introducing an explicit handling
> of the no salt use case to DM-Verity.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Reported-by: Marian Csontos <mcsontos@redhat.com>
> Fixes: d1ac3ff ("dm verity: switch to using asynchronous hash crypto API")
> CC: Milan Broz <gmazyland@gmail.com>

Tested-by: Milan Broz <gmazyland@gmail.com>

Thanks for quick fix!

Mike: this must go to 4.12rc (only).

m.


> ---
>  drivers/md/dm-verity-target.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 97de961..1ec9b2c 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -166,7 +166,7 @@ static int verity_hash_init(struct dm_verity *v, struct ahash_request *req,
>  		return r;
>  	}
>  
> -	if (likely(v->version >= 1))
> +	if (likely(v->salt_size && (v->version >= 1)))
>  		r = verity_hash_update(v, req, v->salt, v->salt_size, res);
>  
>  	return r;
> @@ -177,7 +177,7 @@ static int verity_hash_final(struct dm_verity *v, struct ahash_request *req,
>  {
>  	int r;
>  
> -	if (unlikely(!v->version)) {
> +	if (unlikely(v->salt_size && (!v->version))) {
>  		r = verity_hash_update(v, req, v->salt, v->salt_size, res);
>  
>  		if (r < 0) {
> 
