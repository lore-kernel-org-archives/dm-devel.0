From: Tushar Sugandhi <tusharsu-1pm0nblsJy7Jp67UH1NAhkEOCMrvLtNR@public.gmane.org>
Subject: [PATCH v2 1/2] IMA: generalize key measurement tests
Date: Sun, 27 Sep 2020 20:56:04 -0700
Message-ID: <20200928035605.22701-2-tusharsu@linux.microsoft.com>
References: <20200928035605.22701-1-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ltp-bounces+glt-ltp-list=m.gmane-mx.org-cunTk1MwBs91InPhgRC9rw@public.gmane.org>
In-Reply-To: <20200928035605.22701-1-tusharsu-1pm0nblsJy7Jp67UH1NAhkEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.linux.it/options/ltp>,
 <mailto:ltp-request-cunTk1MwBs91InPhgRC9rw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linux.it/pipermail/ltp/>
List-Post: <mailto:ltp-cunTk1MwBs91InPhgRC9rw@public.gmane.org>
List-Help: <mailto:ltp-request-cunTk1MwBs91InPhgRC9rw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linux.it/listinfo/ltp>,
 <mailto:ltp-request-cunTk1MwBs91InPhgRC9rw@public.gmane.org?subject=subscribe>
Errors-To: ltp-bounces+glt-ltp-list=m.gmane-mx.org-cunTk1MwBs91InPhgRC9rw@public.gmane.org
Sender: "ltp" <ltp-bounces+glt-ltp-list=m.gmane-mx.org-cunTk1MwBs91InPhgRC9rw@public.gmane.org>
To: zohar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pvorel-AlSwsSmVLrQ@public.gmane.org
Cc: nramas-1pm0nblsJy7Jp67UH1NAhkEOCMrvLtNR@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ltp-cunTk1MwBs91InPhgRC9rw@public.gmane.org
List-Id: dm-devel.ids

New functionality is being added in IMA to measure data provided by
kernel components. Tests have to be added in LTP to validate this new
feature. The functionality in ima_keys.sh can be reused to test this new
feature if it is made generic.

Refactor check_keys_policy() and test1() implemented in ima_keys.sh to
make it generic, and move the functionality to ima_setup.sh as new
functions - check_policy_pattern() and check_ima_ascii_log_for_policy().

Signed-off-by: Tushar Sugandhi <tusharsu-1pm0nblsJy7Jp67UH1NAhkEOCMrvLtNR@public.gmane.org>
---
 .../security/integrity/ima/tests/ima_keys.sh  | 62 +++------------
 .../security/integrity/ima/tests/ima_setup.sh | 79 +++++++++++++++++++
 2 files changed, 92 insertions(+), 49 deletions(-)

diff --git a/testcases/kernel/security/integrity/ima/tests/ima_keys.sh b/testcases/kernel/security/integrity/ima/tests/ima_keys.sh
index c9eef4b68..c2120358a 100755
--- a/testcases/kernel/security/integrity/ima/tests/ima_keys.sh
+++ b/testcases/kernel/security/integrity/ima/tests/ima_keys.sh
@@ -6,7 +6,7 @@
 #
 # Verify that keys are measured correctly based on policy.
 
-TST_NEEDS_CMDS="cmp cut grep sed xxd"
+TST_NEEDS_CMDS="cmp cut grep xxd"
 TST_CNT=2
 TST_NEEDS_DEVICE=1
 TST_SETUP=setup
@@ -28,64 +28,28 @@ cleanup()
 	tst_is_num $KEYRING_ID && keyctl clear $KEYRING_ID
 }
 
-check_keys_policy()
-{
-	local pattern="$1"
-
-	if ! grep -E "$pattern" $TST_TMPDIR/policy.txt; then
-		tst_res TCONF "IMA policy must specify $pattern, $FUNC_KEYCHECK, $TEMPLATE_BUF"
-		return 1
-	fi
-	return 0
-}
-
 # Based on https://lkml.org/lkml/2019/12/13/564.
 # (450d0fd51564 - "IMA: Call workqueue functions to measure queued keys")
 test1()
 {
 	local keycheck_lines i keyrings templates
 	local pattern='keyrings=[^[:space:]]+'
-	local test_file="file.txt" tmp_file="file2.txt"
+	local policy="keyrings"
+	local tmp_file="$TST_TMPDIR/keycheck_tmp_file.txt"
+	local res
 
 	tst_res TINFO "verify key measurement for keyrings and templates specified in IMA policy"
 
-	check_keys_policy "$pattern" > $tmp_file || return
-	keycheck_lines=$(cat $tmp_file)
-	keyrings=$(for i in $keycheck_lines; do echo "$i" | grep "keyrings" | \
-		sed "s/\./\\\./g" | cut -d'=' -f2; done | sed ':a;N;$!ba;s/\n/|/g')
-	if [ -z "$keyrings" ]; then
-		tst_res TCONF "IMA policy has a keyring key-value specifier, but no specified keyrings"
-		return
-	fi
-
-	templates=$(for i in $keycheck_lines; do echo "$i" | grep "template" | \
-		cut -d'=' -f2; done | sed ':a;N;$!ba;s/\n/|/g')
-
-	tst_res TINFO "keyrings: '$keyrings'"
-	tst_res TINFO "templates: '$templates'"
-
-	grep -E "($templates).*($keyrings)" $ASCII_MEASUREMENTS | while read line
-	do
-		local digest expected_digest algorithm
-
-		digest=$(echo "$line" | cut -d' ' -f4 | cut -d':' -f2)
-		algorithm=$(echo "$line" | cut -d' ' -f4 | cut -d':' -f1)
-		keyring=$(echo "$line" | cut -d' ' -f5)
+	check_policy_pattern "$pattern" $FUNC_KEYCHECK $TEMPLATE_BUF > $tmp_file || return
 
-		echo "$line" | cut -d' ' -f6 | xxd -r -p > $test_file
+	res="$(check_ima_ascii_log_for_policy $policy $tmp_file)"
 
-		if ! expected_digest="$(compute_digest $algorithm $test_file)"; then
-			tst_res TCONF "cannot compute digest for $algorithm"
-			return
-		fi
-
-		if [ "$digest" != "$expected_digest" ]; then
-			tst_res TFAIL "incorrect digest was found for $keyring keyring"
-			return
-		fi
-	done
+	if [ "$res" = "0" ]; then
+		tst_res TPASS "specified keyrings were measured correctly"
+	else
+		tst_res TFAIL "failed to measure specified keyrings"
+	fi
 
-	tst_res TPASS "specified keyrings were measured correctly"
 }
 
 # Create a new keyring, import a certificate into it, and verify
