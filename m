From: heinzm@redhat.com
Subject: [PATCH] dm raid: Documentaion
Date: Sat, 18 Mar 2017 01:40:07 +0100
Message-ID: <20170318004007.4210-1-heinzm@redhat.com>
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
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Upstream commits d36a19541fe8f392778ac137d60f9be8dfdd8f9d
and 2664f3c94abc7181171b7c05b2aaa76ea7d9d613 fixed a data
corruptor related to reshape requests.

Add missing version 1.10.1 to the documention.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 Documentation/device-mapper/dm-raid.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index 9ec88eb..95c4c8d 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -331,5 +331,6 @@ Version History
 	'D' on the status line.  If '- -' is passed into the constructor, emit
 	'- -' on the table line and '-' as the status line health character.
 1.10.0  Add support for raid4/5/6 journal device
+1.10.1  Fix data corruption on reshape request
 1.11.0  Fix table line argument order
 	(wrong raid10_copies/raid10_format sequence)
-- 
2.9.3
