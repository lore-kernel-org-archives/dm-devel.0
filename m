From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 03/15] Fix leak in mpathpersist
Date: Fri, 17 Jan 2020 16:53:47 +0100
Message-ID: <b4fa27e7ea46d659f9778ffa95d630aa2d98c73c.camel@suse.de>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-4-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1579227500-17196-4-git-send-email-bmarzins@redhat.com>
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
> If the persistent in command fails, the response buffer must be
> freed.
> Found by Coverity
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  mpathpersist/main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mpathpersist/main.c b/mpathpersist/main.c
> index 278b8d51..920e686c 100644
> --- a/mpathpersist/main.c
> +++ b/mpathpersist/main.c
> @@ -499,6 +499,7 @@ static int handle_args(int argc, char * argv[],
> int nline)
>  		if (ret != MPATH_PR_SUCCESS )
>  		{
>  			fprintf (stderr, "Persistent Reserve IN command
> failed\n");
> +			free(resp);
>  			goto out_fd;
>  		}
>  

Reviewed-by: Martin Wilck <mwilck@suse.com>
