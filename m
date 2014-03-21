From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH RFC v1 00/01] dm-lightnvm introduction
Date: Thu, 20 Mar 2014 23:32:17 -0700
Message-ID: <1395383538-18019-1-git-send-email-m@bjorling.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
List-Id: dm-devel.ids

Hi,

Users that have custom firmware SSDs, may choose to expose their flash =
directly.
This allows the host to control logical to physical address mappings, g=
arbage
collection strategy, wear-leveling, and so on.

This is beneficial when you either want to strip the cost of a costly c=
ontroller
or want detailed control over an SSD. Such as implementing key-value st=
ores,
object-stored, atomic I/Os, etc.

LightNVM implements the host-side core. It supports two modes. Users th=
at
doesn't have hardware available and want to emulate an SSD, and users w=
ith a
physical SSD, that has a LightNVM compatible firmware.

The behavior of the core can be exposed through the various components =
that make
up an FTL. Thus, it is not single implementation, but instead possible =
to
mix the best algorithms for the user-space application workloads.

Currently, LightNVM implements a page-based FTL, cost-based GC and simp=
le
wear-leveling. Additionally, it allows simulation of flash timings when=
 hardware
isn't available. There's work on getting it to the OpenSSD platform wit=
h a
custom firmware and getting it stable for broad use.

There is still much work to do. I'm looking for feedback on the approac=
h, dm
integration, and more. Any feedback is greatly appreciated.

A presentation was given at the recent Non-Volatile Memory Workshop (NV=
MW)
workshop. Slides are available at: http://bjorling.me/NVMW2014-LightNVM=
=2Epdf

Major todo's:
 * Patch has TODO and FIXME in places that needs to be cleaned.
 * LightNVM compatible firmware for the OpenSSD platform and integratio=
n.
 * Performance regressions during GC.
 * Durability during power failure.

Thanks,

Matias

Matias Bj=C3=B8rling (1):
  dm-lightnvm: An open FTL for open firmware SSDs

 drivers/md/Kconfig             |   1 +
 drivers/md/Makefile            |   1 +
 drivers/md/lightnvm/Kconfig    |  14 +
 drivers/md/lightnvm/Makefile   |   1 +
 drivers/md/lightnvm/core.c     | 705 +++++++++++++++++++++++++++++++++=
++++++++
 drivers/md/lightnvm/gc.c       | 208 ++++++++++++
 drivers/md/lightnvm/lightnvm.c | 589 +++++++++++++++++++++++++++++++++=
+
 drivers/md/lightnvm/lightnvm.h | 592 +++++++++++++++++++++++++++++++++=
+
 drivers/md/lightnvm/reg.c      |  41 +++
 9 files changed, 2152 insertions(+)
 create mode 100644 drivers/md/lightnvm/Kconfig
 create mode 100644 drivers/md/lightnvm/Makefile
 create mode 100644 drivers/md/lightnvm/core.c
 create mode 100644 drivers/md/lightnvm/gc.c
 create mode 100644 drivers/md/lightnvm/lightnvm.c
 create mode 100644 drivers/md/lightnvm/lightnvm.h
 create mode 100644 drivers/md/lightnvm/reg.c

--=20
1.8.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
