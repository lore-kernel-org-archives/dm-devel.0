From: Germano Percossi <germano.percossi@citrix.com>
Subject: Re: [PATCH 06/15] libmultipath: Remove an unused function
Date: Mon, 24 Oct 2016 11:50:10 +0100
Message-ID: <2b174b78-f42b-2c7f-90da-00b05cba1f6d@citrix.com>
References: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
	<1fcae43b-f64e-7001-ef0d-68ec0585c81d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1fcae43b-f64e-7001-ef0d-68ec0585c81d@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Removing functions packaged in a library just because they are
not used in multipath does not seem fine, in general.
They could still be used by third party.

Germano

On 10/21/2016 07:43 PM, Bart Van Assche wrote:
> The function snprint_config() is not used. Hence remove it.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  libmultipath/print.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 9aa41ad..09e4a2e 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -1745,12 +1745,6 @@ snprint_devices (struct config *conf, char * buff, int len, struct vectors *vecs
>  	return fwd;
>  }
>  
> -extern int
> -snprint_config (char * buff, int len)
> -{
> -	return 0;
> -}
> -
>  /*
>   * stdout printing helpers
>   */
> 
