From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v4 09/11] libmultipath:
 retain_attached_hw_handler obsolete with 4.3+
Date: Fri, 23 Jun 2017 19:25:17 +0200
Message-ID: <4a58e086-8e47-80d0-eb23-cf838bc09f15@gmail.com>
References: <20170622145913.23714-1-mwilck@suse.com>
	<20170622145913.23714-10-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170622145913.23714-10-mwilck@suse.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 06/22/2017 04:59 PM, Martin Wilck wrote:

> Kernels 4.3 and newer (commit 1bab0de0 "dm-mpath, scsi_dh: don't
> let dm detach device handlers") imply "retain_attached_hw_handler yes".
> 
> Clarify this in the propsel code, log messages, and documentation.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> ---
>  libmultipath/configure.c   |  3 ++-
>  libmultipath/dmparser.c    |  3 ++-
>  libmultipath/propsel.c     |  7 ++++++-
>  libmultipath/util.c        | 36 ++++++++++++++++++++++++++++++++++++
>  libmultipath/util.h        |  2 ++
>  multipath/multipath.conf.5 | 15 +++++++++++----
>  6 files changed, 59 insertions(+), 7 deletions(-)
[...]
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -628,7 +628,12 @@ int select_retain_hwhandler(struct config *conf, struct multipath *mp)
>  
>  	if (!VERSION_GE(conf->version, minv_dm_retain)) {
>  		mp->retain_hwhandler = RETAIN_HWHANDLER_OFF;
> -		origin = "(setting: WARNING, requires kernel version >= 1.5.0)";
> +		origin = "(setting: WARNING, requires kernel dm-mpath version >= 1.5.0)";
It would be more informative replace the dm-mpath version with the
kernel version. No one cares about subsystems versions.
