From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [dm-devel] [PATCH -next] md: dm-ebs-target: fix build errors &
 Kconfig entry
Date: Wed, 29 Apr 2020 14:23:21 +0200
Message-ID: <980b6b95-6e18-40ff-f71c-058917c5b6ee@redhat.com>
References: <d33b3bfb-c38d-9770-e6a6-929519dc21d4@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d33b3bfb-c38d-9770-e6a6-929519dc21d4@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 4/28/20 5:03 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Fix build errors by selecting DM_BUFIO.
>
> Fix Kconfig entry formatting by using tabs instead of spaces,
> using "help" instead of "---help---", and
> indenting help text with one additional space.
>
> Fixes these build errors:
>
> ld: drivers/md/dm-ebs-target.o: in function `__ebs_forget_bio':
> dm-ebs-target.c:(.text+0x1bc): undefined reference to `dm_bufio_forget'
> ld: drivers/md/dm-ebs-target.o: in function `ebs_dtr':
> dm-ebs-target.c:(.text+0x2fe): undefined reference to `dm_bufio_client_destroy'
> ld: drivers/md/dm-ebs-target.o: in function `__ebs_rw_bio':
> dm-ebs-target.c:(.text+0x4c4): undefined reference to `dm_bufio_get_block_size'
> ld: dm-ebs-target.c:(.text+0x4f1): undefined reference to `dm_bufio_read'
> ld: dm-ebs-target.c:(.text+0x504): undefined reference to `dm_bufio_get_block_size'
> ld: dm-ebs-target.c:(.text+0x519): undefined reference to `dm_bufio_new'
> ld: dm-ebs-target.c:(.text+0x567): undefined reference to `dm_bufio_mark_partial_buffer_dirty'
> ld: dm-ebs-target.c:(.text+0x56f): undefined reference to `dm_bufio_release'
> ld: drivers/md/dm-ebs-target.o: in function `__ebs_process_bios':
> dm-ebs-target.c:(.text+0x6bf): undefined reference to `dm_bufio_prefetch'
> ld: dm-ebs-target.c:(.text+0x72d): undefined reference to `dm_bufio_prefetch'
> ld: dm-ebs-target.c:(.text+0x783): undefined reference to `dm_bufio_prefetch'
> ld: dm-ebs-target.c:(.text+0x7fe): undefined reference to `dm_bufio_write_dirty_buffers'
> ld: drivers/md/dm-ebs-target.o: in function `ebs_ctr':
> dm-ebs-target.c:(.text+0xa82): undefined reference to `dm_bufio_client_create'
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Heinz Mauelshagen <dm-devel@redhat.com>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> ---
>   drivers/md/Kconfig |   12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> --- linux-next-20200428.orig/drivers/md/Kconfig
> +++ linux-next-20200428/drivers/md/Kconfig
> @@ -338,12 +338,12 @@ config DM_WRITECACHE
>   	   to be cached in standard RAM.
>   
>   config DM_EBS
> -       tristate "Emulated block size target (EXPERIMENTAL)"
> -       depends on BLK_DEV_DM
> -       default n
> -       ---help---
> -	 dm-ebs emulates smaller logical block size on backing devices
> -	 with larger ones (e.g. 512 byte sectors on 4K native disks).
> +	tristate "Emulated block size target (EXPERIMENTAL)"
> +	depends on BLK_DEV_DM
> +	select DM_BUFIO
> +	help
> +	  dm-ebs emulates smaller logical block size on backing devices
> +	  with larger ones (e.g. 512 byte sectors on 4K native disks).
>   
>   config DM_ERA
>          tristate "Era target (EXPERIMENTAL)"


Thanks, fine with me for the most part.

We mainly use '---help---' for dm/md though, so lets's keep it. Mike?

Heinz


>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
