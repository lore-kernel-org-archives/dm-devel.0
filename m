From: Greg KH <greg@kroah.com>
Subject: Re: dm: sysfs add empty release function to avoid debug warning
Date: Tue, 15 Dec 2009 16:47:39 -0800
Message-ID: <20091216004739.GB4898@kroah.com>
References: <200912151735.nBFHZ8XP018683@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756079AbZLPAsK@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200912151735.nBFHZ8XP018683@hera.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Dec 15, 2009 at 05:35:08PM +0000, James Bottomley wrote:
> commit: d2bb7df8cac647b92f51fb84ae735771e7adbfa7
> From: Milan Broz <mbroz@redhat.com>
> Date: Thu, 10 Dec 2009 23:51:53 +0000
> Subject: [PATCH] dm: sysfs add empty release function to avoid debug warning
> 
> This patch just removes an unnecessary warning:
>  kobject: 'dm': does not have a release() function,
>  it is broken and must be fixed.
> 
> The kobject is embedded in mapped device struct, so
> code does not need to release memory explicitly here.

Oh no you did not!

Come on people, do you think that the kernel is just randomly spitting
out warnings because it fricken feels like it!

No, please revert this patch now before someone does it for you.

Please, this is totally and completly wrong.  And if you feel that it is
needed, then your design is wrong and it needs to be fixed.

And note, as per the Documentation/kobject.txt file, you were warned
about this public mocking, next time it will be harsher.

Heh, and you tried to get this into a -stable kernel release, as if.

Patch left below so that others can mock.

bah,

greg k-h

> 
> Cc: stable@kernel.org
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> ---
>  drivers/md/dm-sysfs.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
> index 4b04590..b000de3 100644
> --- a/drivers/md/dm-sysfs.c
> +++ b/drivers/md/dm-sysfs.c
> @@ -80,12 +80,20 @@ static struct sysfs_ops dm_sysfs_ops = {
>  };
>  
>  /*
> + * The sysfs structure is embedded in md struct, nothing to do here
> + */
> +static void dm_sysfs_release(struct kobject *kobj)
> +{
> +}
> +
> +/*
>   * dm kobject is embedded in mapped_device structure
>   * no need to define release function here
>   */
>  static struct kobj_type dm_ktype = {
>  	.sysfs_ops	= &dm_sysfs_ops,
>  	.default_attrs	= dm_attrs,
> +	.release	= dm_sysfs_release
>  };
>  
>  /*
> 
> _______________________________________________
> stable mailing list
> stable@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable
