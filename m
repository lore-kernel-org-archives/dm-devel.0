From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: configlet specifications being ignored in
	multipath-tools-0.4.3
Date: Wed, 23 Mar 2005 15:54:20 +0100
Message-ID: <20050323145420.GA19794@averon.dyndns.org>
References: <20050322170005.5A54073648@hormel.redhat.com>
	<ac71172a050323041348ed3095@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac71172a050323041348ed3095@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tranlan@us.ibm.com
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

Thanks, applied, with the missing header inclusion in devinfo.c

Regards,
cvaroqui

On Wed, Mar 23, 2005 at 04:13:30AM -0800, lan wrote:
> For multipath-tools-0.4.3, when running 'multipath' to setup multipath
> devices, it appears that some configlet specifications are being
> ignored because the select_getXXX calls (e.g. select_getprio,
> select_checkfn, select_getuid) made in devinfo assume that the path's
> hwe pointer is already initialized, but this does not happen until
> after devinfo is called.  Thus, the path ends up being intialized with
> the default values instead of configlet-specificed values.  The
> following change appears to fix this problem.  Please excuse me if
> this problem has already been resolved.
> 
> Thanks!
> Lan
> 
> diff -Naur multipath-tools-0.4.3/multipath/devinfo.c
> multipath-tools-0.4.3-patched/multipath/devinfo.c
> --- multipath-tools-0.4.3/multipath/devinfo.c   2005-03-04
> 16:32:41.000000000 -0800
> +++ multipath-tools-0.4.3-patched/multipath/devinfo.c   2005-03-23
> 03:49:13.000000000 -0800
> @@ -422,6 +422,9 @@
>         pp->claimed = get_claimed(pp->dev_t);
>         dbg("claimed = %i", pp->claimed);
> 
> +       /* get and store hwe pointer */
> +        pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id);
> +
>         /*
>          * get path state, no message collection, no context
>          */
> diff -Naur multipath-tools-0.4.3/multipath/main.c
> multipath-tools-0.4.3-patched/multipath/main.c
> --- multipath-tools-0.4.3/multipath/main.c      2005-03-19
> 05:44:11.000000000 -0800
> +++ multipath-tools-0.4.3-patched/multipath/main.c      2005-03-23
> 00:16:31.000000000 -0800
> @@ -157,8 +157,6 @@
>                         free(curpath);
>                         continue;
>                 }
> -               curpath->hwe = find_hwe(conf->hwtable, curpath->vendor_id,
> -                                                     curpath->product_id);
>                 vector_alloc_slot(pathvec);
>                 vector_set_slot(pathvec, curpath);
>         }
