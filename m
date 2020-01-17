From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 07/15] libmultipath: fix sgio_get_vpd looping
Date: Thu, 16 Jan 2020 20:18:12 -0600
Message-ID: <1579227500-17196-8-git-send-email-bmarzins@redhat.com>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
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

If do_inq returns a page with a length that is less than maxlen, but
larger than DEFAULT_SGIO_LEN, this function will loop forever. Also
if do_inq returns with a length equal to or greater than maxlen,
sgio_get_vpd will exit immediately, even if it hasn't read the entire
page.  Fix these issues, modify the tests to verify the new behavior.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 12 +++---
 tests/vpd.c              | 84 ++++++++++++++++++++++++----------------
 2 files changed, 57 insertions(+), 39 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 72f455e8..3c72a80a 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -870,6 +870,7 @@ static int
 sgio_get_vpd (unsigned char * buff, int maxlen, int fd, int pg)
 {
 	int len = DEFAULT_SGIO_LEN;
+	int rlen;
 
 	if (fd < 0) {
 		errno = EBADF;
@@ -877,12 +878,11 @@ sgio_get_vpd (unsigned char * buff, int maxlen, int fd, int pg)
 	}
 retry:
 	if (0 == do_inq(fd, 0, 1, pg, buff, len)) {
-		len = get_unaligned_be16(&buff[2]) + 4;
-		if (len >= maxlen)
-			return len;
-		if (len > DEFAULT_SGIO_LEN)
-			goto retry;
-		return len;
+		rlen = get_unaligned_be16(&buff[2]) + 4;
+		if (rlen <= len || len >= maxlen)
+			return rlen;
+		len = (rlen < maxlen)? rlen : maxlen;
+		goto retry;
 	}
 	return -1;
 }
diff --git a/tests/vpd.c b/tests/vpd.c
index d9f80eaa..4dbce010 100644
--- a/tests/vpd.c
+++ b/tests/vpd.c
@@ -306,7 +306,7 @@ static int create_vpd83(unsigned char *buf, size_t bufsiz, const char *id,
 	default:
 		break;
 	}
-	put_unaligned_be16(n, buf + 2);
+	put_unaligned_be16(bufsiz, buf + 2);
 	return n + 4;
 }
 
@@ -429,6 +429,8 @@ static void test_vpd_vnd_ ## len ## _ ## wlen(void **state)             \
 	free(exp_wwid);							\
 	will_return(__wrap_ioctl, n);					\
 	will_return(__wrap_ioctl, vt->vpdbuf);				\
