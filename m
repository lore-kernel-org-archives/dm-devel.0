From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 1/2] kpartx.rules: honor
 DM_UDEV_DISABLE_OTHER_RULES_FLAG
Date: Fri, 3 Apr 2020 11:48:12 -0500
Message-ID: <20200403164812.GC5907@octiron.msp.redhat.com>
References: <20200403111914.30717-1-mwilck@suse.com>
	<20200403111914.30717-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200403111914.30717-2-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, vliaskovitis@suse.com
List-Id: dm-devel.ids

On Fri, Apr 03, 2020 at 01:19:13PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> 10-dm.rules sets DM_UDEV_DISABLE_OTHER_RULES_FLAG for spurious
> events that should be ignored by other layers. This means devices
> with DISK_RO set, and devices that have never been set up properly
> by device-mapper before. This flag should be respected by kpartx.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  kpartx/kpartx.rules | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
> index 8f990494..f1bf31ca 100644
> --- a/kpartx/kpartx.rules
> +++ b/kpartx/kpartx.rules
> @@ -7,6 +7,7 @@
>  KERNEL!="dm-*", GOTO="kpartx_end"
>  ACTION!="add|change", GOTO="kpartx_end"
>  ENV{DM_UUID}!="?*", GOTO="kpartx_end"
> +ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=="1", GOTO="kpartx_end"
>  
>  # Create dm tables for partitions on multipath devices.
>  ENV{DM_UUID}!="mpath-?*", GOTO="mpath_kpartx_end"
> -- 
> 2.25.1
