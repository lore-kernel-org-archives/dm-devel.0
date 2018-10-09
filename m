From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] dm flakey: Document "error_writes" feature
Date: Tue,  9 Oct 2018 11:31:31 +0300
Message-ID: <1539073891-7701-1-git-send-email-nborisov@suse.com>
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
Cc: Nikolay Borisov <nborisov@suse.com>, dm-devel@redhat.com, corbet@lwn.net, linux-doc@vger.kernel.org
List-Id: dm-devel.ids

Commit ef548c551e72 ("dm flakey: introduce "error_writes" feature")
added the ability to dm flakey to error out writes in contrast to
silently dropping it with 'drop_writes'. Unfortunately this feature
is not currently documented and one has to be either familiar with the
source code of dm flakey or check out xfstests sources to know of
this parameter. So document it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 Documentation/device-mapper/dm-flakey.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/device-mapper/dm-flakey.txt b/Documentation/device-mapper/dm-flakey.txt
index c43030718cef..9f0e247d0877 100644
--- a/Documentation/device-mapper/dm-flakey.txt
+++ b/Documentation/device-mapper/dm-flakey.txt
@@ -33,6 +33,10 @@ Table parameters
 	All write I/O is silently ignored.
 	Read I/O is handled correctly.
 
+  error_writes:
+	All write I/O is failed with an error signalled.
+	Read I/O is handled correctly.
+
   corrupt_bio_byte <Nth_byte> <direction> <value> <flags>:
 	During <down interval>, replace <Nth_byte> of the data of
 	each matching bio with <value>.
-- 
2.7.4
