From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [dm-devel] [RFC PATCH v2 1/2] dm: allow a dm-fs-style device
 to be	shared via dm-ioctl
Date: Tue, 18 May 2010 11:36:35 +0900
Message-ID: <4BF1FD33.4040305@ct.jp.nec.com>
References: <20100514035347.GA20636@redhat.com> <1273887701-2152-1-git-send-email-wad@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1273887701-2152-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Drewry <wad@chromium.org>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Hi Will,

n 05/15/2010 10:41 AM +0900, Will Drewry wrote:
> In addition, it ensures that public functions are available that
> allow mapped devices and tables to be created and associated
> with the shared code paths with dm-ioctl:
> - suspend flags are available
snip 
> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index bad1724..782d867 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -17,12 +17,6 @@
>  #include <linux/hdreg.h>
>  
>  /*
> - * Suspend feature flags
> - */
> -#define DM_SUSPEND_LOCKFS_FLAG		(1 << 0)
> -#define DM_SUSPEND_NOFLUSH_FLAG		(1 << 1)
> -
> -/*
>   * Type of table and mapped_device's mempool
>   */
>  #define DM_TYPE_NONE		0
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 1381cd9..6c1c230 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -215,6 +215,18 @@ void dm_set_mdptr(struct mapped_device *md, void *ptr);
>  void *dm_get_mdptr(struct mapped_device *md);
>  
>  /*
> + * Export the device via the ioctl interface (uses mdptr).
> + */
> +int dm_ioctl_export(struct mapped_device *md, const char *name,
> +		    const char *uuid);
> +
> +/*
> + * Suspend feature flags
> + */
> +#define DM_SUSPEND_LOCKFS_FLAG		(1 << 0)
> +#define DM_SUSPEND_NOFLUSH_FLAG		(1 << 1)
> +
> +/*
>   * A device can still be used while suspended, but I/O is deferred.
>   */
>  int dm_suspend(struct mapped_device *md, unsigned suspend_flags);

Why do you need suspend feature flags?
I think no feature is needed (specifying '0' is enough) to make/suspend
a dm device at boot time (although I have looked at only this flag part).
Am I missing something?

Thanks,
Kiyoshi Ueda
