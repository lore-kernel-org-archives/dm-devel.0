From: Jan Blunck <jblunck@suse.de>
Subject: Re: [patch 01/11] dm-snap: Replace special round_down()
Date: Sun, 12 Aug 2007 17:20:01 +0000 (UTC)
Message-ID: <f9nfg1$bnd$1@sea.gmane.org>
References: <20070810200204.455820246@suse.de>
	<25205.2138712772$1186776751@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S936994AbXHLRUf@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 10 Aug 2007 22:02:05 +0200, Jan Blunck wrote:

> This patch removes the special round_down() to next power of 2 implementation
> used only at one place in the snapshot target. It is replaced by an equivalent
> 1 << fls() which might use an architecture specific implementation.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> ---
>  drivers/md/dm-snap.c |   12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> --- a/drivers/md/dm-snap.c
> +++ b/drivers/md/dm-snap.c
> @@ -333,16 +333,6 @@ static int calc_max_buckets(void)
>  }
>  
>  /*
> - * Rounds a number down to a power of 2.
> - */
> -static uint32_t round_down(uint32_t n)
> -{
> -	while (n & (n - 1))
> -		n &= (n - 1);
> -	return n;
> -}
> -
> -/*
>   * Allocate room for a suitable hash table.
>   */
>  static int init_hash_tables(struct dm_snapshot *s)
> @@ -361,7 +351,7 @@ static int init_hash_tables(struct dm_sn
>  	hash_size = min(hash_size, max_buckets);
>  
>  	/* Round it down to a power of 2 */
> -	hash_size = round_down(hash_size);
> +	hash_size = 1 << fls(hash_size);
>  	if (init_exception_table(&s->complete, hash_size))
>  		return -ENOMEM;
>  
>

Err, this is sooo stupid. First, 1 << fls(n) isn't round down but
roundup_pow_of_2(). Second, hash_size is of type sector_t which could be
u64 with CONFIG_LBD.

-- 
Subject: dm-snap: Replace special round_down()

This patch removes the special round_down() to next power of 2 implementation
used only at one place in the snapshot target. It is replaced by an equivalent
1 << fls() which might use an architecture specific implementation.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/md/dm-snap.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -333,16 +333,6 @@ static int calc_max_buckets(void)
 }
 
 /*
- * Rounds a number down to a power of 2.
- */
-static uint32_t round_down(uint32_t n)
-{
-	while (n & (n - 1))
-		n &= (n - 1);
-	return n;
-}
-
-/*
  * Allocate room for a suitable hash table.
  */
 static int init_hash_tables(struct dm_snapshot *s)
@@ -361,7 +351,7 @@ static int init_hash_tables(struct dm_sn
 	hash_size = min(hash_size, max_buckets);
 
 	/* Round it down to a power of 2 */
-	hash_size = round_down(hash_size);
+	hash_size = 1 << (fls_long(hash_size) - 1);
 	if (init_exception_table(&s->complete, hash_size))
 		return -ENOMEM;
