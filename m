From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: add Kconfig switch to enable authenticated
	mode.
Date: Thu, 4 May 2017 12:01:41 -0400
Message-ID: <20170504160141.GA1206@redhat.com>
References: <20170504150725.9737-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170504150725.9737-1-gmazyland@gmail.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, May 04 2017 at 11:07am -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> The switch just enables dm-integrity module but it makes
> configuration more logic and user friendly.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---
>  drivers/md/Kconfig | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 3e96fccbbdb2..134f885c6be1 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -285,6 +285,17 @@ config DM_CRYPT
>  
>  	  If unsure, say N.
>  
> +config DM_CRYPT_AEAD
> +	tristate "Crypt target support for authenticated disk encrytion modes"
> +	depends on DM_CRYPT
> +	select DM_INTEGRITY
> +	---help---
> +	  This option enables dm-integrity target that is required in dm-crypt
> +	  for support of authenticated encryption modes (it enables additional
> +	  per-sector metadata for authentication tags).
> +
> +	  If unsure, say N.
> +
>  config DM_SNAPSHOT
>         tristate "Snapshot target"
>         depends on BLK_DEV_DM
> -- 
> 2.11.0

For the benefit of dm-devl: we've decided to _not_ make this change.
