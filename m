From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 0/6] multipath: path validation library prep
	work
Date: Mon, 18 May 2020 23:57:02 -0500
Message-ID: <1589864228-1363-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

I've been playing around with the SID code more and I've decided to hold
off on submitting the library until I have it working with the SID
multipath module better. Instead, I've pulled out the common code that
multipath -u/-c and the library can use, and put it into libmultipath.

I've also removed some of the ordering differences between the existing
code and my new code.  Right now, the only difference is that if a path
is currently multipathed, it will always be claimed as a valid path.

Patches 0001 & 0002 are the same as in my "RFC PATCH v2" set, and patch
0005 is the same as my "libmultipath: simplify failed wwid code" patch.

Only patches 0003 and 0004 haven't been posted before.

Changes from v1:
0003: Minor fixes suggested by Martin Wilck
0004: Fixed typo, added tests for filter_property() and switched some
      tests to pass the check_multipathd code in various ways, instead
      of skipping it, as suggested by Martin Wilck

Benjamin Marzinski (5):
  libmultipath: make libmp_dm_init optional
  libmultipath: make sysfs_is_multipathed able to return wwid
  multipath: centralize validation code
  Unit tests for is_path_valid()
  libmultipath: simplify failed wwid code

Martin Wilck (1):
  libmultipath: use atomic linkat() in mark_failed_wwid()

 libmultipath/Makefile    |   3 +-
 libmultipath/devmapper.c |  62 ++++-
 libmultipath/devmapper.h |   4 +-
 libmultipath/structs.h   |  24 +-
 libmultipath/sysfs.c     |  24 +-
 libmultipath/sysfs.h     |   2 +-
 libmultipath/valid.c     | 118 ++++++++++
 libmultipath/valid.h     |  42 ++++
 libmultipath/wwids.c     | 165 +++++++------
 multipath/main.c         | 295 ++++++++++--------------
 tests/Makefile           |   4 +-
 tests/valid.c            | 486 +++++++++++++++++++++++++++++++++++++++
 12 files changed, 944 insertions(+), 285 deletions(-)
 create mode 100644 libmultipath/valid.c
 create mode 100644 libmultipath/valid.h
 create mode 100644 tests/valid.c

-- 
2.17.2
