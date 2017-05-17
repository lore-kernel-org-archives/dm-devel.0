From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/7] Seven small multipath-tools patches
Date: Wed, 17 May 2017 08:43:02 -0700
Message-ID: <20170517154309.17787-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Christoph,

The seven patches in this series are minor changes to a Makefile,
header files and source files that do not change any functionality
but make the code easier to maintain.

Please consider the patches in this series for inclusion in the
multipath-tools project.

Thanks,

Bart.

Bart Van Assche (7):
  Makefile: Remove assignments to unused variables
  libmultipath/configure.h: Add a forward declaration
  libmpathpersist: Add two missing #include directives
  Remove mpath_reverse_8bytes_order()
  Move the declaration of mpath_mx_alloc_len to a header file
  kpartx: Fix a compiler warning
  Remove a superfluous "extern" keyword

 Makefile                         | 27 +--------------------------
 kpartx/Makefile                  |  4 ++++
 kpartx/sysmacros.h               |  6 ++++++
 libmpathpersist/mpath_persist.h  |  3 +++
 libmpathpersist/mpath_pr_ioctl.c | 15 ---------------
 libmpathpersist/mpath_updatepr.c |  1 +
 libmpathpersist/mpathpr.h        |  2 ++
 libmultipath/configure.h         |  2 ++
 libmultipath/propsel.c           |  3 +--
 mpathpersist/main.c              |  1 -
 multipathd/main.c                |  2 --
 11 files changed, 20 insertions(+), 46 deletions(-)

-- 
2.12.2
