From: Gris Ge <fge@redhat.com>
Subject: [PATCH V6 0/3] Introducing multipath C API
Date: Tue, 12 Jul 2016 14:50:35 +0800
Message-ID: <20160712065038.17565-1-fge@redhat.com>
References: <1453953120-7023-1-git-send-email-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1453953120-7023-1-git-send-email-fge@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Gris Ge <fge@redhat.com>
List-Id: dm-devel.ids

Changes since V5:
 * Fix commit message typo of patch 1/3:
    'EINVA vs EINVAL' and 'dedicate vs dedicated'
 * Use $(LN) and $(RM) in Makefile in patch 3/3.
 * Rebased to current master(c9aef428b1b16b8128c9fbed1cdefe30bed4ac6f).

Changes since V4:

 * Remove the unused constant incorrectly added to libmpathcmd in V3.
 * The patch 3/3 could also be found in below link if dm-devel mailing list
   discard that patch again:
    https://github.com/cathay4t/multipath-tools/commit/b992056a447b90251a65aa4919055c70aa62a498.patch

Changes since V3:
 * New way to limit the IPC command length.
 * Treat IPC connection refuse error as DMMP_ERR_NO_DAEMON.

Gris Ge (3):
  multipath-tools: New way to limit the IPC command length.
  multipath-tools: Set errno mpath_recv_reply() when failure
  multipath-tools: Introducing multipath C API

 .gitignore                            |    4 +
 Makefile                              |    1 +
 Makefile.inc                          |    3 +
 libdmmp/DEV_NOTES                     |   41 +
 libdmmp/Makefile                      |   78 +
 libdmmp/docs/kernel-doc               | 2971 +++++++++++++++++++++++++++++++++
 libdmmp/docs/libdmmp.h.3              |  113 ++
 libdmmp/docs/split-man.pl             |   41 +
 libdmmp/libdmmp.c                     |  286 ++++
 libdmmp/libdmmp.pc.in                 |    9 +
 libdmmp/libdmmp/libdmmp.h             |  607 +++++++
 libdmmp/libdmmp_misc.c                |   87 +
 libdmmp/libdmmp_mp.c                  |  150 ++
 libdmmp/libdmmp_path.c                |  115 ++
 libdmmp/libdmmp_pg.c                  |  208 +++
 libdmmp/libdmmp_private.h             |  208 +++
 libdmmp/test/Makefile                 |   30 +
 libdmmp/test/libdmmp_speed_test.c     |   49 +
 libdmmp/test/libdmmp_test.c           |  144 ++
 libmpathcmd/mpath_cmd.c               |    6 +-
 libmpathcmd/mpath_cmd.h               |    2 -
 libmpathpersist/mpath_updatepr.c      |    6 +-
 libmultipath/Makefile                 |    2 +-
 libmultipath/alias.c                  |    1 -
 libmultipath/configure.c              |    5 +-
 libmultipath/file.c                   |   24 +-
 libmultipath/file.h                   |    1 +
 libmultipath/uxsock.h                 |    6 -
 libmultipath/wwids.c                  |    1 -
 multipath/main.c                      |    1 -
 multipathd/Makefile                   |    2 +-
 multipathd/uxclnt.c                   |   13 +-
 multipathd/uxlsnr.c                   |   12 +-
 {libmultipath => multipathd}/uxsock.c |   69 +-
 multipathd/uxsock.h                   |   13 +
 35 files changed, 5210 insertions(+), 99 deletions(-)
 create mode 100644 libdmmp/DEV_NOTES
 create mode 100644 libdmmp/Makefile
 create mode 100644 libdmmp/docs/kernel-doc
 create mode 100644 libdmmp/docs/libdmmp.h.3
 create mode 100644 libdmmp/docs/split-man.pl
 create mode 100644 libdmmp/libdmmp.c
 create mode 100644 libdmmp/libdmmp.pc.in
 create mode 100644 libdmmp/libdmmp/libdmmp.h
 create mode 100644 libdmmp/libdmmp_misc.c
 create mode 100644 libdmmp/libdmmp_mp.c
 create mode 100644 libdmmp/libdmmp_path.c
 create mode 100644 libdmmp/libdmmp_pg.c
 create mode 100644 libdmmp/libdmmp_private.h
 create mode 100644 libdmmp/test/Makefile
 create mode 100644 libdmmp/test/libdmmp_speed_test.c
 create mode 100644 libdmmp/test/libdmmp_test.c
 delete mode 100644 libmultipath/uxsock.h
 rename {libmultipath => multipathd}/uxsock.c (67%)
 create mode 100644 multipathd/uxsock.h

-- 
2.9.0
