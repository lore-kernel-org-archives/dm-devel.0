From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 22/57] multipath: use option '-i' when called
	from udev
Date: Mon, 2 May 2016 10:31:24 -0500
Message-ID: <20160502153124.GP26117@octiron.msp.redhat.com>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-23-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1461755458-29225-23-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Wed, Apr 27, 2016 at 01:10:23PM +0200, Hannes Reinecke wrote:
> multipath should be using the option '-i' to ignore the wwids
> file when called from udev. Otherwise we might run into a race
> condition with systemd and the system might not boot up correctly.

The race condition being? Are you talking about the udev rules not
claiming a path for multipath, but then having multipathd create a
multipath device using that path? I agree that this can be an issue.
Another way to solve it is to run mutipathd with the -n option in the
initramfs (see commit a8efa5838cf215febd853f282c26af62c0daa862). That
commit solves the race by making mutipathd ignore devices that aren't
already in the wwids file.  This also keeps the initramfs from picking a
different user_friendly_name than will be picked in late boot (but
hopefully that issue has been sorted out by other patches already).

I'm not NAKing this. The question of what to do about the differnces in
the distribution's systemd and udev configurations can be hashed out
outside of patch reviewing. I just want to make sure I understand the
race this is solving.

-Ben

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  multipath/multipath.rules | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/multipath/multipath.rules b/multipath/multipath.rules
> index c8fb7e6..6b0d1cd 100644
> --- a/multipath/multipath.rules
> +++ b/multipath/multipath.rules
> @@ -15,7 +15,7 @@ ENV{MPATH_SBIN_PATH}="/sbin"
>  TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
>  
>  ENV{DM_MULTIPATH_DEVICE_PATH}!="1", \
> -	PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -u %k", \
> +	PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -i -u %k", \
>  	ENV{DM_MULTIPATH_DEVICE_PATH}="1", ENV{ID_FS_TYPE}="none", \
>  	ENV{SYSTEMD_READY}="0"
>  
> -- 
> 2.6.6
