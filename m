From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [RFC PATCH v2 0/3] multipath: new path validation library
Date: Fri,  3 Apr 2020 01:50:38 -0500
Message-ID: <1585896641-22896-1-git-send-email-bmarzins@redhat.com>
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

changes in v2:
0002: make sysfs_is_multipathed only read the sysfs file once, as
suggested by Martin.

0003: dm_is_mpath_uuid() is now dm_map_present_by_uuid(). The library
includes a new function mpath_get_mode(), to get the find_multipaths
mode, and the modes now include MPATH_FIND. mpath_is_path() now accepts
an array of mpath_infos, which the caller can use to pass the previous
path wwids. This allows mpath_is_path() to return MPATH_IS_VALID for
paths if there already is another path with that wwid.

However, mpath_is_path() still treats MPATH_SMART and MPATH_FIND the
same.  I tried to make them work differently, but I realized that I need
a way to signal that the MPATH_FIND path didn't fail because it was
blacklisted, but instead because it needed another paths. Otherwise the
caller won't know that it needs to save the wwid to check when later
paths appear. This is exactly what MPATH_IS_MAYBE_VALID means. In the
multipath -u code, the only difference between the find_multipaths "on"
and "smart" case is what to do when a path that needs another path
appears for the first time.  Dealing with this difference is the
responsiblity of the caller of the mpathvalid library. mpath_get_mode(),
will let it know what the configured find_multipaths mode is.

Benjamin Marzinski (3):
  libmultipath: make libmp_dm_init optional
  libmultipath: make sysfs_is_multipathed able to return wwid
  multipath: add libmpathvalid library

 Makefile                            |   1 +
 Makefile.inc                        |   1 +
 libmpathvalid/Makefile              |  38 ++++++
 libmpathvalid/libmpathvalid.version |   7 +
 libmpathvalid/mpath_valid.c         | 198 ++++++++++++++++++++++++++++
 libmpathvalid/mpath_valid.h         |  56 ++++++++
 libmultipath/Makefile               |   1 +
 libmultipath/devmapper.c            |  66 +++++++++-
 libmultipath/devmapper.h            |   4 +-
 libmultipath/sysfs.c                |  24 +++-
 libmultipath/sysfs.h                |   2 +-
 multipath/main.c                    |   7 +-
 12 files changed, 391 insertions(+), 14 deletions(-)
 create mode 100644 libmpathvalid/Makefile
 create mode 100644 libmpathvalid/libmpathvalid.version
 create mode 100644 libmpathvalid/mpath_valid.c
 create mode 100644 libmpathvalid/mpath_valid.h

-- 
2.17.2
