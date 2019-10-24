From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] dm raid: Remove unnecessary negation of a shift in raid10_format_to_md_layout
Date: Thu, 24 Oct 2019 14:46:10 -0700
Message-ID: <CAKwvOdmw+fSNfksLtiAKF8upAuQB+rOzWP010cC-ivF5z=XuYA@mail.gmail.com>
References: <20191024202803.47613-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191024202803.47613-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>, clang-built-linux <clang-built-linux@googlegroups.com>
List-Id: dm-devel.ids

On Thu, Oct 24, 2019 at 1:28 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> When building with Clang + -Wtautological-constant-compare:
>
>  drivers/md/dm-raid.c:619:8: warning: converting the result of '<<' to a
>  boolean always evaluates to true [-Wtautological-constant-compare]
>                  r = !RAID10_OFFSET;
>                       ^
>  drivers/md/dm-raid.c:517:28: note: expanded from macro 'RAID10_OFFSET'
>  #define RAID10_OFFSET                   (1 << 16) /* stripes with data
>  copies area adjacent on devices */
>                                            ^
>  1 warning generated.
>
> Negating a non-zero number will always make it zero, which is the
> default value of r in this function so this statement is unnecessary;

Yep, thanks for the patch.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
(algorithm should be an enum, and there's some code duplication
between ALGORITHM_RAID10_OFFSET and ALGORITHM_RAID10_FAR cases, but
this patch is good enough).

> remove it so that clang no longer warns.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/753
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/md/dm-raid.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index b0aa595e4375..13fabc6779e5 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -616,7 +616,6 @@ static int raid10_format_to_md_layout(struct raid_set *rs,
>
>         } else if (algorithm == ALGORITHM_RAID10_FAR) {
>                 f = copies;
> -               r = !RAID10_OFFSET;
>                 if (!test_bit(__CTR_FLAG_RAID10_USE_NEAR_SETS, &rs->ctr_flags))
>                         r |= RAID10_USE_FAR_SETS;
>


-- 
Thanks,
~Nick Desaulniers
