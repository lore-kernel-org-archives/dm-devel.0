From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 26/78] 11-dm-mpath.rules: Import blkid values
 if all paths are down
Date: Thu, 26 Mar 2015 22:42:42 -0500
Message-ID: <20150327034242.GQ29132@octiron.msp.redhat.com>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
	<1426509425-15978-27-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1426509425-15978-27-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 16, 2015 at 01:36:13PM +0100, Hannes Reinecke wrote:
> When all paths are failed we should not try to run any programs
> requiring disk access. However, we still need to create the
> symlinks so as not to confuse systemd.
> So import the blkid values from the database in these cases.

Don't we still need to set DM_NOSCAN here?

-Ben

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  multipath/11-dm-mpath.rules | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
> index 69c24b5..2e7076d 100644
> --- a/multipath/11-dm-mpath.rules
> +++ b/multipath/11-dm-mpath.rules
> @@ -6,7 +6,13 @@ ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
>  # otherwise there would be a hang or IO error on access.
>  # We'd like to avoid this, especially within udev processing.
>  ENV{DM_NR_VALID_PATHS}!="?*", IMPORT{db}="DM_NR_VALID_PATHS"
> -ENV{DM_NR_VALID_PATHS}=="0", ENV{DM_NOSCAN}="1"
> +ENV{DM_NR_VALID_PATHS}!="0", GOTO="mpath_blkid_end"
> +IMPORT{db}="ID_FS_TYPE"
> +IMPORT{db}="ID_FS_USAGE"
> +IMPORT{db}="ID_FS_UUID"
> +IMPORT{db}="ID_FS_UUID_ENC"
> +IMPORT{db}="ID_FS_VERSION"
> +LABEL="mpath_blkid_end"
>  
>  # Also skip all foreign rules if no path is available.
>  # Remember the original value of DM_DISABLE_OTHER_RULES_FLAG
> -- 
> 1.8.4.5
