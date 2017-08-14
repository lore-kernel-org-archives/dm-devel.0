From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/3] some minor multipath-tools fixes
Date: Mon, 14 Aug 2017 22:40:40 +0200
Message-ID: <20170814204043.17640-1-mwilck@suse.com>
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

Fix some glitches that were discovered recently here at SUSE.

Martin Wilck (3):
  kpartx/devmapper.h: remove dm_no_partitions
  libmultipath: cli_add_map: Use CMD_NONE
  multipath-tools: link internal libraries before foreigns

 kpartx/devmapper.h        | 1 -
 mpathpersist/Makefile     | 4 ++--
 multipath/Makefile        | 4 ++--
 multipathd/Makefile       | 4 ++--
 multipathd/cli_handlers.c | 2 +-
 5 files changed, 7 insertions(+), 8 deletions(-)

-- 
2.14.0
