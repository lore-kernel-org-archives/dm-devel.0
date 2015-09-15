From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [dm-devel] [PATCH] dm: ioctl: prevent double freeing
Date: Tue, 15 Sep 2015 09:18:55 -0700
Message-ID: <20150915161855.GE10399@birch.djwong.org>
References: <1441365759-7247-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1441365759-7247-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
List-Id: dm-devel.ids

On Fri, Sep 04, 2015 at 04:52:39PM +0530, Sudip Mukherjee wrote:
> DM_PARAMS_KMALLOC and DM_PARAMS_VMALLOC should never be set together in
> param_flags. We are setting these flags while allocating so we know that
> there is almost no chance of having these two set together but still we
> can have some additional safety.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>  drivers/md/dm-ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 80a4395..aaad74e 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1680,7 +1680,7 @@ static void free_params(struct dm_ioctl *param, size_t param_size, int param_fla
>  
>  	if (param_flags & DM_PARAMS_KMALLOC)
>  		kfree(param);
> -	if (param_flags & DM_PARAMS_VMALLOC)
> +	else if (param_flags & DM_PARAMS_VMALLOC)

Wouldn't you also want a WARN_ON to complain about both flags being set?

--D

>  		vfree(param);
>  }
>  
> -- 
> 1.9.1
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
