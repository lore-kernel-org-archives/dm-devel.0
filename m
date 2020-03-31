From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [RFC Patch 0/3] multipath: new path validation library
Date: Mon, 30 Mar 2020 21:00:52 -0500
Message-ID: <1585620055-27112-1-git-send-email-bmarzins@redhat.com>
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

This patchset is for a new library that programs can use to determine
if a device belongs to multipath.  The primary user that this is
intended for is SID, the Storage Instantiation Daemon

https://github.com/sid-project

Right now, this doesn't change our existing code to determine path
ownership, and it doesn't do the exact same steps, although it is very
close.  In the future, it would be possible to pull most of this code
entirely into libmultipath, except for some wrappers, and use it for
both methods.  Obviously, this still needs man pages, and there are some
helper functions for things like controlling multipath's logging that
are missing, but I want to see if anyone has strong feelings about what
this looks like.

I also have two more changes that I want to make to the multipath code,
to make path validation do less unnecessary work, which aren't in this
patchset.

1. I want to remove the lock file from the failed wwids code. I don't
see how it actually stops any races, and it means that simply reading
a file, can trigger delays and writes (albeit to a memory base fs).

2. I want to deprecate getuid_callout.  Once this is gone, you will be
able to call pathinfo and get a path's WWID, without ever needing to
open the path.

Benjamin Marzinski (3):
  libmultipath: make libmp_dm_init optional
  libmultipath: make sysfs_is_multipathed able to return wwid
  multipath: add libmpathvalid library

 Makefile                            |   1 +
 Makefile.inc                        |   1 +
 libmpathvalid/Makefile              |  38 +++++++
 libmpathvalid/libmpathvalid.version |   6 +
 libmpathvalid/mpath_valid.c         | 171 ++++++++++++++++++++++++++++
 libmpathvalid/mpath_valid.h         |  53 +++++++++
 libmultipath/Makefile               |   1 +
 libmultipath/devmapper.c            |  66 ++++++++++-
 libmultipath/devmapper.h            |   4 +-
 libmultipath/sysfs.c                |  22 +++-
 libmultipath/sysfs.h                |   2 +-
 multipath/main.c                    |   7 +-
 12 files changed, 360 insertions(+), 12 deletions(-)
 create mode 100644 libmpathvalid/Makefile
 create mode 100644 libmpathvalid/libmpathvalid.version
 create mode 100644 libmpathvalid/mpath_valid.c
 create mode 100644 libmpathvalid/mpath_valid.h

-- 
2.17.2
