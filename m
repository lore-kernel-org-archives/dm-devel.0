From: Mauro Carvalho Chehab <mchehab+huawei-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 00/29] Documentation fixes
Date: Mon, 15 Jun 2020 08:46:39 +0200
Message-ID: <cover.1592203542.git.mchehab+huawei@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Sender: "iommu" <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
To: Linux Doc Mailing List <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, Geert Uytterhoeven <geert+renesas-gXvu3+zWzMSzQB+pC5nmwQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bartosz Golaszewski <bgolaszewski-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, NXP Linux Team <linux-imx-3arQi8VN3Tc@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nicholas Piggin <npiggin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pen
List-Id: dm-devel.ids

Hi Jon,

That's a bunch of files I have to be applied on the top of v5.8-rc1 fixing
documentation warnings. I already removed some duplicated stuff.

Regards,
Mauro

Mauro Carvalho Chehab (29):
  mm: vmalloc.c: remove a kernel-doc annotation from a removed parameter
  net: dev: add a missing kernel-doc annotation
  net: netdevice.h: add a description for napi_defer_hard_irqs
  scripts/kernel-doc: parse __ETHTOOL_DECLARE_LINK_MODE_MASK
  net: pylink.h: add kernel-doc descriptions for new fields at
    phylink_config
  scripts/kernel-doc: handle function pointer prototypes
  fs: fs.h: fix a kernel-doc parameter description
  gpio: driver.h: fix kernel-doc markup
  kcsan: fix a kernel-doc warning
  rcu: fix some kernel-doc warnings
  fs: docs: f2fs.rst: fix a broken table
  dt: update a reference for reneases pcar file renamed to yaml
  dt: fix broken links due to txt->yaml renames
  dt: Fix broken references to renamed docs
  dt: fix reference to olpc,xo1.75-ec.txt
  selftests/vm/keys: fix a broken reference at protection_keys.c
  docs: hugetlbpage.rst: fix some warnings
  docs: powerpc: fix some issues at vas-api.rst
  docs: driver-model: remove a duplicated markup at driver.rst
  docs: watch_queue.rst: supress some Sphinx warnings and move to
    core-api
  docs: device-mapper: add dm-ebs.rst to an index file
  docs: it_IT: add two missing references
  docs: ABI: fix a typo when pointing to w1-generic.rst
  docs: fs: locking.rst: fix a broken table
  docs: add bus-virt-phys-mapping.txt to core-api
  docs: fix references for DMA*.txt files
  docs: dt: minor adjustments at writing-schema.rst
  docs: fs: proc.rst: fix a warning due to a merge conflict
  docs: fs: proc.rst: convert a new chapter to ReST

 .../ABI/testing/sysfs-driver-w1_therm         |   2 +-
 Documentation/PCI/pci.rst                     |   6 +-
 .../admin-guide/device-mapper/index.rst       |   1 +
 Documentation/admin-guide/mm/hugetlbpage.rst  |  25 ++-
 Documentation/block/biodoc.rst                |   2 +-
 .../bus-virt-phys-mapping.rst}                |   2 +-
 Documentation/core-api/dma-api.rst            |   6 +-
 Documentation/core-api/dma-isa-lpc.rst        |   2 +-
 Documentation/core-api/index.rst              |   2 +
 Documentation/{ => core-api}/watch_queue.rst  |  34 ++--
 .../bindings/arm/freescale/fsl,scu.txt        |   2 +-
 .../bindings/display/bridge/sii902x.txt       |   2 +-
 .../bindings/display/imx/fsl-imx-drm.txt      |   4 +-
 .../devicetree/bindings/display/imx/ldb.txt   |   4 +-
 .../display/rockchip/rockchip-drm.yaml        |   2 +-
 .../bindings/misc/olpc,xo1.75-ec.txt          |   2 +-
 .../bindings/net/mediatek-bluetooth.txt       |   2 +-
 .../bindings/pinctrl/renesas,pfc-pinctrl.txt  |   2 +-
 .../bindings/sound/audio-graph-card.txt       |   2 +-
 .../bindings/sound/st,sti-asoc-card.txt       |   2 +-
 .../bindings/spi/qcom,spi-geni-qcom.txt       |   2 +-
 Documentation/devicetree/writing-schema.rst   |   9 +-
 .../driver-api/driver-model/driver.rst        |   2 -
 Documentation/driver-api/usb/dma.rst          |   6 +-
 Documentation/filesystems/f2fs.rst            | 150 ++++++++++++------
 Documentation/filesystems/locking.rst         |   6 +-
 Documentation/filesystems/proc.rst            |  46 +++---
 Documentation/memory-barriers.txt             |   6 +-
 Documentation/mips/ingenic-tcu.rst            |   2 +-
 Documentation/powerpc/vas-api.rst             |  23 ++-
 Documentation/security/keys/core.rst          |   2 +-
 .../it_IT/process/management-style.rst        |   2 +
 .../it_IT/process/submitting-patches.rst      |   2 +
 .../translations/ko_KR/memory-barriers.txt    |   6 +-
 MAINTAINERS                                   |   8 +-
 arch/ia64/hp/common/sba_iommu.c               |  12 +-
 arch/parisc/kernel/pci-dma.c                  |   2 +-
 arch/x86/include/asm/dma-mapping.h            |   4 +-
 arch/x86/kernel/amd_gart_64.c                 |   2 +-
 drivers/parisc/sba_iommu.c                    |  14 +-
 include/linux/dma-mapping.h                   |   2 +-
 include/linux/fs.h                            |   2 +-
 include/linux/gpio/driver.h                   |   2 +-
 include/linux/kcsan-checks.h                  |  10 +-
 include/linux/netdevice.h                     |   2 +
 include/linux/phylink.h                       |   4 +
 include/linux/rculist.h                       |   2 +-
 include/linux/watch_queue.h                   |   2 +-
 include/media/videobuf-dma-sg.h               |   2 +-
 init/Kconfig                                  |   2 +-
 kernel/dma/debug.c                            |   2 +-
 kernel/watch_queue.c                          |   2 +-
 mm/vmalloc.c                                  |   1 -
 net/core/dev.c                                |   1 +
 scripts/kernel-doc                            |   7 +
 tools/testing/selftests/vm/protection_keys.c  |   2 +-
 56 files changed, 282 insertions(+), 175 deletions(-)
 rename Documentation/{bus-virt-phys-mapping.txt => core-api/bus-virt-phys-mapping.rst} (99%)
 rename Documentation/{ => core-api}/watch_queue.rst (94%)

-- 
2.26.2
