From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [RFC PATCH v2 0/3] add library to check if device is a
	valid path
Date: Wed, 23 Sep 2020 23:59:26 -0500
Message-ID: <1600923569-17412-1-git-send-email-bmarzins@redhat.com>
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
patch just changes the get_uid log level for devices configured with
uid_attribute "". This is because it is currently necessary to configure
multipath with

overrides {
        uid_attribute ""
}

to claim multipath devices with SID (instead of using multipath.rules),
since SID doesn't currently get the UID information itself, and it is
called by udev before this information is added to the udev database.

I'm resubmitting this as a RFC patchset. Assuming they are ACKed, I will
resend these patches again, along with a man page, and unit tests, on
top of Martin's revised version of his "multipath-tools: shutdown,
libdevmapper races, globals" patchset.

changes from v1
---------------

0001: This patch is now rebased on top of, and makes use of Martin's
patches that provide a default *_multipath_config, udev, and logsink.
Because of this, mpathvalid_init() now has a parameter used to set
logsink. There is also a new API function, mpathvalid_reload_config().

0003: This is completely new, since Martin pointed out that adding a new
config option to always use the fallback getuid code was unnecessary. It
just makes a uid_attribute of "" log at normal levels.

Benjamin Marzinski (3):
  multipath: add libmpathvalid library
  libmultipath: add uid failback for dasd devices
  libmultipath: change log level for null uid_attribute

 Makefile                            |   3 +-
 libmpathvalid/Makefile              |  38 ++++++
 libmpathvalid/libmpathvalid.version |  10 ++
 libmpathvalid/mpath_valid.c         | 199 ++++++++++++++++++++++++++++
 libmpathvalid/mpath_valid.h         |  61 +++++++++
 libmultipath/defaults.h             |   1 +
 libmultipath/discovery.c            |  40 +++++-
 7 files changed, 349 insertions(+), 3 deletions(-)
 create mode 100644 libmpathvalid/Makefile
 create mode 100644 libmpathvalid/libmpathvalid.version
 create mode 100644 libmpathvalid/mpath_valid.c
 create mode 100644 libmpathvalid/mpath_valid.h

-- 
2.17.2
