From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 20/30] multipath.conf.5: clarify 'no_path_retry'
	default setting
Date: Tue, 16 Jul 2013 09:13:11 +0200
Message-ID: <1373958801-103613-21-git-send-email-hare@suse.de>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373958801-103613-1-git-send-email-hare@suse.de>
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

The default setting for 'no_path_retry' is 'unset', so we should
be stating this in the man page.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/multipath.conf.5 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index ade9885..a937db9 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -295,7 +295,8 @@ Specify the number of retries until disable queueing, or
 .I fail
 for immediate failure (no queueing),
 .I queue
-for never stop queueing. Default is 0.
+for never stop queueing. If unset no queueing is attempted.
+Default is unset.
 .TP
 .B user_friendly_names
 If set to 
-- 
1.7.12.4
