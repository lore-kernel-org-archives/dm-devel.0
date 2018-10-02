From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/2] multipath/tests: fix hwtable tests after
	"hidden" support
Date: Tue,  2 Oct 2018 20:47:00 +0200
Message-ID: <20181002184701.18956-2-mwilck@suse.com>
References: <20181002184701.18956-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181002184701.18956-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

The previous patch "libmultipath: pathinfo: skip hidden devices"
requires a change in the pathinfo mocking code. Otherwise the hwtable
tests will fail.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/test-lib.c | 6 ++++++
 tests/test-lib.h | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tests/test-lib.c b/tests/test-lib.c
index cff7a5d1..59275163 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -248,6 +248,12 @@ static void mock_sysfs_pathinfo(const struct mocked_path *mp)
  */
 void mock_pathinfo(int mask, const struct mocked_path *mp)
 {
+	if (mp->flags & DEV_HIDDEN) {
+		will_return(__wrap_udev_device_get_sysattr_value, "1");
+		return;
+	} else
+		will_return(__wrap_udev_device_get_sysattr_value, "0");
+
 	/* filter_property */
 	will_return(__wrap_udev_device_get_sysname, mp->devnode);
 	if (mp->flags & BL_BY_PROPERTY) {
diff --git a/tests/test-lib.h b/tests/test-lib.h
index d2745979..7643ab67 100644
--- a/tests/test-lib.h
+++ b/tests/test-lib.h
@@ -14,7 +14,8 @@ enum {
 	BL_MASK = BL_BY_DEVNODE|BL_BY_DEVICE|BL_BY_WWID|BL_BY_PROPERTY,
 	NEED_SELECT_PRIO = (1 << 8),
 	NEED_FD		= (1 << 9),
-	USE_GETUID	= (1 << 10)
+	USE_GETUID	= (1 << 10),
+	DEV_HIDDEN	= (1 << 11),
 };
 
 struct mocked_path {
-- 
2.19.0
