From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] multipath-tools: Fix dry runs to identify
	renames
Date: Tue, 20 Oct 2009 22:47:52 +0200
Message-ID: <1256071672.9634.1.camel@zezette>
References: <20091020195034.GR3555@ether.msp.redhat.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091020195034.GR3555@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Ben,
this one was already in (sep 28th).
The 3 others are now merged.

Thanks.

On mar., 2009-10-20 at 14:50 -0500, Benjamin Marzinski wrote:
> multipath didn't correctly identify renames on a dry run.  This fixes it.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/configure.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: multipath-tools-091013/libmultipath/configure.c
> ===================================================================
> --- multipath-tools-091013.orig/libmultipath/configure.c
> +++ multipath-tools-091013/libmultipath/configure.c
> @@ -151,7 +151,7 @@ select_action (struct multipath * mpp, v
>  	if (!cmpp) {
>  		cmpp = find_mp_by_wwid(curmp, mpp->wwid);
>  
> -		if (cmpp && !conf->dry_run) {
> +		if (cmpp) {
>  			condlog(2, "%s: rename %s to %s", mpp->wwid,
>  				cmpp->alias, mpp->alias);
>  			strncpy(mpp->alias_old, cmpp->alias, WWID_SIZE);
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
