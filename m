From: heinzm@redhat.com
Subject: [PATCH v2 0/4] dm-raid: Add support for the MD RAID0
	personality
Date: Wed, 29 Apr 2015 14:03:03 +0200
Message-ID: <1430308987-24703-1-git-send-email-heinzm@redhat.com>
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

This v2 patchset of 4 adds access to the MD RAID0 personality to dm-raid
(in addition to the already supported raid1/10/4/5/6 personalities)
to enable single zone striping.

The added functionality is the first step to allow full support
of MD kernel functionality via dm-raid and to eventually replace
the dm "striped" target altogether. Adding shrink/takeover and
reshape functionality to dm-raid is subject to future patches.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>


Heinz Mauelshagen (4):
  dm-raid: Add support for the MD RAID0 personality
  md-raid0: conditional mddev->queue access to suit dm-raid
  Documentation: add version history entries for raid0 support _and_
    forgotten devices_handle_discards_safely module paramater
  dm-raid: remove bogus parse_raid_params() comment about
    devices_handle_discards_safely

 Documentation/device-mapper/dm-raid.txt |   3 +
 drivers/md/dm-raid.c                    | 206 +++++++++++++++++---------------
 drivers/md/raid0.c                      |   5 +-
 3 files changed, 117 insertions(+), 97 deletions(-)

-- 
2.1.0
