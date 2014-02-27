From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: not skip paths not belonging to
 a mpp in check_path
Date: Thu, 27 Feb 2014 09:14:50 +0100
Message-ID: <CABr-GnfTibNvZ4khrhf01GizZvi3hTwb7W039eWYNLMSZOiVyA@mail.gmail.com>
References: <1393072495-7238-1-git-send-email-vaughan.cao@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1393072495-7238-1-git-send-email-vaughan.cao@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Vaughan Cao <vaughan.cao@oracle.com>
List-Id: dm-devel.ids

Applied.

Indeed, it seems I messed up the merge.

Thanks.

On Sat, Feb 22, 2014 at 1:34 PM, Vaughan Cao <vaughan.cao@oracle.com> wrote:
> From: Vaughan Cao <Vaughan.Cao@oracle.com>
>
> commit bf4c80aee4e977e89d6925df569647acd3d5efef
> multipathd: add path when transitioned from 'blocked' state
> intends to check paths not belonging to a mpp usually because of
> they are in 'blocked' state and we cannot get the path uuid.
> So these paths ought not to be skipped at the start of the function.
> It could be a fault when merge the original patch -
> http://www.redhat.com/archives/dm-devel/2013-December/msg00085.html
>
> Signed-off-by: Vaughan Cao <Vaughan.Cao@oracle.com>
> ---
>  multipathd/main.c |    3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index af93f32..56d00d3 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1118,9 +1118,6 @@ check_path (struct vectors * vecs, struct path * pp)
>         int chkr_new_path_up = 0;
>         int oldchkrstate = pp->chkrstate;
>
> -       if (!pp->mpp)
> -               return 0;
> -
>         if (pp->tick && --pp->tick)
>                 return 0; /* don't check this path yet */
>
> --
> 1.7.9.5
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
