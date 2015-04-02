From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH 6/7] block/partitions: use block_device name vsprintf
 helper
Date: Thu, 2 Apr 2015 14:58:24 +0900
Message-ID: <20150402055824.GA548@swordfish>
References: <1427817681-4494-1-git-send-email-dmonakhov@openvz.org>
 <1427817681-4494-7-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427817681-4494-7-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, dm-devel@redhat.com
List-Id: dm-devel.ids

On (03/31/15 20:01), Dmitry Monakhov wrote:
[..]
>  	if(be32_to_cpu(magic) != SGI_LABEL_MAGIC) {
> -		/*printk("Dev %s SGI disklabel: bad magic %08x\n",
> -		       bdevname(bdev, b), be32_to_cpu(magic));*/
> +		/*printk("Dev %pg SGI disklabel: bad magic %08x\n",
> +		       bdev, be32_to_cpu(magic));*/
>  
[..]
>  	p = label->partitions;
>  	if (be16_to_cpu(label->magic) != SUN_LABEL_MAGIC) {
> -/*		printk(KERN_INFO "Dev %s Sun disklabel: bad magic %04x\n",
> -		       bdevname(bdev, b), be16_to_cpu(label->magic)); */
> +/*		printk(KERN_INFO "Dev %pg Sun disklabel: bad magic %04x\n",
> +		       bdev, be16_to_cpu(label->magic)); */
>  		put_dev_sector(sect);

may be entirely remove these commented out printk()-s?

	-ss
