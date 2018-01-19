From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 09/16] multipath.8: adapt documentation of
	'-i'
Date: Fri, 19 Jan 2018 01:29:09 +0100
Message-ID: <20180119002916.10323-10-mwilck@suse.com>
References: <20180119002916.10323-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119002916.10323-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

---
 multipath/multipath.8 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/multipath/multipath.8 b/multipath/multipath.8
index 56f870351ee2..ee5aecd06bf1 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -94,7 +94,8 @@ Force devmap reload.
 .
 .TP
 .B \-i
-Ignore WWIDs file when processing devices.
+Ignore WWIDs file when processing devices. This option overrides the config
+file setting \fBignore_wwids\fR.
 .
 .TP
 .B \-B
-- 
2.15.1
