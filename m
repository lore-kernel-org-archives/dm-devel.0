From: John Pittman <jpittman@redhat.com>
Subject: [PATCH] dm flakey: add error_writes to documentation
Date: Fri, 28 Sep 2018 11:06:14 -0400
Message-ID: <20180928150614.21547-1-jpittman@redhat.com>
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
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, John Pittman <jpittman@redhat.com>
List-Id: dm-devel.ids

The "error_writes" optional feature parameter was added by commit
ef548c551e72 ("dm flakey: introduce "error_writes" feature"). Add
additional documentation detailing this parameter.

Signed-off-by: John Pittman <jpittman@redhat.com>
---
 Documentation/device-mapper/dm-flakey.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/device-mapper/dm-flakey.txt b/Documentation/device-mapper/dm-flakey.txt
index c43030718cef..4eb4ffa6ba52 100644
--- a/Documentation/device-mapper/dm-flakey.txt
+++ b/Documentation/device-mapper/dm-flakey.txt
@@ -33,6 +33,11 @@ Optional feature parameters:
 	All write I/O is silently ignored.
 	Read I/O is handled correctly.
 
+  error_writes:
+	All write I/O is errored and dropped
+	Incompatible with drop_writes
+	Read I/O is handled correctly.
+
   corrupt_bio_byte <Nth_byte> <direction> <value> <flags>:
 	During <down interval>, replace <Nth_byte> of the data of
 	each matching bio with <value>.
-- 
2.17.1
