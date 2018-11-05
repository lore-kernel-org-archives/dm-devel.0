From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [RFC PATCH] dm: Check for device sector overflow if
 CONFIG_LBDAF is not set
Date: Mon, 5 Nov 2018 13:35:05 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1811051333580.28808@file01.intranet.prod.int.rdu2.redhat.com>
References: <20181104134234.13597-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181104134234.13597-1-gmazyland@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids



On Sun, 4 Nov 2018, Milan Broz wrote:

> Reference to a device in device-mapper table contains offset in sectors.
> 
> If the sector_t is 32bit integer (CONFIG_LBDAF is not set), then
> several device-mapper targets can overflow this offset and validity
> check is then performad on wrong offset and wrong table is activated.
> 
> See for example (on 32bit without CONFIG_LBDAF) this overflow:
> 
>   # dmsetup create test --table "0 2048 linear /dev/sdg 4294967297"
>   # dmsetup table test
>   0 2048 linear 8:96 1
> 
> In this patch I tried to add check for this problem to dm-linear and dm-crypt,
> but I am sure there are more places and I am not sure this is the proper way.
> 
> Should we use uint64_t in DM internally for device offset instead?
> 
> There are probably some internal calculations in dm-table.c that
> can overflow as well.
> 
> NOTE: it is a RFC patch that is incomplete (more targets need fixes).

OK.

But the condition "sizeof(cc->start) < sizeof(tmpll)" could be dropped, 
the compiler will optimize out "cc->start != tmpll" if the types have the 
same width.

Mikulas

> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---
>  drivers/md/dm-crypt.c  | 4 ++++
>  drivers/md/dm-linear.c | 4 ++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 49be7a6a2e81..008fc40ef84b 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -2786,6 +2786,10 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  		goto bad;
>  	}
>  	cc->start = tmpll;
> +	if (sizeof(cc->start) < sizeof(tmpll) && cc->start != tmpll) {
> +		ti->error = "Device sector overflow";
> +		goto bad;
> +	}
>  
>  	if (crypt_integrity_aead(cc) || cc->integrity_iv_size) {
>  		ret = crypt_integrity_ctr(cc, ti);
> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> index 8d7ddee6ac4d..b5a0065d1436 100644
> --- a/drivers/md/dm-linear.c
> +++ b/drivers/md/dm-linear.c
> @@ -50,6 +50,10 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  		goto bad;
>  	}
>  	lc->start = tmp;
> +	if (sizeof(lc->start) < sizeof(tmp) && lc->start != tmp) {
> +		ti->error = "Device sector overflow";
> +		goto bad;
> +	}
>  
>  	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &lc->dev);
>  	if (ret) {
> -- 
> 2.19.1
> 
