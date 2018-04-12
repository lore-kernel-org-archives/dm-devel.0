From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] 11-dm-mpath.rules: dont't run "multipath -U"
 during coldplug
Date: Thu, 12 Apr 2018 14:52:06 -0500
Message-ID: <20180412195206.GY3103@octiron.msp.redhat.com>
References: <20180406114521.4883-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180406114521.4883-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Apr 06, 2018 at 01:45:21PM +0200, Martin Wilck wrote:
> When udevadm trigger is run after switching root, lots of simultaneous uevents
> for both path and multipath devices arrive. In may happen that when "multipath
> -U" is called on a dm device, the path's uevents haven't finished yet, thus
> the paths aren't found in the udev db, and multipath -U erroneously concludes
> that there are no usable paths. Avoid that by skipping "multipath -U" during
> coldplug.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Fixes: "ce5ea6a 11-dm-mpath.rules: multipath -U for READY check"
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/11-dm-mpath.rules | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
> index 03ac5da..07320a1 100644
> --- a/multipath/11-dm-mpath.rules
> +++ b/multipath/11-dm-mpath.rules
> @@ -26,6 +26,10 @@ ENV{DM_NR_VALID_PATHS}=="0", ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
>  ENV{MPATH_SBIN_PATH}="/sbin"
>  TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
>  
> +# Don't run multipath -U during "coldplug" after switching root,
> +# because paths are just being added to the udev db.
> +ACTION=="add", ENV{.MPATH_DEVICE_READY_OLD}=="1", GOTO="paths_ok"
> +
>  # Check the map state directly with multipath -U.
>  # This doesn't attempt I/O on the device.
>  PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -U %k", GOTO="paths_ok"
> -- 
> 2.16.1
