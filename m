From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] libmultipath: fix memory API logic error
Date: Mon, 15 Aug 2016 15:58:41 +0200
Message-ID: <20160815135841.smic6ttprb7kwoc4@c203.arch.suse.de>
References: <1471258749-12176-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1471258749-12176-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

On Mon, Aug 15, 2016 at 06:59:09PM +0800, tang.junhui@zte.com.cn wrote:
> From: "tang.junhui" <tang.junhui@zte.com.cn>
> =

> Memroy API use mem_allocated to record the total size of used memory,
> however, it's wrong to use size(p) as the length of freed memory in xfree=
(),
> and memory may also be allocated by STRDUP() or REALLOC(), which is
> not calculated into mem_allocated, so the total size of used memory is
> not correctly. For these reasons, we removed these incorrectly code to ke=
ep
> the code clean.
> =

> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> ---
>  libmpathpersist/mpath_updatepr.c |  1 -
>  libmultipath/memory.c            | 31 -------------------------------
>  libmultipath/memory.h            | 13 ++-----------
>  3 files changed, 2 insertions(+), 43 deletions(-)
> =

> diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_upd=
atepr.c
> index 9ff4b30..5af2e03 100644
> --- a/libmpathpersist/mpath_updatepr.c
> +++ b/libmpathpersist/mpath_updatepr.c
> @@ -16,7 +16,6 @@
>  #include "uxsock.h"
>  #include "memory.h"
>  =

> -unsigned long mem_allocated;    /* Total memory used in Bytes */
>  =

>  int update_prflag(char * arg1, char * arg2, int noisy)
>  {
> diff --git a/libmultipath/memory.c b/libmultipath/memory.c
> index 1366f45..5441e6a 100644
> --- a/libmultipath/memory.c
> +++ b/libmultipath/memory.c
> @@ -22,37 +22,6 @@
>

[...]

> -
> -void
> -xfree(void *p)
> -{
> -	mem_allocated -=3D sizeof (p);
> -	free(p);
> -	p =3D NULL;
> -}
> -
>  /*

[...]

> -#define MALLOC(n)    (zalloc(n))
> -#define FREE(p)      (xfree(p))
> +#define MALLOC(n)    (calloc(1,(n)))
> +#define FREE(p)      (free(p))
>  #define REALLOC(p,n) (realloc((p),(n)))
>  #define STRDUP(n)    (strdup(n))

One minor nit, the original xfree() has set the freed pointer to 0, so mayb=
e a

#define FREE(p) do { free(p); p =3D NULL } while(0)

would be advisable. I personally like setting free'd pointers to NULL,
as a NULL pointer access is a more immediate feedback than some rather
nasty use-after-free.

Just my $0.2

Byte,
	Johannes

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
