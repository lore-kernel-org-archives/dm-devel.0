From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] self-contained "kpartx kicker"
Date: Thu, 7 Apr 2005 10:15:08 +0200
Message-ID: <20050407081508.GA2617@averon.dyndns.org>
References: <20050406.211615.74755485.k-ueda@kde.biglobe.ne.jp@kde.biglobe.ne.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050406.211615.74755485.k-ueda@kde.biglobe.ne.jp@kde.biglobe.ne.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Apr 06, 2005 at 09:16:15PM -0400, k-ueda@ct.jp.nec.com wrote:
> Hello,
> 
> I think that self-contained "kpartx kicker" which doesn't require
> shell is needed for / on dm-multipath.
> The attached patch makes kpartx works like /etc/dev.d/block/multipath.dev
> if kpartx is called as "kpartx.dev".
> The patch is for multipath-tools-0.4.4-pre8.
> 
> Any comments are welcome.
> 
> 
> Background
> ----------
> If you have / on a partition on dm-multipath device, kpartx has to
> be launched on the initramfs.
> /etc/dev.d/block/multipath.dev does it over hotplug event, but
> multipath.dev is shell script.
> 
> In the initramfs of Fedora / RedHat, /bin/sh and any libraries aren't
> included.  I feel it is their policy and I think it isn't recommended
> to run shell scritp on the initramfs of Fedora / RedHat.
> 
It's a nice to have feature, but I don't really understand the reasons you present :
kpartx needs running only after multipath, if multipath is execed from initrd why bother doing kpartx in initramfs ?

Either we need to do the same "hotplug mode" in multipath too, or nothing.

I guess the former brings more freedom to distributors as they can choose how they want to run, and it is overall good for performance and memory utilisation.

Care to do the multipath part ?

regards,
cvaroqui