+	will_return(__wrap_ioctl, n);					\
+	will_return(__wrap_ioctl, vt->vpdbuf);				\
 	ret = get_vpd_sgio(10, 0x83, vt->wwid, wlen);			\
 	assert_correct_wwid("test_vpd_vnd_" #len "_" #wlen,		\
 			    exp_len, ret, '1', 0, false,		\
@@ -459,6 +461,8 @@ static void test_vpd_str_ ## typ ## _ ## len ## _ ## wlen(void **state) \
 		exp_len = wlen - 1;					\
 	will_return(__wrap_ioctl, n);					\
 	will_return(__wrap_ioctl, vt->vpdbuf);				\
+	will_return(__wrap_ioctl, n);					\
+	will_return(__wrap_ioctl, vt->vpdbuf);				\
 	ret = get_vpd_sgio(10, 0x83, vt->wwid, wlen);			\
 	assert_correct_wwid("test_vpd_str_" #typ "_" #len "_" #wlen,	\
 			    exp_len, ret, byte0[type], 0,		\
@@ -496,6 +500,8 @@ static void test_vpd_naa_ ## naa ## _ ## wlen(void **state)             \
 			 3, naa, 0);					\
 	will_return(__wrap_ioctl, n);					\
 	will_return(__wrap_ioctl, vt->vpdbuf);				\
+	will_return(__wrap_ioctl, n);					\
+	will_return(__wrap_ioctl, vt->vpdbuf);				\
 	ret = get_vpd_sgio(10, 0x83, vt->wwid, wlen);			\
 	assert_correct_wwid("test_vpd_naa_" #naa "_" #wlen,		\
 			    exp_len, ret, '3', '0' + naa, true,		\
@@ -506,22 +512,26 @@ static void test_vpd_naa_ ## naa ## _ ## wlen(void **state)             \
  * test_vpd_eui_LEN_WLEN() - test code for VPD 83, EUI64
  * @LEN:	EUI64 length (8, 12, or 16)
  * @WLEN:	WWID buffer size
+ * @SML:	Use small VPD page size
  */
-#define make_test_vpd_eui(len, wlen)					\
-static void test_vpd_eui_ ## len ## _ ## wlen(void **state)             \
+#define make_test_vpd_eui(len, wlen, sml)				\
+static void test_vpd_eui_ ## len ## _ ## wlen ## _ ## sml(void **state)	\
 {									\
 	struct vpdtest *vt = *state;                                    \
 	int n, ret;							\
 	/* returned size is always uneven */				\
 	int exp_len = wlen > 2 * len + 1 ? 2 * len + 1 :		\
 		wlen % 2 == 0 ? wlen - 1 : wlen - 2;			\
+	int bufsize = sml ? 255 : sizeof(vt->vpdbuf);			\
 									\
-	n = create_vpd83(vt->vpdbuf, sizeof(vt->vpdbuf), test_id,	\
+	n = create_vpd83(vt->vpdbuf, bufsize, test_id,			\
 			 2, 0, len);					\
 	will_return(__wrap_ioctl, n);					\
 	will_return(__wrap_ioctl, vt->vpdbuf);				\
+	will_return(__wrap_ioctl, n);					\
+	will_return(__wrap_ioctl, vt->vpdbuf);				\
 	ret = get_vpd_sgio(10, 0x83, vt->wwid, wlen);			\
-	assert_correct_wwid("test_vpd_eui_" #len "_" #wlen,		\
+	assert_correct_wwid("test_vpd_eui_" #len "_" #wlen "_" #sml,	\
 			    exp_len, ret, '2', 0, true,			\
 			    test_id, vt->wwid);				\
 }
@@ -603,25 +613,30 @@ make_test_vpd_vnd(20, 10);
 make_test_vpd_vnd(10, 10);
 
 /* EUI64 tests */
+/* small vpd page test */
+make_test_vpd_eui(8, 32, 1);
+make_test_vpd_eui(12, 32, 1);
+make_test_vpd_eui(16, 40, 1);
+
 /* 64bit, WWID size: 18 */
-make_test_vpd_eui(8, 32);
-make_test_vpd_eui(8, 18);
-make_test_vpd_eui(8, 17);
-make_test_vpd_eui(8, 16);
-make_test_vpd_eui(8, 10);
+make_test_vpd_eui(8, 32, 0);
+make_test_vpd_eui(8, 18, 0);
+make_test_vpd_eui(8, 17, 0);
+make_test_vpd_eui(8, 16, 0);
+make_test_vpd_eui(8, 10, 0);
 
 /* 96 bit, WWID size: 26 */
-make_test_vpd_eui(12, 32);
-make_test_vpd_eui(12, 26);
-make_test_vpd_eui(12, 25);
-make_test_vpd_eui(12, 20);
-make_test_vpd_eui(12, 10);
+make_test_vpd_eui(12, 32, 0);
+make_test_vpd_eui(12, 26, 0);
+make_test_vpd_eui(12, 25, 0);
+make_test_vpd_eui(12, 20, 0);
+make_test_vpd_eui(12, 10, 0);
 
 /* 128 bit, WWID size: 34 */
-make_test_vpd_eui(16, 40);
-make_test_vpd_eui(16, 34);
-make_test_vpd_eui(16, 33);
-make_test_vpd_eui(16, 20);
+make_test_vpd_eui(16, 40, 0);
+make_test_vpd_eui(16, 34, 0);
+make_test_vpd_eui(16, 33, 0);
+make_test_vpd_eui(16, 20, 0);
 
 /* NAA IEEE registered extended (36), WWID size: 34 */
 make_test_vpd_naa(6, 40);
@@ -722,20 +737,23 @@ static int test_vpd(void)
 		cmocka_unit_test(test_vpd_vnd_19_20),
 		cmocka_unit_test(test_vpd_vnd_20_10),
 		cmocka_unit_test(test_vpd_vnd_10_10),
-		cmocka_unit_test(test_vpd_eui_8_32),
-		cmocka_unit_test(test_vpd_eui_8_18),
-		cmocka_unit_test(test_vpd_eui_8_17),
-		cmocka_unit_test(test_vpd_eui_8_16),
-		cmocka_unit_test(test_vpd_eui_8_10),
-		cmocka_unit_test(test_vpd_eui_12_32),
-		cmocka_unit_test(test_vpd_eui_12_26),
-		cmocka_unit_test(test_vpd_eui_12_25),
-		cmocka_unit_test(test_vpd_eui_12_20),
-		cmocka_unit_test(test_vpd_eui_12_10),
-		cmocka_unit_test(test_vpd_eui_16_40),
-		cmocka_unit_test(test_vpd_eui_16_34),
-		cmocka_unit_test(test_vpd_eui_16_33),
-		cmocka_unit_test(test_vpd_eui_16_20),
+		cmocka_unit_test(test_vpd_eui_8_32_1),
+		cmocka_unit_test(test_vpd_eui_12_32_1),
+		cmocka_unit_test(test_vpd_eui_16_40_1),
+		cmocka_unit_test(test_vpd_eui_8_32_0),
+		cmocka_unit_test(test_vpd_eui_8_18_0),
+		cmocka_unit_test(test_vpd_eui_8_17_0),
+		cmocka_unit_test(test_vpd_eui_8_16_0),
+		cmocka_unit_test(test_vpd_eui_8_10_0),
+		cmocka_unit_test(test_vpd_eui_12_32_0),
+		cmocka_unit_test(test_vpd_eui_12_26_0),
+		cmocka_unit_test(test_vpd_eui_12_25_0),
+		cmocka_unit_test(test_vpd_eui_12_20_0),
+		cmocka_unit_test(test_vpd_eui_12_10_0),
+		cmocka_unit_test(test_vpd_eui_16_40_0),
+		cmocka_unit_test(test_vpd_eui_16_34_0),
+		cmocka_unit_test(test_vpd_eui_16_33_0),
+		cmocka_unit_test(test_vpd_eui_16_20_0),
 		cmocka_unit_test(test_vpd_naa_6_40),
 		cmocka_unit_test(test_vpd_naa_6_34),
 		cmocka_unit_test(test_vpd_naa_6_33),
-- 
2.17.2
