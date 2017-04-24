From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/5] More misc patches
Date: Mon, 24 Apr 2017 17:39:25 -0500
Message-ID: <1493073570-17167-1-git-send-email-bmarzins@redhat.com>
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

Here are a couple of bug fixes and cleanups. Since nobody complained
about the DELL MD3xxx merge, I put that in as well. I've left out the
multipath.rules change from before, since that one shouldn't go in
without an explicit ACK from other maintainers.

Benjamin Marzinski (5):
  multipath: Merge the DELL MD3xxx device configs
  multipath: fix up position independent code
  libmultipath: fix partition detection
  kpartx: default to running in sync mode
  libmultipath: force udev reloads

 Makefile.inc                       |  6 +++-
 kpartx/Makefile                    |  3 +-
 kpartx/kpartx.c                    | 10 +++++--
 kpartx/kpartx.rules                |  2 +-
 libdmmp/Makefile                   |  2 +-
 libmpathcmd/Makefile               |  2 ++
 libmpathpersist/Makefile           |  2 +-
 libmultipath/Makefile              |  2 +-
 libmultipath/checkers/Makefile     |  2 +-
 libmultipath/configure.c           |  7 ++++-
 libmultipath/devmapper.c           | 56 ++++++++++++++++++--------------------
 libmultipath/hwtable.c             | 26 +-----------------
 libmultipath/prioritizers/Makefile |  2 +-
 libmultipath/structs.h             |  1 +
 mpathpersist/Makefile              |  3 +-
 multipath/Makefile                 |  4 +--
 multipathd/Makefile                |  6 ++--
 17 files changed, 63 insertions(+), 73 deletions(-)

-- 
1.8.3.1
