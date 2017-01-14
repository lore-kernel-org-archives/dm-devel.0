From: heinzm@redhat.com
Subject: [PATCH v2 0/5] dm raid: fix transient device failure
	processing and cleanup
Date: Sat, 14 Jan 2017 03:53:06 +0100
Message-ID: <20170114025311.22762-1-heinzm@redhat.com>
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

This is version 2 of
"[dm-devel] [PATCH] dm raid: fix transient device failure processing"
dated 12/22/2016 split up to ease review.

This patch series is on top of
"[PATCH] dm raid: change raid4/5/6 journal device status health char to 'A' rather than 'J'"
dated 12/13/2016.

Resolves: rhbz1404425

Heinz Mauelshagen (5):
  dm raid: fix transient device failure processing
  dm raid: be prepared to accept arbitray '- -' tupples
  dm raid: fix typos and a comment
  dm raid: use read_disk_sb() throughout
  dm raid: use mddev-> rather than rdev->mddev

 Documentation/device-mapper/dm-raid.txt |   4 +
 drivers/md/dm-raid.c                    | 144 +++++++++++++++++---------------
 2 files changed, 82 insertions(+), 66 deletions(-)

-- 
2.9.3
