From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Support HDIO_GETGEO on device-mapper volumes
Date: Thu, 9 Feb 2006 18:58:55 -0800
Message-ID: <20060209185855.6643dcce.akpm@osdl.org>
References: <43EBEDD0.60608@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43EBEDD0.60608@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, lcm@us.ibm.com
List-Id: dm-devel.ids

"Darrick J. Wong" <djwong@us.ibm.com> wrote:
>
> The attached patch implements a simple ioctl handler that supplies a 
> compatible geometry when HDIO_GETGEO is called against a device-mapper 
> device.

block_device_operations now has a standalone `getgeo' method.

> ...
> +static int dm_blk_ioctl(struct inode * inode, struct file * filp,
> +			unsigned int cmd, unsigned long arg)
> +{
> +	struct block_device *bdev = inode->i_bdev;
> +	struct hd_geometry __user *loc = (void __user *)arg;
> +	struct mapped_device *md;
> +	int diskinfo[4];
> +
> +	if (cmd == HDIO_GETGEO) {
> +		if (!arg)
> +			return -EINVAL;

I don't think we need that check?  The -EFAULT should suffice.
