From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/3] miscellaneous multipath patches
Date: Fri,  3 Oct 2014 19:11:20 -0500
Message-ID: <1412381483-15757-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Here are a couple of unrelated multipath bugfixes.

Benjamin Marzinski (3):
  libmultipath: replace PATH_TIMEOUT with PATH_DOWN
  libmultipath: fix sysfs_get_size bug
  Revert "libmultipath: fixup strlcpy"

 libmultipath/checkers.c     | 1 -
 libmultipath/checkers.h     | 5 -----
 libmultipath/checkers/tur.c | 5 ++---
 libmultipath/discovery.c    | 2 --
 libmultipath/print.c        | 2 --
 libmultipath/sysfs.c        | 2 +-
 libmultipath/util.c         | 3 ++-
 7 files changed, 5 insertions(+), 15 deletions(-)

-- 
1.8.3.1
