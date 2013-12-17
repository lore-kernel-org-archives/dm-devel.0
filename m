From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/5] Small fixes and cleanup
Date: Tue, 17 Dec 2013 08:04:03 +0100
Message-ID: <1387263848-73945-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

as requested here are the missing bits and some fixes I found on
the way.

Please apply.

Hannes Reinecke (5):
  multipathd: document return values for check_path()
  Make 'multipath -t' able to run as normal user
  libmultipath: remove 'remove_trailing_chars'
  libmultipath: simplify basenamecpy()
  libmultipath: Fix overflow in sysfs_get_str()

 libmultipath/config.c    |  1 -
 libmultipath/discovery.c |  5 ++---
 libmultipath/util.c      | 12 +-----------
 libmultipath/util.h      |  1 -
 multipath/main.c         | 22 +++++++++++++---------
 multipathd/main.c        |  9 +++++++--
 6 files changed, 23 insertions(+), 27 deletions(-)

-- 
1.7.12.4