@@ -97,11 +61,11 @@ test2()
 	local cert_file="$TST_DATAROOT/x509_ima.der"
 	local keyring_name="key_import_test"
 	local pattern="keyrings=[^[:space:]]*$keyring_name"
-	local temp_file="file.txt"
+	local temp_file="$TST_TMPDIR/key_import_test_file.txt"
 
 	tst_res TINFO "verify measurement of certificate imported into a keyring"
 
-	check_keys_policy "$pattern" >/dev/null || return
+	check_policy_pattern "$pattern" $FUNC_KEYCHECK $TEMPLATE_BUF >/dev/null || return
 
 	KEYRING_ID=$(keyctl newring $keyring_name @s) || \
 		tst_brk TBROK "unable to create a new keyring"
diff --git a/testcases/kernel/security/integrity/ima/tests/ima_setup.sh b/testcases/kernel/security/integrity/ima/tests/ima_setup.sh
index 1f17aa707..2841d7df5 100644
--- a/testcases/kernel/security/integrity/ima/tests/ima_setup.sh
+++ b/testcases/kernel/security/integrity/ima/tests/ima_setup.sh
@@ -54,6 +54,85 @@ compute_digest()
 	return 1
 }
 
+check_policy_pattern()
+{
+	local pattern="$1"
+	local func="$2"
+	local template="$3"
+
+	if ! grep -E "$pattern" $TST_TMPDIR/policy.txt; then
+		tst_res TCONF "IMA policy must specify $pattern, $func, $template"
+		return 1
+	fi
+	return 0
+}
+
+check_ima_ascii_log_for_policy()
+{
+	local test_file="$TST_TMPDIR/ascii_log_test_file.txt"
+	local grep_file="$TST_TMPDIR/ascii_log_grep_file.txt"
+	local func_lines sources templates i src 
+	local input_digest_res=1
+	local policy_option="$1"
+	local input_digest="$3"
+
+	func_lines=$(cat $2)
+
+	sources=$(for i in $func_lines; do echo "$i" | grep "$policy_option" | \
+		sed "s/\./\\\./g" | cut -d'=' -f2; done | sed ':a;N;$!ba;s/\n/|/g')
+	if [ -z "$sources" ]; then
+		tst_res TCONF "IMA policy $policy_option is a key-value specifier, but no values specified"
+		echo "1"
+		return
+	fi
+
+	templates=$(for i in $func_lines; do echo "$i" | grep "template" | \
+		cut -d'=' -f2; done | sed ':a;N;$!ba;s/\n/|/g')
+
+	tst_res TINFO "policy sources: '$sources'"
+	tst_res TINFO "templates: '$templates'"
+
+	grep -E "($templates).*($sources)" $ASCII_MEASUREMENTS > $grep_file
+
+	while read line
+	do
+		local digest expected_digest algorithm
+
+		digest=$(echo "$line" | cut -d' ' -f4 | cut -d':' -f2)
+		algorithm=$(echo "$line" | cut -d' ' -f4 | cut -d':' -f1)
+		src_line=$(echo "$line" | cut -d' ' -f5)
+
+		echo "$line" | cut -d' ' -f6 | xxd -r -p > $test_file
+
+		if ! expected_digest="$(compute_digest $algorithm $test_file)"; then
+			tst_res TCONF "cannot compute digest for $algorithm"
+			echo "1"
+			return
+		fi
+
+		if [ "$digest" != "$expected_digest" ]; then
+			tst_res TINFO "incorrect digest was found for $src_line $policy_option"
+			echo "1"	
+			return
+		fi
+
+		if [ "$input_digest" ]; then
+			if [ "$digest" = "$input_digest" ]; then
+				input_digest_res=0
+			fi
+		fi
+
+	done < $grep_file
+
+	if [ "$input_digest" ]; then
+		echo "$input_digest_res"
+		return
+	else
+		echo "0"
+		return
+	fi
+}
+
 check_policy_readable()
 {
 	if [ ! -f $IMA_POLICY ]; then
-- 
2.17.1


-- 
Mailing list info: https://lists.linux.it/listinfo/ltp
