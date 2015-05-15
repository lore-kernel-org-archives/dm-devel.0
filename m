From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 00/10] Multipath path resync
Date: Fri, 15 May 2015 18:14:03 -0500
Message-ID: <1431731653-3892-1-git-send-email-bmarzins@redhat.com>
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

The first patch is just a resend of earlier patches. The rest are a mix
of bug fixes and features. "retrigger uevents to try and get the uid
through udev" is one that I'm open to a number of changes to, if anyone
feels strongly that it should work differently. I'm also not sure if
the new location I'm moved the multipath rules to works for everyone. If
not, I have no problem with dropping it.  Lastly, I like I mentioned in
the "Fix issues with user_friendly_names initramfs binding", if anyone has
a better way of making multipathd run differently in the initramfs, I'd
be happy to consider that instead of my existing patch.

Benjamin Marzinski (10):
  libmultipath: Add prioritizer context data
  fix memory leaks on realloc failures
  multipathd: use /run instead of /var/run
  retrigger uevents to try and get the uid through udev
  update multipath rules to deal with partition devices
  change order of multipath.rules
  make kpartx -d remove all partitions
  Fix issues with user_friendly_names initramfs bindings
  Make multipath deactivate devices before iscsi shutdown
  resize reply buffer for mutipathd help message

 kpartx/kpartx.c                          |  4 +-
 libmultipath/config.c                    |  6 +++
 libmultipath/config.h                    |  3 ++
 libmultipath/configure.c                 |  3 ++
 libmultipath/defaults.h                  |  4 +-
 libmultipath/dict.c                      | 12 +++++
 libmultipath/discovery.c                 | 28 +++++-----
 libmultipath/dmparser.c                  |  6 ++-
 libmultipath/prio.c                      | 34 +++++++++++-
 libmultipath/prio.h                      |  7 +++
 libmultipath/prioritizers/alua.c         | 58 ++++++++++++++++-----
 libmultipath/prioritizers/alua_rtpg.c    | 22 ++++++--
 libmultipath/prioritizers/alua_rtpg.h    |  4 +-
 libmultipath/prioritizers/const.c        |  4 ++
 libmultipath/prioritizers/datacore.c     |  3 ++
 libmultipath/prioritizers/def_func.h     | 11 ++++
 libmultipath/prioritizers/emc.c          |  4 ++
 libmultipath/prioritizers/hds.c          |  4 ++
 libmultipath/prioritizers/hp_sw.c        |  4 ++
 libmultipath/prioritizers/iet.c          |  4 ++
 libmultipath/prioritizers/ontap.c        |  4 ++
 libmultipath/prioritizers/random.c       |  4 ++
 libmultipath/prioritizers/rdac.c         |  4 ++
 libmultipath/prioritizers/weightedpath.c |  3 ++
 libmultipath/propsel.c                   |  4 +-
 libmultipath/structs.h                   |  8 +++
 libmultipath/util.c                      | 30 +++++++++++
 libmultipath/util.h                      |  1 +
 multipath/Makefile                       |  4 +-
 multipath/main.c                         |  9 ++--
 multipath/multipath.rules                | 16 ++++--
 multipathd/cli.c                         | 88 +++++++++++++++++++++++---------
 multipathd/cli.h                         | 16 +++++-
 multipathd/cli_handlers.c                | 58 ++++-----------------
 multipathd/main.c                        | 49 ++++++++++++------
 multipathd/multipathd.init.suse          |  2 +-
 multipathd/multipathd.service            |  1 +
 multipathd/uxlsnr.c                      | 19 ++++++-
 38 files changed, 406 insertions(+), 139 deletions(-)
 create mode 100644 libmultipath/prioritizers/def_func.h

-- 
1.8.3.1
