From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 04/15] libmultipath: remove unused
	path->prio_args
Date: Fri, 17 Jan 2020 16:55:19 +0100
Message-ID: <e65de5749f9fbd3047781251bee491d9d3719f1e.camel@suse.de>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-5-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1579227500-17196-5-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2020-01-16 at 20:18 -0600, Benjamin Marzinski wrote:
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/structs.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index a3adf906..1c32a799 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -272,7 +272,6 @@ struct path {
>  	char * uid_attribute;
>  	char * getuid;
>  	struct prio prio;
> -	char * prio_args;
>  	struct checker checker;
>  	struct multipath * mpp;
>  	int fd;

Reviewed-by: Martin Wilck <mwilck@suse.com>
