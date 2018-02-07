From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 1/3] multipath.rules: handle NVME devices
Date: Wed, 7 Feb 2018 12:37:10 -0600
Message-ID: <20180207183710.GO14513@octiron.msp.redhat.com>
References: <20180119001944.9565-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180119001944.9565-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Fri, Jan 19, 2018 at 01:19:42AM +0100, Martin Wilck wrote:
> Note: ID_WWN is set in 60-persistent-storage.rules in current systemd.
> That won't work well together with us installing multipath.rules as
> 56-multipath.rules -  multipath -u won't see ID_WWN.
> 
> However, we have strong reasons to run before blkid is invoked.
> ID_WWN determination for NVMe should be moved to an earlier udev rule.
> See systemd pull request #7594 on github.
> 

ACK for all three.
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/multipath.rules | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/multipath/multipath.rules b/multipath/multipath.rules
> index bc1a8529638f..6f8ee2be0a58 100644
> --- a/multipath/multipath.rules
> +++ b/multipath/multipath.rules
> @@ -1,7 +1,7 @@
>  # Set DM_MULTIPATH_DEVICE_PATH if the device should be handled by multipath
>  SUBSYSTEM!="block", GOTO="end_mpath"
>  ACTION!="add|change", GOTO="end_mpath"
> -KERNEL!="sd*|dasd*", GOTO="end_mpath"
> +KERNEL!="sd*|dasd*|nvme*", GOTO="end_mpath"
>  
>  IMPORT{cmdline}="nompath"
>  ENV{nompath}=="?*", GOTO="end_mpath"
> -- 
> 2.15.1
