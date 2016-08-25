From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v2] mdopen: Prevent overrunning the devname
 buffer when copying devnm into it for long md names.
Date: Thu, 25 Aug 2016 02:44:14 -0500
Message-ID: <CAJVOszDvg6-VBndG=4XdGbfwEXbBj6-oYJsGNtvtkrQ-J6JPbQ@mail.gmail.com>
References: <20160824161044.20887-1-robert@leblancnet.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160824161044.20887-1-robert@leblancnet.us>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Robert LeBlanc <robert@leblancnet.us>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Aug 24, 2016 at 11:10 AM, Robert LeBlanc <robert@leblancnet.us> wrote:
> Linux allows for 32 character device names. When using the maximum size device name and also
> storing "/dev/", devname needs to be 37 character long to store the complete device name.
> i.e. "/dev/md_abcdefghijklmnopqrstuvwxyz12\0"
>
> Signed-Off: Robert LeBlanc<robert@leblancnet.us>
> ---
>  mdopen.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mdopen.c b/mdopen.c
> index f818fdf..5af344b 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -144,7 +144,7 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
>         struct createinfo *ci = conf_get_create_info();
>         int parts;
>         char *cname;
> -       char devname[20];
> +       char devname[37];

I think you want 38 here.
   5 + 32 + '\0'.

>         char devnm[32];
>         char cbuf[400];
>         if (chosen == NULL)
> --
> 2.9.3
>

Also a sprintf() to snprintf() cleanup might not be a bad idea ..
-- 
Shaun Tancheff
