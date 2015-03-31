From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/7] lib/vsprintf: add %*pg format specifier
Date: Tue, 31 Mar 2015 10:06:16 -0700
Message-ID: <1427821576.10376.29.camel@perches.com>
References: <1427817681-4494-1-git-send-email-dmonakhov@openvz.org>
	 <1427817681-4494-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427817681-4494-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 2015-03-31 at 20:01 +0400, Dmitry Monakhov wrote:
> This allow to directly print block_device name.
> Currently one should use bdevname() with temporal char buf[BDEVNAME_SIZE].
> This is very ineffective because bloat stack usage for deep IO call-traces
[]
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
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

Can you please use the same form as dentry_name and
dereference the pointer in vsprintf not here as below.

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
