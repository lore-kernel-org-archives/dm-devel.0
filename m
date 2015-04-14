From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/7] lib/vsprintf: add %*pg format specifier
Date: Tue, 14 Apr 2015 11:15:09 +0200
Message-ID: <20150414091509.GE23327@quack.suse.cz>
References: <1428928300-9132-1-git-send-email-dmonakhov@openvz.org>
 <1428928300-9132-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1428928300-9132-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon 13-04-15 16:31:35, Dmitry Monakhov wrote:
> This allow to directly print block_device name.
> Currently one should use bdevname() with temporal char buffer.
> This is very ineffective because bloat stack usage for deep IO call-traces
> 
> Example:
> 	%pg  ->    sda, sda1 or loop0p1
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  I like this. Seeing how many places use bdevname() it seems as a
worthwhile simplification. %pg is somewhat arbitrary but I don't know about
a better free letter either... You can add:
  Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  Documentation/printk-formats.txt |    6 ++++++
>  lib/vsprintf.c                   |   28 ++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
> index 5a615c1..de2f18f 100644
> --- a/Documentation/printk-formats.txt
> +++ b/Documentation/printk-formats.txt
> @@ -216,6 +216,12 @@ dentry names:
>  	equivalent of %s dentry->d_name.name we used to use, %pd<n> prints
>  	n last components.  %pD does the same thing for struct file.
>  
> +block_device names:
> +
> +	%pg	sda, sda1 or loop0p1
> +
> +	For printing name of block_device pointers.
> +
>  struct va_format:
>  
>  	%pV
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index b235c96..57f6fa9 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -29,6 +29,9 @@
>  #include <linux/dcache.h>
>  #include <linux/cred.h>
>  #include <net/addrconf.h>
> +#ifdef CONFIG_BLOCK
> +#include <linux/blkdev.h>
> +#endif
>  
>  #include <asm/page.h>		/* for PAGE_SIZE */
>  #include <asm/sections.h>	/* for dereference_function_descriptor() */
> @@ -610,6 +613,23 @@ char *dentry_name(char *buf, char *end, const struct dentry *d, struct printf_sp
>  	return buf;
>  }
>  
> +#ifdef CONFIG_BLOCK
> +static noinline_for_stack
> +char *bdev_name(char *buf, char *end, struct block_device *bdev,
> +		struct printf_spec spec, const char *fmt)
> +{
> +	struct gendisk *hd = bdev->bd_disk;
> +	
> +	buf = string(buf, end, hd->disk_name, spec);
> +	if (bdev->bd_part->partno) {
> +		if (isdigit(hd->disk_name[strlen(hd->disk_name)-1]) && buf < end)
> +			*buf++ = 'p';
> +		buf = number(buf, end, bdev->bd_part->partno, spec);
> +	}
> +	return buf;
> +}
> +#endif
> +
>  static noinline_for_stack
>  char *symbol_string(char *buf, char *end, void *ptr,
>  		    struct printf_spec spec, const char *fmt)
> @@ -1404,6 +1424,8 @@ int kptr_restrict __read_mostly;
>   *           (default assumed to be phys_addr_t, passed by reference)
>   * - 'd[234]' For a dentry name (optionally 2-4 last components)
>   * - 'D[234]' Same as 'd' but for a struct file
> + * - 'g' For block_device name (gendisk + partition number)
> +
>   *
>   * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
>   * function pointers are really function descriptors, which contain a
> @@ -1552,6 +1574,11 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  		return dentry_name(buf, end,
>  				   ((const struct file *)ptr)->f_path.dentry,
>  				   spec, fmt);
> +#ifdef CONFIG_BLOCK
> +	case 'g':
> +		return bdev_name(buf, end, ptr, spec, fmt);
> +#endif
> +
>  	}
>  	spec.flags |= SMALL;
>  	if (spec.field_width == -1) {
> @@ -1779,6 +1806,7 @@ qualifier:
>   * %pF output the name of a function pointer with its offset
>   * %pf output the name of a function pointer without its offset
>   * %pB output the name of a backtrace symbol with its offset
> + * %pg output the name of a block_device
>   * %pR output the address range in a struct resource with decoded flags
>   * %pr output the address range in a struct resource with raw flags
>   * %pb output the bitmap with field width as the number of bits
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
