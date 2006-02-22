From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/3] sysfs representation of stacked devices
	(common) (rev.2)
Date: Wed, 22 Feb 2006 10:48:53 -0800
Message-ID: <20060222184853.GB13638@suse.de>
References: <43FC8C00.5020600@ce.jp.nec.com> <43FC8D8C.1060904@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <43FC8D8C.1060904@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>, Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Feb 22, 2006 at 11:13:00AM -0500, Jun'ichi Nomura wrote:
> +/* This is a mere directory in sysfs. No methods are needed. */
> +static struct kobj_type bd_holder_ktype = {
> +	.release	= NULL,
> +	.sysfs_ops	= NULL,
> +	.default_attrs	= NULL,
> +};

That doesn't look right.  You always need a release function.

> +static inline void add_holder_dir(struct block_device *bdev)
> +{
> +	struct kobject *kobj = &bdev->bd_holder_dir;
> +
> +	kobj->ktype = &bd_holder_ktype;
> +	kobject_set_name(kobj, "holders");
> +	kobj->parent = bdev_get_kobj(bdev);
> +	kobject_init(kobj);
> +	kobject_add(kobj);
> +	kobject_put(kobj->parent);
> +}
> +
> +static inline void del_holder_dir(struct block_device *bdev)
> +{
> +	/*
> +	 * Don't kobject_unregister to avoid memory allocation
> +	 * in kobject_hotplug.
> +	 */
> +	kobject_del(&bdev->bd_holder_dir);
> +	kobject_put(&bdev->bd_holder_dir);
> +}

No, do it correctly please.

thanks,

greg k-h
