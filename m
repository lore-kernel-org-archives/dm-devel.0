From: Gris Ge <fge@redhat.com>
Subject: [PATCH V3 0/3] Introducing multipath C API
Date: Fri,  1 Jul 2016 20:46:53 +0800
Message-ID: <20160701124656.169890-1-fge@redhat.com>
References: <1455264623-16199-2-git-send-email-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1455264623-16199-2-git-send-email-fge@redhat.com>
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

Changes since V2:
 * Use json interface "show maps json".
 * Removed the use of enum.
 * Use libmpathcmd for IPC communication.
 * Include two trivial fixes for libmpathcmd.

Gris Ge (3):
  multipath-tools: Increase MAX_REPLY_LEN.
  multipath-tools: Set errno mpath_recv_reply() when failure.
  multipath-tools: Introducing multipath C API <libdmmp/libdmmp.h>

 .gitignore                        |    4 +
 Makefile                          |    1 +
 Makefile.inc                      |    3 +
 libdmmp/DEV_NOTES                 |   41 +
 libdmmp/Makefile                  |   78 +
 libdmmp/docs/kernel-doc           | 2971 +++++++++++++++++++++++++++++++++++++
 libdmmp/docs/libdmmp.h.3          |  113 ++
 libdmmp/docs/split-man.pl         |   41 +
 libdmmp/libdmmp.c                 |  272 ++++
 libdmmp/libdmmp.pc.in             |    9 +
 libdmmp/libdmmp/libdmmp.h         |  607 ++++++++
 libdmmp/libdmmp_misc.c            |   87 ++
 libdmmp/libdmmp_mp.c              |  150 ++
 libdmmp/libdmmp_path.c            |  115 ++
 libdmmp/libdmmp_pg.c              |  208 +++
 libdmmp/libdmmp_private.h         |  208 +++
 libdmmp/test/Makefile             |   30 +
 libdmmp/test/libdmmp_speed_test.c |   49 +
 libdmmp/test/libdmmp_test.c       |  144 ++
 libmpathcmd/mpath_cmd.c           |   10 +-
 libmpathcmd/mpath_cmd.h           |    4 +-
 21 files changed, 5140 insertions(+), 5 deletions(-)
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

-- 
2.9.0
