From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath: check setup_multipath
	return	value.
Date: Wed, 31 Aug 2011 21:50:26 -0500
Message-ID: <20110901025026.GC11793@ether.msp.redhat.com>
References: <20110713183042.GT15149@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110713183042.GT15149@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Christophe, would it be possible to get this merged?

Thanks,
-Ben

On Wed, Jul 13, 2011 at 01:30:42PM -0500, Benjamin Marzinski wrote:
> When setup_multipath() fails, it removes the map. So update_path_groups()
> needs check the return value, and fail without touching the map anymore if
> setup_multipath() fails.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/main.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: multipath-tools-110713/multipathd/main.c
> ===================================================================
> --- multipath-tools-110713.orig/multipathd/main.c
> +++ multipath-tools-110713/multipathd/main.c
> @@ -1060,7 +1060,8 @@ int update_path_groups(struct multipath 
>  		return 1;
>  	}
>  	dm_lib_release();
> -	setup_multipath(vecs, mpp);
> +	if (setup_multipath(vecs, mpp) != 0)
> +		return 1;
>  	sync_map_state(mpp);
>  
>  	return 0;
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
