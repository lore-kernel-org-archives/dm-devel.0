From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [RFC PATCH 0/2] multipath: change default devnode
	blacklist
Date: Thu,  4 Jun 2020 19:30:58 -0500
Message-ID: <1591317060-25484-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Nikhil Kshirsagar <nkshirsa@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

I recently got a request to add the Oracle ASM filer driver devices to
multipath's builtin devnode blacklist.  However, instead of having to do
always this for each device type individually, I decided to make
multipath blacklist all non scsi, nvme, and dasd devnodes by default.
This is what the multipath udev rules already do. If people don't like
this solution, the alternative is to add another line to the default
devnode blacklist like "^(asm/|oracleafd/|ofsctl)".

Benjamin Marzinski (2):
  libmultipath: change filter_devnode arguments
  libmultipath: change how default devnode blacklist works

 libmultipath/blacklist.c   | 21 +++++++---------
 libmultipath/blacklist.h   |  2 +-
 libmultipath/config.c      |  5 ++++
 libmultipath/config.h      |  1 +
 libmultipath/discovery.c   |  4 +--
 libmultipath/print.c       | 12 ++++++---
 libmultipath/uevent.c      |  3 +--
 multipath/main.c           |  3 +--
 multipath/multipath.conf.5 | 11 +++++---
 multipathd/cli_handlers.c  |  3 +--
 tests/blacklist.c          | 51 ++++++++++++++++++++++++++++++++------
 11 files changed, 80 insertions(+), 36 deletions(-)

-- 
2.17.2
