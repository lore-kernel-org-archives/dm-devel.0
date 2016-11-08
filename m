From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 3/3] multipathd: Add 'sysfs' prioritizer
Date: Tue, 8 Nov 2016 19:52:55 +0100
Message-ID: <60729efa-12ad-aa28-f657-1b8ec6dbd4d2@gmail.com>
References: <1468565337-5178-1-git-send-email-hare@suse.de>
	<1468565337-5178-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468565337-5178-4-git-send-email-hare@suse.de>
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

On 07/15/2016 08:48 AM, Hannes Reinecke wrote:

> Recent kernels have an 'access_state' attribute which allows
> us to read the asymmetric access state directly from sysfs.

Hi Hannes,

with this patch it's impossible to select/autodetect ALUA.
sysfs always takes precedence over alua.

"detect_prio no" was added to overrides section, to make
it work again.

SLES 12-SP2

Thank you.

> ---
>  libmultipath/discovery.c           | 33 +++++++++++++++++++++
>  libmultipath/discovery.h           |  2 ++
>  libmultipath/prio.h                |  1 +
>  libmultipath/prioritizers/Makefile |  3 +-
>  libmultipath/prioritizers/sysfs.c  | 61 ++++++++++++++++++++++++++++++++++++++
>  libmultipath/propsel.c             |  6 +++-
>  multipath/multipath.conf.5         | 19 ++++++++++--
>  7 files changed, 120 insertions(+), 5 deletions(-)
>  create mode 100644 libmultipath/prioritizers/sysfs.c
> 

[ ...]

> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index beb0798..0caf269 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -375,6 +375,8 @@ detect_prio(struct config *conf, struct path * pp)
>  	struct prio *p = &pp->prio;
>  	int tpgs = 0;
>  	unsigned int timeout = conf->checker_timeout;
> +	char buff[512];
> +	char *default_prio = PRIO_ALUA;
>  
>  	if ((tpgs = get_target_port_group_support(pp->fd, timeout)) <= 0)
>  		return;
> @@ -384,7 +386,9 @@ detect_prio(struct config *conf, struct path * pp)
>  		return;
>  	if (get_asymmetric_access_state(pp->fd, ret, timeout) < 0)
>  		return;
> -	prio_get(conf->multipath_dir, p, PRIO_ALUA, DEFAULT_PRIO_ARGS);
> +	if (sysfs_get_asymmetric_access_state(pp, buff, 512) >= 0)
> +		default_prio = PRIO_SYSFS;
> +	prio_get(conf->multipath_dir, p, default_prio, DEFAULT_PRIO_ARGS);
>  }
