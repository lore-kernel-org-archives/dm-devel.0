From: heinzm@redhat.com
Subject: [PATCH 0/3] dm-raid: Add support for the MD RAID0
	personality
Date: Fri, 17 Apr 2015 14:39:43 +0200
Message-ID: <1429274386-16385-1-git-send-email-heinzm@redhat.com>
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
To: dm-devel@redhat.com
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

This patchset of 3 adds access to the MD RAID0 personality to dm-raid
(in addition to the already supported raid1/10/4/5/6 personalities)
to enable single zone striping.

The added functionality is the first step to allow full support
of MD kernel functionality via dm-raid and to eventually replace
the dm "striped" target altogether. Adding shrink/takeover and
reshape functionality to dm-raid is subject to future patches.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>

Heinz Mauelshagen (3):
  dm-raid: Add support for the MD RAID0 personality
  dm core: export dm_disk to allow for dm-raid to pass it on to the MD
    raid0 personality
  raid0: conditional mddev->queue access to suit dm-raid

 drivers/md/dm-raid.c | 115 ++++++++++++++++++++++++++++++---------------------
 drivers/md/dm.c      |   1 +
 drivers/md/raid0.c   |  48 +++++++++++----------
 3 files changed, 96 insertions(+), 68 deletions(-)

-- 
2.1.0
