From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v3 87/87] libmultipath: fix a
 -Wformat-truncation warning from gcc 10
Date: Wed, 19 Aug 2020 17:40:15 -0500
Message-ID: <20200819224015.GW19233@octiron.msp.redhat.com>
References: <20200819131819.13493-1-mwilck@suse.com>
	<20200819131819.13493-5-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200819131819.13493-5-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Aug 19, 2020 at 03:18:19PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> This fixes a warning seen with gcc 10 on x86 (32 bit).
> Fix it by checking the snprintf() return value.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/util.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/libmultipath/util.c b/libmultipath/util.c
> index 207e63c..1512424 100644
> --- a/libmultipath/util.c
> +++ b/libmultipath/util.c
> @@ -250,9 +250,9 @@ int systemd_service_enabled_in(const char *dev, const char *prefix)
>  		p = d->d_name + strlen(d->d_name) - 6;
>  		if (strcmp(p, ".wants"))
>  			continue;
> -		snprintf(file, sizeof(file), "%s/%s/%s",
> -			 path, d->d_name, service);
> -		if (stat(file, &stbuf) == 0) {
> +		if (!safe_sprintf(file, "%s/%s/%s",
> +				  path, d->d_name, service)
> +		    && stat(file, &stbuf) == 0) {
>  			condlog(3, "%s: found %s", dev, file);
>  			found++;
>  			break;
> -- 
> 2.28.0
