From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4/7] dm-crypt: remove io_pool
Date: Fri, 13 Feb 2015 16:17:20 -0500
Message-ID: <20150213211720.GB7180@redhat.com>
References: <alpine.LRH.2.02.1502130824500.6449@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1502130824500.6449@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 13 2015 at  8:25P -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Remove io_pool and _crypt_io_pool because they are unused.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-crypt.c |   21 +--------------------
>  1 file changed, 1 insertion(+), 20 deletions(-)
> 
> Index: linux-3.18-rc1/drivers/md/dm-crypt.c
> ===================================================================
> --- linux-3.18-rc1.orig/drivers/md/dm-crypt.c	2014-10-21 00:49:34.000000000 +0200
> +++ linux-3.18-rc1/drivers/md/dm-crypt.c	2014-10-21 00:49:37.000000000 +0200
> @@ -1946,14 +1933,9 @@ static int __init dm_crypt_init(void)
>  {
>  	int r;
>  
> -	_crypt_io_pool = KMEM_CACHE(dm_crypt_io, 0);
> -	if (!_crypt_io_pool)
> -		return -ENOMEM;
> -
>  	r = dm_register_target(&crypt_target);
>  	if (r < 0) {
>  		DMERR("register failed %d", r);
> -		kmem_cache_destroy(_crypt_io_pool);
>  	}
>  
>  	return r;

I folded this in:

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index e6a1460..cb075a7 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2035,9 +2035,8 @@ static int __init dm_crypt_init(void)
 	int r;
 
 	r = dm_register_target(&crypt_target);
-	if (r < 0) {
+	if (r < 0)
 		DMERR("register failed %d", r);
-	}
 
 	return r;
 }
