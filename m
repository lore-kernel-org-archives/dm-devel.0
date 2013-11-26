From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/9] multipath systemd integration
Date: Tue, 26 Nov 2013 12:41:21 +0100
Message-ID: <1385466090-24290-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

here is now the patchset for systemd integration. As requested
I've implemented a conditional compilation. Whenever systemd
is installed on the system the systemd hooks are compiled in,
or left out if not. I've also pulled the patch for the 'one-shot'
mechanism as Ben Marzinski rightly pointed out issues with
that one. The watchdog implementation has been clarified and
tested; turned out to be a systemd issue where watchdog is only
working properly on later versions of systemd.

Hannes Reinecke (9):
  Clarify uxsock logging
  Use system-provided regex implementation
  multipathd: Add option '-s' to suppress timestamps
  multipathd: switch to socket activation for systemd
  multipathd: use sd_notify() to inform systemd
  multipathd: Implement systemd watchdog integration
  multipathd: enable core dumps for systemd
  multipathd: Read environment variables from systemd
  multipathd: measure path check time

 Makefile.inc                     |    6 +
 libmultipath/Makefile            |    8 +-
 libmultipath/debug.c             |   17 +-
 libmultipath/devmapper.c         |   16 +-
 libmultipath/regex.c             | 4032 --------------------------------------
 libmultipath/regex.h             |  252 ---
 libmultipath/uxsock.c            |   28 +-
 multipath/multipath.conf.5       |    7 +-
 multipathd/Makefile              |   26 +-
 multipathd/main.c                |  109 +-
 multipathd/multipathd.8          |   34 +-
 multipathd/multipathd.service    |   16 -
 multipathd/multipathd.service.in |   18 +
 multipathd/multipathd.socket     |    5 +
 multipathd/uxclnt.c              |    4 +-
 multipathd/uxlsnr.c              |    4 +-
 16 files changed, 228 insertions(+), 4354 deletions(-)
 delete mode 100644 libmultipath/regex.c
 delete mode 100644 libmultipath/regex.h
 delete mode 100644 multipathd/multipathd.service
 create mode 100644 multipathd/multipathd.service.in
 create mode 100644 multipathd/multipathd.socket

-- 
1.8.1.4
