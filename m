From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 56/79] docs: Documentation/*.txt: rename all ReST files
	to *.rst
Date: Mon, 22 Apr 2019 10:37:35 -0600
Message-ID: <3e26b3a0-bcd3-93a1-d21c-ac1041f93697@deltatee.com>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
	<cda57849a6462ccc72dcd360b30068ab6a1021c4.1555938376.git.mchehab+samsung@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <cda57849a6462ccc72dcd360b30068ab6a1021c4.1555938376.git.mchehab+samsung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-CA
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab+samsung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux Doc Mailing List <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Farhan Ali <alifm-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Halil Pasic <pasic-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, openipmi-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nicholas Piggin <npiggin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sean Paul <sean-p7yTbzM4H96eqtR555YLDQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-wireless@v
List-Id: dm-devel.ids



On 2019-04-22 7:27 a.m., Mauro Carvalho Chehab wrote:

> 
> Later patches will move them to a better place and remove the
> :orphan: markup.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  Documentation/ABI/removed/sysfs-class-rfkill  |  2 +-
>  Documentation/ABI/stable/sysfs-class-rfkill   |  2 +-
>  Documentation/ABI/stable/sysfs-devices-node   |  2 +-
>  Documentation/ABI/testing/procfs-diskstats    |  2 +-
>  Documentation/ABI/testing/sysfs-block         |  2 +-
>  .../ABI/testing/sysfs-class-switchtec         |  2 +-
>  .../ABI/testing/sysfs-devices-system-cpu      |  4 +-
>  .../{DMA-API-HOWTO.txt => DMA-API-HOWTO.rst}  |  2 +
>  Documentation/{DMA-API.txt => DMA-API.rst}    |  8 ++-
>  .../{DMA-ISA-LPC.txt => DMA-ISA-LPC.rst}      |  4 +-
>  ...{DMA-attributes.txt => DMA-attributes.rst} |  2 +
>  Documentation/{IPMI.txt => IPMI.rst}          |  2 +
>  .../{IRQ-affinity.txt => IRQ-affinity.rst}    |  2 +
>  .../{IRQ-domain.txt => IRQ-domain.rst}        |  2 +
>  Documentation/{IRQ.txt => IRQ.rst}            |  2 +
>  .../{Intel-IOMMU.txt => Intel-IOMMU.rst}      |  2 +
>  Documentation/PCI/pci.txt                     |  8 +--
>  Documentation/{SAK.txt => SAK.rst}            |  2 +
>  Documentation/{SM501.txt => SM501.rst}        |  2 +
>  .../admin-guide/kernel-parameters.txt         |  6 +-
>  Documentation/admin-guide/l1tf.rst            |  2 +-
>  .../{atomic_bitops.txt => atomic_bitops.rst}  |  2 +
>  Documentation/block/biodoc.txt                |  2 +-
>  .../{bt8xxgpio.txt => bt8xxgpio.rst}          |  2 +
>  Documentation/{btmrvl.txt => btmrvl.rst}      |  2 +
>  ...-mapping.txt => bus-virt-phys-mapping.rst} |  4 +-
>  ...g-warn-once.txt => clearing-warn-once.rst} |  2 +
>  Documentation/{cpu-load.txt => cpu-load.rst}  |  2 +
>  .../{cputopology.txt => cputopology.rst}      |  2 +
>  Documentation/{crc32.txt => crc32.rst}        |  2 +
>  Documentation/{dcdbas.txt => dcdbas.rst}      |  2 +
>  ...ging-modules.txt => debugging-modules.rst} |  2 +
>  ...hci1394.txt => debugging-via-ohci1394.rst} |  2 +
>  Documentation/{dell_rbu.txt => dell_rbu.rst}  |  2 +
>  Documentation/device-mapper/statistics.rst    |  4 +-
>  .../devicetree/bindings/phy/phy-bindings.txt  |  2 +-
>  Documentation/{digsig.txt => digsig.rst}      |  2 +
>  Documentation/driver-api/usb/dma.rst          |  6 +-
>  Documentation/driver-model/device.rst         |  2 +-
>  Documentation/{efi-stub.txt => efi-stub.rst}  |  2 +
>  Documentation/{eisa.txt => eisa.rst}          |  2 +
>  Documentation/fb/vesafb.rst                   |  2 +-
>  Documentation/filesystems/sysfs.txt           |  2 +-
>  ...ex-requeue-pi.txt => futex-requeue-pi.rst} |  2 +
>  .../{gcc-plugins.txt => gcc-plugins.rst}      |  2 +
>  Documentation/gpu/drm-mm.rst                  |  2 +-
>  Documentation/{highuid.txt => highuid.rst}    |  2 +
>  .../{hw_random.txt => hw_random.rst}          |  2 +
>  .../{hwspinlock.txt => hwspinlock.rst}        |  2 +
>  Documentation/ia64/IRQ-redir.txt              |  2 +-
>  .../{intel_txt.txt => intel_txt.rst}          |  2 +
>  .../{io-mapping.txt => io-mapping.rst}        |  2 +
>  .../{io_ordering.txt => io_ordering.rst}      |  2 +
>  Documentation/{iostats.txt => iostats.rst}    |  2 +
>  ...flags-tracing.txt => irqflags-tracing.rst} |  2 +
>  Documentation/{isa.txt => isa.rst}            |  2 +
>  Documentation/{isapnp.txt => isapnp.rst}      |  2 +
>  ...hreads.txt => kernel-per-CPU-kthreads.rst} |  4 +-
>  Documentation/{kobject.txt => kobject.rst}    |  4 +-
>  Documentation/{kprobes.txt => kprobes.rst}    |  2 +
>  Documentation/{kref.txt => kref.rst}          |  2 +
>  Documentation/laptops/thinkpad-acpi.txt       |  6 +-
>  Documentation/{ldm.txt => ldm.rst}            |  2 +
>  Documentation/locking/rt-mutex.rst            |  2 +-
>  ...kup-watchdogs.txt => lockup-watchdogs.rst} |  2 +
>  Documentation/{lsm.txt => lsm.rst}            |  2 +
>  Documentation/{lzo.txt => lzo.rst}            |  2 +
>  Documentation/{mailbox.txt => mailbox.rst}    |  2 +
>  Documentation/memory-barriers.txt             |  6 +-
>  ...hameleon-bus.txt => men-chameleon-bus.rst} |  2 +
>  Documentation/networking/scaling.rst          |  4 +-
>  .../{nommu-mmap.txt => nommu-mmap.rst}        |  2 +
>  Documentation/{ntb.txt => ntb.rst}            |  2 +
>  Documentation/{numastat.txt => numastat.rst}  |  2 +
>  Documentation/{padata.txt => padata.rst}      |  2 +
>  ...port-lowlevel.txt => parport-lowlevel.rst} |  2 +
>  ...-semaphore.txt => percpu-rw-semaphore.rst} |  2 +
>  Documentation/{phy.txt => phy.rst}            |  2 +
>  Documentation/{pi-futex.txt => pi-futex.rst}  |  2 +
>  Documentation/{pnp.txt => pnp.rst}            |  2 +
>  ...reempt-locking.txt => preempt-locking.rst} |  2 +
>  Documentation/{pwm.txt => pwm.rst}            |  2 +
>  Documentation/{rbtree.txt => rbtree.rst}      |  2 +
>  .../{remoteproc.txt => remoteproc.rst}        |  4 +-
>  Documentation/{rfkill.txt => rfkill.rst}      |  2 +
>  ...ust-futex-ABI.txt => robust-futex-ABI.rst} |  2 +
>  ...{robust-futexes.txt => robust-futexes.rst} |  2 +
>  Documentation/{rpmsg.txt => rpmsg.rst}        |  2 +
>  Documentation/{rtc.txt => rtc.rst}            |  2 +
>  Documentation/s390/vfio-ccw.rst               |  6 +-
>  Documentation/{sgi-ioc4.txt => sgi-ioc4.rst}  |  2 +
>  Documentation/{siphash.txt => siphash.rst}    |  2 +
>  .../{smsc_ece1099.txt => smsc_ece1099.rst}    |  2 +
>  .../{speculation.txt => speculation.rst}      |  2 +
>  .../{static-keys.txt => static-keys.rst}      |  2 +
>  Documentation/{svga.txt => svga.rst}          |  2 +
>  .../{switchtec.txt => switchtec.rst}          |  4 +-

For all the switchtec changes:

Acked-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>

Thanks,

Logan
