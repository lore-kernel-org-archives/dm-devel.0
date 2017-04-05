From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 17/33] multipathd: imply -n if
 find_multipaths is set
Date: Wed, 5 Apr 2017 18:03:28 -0500
Message-ID: <20170405230328.GJ19236@octiron.msp.redhat.com>
References: <20170228162329.14517-1-mwilck@suse.com>
	<20170228162329.14517-18-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170228162329.14517-18-mwilck@suse.com>
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

On Tue, Feb 28, 2017 at 05:23:13PM +0100, Martin Wilck wrote:
> Automatic detection of new devices with find_multipaths
> doesn't work correctly currently. Therefore, for now,
> imply ignore_new_devs if find_multipaths is seen.

I would rather not do this (at least outside of the initramfs), since it
keeps multipathd from automatically creating multipath devices as
expected when you enable find_multipaths. I admit that these path
devices won't be correctly claimed in udev when they appear for the
first time, but it's hard to believe that they are critical the very
first time they appear on the system. I have a patch that I can send
upstream that triggers a change uevent on path devices when they are
added to the wwids file.  This means that these devices will be
correctly claimed by multipath as soon as it gets set up on top of them.

Martin, what do you thing about reverting this change and triggering a
uevent instead?

-Ben
 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index cf44778b..8f464bfb 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2183,6 +2183,10 @@ reconfigure (struct vectors * vecs)
>  		conf->verbosity = verbosity;
>  	if (bindings_read_only)
>  		conf->bindings_read_only = bindings_read_only;
> +	if (conf->find_multipaths) {
> +		condlog(2, "find_multipaths is set: -n is implied");
> +		ignore_new_devs = 1;
> +	}
>  	if (ignore_new_devs)
>  		conf->ignore_new_devs = ignore_new_devs;
>  	uxsock_timeout = conf->uxsock_timeout;
> -- 
> 2.11.0
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
