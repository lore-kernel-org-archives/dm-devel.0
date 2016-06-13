From: Ritesh Raj Sarraf <rrs@debian.org>
Subject: [PATCH] Update kpartx manpage with current output
Date: Mon, 13 Jun 2016 14:10:47 +0530
Message-ID: <1465807247-15392-1-git-send-email-rrs@debian.org>
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
Cc: Ritesh Raj Sarraf <rrs@debian.org>, xose.vazquez@gmail.com
List-Id: dm-devel.ids

See Debian Bug #796948 for details
Many users are reported to be consuming the output in a scripted setup

Signed-off-by: Ritesh Raj Sarraf <rrs@debian.org>
---
 kpartx/kpartx.8 | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
index 021ddc0..564d93b 100644
--- a/kpartx/kpartx.8
+++ b/kpartx/kpartx.8
@@ -50,15 +50,15 @@ kpartx \-av disk.img
 .PP
 This will output lines such as:
 .IP
-loop3p1 : 0 20964762 /dev/loop3 63
+add map loop1p1 (254:4): 0 409597 linear 7:1 3
 .PP
 The 
-.I loop3p1
+.I loop1p1
 is the name of a device file under 
 .I /dev/mapper
 which you can use to access the partition, for example to fsck it:
 .IP
-fsck /dev/mapper/loop3p1
+fsck /dev/mapper/loop1p1
 .PP
 When you're done, you need to remove the devices:
 .IP
-- 
2.8.1
