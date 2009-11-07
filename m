From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v4 00/12] introduce skip_spaces(),
	reducing code size plus some clean-ups
Date: Sat,  7 Nov 2009 13:16:08 -0200
Message-ID: <cover.1257602781.git.andre.goddard@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com, Michael Holzheu <holzheu@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-f>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
List-Id: dm-devel.ids

This patch reduces lib.a code size by 173 bytes on my Core 2 with gcc 4.4=
.1
even considering that it exports a newly defined function skip_spaces()
to drivers:
   text    data     bss     dec     hex filename                         =
 =20
  64867     840     592   66299   102fb (TOTALS-lib.a-before)
  64954     584     588   66126   1024e (TOTALS-lib.a-after)
and implements some code tidy up.

Besides reducing lib.a size, it converts many in-tree drivers to use the
newly defined function, which makes another small reduction on kernel siz=
e
overall when those drivers are used.

p.s.: Ingo, I hope to have finally fixed my environment by using send-ema=
il now.
Please let me know if you have any problem with these and thank you for t=
he
good advice. get_maintainer.pl gave lots of people as output, I hope that=
's ok.

Changelog:
   v4: convert drivers over newly defined skip_spaces() function=20
   v3: improved comments on patch 5/7 and factorize a switch statement on=
 6/7
as per suggestions from Ingo and Frederic (thanks!)
   v2: addressed feedback from Frederic Weisbecker review (thanks!!)
and split into separate patches
   v1: original submission

Andr=C3=A9 Goddard Rosa (12):
  vsprintf: factorize "(null)" string
  vsprintf: pre-calculate final string length for later use
  vsprintf: give it some care to please checkpatch.pl
  vsprintf: use TOLOWER whenever possible
  vsprintf: reduce code size by avoiding extra check
  vsprintf: move local vars to block local vars and remove unneeded
    ones
  vsprintf: factor out skip_space code in a separate function
  vsprintf: reuse almost identical simple_strtoulX() functions
  ctype: constify read-only _ctype string
  string: factorize skip_spaces and export it to be generally available
  string: on strstrip(), first remove leading spaces before running
    over str
  tree-wide: convert open calls to remove spaces to skip_spaces() lib
    function

 arch/s390/kernel/debug.c              |    3 +-
 arch/um/drivers/mconsole_kern.c       |   16 +-
 arch/x86/kernel/cpu/mtrr/if.c         |   11 +-
 drivers/md/dm-table.c                 |    6 +-
 drivers/md/md.c                       |    4 +-
 drivers/parisc/pdc_stable.c           |    9 +-
 drivers/platform/x86/thinkpad_acpi.c  |    7 +-
 drivers/pnp/interface.c               |   36 +---
 drivers/s390/block/dasd_proc.c        |    5 +-
 drivers/video/backlight/lcd.c         |    4 +-
 drivers/video/display/display-sysfs.c |    2 +-
 fs/cachefiles/daemon.c                |    8 +-
 fs/ext4/super.c                       |    7 +-
 include/linux/ctype.h                 |    2 +-
 include/linux/string.h                |    1 +
 kernel/params.c                       |    8 +-
 lib/argv_split.c                      |   13 +-
 lib/ctype.c                           |   50 +++---
 lib/dynamic_debug.c                   |    4 +-
 lib/string.c                          |   19 ++-
 lib/vsprintf.c                        |  342 ++++++++++++++++-----------=
------
 net/irda/irnet/irnet.h                |    1 +
 net/irda/irnet/irnet_ppp.c            |    8 +-
 net/netfilter/xt_recent.c             |    3 +-
 sound/pci/hda/hda_hwdep.c             |    7 +-
 25 files changed, 264 insertions(+), 312 deletions(-)
