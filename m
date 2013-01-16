From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/13] Fixup .gitignore
Date: Wed, 16 Jan 2013 13:14:04 +0100
Message-ID: <1358338456-1234-2-git-send-email-hare@suse.de>
References: <1358338456-1234-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358338456-1234-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Only exclude the binaries, not the entire directories ...
And the nfs link, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 .gitignore |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/.gitignore b/.gitignore
index 9b3f663..7f25d0e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -5,6 +5,8 @@
 *.so.0
 *.a
 *.gz
-kpartx
-multipath
-multipathd
+kpartx/kpartx
+multipath/multipath
+multipathd/multipathd
+mpathpersist/mpathpersist
+.nfs*
-- 
1.7.4.2
