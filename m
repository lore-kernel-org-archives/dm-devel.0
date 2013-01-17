From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/11] Final round of SLES resync patches
Date: Thu, 17 Jan 2013 15:59:22 +0100
Message-ID: <1358434773-2002-1-git-send-email-hare@suse.de>
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

and this is now the final round of SLES resync patches.
Mostly cleanup and minor fixes, except from the abstract
socket patch for CLI commands.
I _thought_ I had send this early, but apparently not.
Please apply.

Note that I've removed the rules file as it shouldn't
be necessary anymore; we're using libudev directly.

Hannes Reinecke (10):
  Cleanup whitespaces
  Provide correct persistent symlinks for user_friendly_names
  kpartx_id: Generate persistent symlinks for 'wwn'
  kpartx: Fix DASD name in kpartx_id
  Break out loop in factorize_hwtable()
  multipathd: switch to abstract sockets for CLI commands
  multipathd: log message when check interval has changed
  multipathd: call 'reconfigure' during startup
  multipath: do not install rules file
  kpartx: Deinstall kpartx_id

Petr Uzel (1):
  Fix inconsistent entries after merging hwtable with user's config

 kpartx/Makefile                 |    1 +
 kpartx/kpartx.rules             |    8 ++++++++
 kpartx/kpartx_id                |   11 +++++++++--
 libmultipath/config.c           |   25 +++++++++++++++++++------
 libmultipath/defaults.h         |    2 +-
 libmultipath/uxsock.c           |   27 ++++++++++++++-------------
 multipath/Makefile              |    3 ---
 multipath/multipath.rules       |    7 -------
 multipathd/main.c               |   26 ++++++++++++++------------
 multipathd/multipathd.init.suse |    2 +-
 multipathd/uxlsnr.c             |    6 +++---
 11 files changed, 70 insertions(+), 48 deletions(-)
 delete mode 100644 multipath/multipath.rules

-- 
1.7.10.4
