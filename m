From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 0/5] dm raid: deadlock/corruptor fixes
Date: Wed,  5 Sep 2018 19:36:40 +0200
Message-ID: <cover.1536167421.git.heinzm@redhat.com>
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
To: heinzm@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

This series of raid patches critically fixes:
- a race causing hangs occuring on tiny devices
- a reshape deadlock / potential data corruption
- a superblock update problem rebuilding individual component devices

In addition, it contains (patches 4+5, less critical) removal
of code duplication deciphering the synchonization action and
avoids to create a bitmap when using a raid4/5/6 journal device.

Fixes pass all lvm2 raid tests.

Heinz Mauelshagen (5):
  dm-raid: fix reshape race on small devices
  dm-raid: fix stripe adding reshape deadlock
  dm-raid: correct explicit superblock update requests
  dm-raid: share decipher_sync_action
  dm-raid: disable bitmap when journaled

 Documentation/device-mapper/dm-raid.txt |   2 +
 drivers/md/dm-raid.c                    | 177 +++++++++---------------
 2 files changed, 71 insertions(+), 108 deletions(-)

-- 
2.17.1
