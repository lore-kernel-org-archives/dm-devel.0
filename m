From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH]libmultipath/dmparser: add missing path with
 good status when sync state with dm kernel
Date: Tue, 07 Jul 2020 11:43:03 +0200
Message-ID: <1b8f4d69bedb77a5e47c9d638e95af7698257f90.camel@suse.com>
References: <bf821e180f4345aa9d5920bf50e28700@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <bf821e180f4345aa9d5920bf50e28700@h3c.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chongyun Wu <wu.chongyun@h3c.com>, Benjamin Marzinski <bmarzins@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Chengchiwen <chengchiwen@h3c.com>, Guozhonghua <guozhonghua@h3c.com>, Changlimin <changlimin@h3c.com>, Wangyong <wang.yongD@h3c.com>, Zhangguanghui <zhang.guanghui@h3c.com>
List-Id: dm-devel.ids

Hello Chongyun,

On Tue, 2020-07-07 at 03:08 +0000, Chongyun Wu wrote:
> Hi Martin and Ben,
> 
> Cloud you help to view below patch, thanks.
> 
> > From b2786c81a78bf3868f300fd3177e852e718e7790 Mon Sep 17 00:00:00
> > 2001
> From: Chongyun Wu <wu.chongyun@h3c.com>
> Date: Mon, 6 Jul 2020 11:22:21 +0800
> Subject: [PATCH] libmultipath/dmparser: add missing path with good
> status
>  when sync state with dm kernel
> 

Nack, sorry. I know we have an issue in this area, but I would like to
handle it differently.

First of all, I want to get rid of disassemble_map() making
modifications to the pathvec. The fact that disassemble_map() currently
does this is an ugly layer violation IMO, and I don't like the idea of
adding more of this on top. I'm currently preparing a patch set that
addresses this (among other things). It will also address the issue of
missing paths in pathvec, and I'd be very glad if you could give it a
try in your test environment.

> Add path back into deamon vecs->pathvecs when found path missing in
> multipathd which can fix dm io blocked issue.
> 
> Test environment:
> several hosts;
> each host have 100+ multipath, each multipath have 1 to 4 paths.
> run up/down storage network loop script for days.
> 
> Issue:
> After several hours stop script, found some hosts have dm io blocked
> issue:
> slave block device access well, but its dm device blocked.
> 36c0bfc0100a8d4a228214da50000003c dm-20 HUAWEI,XSG1
> size=350G features='1 queue_if_no_path' hwhandler='0' wp=rw
> `-+- policy='round-robin 0' prio=1 status=enabled
>   |- 1:0:0:20  sdbk 67:224  failed ready running
> multipathd show paths cannot found sdbk!

Is /dev/sdbk indeed a healthy path in this situation, or not?
Please run "multipathd show devices", too.

I wonder if your logs provide some more evidence how this situation
came to pass. I suspect that either a) uevents got lost, or that b)
multipathd failed to (re-)add the path while handling an uevent. It'd
be interesting to find out what it actually was.

More notes below.

> Test result:
> With this patch, run script several days, io blocked issue
> not found again.
> 
> This patch can fix this issue: when found path only missing in
> multipathd but still in dm, check the missing path status if ok
> try to add it back, and checker have chance to reinstate this
> path and the dm io blocked issue will disappear.
> 
> Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
> ---
>  libmultipath/dmparser.c | 31 +++++++++++++++++++++++++++++++
>  libmultipath/dmparser.h |  1 +
>  2 files changed, 32 insertions(+)
> 
> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> index b856a07f..2f90b17c 100644
> --- a/libmultipath/dmparser.c
> +++ b/libmultipath/dmparser.c
> @@ -317,6 +317,12 @@ int disassemble_map(vector pathvec, char
> *params, struct multipath *mpp,
>  				/* Only call this in multipath client
> mode */
>  				if (!is_daemon && store_path(pathvec,
> pp))
>  					goto out1;

I believe that your problem would have been solved simply by removing
the "!is_daemon" condition above. I'd like to know if that's actually
the case, because your add_missing_path() function does basically the
same thing (plus calling pathinfo()).

However, the "!is_daemon" test is there for a reason (see b96dead 
("[multipathd] remove the retry login in uev_remove_path()"), and
that's why your patch isn't correct as-is. 

Regards,
Martin

> +
> +				/* Try to add good status path back to
> avoid
> +				 * dm io blocked issue in special
> condition.
> +				 */
> +				if(add_missing_path(pathvec, devname))
> +					condlog(2, "Try to add missing
> path %s failed", devname);
>  			} else {
>  				if (!strlen(pp->wwid) &&
>  				    strlen(mpp->wwid))
> @@ -569,3 +575,28 @@ int disassemble_status(char *params, struct
> multipath *mpp)
>  	}
>  	return 0;
>  }
> +
> +/* Add missing good status path back to multipathd */
> +int add_missing_path(vector pathvec, char *missing_dev)
> +{
> +	struct udev_device *udevice;
> +	struct config *conf;
> +	int ret = 0;
> +				
> +	condlog(2, "Cant't found path %s try to add it back if its
> state is up.", 
> +			missing_dev);
> +
> +	udevice = udev_device_new_from_subsystem_sysname(udev, "block",
> missing_dev);
> +	if (!udevice) {
> +		condlog(0, "%s: can't find path form udev",
> missing_dev);
> +		return 1;
> +	}
> +	conf = get_multipath_config();
> +	pthread_cleanup_push(put_multipath_config, conf);
> +	ret = store_pathinfo(pathvec, conf,
> +						 udevice, DI_ALL |
> DI_BLACKLIST, NULL);
> +	pthread_cleanup_pop(1);
> +	udev_device_unref(udevice);
> +
> +	return ret;
> +}
> diff --git a/libmultipath/dmparser.h b/libmultipath/dmparser.h
> index e1badb0b..515ca900 100644
> --- a/libmultipath/dmparser.h
> +++ b/libmultipath/dmparser.h
> @@ -1,3 +1,4 @@
>  int assemble_map (struct multipath *, char *, int);
>  int disassemble_map (vector, char *, struct multipath *, int);
>  int disassemble_status (char *, struct multipath *);
> +int add_missing_path(vector pathvec, char *missing_dev);
