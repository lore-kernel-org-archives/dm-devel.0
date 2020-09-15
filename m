From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 0/3] add library to check if device is a valid
	path
Date: Tue, 15 Sep 2020 16:45:09 -0500
Message-ID: <1600206312-6497-1-git-send-email-bmarzins@redhat.com>
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

The main part of the this patchset is the first patch, which adds a
new library interface to check whether devices are valid paths. This
was designed for use in the Storage Instantiation Daemon (SID).

https://github.com/sid-project

Hopefully, I've removed all the controvertial bits from the last time I
proposed this library.

The second patch adds get_uid fallback code for dasd devices. The third
patch adds a config option to force multpath to get the device uid from
the fallback methods. This is currently necessary for claiming multipath
devices with SID (instead of using multipath.rules), since SID doesn't
currently get the UID information itself, and it is called by udev
before this information is added to the udev database.

I would like to have this patch included in upstream, since it will make
it easier for people to try out SID, without having to recompile
multipath. However, I understand that there's not much reason to set
this outside of SID. I have a git branch that is Martin's upstream-queue
branch with these patches added, that I people can use if this patch
isn't acceptable.

https://github.com/bmarzins/rh-multipath-tools/tree/sid-patches

Benjamin Marzinski (3):
  multipath: add libmpathvalid library
  libmultipath: add uid failback for dasd devices
  libmultipath: add ignore_udev_uid option

 Makefile                            |   3 +-
 libmpathvalid/Makefile              |  38 +++++++
 libmpathvalid/libmpathvalid.version |  10 ++
 libmpathvalid/mpath_valid.c         | 168 ++++++++++++++++++++++++++++
 libmpathvalid/mpath_valid.h         |  57 ++++++++++
 libmultipath/config.h               |   1 +
 libmultipath/defaults.h             |   1 +
 libmultipath/dict.c                 |   4 +
 libmultipath/discovery.c            |  54 +++++++--
 libmultipath/discovery.h            |   8 +-
 libmultipath/uevent.c               |   2 +-
 multipath/multipath.conf.5          |  13 +++
 multipathd/main.c                   |   7 +-
 13 files changed, 355 insertions(+), 11 deletions(-)
 create mode 100644 libmpathvalid/Makefile
 create mode 100644 libmpathvalid/libmpathvalid.version
 create mode 100644 libmpathvalid/mpath_valid.c
 create mode 100644 libmpathvalid/mpath_valid.h

-- 
2.17.2
