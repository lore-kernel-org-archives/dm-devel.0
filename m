From: mwilck@suse.com
Subject: [PATCH 2/5] libmultipath: fix memory leak in ble handlers
Date: Tue, 25 Aug 2020 23:24:47 +0200
Message-ID: <20200825212450.8561-2-mwilck@suse.com>
References: <20200825212450.8561-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200825212450.8561-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: lixiaokeng <lixiaokeng@huawei.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Since patch "libmultipath fix a memory leak in set_ble_device",
strings are strdup'd in set_ble_device() and store_ble(). The
passed string must therefore be freed in the handlers in dict.c.

Fixes: ("libmultipath fix a memory leak in set_ble_device")
Cc: lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dict.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index be3029c..feabae5 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1499,7 +1499,8 @@ blacklist_exceptions_handler(struct config *conf, vector strvec)
 static int								\
 ble_ ## option ## _handler (struct config *conf, vector strvec)		\
 {									\
-	char * buff;							\
+	char *buff;							\
+	int rc;								\
 									\
 	if (!conf->option)						\
 		return 1;						\
@@ -1508,7 +1509,9 @@ ble_ ## option ## _handler (struct config *conf, vector strvec)		\
 	if (!buff)							\
 		return 1;						\
 									\
-	return store_ble(conf->option, buff, ORIGIN_CONFIG);		\
+	rc = store_ble(conf->option, buff, ORIGIN_CONFIG);		\
+	free(buff);							\
+	return rc;							\
 }
 
 #define declare_ble_device_handler(name, option, vend, prod)		\
@@ -1516,6 +1519,7 @@ static int								\
 ble_ ## option ## _ ## name ## _handler (struct config *conf, vector strvec) \
 {									\
 	char * buff;							\
+	int rc;								\
 									\
 	if (!conf->option)						\
 		return 1;						\
@@ -1524,7 +1528,9 @@ ble_ ## option ## _ ## name ## _handler (struct config *conf, vector strvec) \
 	if (!buff)							\
 		return 1;						\
 									\
-	return set_ble_device(conf->option, vend, prod, ORIGIN_CONFIG);	\
+	rc = set_ble_device(conf->option, vend, prod, ORIGIN_CONFIG);	\
+	free(buff);							\
+	return rc;							\
 }
 
 declare_ble_handler(blist_devnode)
-- 
2.28.0
