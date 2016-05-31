From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/7] multpath patch sync
Date: Tue, 31 May 2016 18:16:43 -0500
Message-ID: <1464736610-20027-1-git-send-email-bmarzins@redhat.com>
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

This series is a resend of my previous "handler fixes" patch, along with some
bug fixes, a new default configuration, and a new attempt to make multipath
able to skip kpartx handling on devices.

Benjamin Marzinski (7):
  multipathd: handler fixes
  libmultipath: remove calls to dm_udev_complete
  libmultipath: add skip_kpartx option
  kpartx.rules: respect skip_kpartx flag
  multipath: validate devmap names
  libmultipath: add Huawei Storage default config
  kpartx: fix dos partition rollover error

 kpartx/devmapper.c         | 20 +++------------
 kpartx/dos.c               |  2 +-
 kpartx/kpartx.rules        |  2 ++
 libmultipath/alias.c       |  8 ++++++
 libmultipath/alias.h       |  1 +
 libmultipath/config.c      |  2 ++
 libmultipath/config.h      |  3 +++
 libmultipath/configure.c   |  5 ++--
 libmultipath/defaults.h    |  1 +
 libmultipath/devmapper.c   | 62 +++++++++++++++++++++++++---------------------
 libmultipath/devmapper.h   |  8 +++++-
 libmultipath/dict.c        | 13 ++++++++++
 libmultipath/hwtable.c     |  9 +++++++
 libmultipath/propsel.c     | 18 ++++++++++++++
 libmultipath/propsel.h     |  1 +
 libmultipath/structs.h     |  7 ++++++
 multipath/main.c           |  7 +++++-
 multipath/multipath.conf.5 | 12 +++++++++
 multipathd/cli.c           |  2 +-
 multipathd/cli_handlers.c  |  4 ++-
 multipathd/main.c          |  4 +--
 21 files changed, 138 insertions(+), 53 deletions(-)

-- 
1.8.3.1
