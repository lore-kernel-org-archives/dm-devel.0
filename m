From: Christophe Saout <christophe@saout.de>
Subject: Re: Partition tables on devices
Date: Thu, 21 Jun 2007 22:14:36 +0200
Message-ID: <1182456876.14602.13.camel@leto.intern.saout.de>
References: <Pine.LNX.4.62.0706211726260.3710@pademelon.sonytel.be>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.62.0706211726260.3710@pademelon.sonytel.be>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Geert,

> I have a disk that embeds another disk image (including a partition table and
> partitions).  Using dmsetup and the linear target I created a new device to
> access the embedded disk image. Cfdisk shows me the partitions on the new
> device, but the kernel didn't scan for partitions and hence didn't created
> devices for them.
> 
> Does there exist a way to let the kernel scan for partition tables on a device
> created using dmsetup? Or should I use a script like the one proposed by
> Christophe Saout in http://lkml.org/lkml/2003/7/18/141?

There's a small tool
"kpartx" ( http://www.die.net/doc/linux/man/man8/kpartx.8.html ), which
I think, IIRC is a simple port of the kernel partition detection code to
userspace, which uses the device mapper to set things up. I have used it
at times, it works nicely (it can even replace the kernel detection code
seamlessly, if put into an initramfs for instance). 

There's a copy of it in the distributed with the multipath tools.
