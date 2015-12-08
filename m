From: Scotty Bauer <sbauer@eng.utah.edu>
Subject: Re: [PATCH] dm ioctl: Access user-land memory through safe functions.
Date: Tue, 8 Dec 2015 11:26:24 -0700
Message-ID: <566720D0.8080509@eng.utah.edu>
References: <565DE2B8.7040709@eng.utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <565DE2B8.7040709@eng.utah.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids


On 12/01/2015 11:11 AM, Scotty wrote:
> 
> 0001-dm-ioctl-Access-user-land-memory-through-safe-functi.patch
> 
> 
> From b26adf880eba03ac6f2b1dd87426bb96fd2a0282 Mon Sep 17 00:00:00 2001
> From: Scotty Bauer <sbauer@eng.utah.edu>
> Date: Tue, 1 Dec 2015 10:52:46 -0700
> Subject: [PATCH] dm ioctl: Access user-land memory through safe functions.
> 
> This patch fixes a user-land dereference. Now we use
> the safe copy_from_user to access the memory.
> 
> Signed-off-by: Scotty Bauer <sbauer@eng.utah.edu>
> ---
>  drivers/md/dm-ioctl.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 80a4395..39a9d1a 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1642,9 +1642,13 @@ static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
>  static int check_version(unsigned int cmd, struct dm_ioctl __user *user)
>  {
>  	uint32_t version[3];
> +	uint32_t __user *version_ptr;
>  	int r = 0;
>  
> -	if (copy_from_user(version, user->version, sizeof(version)))
> +	if (copy_from_user(&version_ptr, &user->version, sizeof(version_ptr)))
> +		return -EFAULT;
> +
> +	if (copy_from_user(version, version_ptr, sizeof(version)))
>  		return -EFAULT;
>  
>  	if ((DM_VERSION_MAJOR != version[0]) ||
> @@ -1663,7 +1667,7 @@ static int check_version(unsigned int cmd, struct dm_ioctl __user *user)
>  	version[0] = DM_VERSION_MAJOR;
>  	version[1] = DM_VERSION_MINOR;
>  	version[2] = DM_VERSION_PATCHLEVEL;
> -	if (copy_to_user(user->version, version, sizeof(version)))
> +	if (copy_to_user(version_ptr, version, sizeof(version)))
>  		return -EFAULT;
>  
>  	return r;
> -- 


Friendly ping, is anyone interested in this?
