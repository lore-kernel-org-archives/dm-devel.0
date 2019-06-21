From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 07/30] libmpathcmd: use target length in
	strncpy() call
Date: Fri, 21 Jun 2019 14:23:07 -0500
Message-ID: <20190621192307.GL3251@octiron.msp.redhat.com>
References: <20190607130552.13203-1-mwilck@suse.com>
	<20190607130552.13203-8-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190607130552.13203-8-mwilck@suse.com>
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

On Fri, Jun 07, 2019 at 03:05:29PM +0200, Martin Wilck wrote:

Not a big deal since default socket is a defined string, but since we
are writing to &addr.sun_path[1], if DEFAULT_SOCKET were of size >=
"sizeof(addr.sun_path) - 1", the strncpy() would fill all of
addr.sun_path, without leaving any space for the the null byte at the
end. I assume you meant to change this to be strlcpy() instead of
leaving it as strncpy().

-Ben

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathcmd/mpath_cmd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
> index b681311b..05b69316 100644
> --- a/libmpathcmd/mpath_cmd.c
> +++ b/libmpathcmd/mpath_cmd.c
> @@ -104,7 +104,7 @@ int __mpath_connect(int nonblocking)
>  	addr.sun_family = AF_LOCAL;
>  	addr.sun_path[0] = '\0';
>  	len = strlen(DEFAULT_SOCKET) + 1 + sizeof(sa_family_t);
> -	strncpy(&addr.sun_path[1], DEFAULT_SOCKET, len);
> +	strncpy(&addr.sun_path[1], DEFAULT_SOCKET, sizeof(addr.sun_path) - 1);
>  
>  	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
>  	if (fd == -1)
> -- 
> 2.21.0
