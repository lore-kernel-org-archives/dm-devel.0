From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 23/57] multipath: remove warning 'failed to
	get wwid'
Date: Mon, 2 May 2016 10:43:00 -0500
Message-ID: <20160502154300.GR26117@octiron.msp.redhat.com>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-24-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1461755458-29225-24-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Wed, Apr 27, 2016 at 01:10:24PM +0200, Hannes Reinecke wrote:

Again. I'd prefer leaving the messages in either at a higher log level
or with less alarming text.

-Ben

> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  multipath/main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index d14a913..da8fa23 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -284,7 +284,6 @@ configure (void)
>  		int failed = get_refwwid(conf->dev, conf->dev_type, pathvec,
>  					 &refwwid);
>  		if (!refwwid) {
> -			condlog(3, "%s: failed to get wwid", conf->dev);
>  			if (failed == 2 && conf->cmd == CMD_VALID_PATH)
>  				printf("%s is not a valid multipath device path\n", conf->dev);
>  			else
> -- 
> 2.6.6
