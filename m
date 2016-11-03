From: tang.wenji@zte.com.cn
Subject: [PATCH] mpathpersist:check variable 'conf' before using
	it
Date: Thu, 3 Nov 2016 11:32:15 +0800
Message-ID: <1478143935-5564-1-git-send-email-tang.wenji@zte.com.cn>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.wenji" <tang.wenji@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.wenji" <tang.wenji@zte.com.cn>

If the variable 'conf' is NULL, the program should exit.

Signed-off-by: tang.wenji <tang.wenji@zte.com.cn>
---
 mpathpersist/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 8e8cc35..5863082 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -105,6 +105,11 @@ int main (int argc, char * argv[])
 
 	udev = udev_new();
 	conf = mpath_lib_init(udev);
+	if(!conf) {
+		udev_unref(udev);
+		exit(1);
+	}
+	
 	memset(transportids, 0, MPATH_MX_TIDS * sizeof(struct transportid));
 	multipath_conf = conf;
 
-- 
2.8.1.windows.1
