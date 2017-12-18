From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v4 1/2] dm-unstripe: unstripe RAID 0/dm-striped device
Date: Mon, 18 Dec 2017 11:11:39 -0800
Message-ID: <e39cb433-d54b-50a6-70c3-1315e4ffbf0b@infradead.org>
References: <20171218172809.5826-1-scott.bauer@intel.com>
 <20171218172809.5826-2-scott.bauer@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171218172809.5826-2-scott.bauer@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Scott Bauer <scott.bauer@intel.com>, dm-devel@redhat.com
Cc: snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, keith.busch@intel.com, jonathan.derrick@intel.com
List-Id: dm-devel.ids

On 12/18/2017 09:28 AM, Scott Bauer wrote:
> This device mapper module remaps and unstripes IO so it lands
> solely on a single drive in a RAID 0/dm-stripe target.
> In a 4 drive RAID 0 the mapper exposes 1/4th of the LBA range
> as a virtual drive. Each IO to that virtual drive will land on
> only one of the 4 drives, selected by the user.
> 
> Signed-off-by: Scott Bauer <scott.bauer@intel.com>
> Acked-by: Keith Busch <keith.busch@intel.com>
> ---
>  drivers/md/Kconfig       |  10 +++
>  drivers/md/Makefile      |   1 +
>  drivers/md/dm-unstripe.c | 204 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 215 insertions(+)
>  create mode 100644 drivers/md/dm-unstripe.c
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 83b9362be09c..e1c48a7f98f1 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -269,6 +269,16 @@ config DM_BIO_PRISON
>  
>  source "drivers/md/persistent-data/Kconfig"
>  
> +config DM_UN_STRIPE
> +       tristate "Transpose IO to individual drives on a raid device"
> +       depends on BLK_DEV_DM
> +       ---help---
> +	  Enable this feature if you with to unstripe I/O on a RAID 0
> +	  device to the respective drive. If your hardware has physical
> +	  RAID 0 this module can unstripe the I/O to respective sides.

What does "sides" mean above?

> +
> +	  If unsure say N.
> +
thanks,
-- 
~Randy
