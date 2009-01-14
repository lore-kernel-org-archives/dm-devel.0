From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: merging dm-ioband into Linux
Date: Wed, 14 Jan 2009 11:01:27 +0900 (JST)
Message-ID: <20090114.110127.193692919.ryov@valinux.co.jp>
References: <20090105.225124.193700534.ryov@valinux.co.jp>
	<09F68804-691D-4E75-ABFC-9E1CE86FB98A@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <09F68804-691D-4E75-ABFC-9E1CE86FB98A@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, jbrassow@redhat.com
List-Id: dm-devel.ids

Hi Jonathan,

I'm sorry for responding late.

From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [dm-devel] merging dm-ioband into Linux
Date: Thu, 8 Jan 2009 12:05:09 -0600

> Perhaps it will help people to know that there is a good write-up about how it all works at the end of the patch found at:
> http://people.valinux.co.jp/~ryov/dm-ioband/patches/dm-ioband-1.7.0.patch

Thanks for the advice.

> It seem interesting to me.  (I'm still reading through the description and haven't started looking at the code.)

I would also be happy if you give me any comments on the code.

> Regarding:
> +                ioband_device_id
> +
> +                          The ID number for an ioband device. The same ID
> +                        must be set among the ioband devices that share the
> +                        same bandwidth, which means they work on the same
> +                        physical disk.
> ... but it doesn't have to be the same physical disk, right?  It could be a group if disks if you felt the need to do something like that, right?  (You could treat a JBOD as one unit.)  Otherwise, you could probably eliminate this field.

As you wrote, dm-ioband can treat a logical volume on different
physical devices like this:
http://people.valinux.co.jp/~ryov/dm-ioband/benchmark/lvm.html

Thanks,
Ryo Tsuruta
