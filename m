From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm flakey: document corrupt_bio_byte and
 optional feature precedence
Date: Wed, 29 Jun 2011 10:41:13 -0400
Message-ID: <20110629144112.GA20420@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/dm-flakey.txt |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/Documentation/device-mapper/dm-flakey.txt b/Documentation/device-mapper/dm-flakey.txt
index 6b40f79..6b4df49 100644
--- a/Documentation/device-mapper/dm-flakey.txt
+++ b/Documentation/device-mapper/dm-flakey.txt
@@ -27,7 +27,20 @@ Mandatory parameters:
 
 Optional feature parameters:
   If no feature parameters are present, during the periods of
-  unreliability, all I/O returns errors.
+  unreliability, all I/O returns errors.  Optional features may be
+  combined (e.g. corrupt_bio_byte on READ and drop_writes).  Conflicting
+  features (e.g. corrupt_bio_byte on WRITE and drop_writes) are resolved
+  according to the following feature precedence (descending order):
+
+  corrupt_bio_byte <Nth byte> <bio_flags> <value>:
+	Corrupt bios that have specific bi_rw flag(s), e.g.: READ=0 or
+	REQ_WRITE=1|REQ_META=32, by writing <value> to the <Nth byte> of
+	bios that have data.
+	Examples:
+	1) corrupt 32nd byte in READ bios with the value 1:
+	   corrupt_bio_byte 32 0 1
+	2) corrupt 224th byte in WRITE|REQ_META bios with the value 0:
+	   corrupt_bio_byte 224 33 0
 
   drop_writes:
 	All write I/O is silently ignored.
