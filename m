From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/2] device-mapper: use dynamic debug
Date: Thu, 14 May 2020 08:09:27 +0200
Message-ID: <20200514060929.85469-1-hare@suse.de>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

here's an updated version of my earlier patch to switch to dynamic
debug instead of using a compile-time option.
I've modified the initial patch as suggested by Mike, and also fixed
up stray newlines which had crept in with some debugging messages
in dm-zoned.

Hannes Reinecke (2):
  device-mapper: use dynamic debug instead of compile-time config option
  dm-zoned: remove spurious newlines from debugging messages

 drivers/md/dm-zoned-reclaim.c | 4 ++--
 drivers/md/dm-zoned-target.c  | 4 ++--
 include/linux/device-mapper.h | 5 ++---
 3 files changed, 6 insertions(+), 7 deletions(-)

-- 
2.16.4
