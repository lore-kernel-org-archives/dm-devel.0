From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/9] misc cleanups and bugfixes
Date: Fri,  7 Apr 2017 01:16:29 -0500
Message-ID: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

These patches are all just small cleanup and bugfixes.

Benjamin Marzinski (9):
  libdmmp: minor Makefile cleanup
  multipath-tools: remove incdir from Makefiles
  libdmmp: don't disconnect from multipathd twice
  multipathd: don't call strlen on NULL variables
  libdmmp: move libdmmp.pc install location
  multipathd: drop lock before calling uev_add_path
  multipathd: allow devices to switch from RW to RO
  libmultipath: don't set max_sectors_kb on reloads
  multipath: fix segfault with disable_changed_wwids

 Makefile.inc             |  3 +--
 libdmmp/Makefile         | 18 +++++++--------
 libdmmp/libdmmp.c        |  1 -
 libdmmp/test/Makefile    |  2 +-
 libmpathcmd/Makefile     |  6 ++---
 libmpathpersist/Makefile |  6 ++---
 libmultipath/configure.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++--
 libmultipath/devmapper.c |  9 ++++----
 libmultipath/discovery.c | 23 -------------------
 libmultipath/discovery.h |  1 -
 libmultipath/structs.h   |  1 +
 multipathd/main.c        | 21 ++++++++++++-----
 12 files changed, 96 insertions(+), 55 deletions(-)

-- 
1.8.3.1
