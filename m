From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-bufio: avoid false-positive Wmaybe-uninitialized
	warning
Date: Thu, 22 Feb 2018 11:04:32 -0500
Message-ID: <20180222160432.GA16971@redhat.com>
References: <20180222155627.1800948-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180222155627.1800948-1-arnd@arndb.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mark Rutland <mark.rutland@arm.com>, Jan Kara <jack@suse.cz>, Eric Biggers <ebiggers@google.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Aliaksei Karaliou <akaraliou.dev@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>, Mikulas Patocka <mpatocka@redhat.com>, Ingo Molnar <mingo@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 22 2018 at 10:56am -0500,
Arnd Bergmann <arnd@arndb.de> wrote:

> gcc-6.3 and earlier show a new warning after a seemingly unrelated change
> to the arm64 PAGE_KERNEL definition:
> 
> In file included from drivers/md/dm-bufio.c:14:0:
> drivers/md/dm-bufio.c: In function 'alloc_buffer':
> include/linux/sched/mm.h:182:56: warning: 'noio_flag' may be used uninitialized in this function [-Wmaybe-uninitialized]
>   current->flags = (current->flags & ~PF_MEMALLOC_NOIO) | flags;
>                                                         ^
> 
> The same warning happened earlier on linux-3.18 for MIPS and I did a
> workaround for that, but now it's come back.
> 
> gcc-7 and newer are apparently smart enough to figure this out, and
> other architectures don't show it, so the best I could come up with is
> to rework the caller slightly in a way that makes it obvious enough to
> all arm64 compilers what is happening here.
> 
> Fixes: 41acec624087 ("arm64: kpti: Make use of nG dependent on arm64_kernel_unmapped_at_el0()")
> Link: https://patchwork.kernel.org/patch/9692829/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/md/dm-bufio.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 414c9af54ded..e7ad6fc6a5ea 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -413,13 +413,13 @@ static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
>  	 * as if GFP_NOIO was specified.
>  	 */
>  
> -	if (gfp_mask & __GFP_NORETRY)
> +	if (gfp_mask & __GFP_NORETRY) {
>  		noio_flag = memalloc_noio_save();
> -
> -	ptr = __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
> -
> -	if (gfp_mask & __GFP_NORETRY)
> +		ptr = __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
>  		memalloc_noio_restore(noio_flag);
> +	} else {
> +		ptr = __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
> +	}
>  
>  	return ptr;
>  }

Mikulas already sent a fix for this:
https://patchwork.kernel.org/patch/10211631/

But I like yours a bit better, though I'll likely move the declaration
of 'noio_flag' temporary inside the conditional.

Anyway, I'll get this fixed up shortly, thanks.

Mike
