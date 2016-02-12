From: Gris Ge <fge@redhat.com>
Subject: [PATCH V2] Introducing multipath C API.
Date: Fri, 12 Feb 2016 16:10:22 +0800
Message-ID: <1455264623-16199-1-git-send-email-fge@redhat.com>
References: <56AF5F58.6030302@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56AF5F58.6030302@suse.de>
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

Based on these posted patches:
    * [PATCH v2 1/3] Add %g format specifier to 'multipathd show paths format'
      command
    * [PATCH v2 2/3] Add 'show groups' command to multipathd
    * [PATCH v2 3/3] Add options to the show groups command

Changes since V1:
    * Use multipathd IPC instead of libmultipath.
    * Removed DMMP_ERR_INVALID_ARGUMENT error, application will be terminated
      by assert if illegal argument provided.

Gris Ge (1):
  Introducing multipath C API <libdmmp/libdmmp.h>

 .gitignore                        |    4 +
 Makefile                          |    1 +
 Makefile.inc                      |    5 +-
 libdmmp/DEV_NOTES                 |   40 +
 libdmmp/Makefile                  |   74 +
 libdmmp/docs/kernel-doc           | 2703 +++++++++++++++++++++++++++++++++++++
 libdmmp/docs/libdmmp.h.3          |  113 ++
 libdmmp/docs/split-man.pl         |   41 +
 libdmmp/libdmmp.c                 |  515 +++++++
 libdmmp/libdmmp.pc.in             |    9 +
 libdmmp/libdmmp/libdmmp.h         |  617 +++++++++
 libdmmp/libdmmp_misc.c            |  239 ++++
 libdmmp/libdmmp_mp.c              |  242 ++++
 libdmmp/libdmmp_path.c            |  156 +++
 libdmmp/libdmmp_pg.c              |  247 ++++
 libdmmp/libdmmp_private.h         |  292 ++++
 libdmmp/test/Makefile             |   29 +
 libdmmp/test/libdmmp_speed_test.c |   49 +
 libdmmp/test/libdmmp_test.c       |  141 ++
 19 files changed, 5516 insertions(+), 1 deletion(-)
 create mode 100644 libdmmp/DEV_NOTES
 create mode 100644 libdmmp/Makefile
 create mode 100755 libdmmp/docs/kernel-doc
 create mode 100644 libdmmp/docs/libdmmp.h.3
 create mode 100755 libdmmp/docs/split-man.pl
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
2.7.1
