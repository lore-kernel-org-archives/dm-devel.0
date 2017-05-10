From: Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH] dm ioctl: make dm_open and dm_release release
Date: Wed, 10 May 2017 10:19:29 +0100
Message-ID: <cda3064e-05eb-e9d3-29c6-185ac19b32b8@canonical.com>
References: <20170510091821.17995-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170510091821.17995-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 10/05/17 10:18, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Making dm_open and dm_release static fixes the sparse warnings:
> 
> warning: symbol 'dm_open' was not declared. Should it be static?
> warning: symbol 'dm_release' was not declared. Should it be static?
> 
> Fixes: ab2c6224f4c0c ("dm: a basic support for using the select or poll function")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/md/dm-ioctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 70dc5db90ef2..d45c68115d4c 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1893,7 +1893,7 @@ static long dm_compat_ctl_ioctl(struct file *file, uint command, ulong u)
>  #define dm_compat_ctl_ioctl NULL
>  #endif
>  
> -int dm_open(struct inode *inode, struct file *filp)
> +static int dm_open(struct inode *inode, struct file *filp)
>  {
>  	int r;
>  	struct dm_file *priv;
> @@ -1911,7 +1911,7 @@ int dm_open(struct inode *inode, struct file *filp)
>  	return 0;
>  }
>  
> -int dm_release(struct inode *inode, struct file *filp)
> +static int dm_release(struct inode *inode, struct file *filp)
>  {
>  	kfree(filp->private_data);
>  	return 0;
> 

Sorry, ignore this, it had a mistake in the subject line
