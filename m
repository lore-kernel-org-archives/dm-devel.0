From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/6] multipath cookie handling rework
Date: Wed,  4 May 2016 07:57:24 +0200
Message-ID: <1462341450-5507-1-git-send-email-hare@suse.de>
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

Hi all,

here's now an updated version of the cookie handling rework
for multipathd. It's a split off version of the original
SLES resync patch series sent earlier.

With this version I've fixed the 'reload' issue reported
by Ben Marzinski.

As usual, comments and reviews are welcome.

Hannes Reinecke (6):
  libmultipath: pass in cookie as argument for dm_simplecmd()
  libmultipath: pass in 'cookie' as argument for dm_addmap()
  Remove 'udev_sync' argument from dm_simplecmd()
  libmultipath: Fixup 'DM_DEVICE_RELOAD' handling
  devmapper: do not flush I/O for DM_DEVICE_CREATE
  libmultipath: fixup dm_rename to complete cookie on failure

 libmultipath/configure.c |  16 ++----
 libmultipath/devmapper.c | 123 +++++++++++++++++++++++++++++++----------------
 libmultipath/devmapper.h |   2 +-
 3 files changed, 86 insertions(+), 55 deletions(-)

-- 
2.6.6
