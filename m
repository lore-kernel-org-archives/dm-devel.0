From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 08/18] libmultipath: add vend_id to
	get_vpd_sgio
Date: Wed, 19 Feb 2020 00:48:30 -0600
Message-ID: <1582094920-9883-9-git-send-email-bmarzins@redhat.com>
References: <1582094920-9883-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1582094920-9883-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

This tells multipath how it should decode vendor specific pages. It will
be used by a future patch.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c |  4 ++--
 libmultipath/discovery.h |  2 +-
 libmultipath/propsel.c   |  2 +-
 tests/vpd.c              | 10 +++++-----
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 19a8d2af..8b9bdb55 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1205,7 +1205,7 @@ get_vpd_sysfs (struct udev_device *parent, int pg, char * str, int maxlen)
 }
 
 int
-get_vpd_sgio (int fd, int pg, char * str, int maxlen)
+get_vpd_sgio (int fd, int pg, int vend_id, char * str, int maxlen)
 {
 	int len, buff_len;
 	unsigned char buff[4096];
@@ -1880,7 +1880,7 @@ static ssize_t uid_fallback(struct path *pp, int path_state,
 		if (len < 0 && path_state == PATH_UP) {
 			condlog(1, "%s: failed to get sysfs uid: %s",
 				pp->dev, strerror(-len));
-			len = get_vpd_sgio(pp->fd, 0x83, pp->wwid,
+			len = get_vpd_sgio(pp->fd, 0x83, 0, pp->wwid,
 					   WWID_SIZE);
 			*origin = "sgio";
 		}
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 0516e41b..6444887d 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -35,7 +35,7 @@ int path_get_tpgs(struct path *pp); /* This function never returns TPGS_UNDEF */
 int do_tur (char *);
 int path_offline (struct path *);
 int get_state (struct path * pp, struct config * conf, int daemon, int state);
-int get_vpd_sgio (int fd, int pg, char * str, int maxlen);
+int get_vpd_sgio (int fd, int pg, int vend_id, char * str, int maxlen);
 int pathinfo (struct path * pp, struct config * conf, int mask);
 int alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
 			      const char *wwid, int flag, struct path **pp_ptr);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index a5fc6ba0..cd372d94 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -504,7 +504,7 @@ check_rdac(struct path * pp)
 	if (__do_set_from_hwe(checker_name, pp, checker_name) &&
 	    strcmp(checker_name, RDAC))
 		return 0;
-	len = get_vpd_sgio(pp->fd, 0xC9, buff, 44);
+	len = get_vpd_sgio(pp->fd, 0xC9, 0, buff, 44);
 	if (len <= 0)
 		return 0;
 	return !(memcmp(buff + 4, "vac1", 4));
diff --git a/tests/vpd.c b/tests/vpd.c
index 1e653ed4..0331c487 100644
--- a/tests/vpd.c
+++ b/tests/vpd.c
@@ -429,7 +429,7 @@ static void test_vpd_vnd_ ## len ## _ ## wlen(void **state)             \
 	free(exp_wwid);							\
 	will_return(__wrap_ioctl, n);					\
 	will_return(__wrap_ioctl, vt->vpdbuf);				\
-	ret = get_vpd_sgio(10, 0x83, vt->wwid, wlen);			\
+	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, wlen);		\
 	assert_correct_wwid("test_vpd_vnd_" #len "_" #wlen,		\
 			    exp_len, ret, '1', 0, false,		\
 			    exp_subst, vt->wwid);			\
@@ -459,7 +459,7 @@ static void test_vpd_str_ ## typ ## _ ## len ## _ ## wlen(void **state) \
 		exp_len = wlen - 1;					\
 	will_return(__wrap_ioctl, n);					\
 	will_return(__wrap_ioctl, vt->vpdbuf);				\
-	ret = get_vpd_sgio(10, 0x83, vt->wwid, wlen);			\
+	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, wlen);		\
 	assert_correct_wwid("test_vpd_str_" #typ "_" #len "_" #wlen,	\
 			    exp_len, ret, byte0[type], 0,		\
 			    type != STR_IQN,				\
@@ -496,7 +496,7 @@ static void test_vpd_naa_ ## naa ## _ ## wlen(void **state)             \
 			 3, naa, 0);					\
 	will_return(__wrap_ioctl, n);					\
 	will_return(__wrap_ioctl, vt->vpdbuf);				\
-	ret = get_vpd_sgio(10, 0x83, vt->wwid, wlen);			\
+	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, wlen);		\
 	assert_correct_wwid("test_vpd_naa_" #naa "_" #wlen,		\
 			    exp_len, ret, '3', '0' + naa, true,		\
 			    test_id, vt->wwid);				\
@@ -527,7 +527,7 @@ static void test_vpd_eui_ ## len ## _ ## wlen ## _ ## sml(void **state)	\
 	}								\
 	will_return(__wrap_ioctl, n);					\
 	will_return(__wrap_ioctl, vt->vpdbuf);				\
-	ret = get_vpd_sgio(10, 0x83, vt->wwid, wlen);			\
+	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, wlen);		\
 	assert_correct_wwid("test_vpd_eui_" #len "_" #wlen "_" #sml,	\
 			    exp_len, ret, '2', 0, true,			\
 			    test_id, vt->wwid);				\
@@ -554,7 +554,7 @@ static void test_vpd80_ ## size ## _ ## len ## _ ## wlen(void **state)  \
 			 size, len);					\
 	will_return(__wrap_ioctl, n);					\
 	will_return(__wrap_ioctl, vt->vpdbuf);				\
-	ret = get_vpd_sgio(10, 0x80, vt->wwid, wlen);			\
+	ret = get_vpd_sgio(10, 0x80, 0, vt->wwid, wlen);		\
 	assert_correct_wwid("test_vpd80_" #size "_" #len "_" #wlen,	\
 			    exp_len, ret, 0, 0, false,			\
 			    input, vt->wwid);				\
-- 
2.17.2
