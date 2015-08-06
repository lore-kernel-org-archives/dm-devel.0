From: heinzm@redhat.com
Subject: [PATCH] dm-raid.txt: document discard support
Date: Thu,  6 Aug 2015 16:44:39 +0200
Message-ID: <1438872279-30693-1-git-send-email-heinzm@redhat.com>
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

For raid4/5/6 data integrity reasons, 'discard_zeroes_data' needs to work properly.

This patch ducuments the background of this critical requirement.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 Documentation/device-mapper/dm-raid.txt | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index cb12af3..597ba0a 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -209,6 +209,32 @@ include:
 	"repair" - Initiate a repair of the array.
 	"reshape"- Currently unsupported (-EINVAL).
 
+Discard Support
+---------------
+The implementation of discard support amoung hardware vendors varies. When
+a block is discarded, some storage devices will return zeros when it is
+read.  These devices set the 'discard_zeros_data' attribute.  Other devices
+will return random data.  Confusingly, some devices will set
+'discard_zeros_data', but will still not always return zeros when
+discarded blocks are read!  Since RAID 4/5/6 uses blocks from a number of
+devices to calculate parity blocks and relies on 'discard_zeros_data' returning
+zeroes doing so, it is important that the devices be consistent.  Blocks may be
+discarded in the middle of a RAID 4/5/6 stripe and if the read results are
+not consistent, the parity blocks may be calculated differently at any time;
+making the parity blocks useless for redundancy.  It is important to
+understand how your hardware behaves with discards if you are going
+to use RAID 4/5/6.
+
+Since the behavior of storage devices is unreliable in this respect - even
+when reporting 'discard_zeros_data' - RAID 4/5/6 does not enable discard
+support by default.  If the storage has been verified to return zeros when
+reading a discarded block, the following module parameter can be set:
+
+       'devices_handle_discards_safely'
+
+Once set, RAID 4/5/6 will enable discards and can safely use them.
+
+
 Version History
 ---------------
 1.0.0	Initial version.  Support for RAID 4/5/6
-- 
2.1.0
