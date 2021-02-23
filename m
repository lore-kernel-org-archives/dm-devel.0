Return-Path: <SRS0=Sgdu=HZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11BF7C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 22:59:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7B00264E79
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 22:59:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B00264E79
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-ejTjMWSGN_i8U6SzIolViw-1; Tue, 23 Feb 2021 17:59:55 -0500
X-MC-Unique: ejTjMWSGN_i8U6SzIolViw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D78861868405;
	Tue, 23 Feb 2021 22:59:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 47CDA5C675;
	Tue, 23 Feb 2021 22:59:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EADC058075;
	Tue, 23 Feb 2021 22:59:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11NMxlLk015737 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Feb 2021 17:59:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8721F10EB297; Tue, 23 Feb 2021 22:59:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8384310EB295
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 22:59:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C6F8858EEB
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 22:59:47 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-141-7V2AzpuqNYCINsr5jX59SA-1;
	Tue, 23 Feb 2021 17:59:39 -0500
X-MC-Unique: 7V2AzpuqNYCINsr5jX59SA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 28362AF49;
	Tue, 23 Feb 2021 22:59:38 +0000 (UTC)
From: Petr Vorel <pvorel@suse.cz>
To: ltp@lists.linux.it
Date: Tue, 23 Feb 2021 23:59:30 +0100
Message-Id: <20210223225930.27095-3-pvorel@suse.cz>
In-Reply-To: <20210223225930.27095-1-pvorel@suse.cz>
References: <20210223225930.27095-1-pvorel@suse.cz>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11NMxlLk015737
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, Petr Vorel <pvorel@suse.cz>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, dm-devel@redhat.com,
	Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	linux-integrity@vger.kernel.org,
	Mimi Zohar <zohar@linux.vnet.ibm.com>, gmazyland@gmail.com, agk@redhat.com
Subject: [dm-devel] [PATCH v3 2/2] IMA: Add test for dm-crypt measurement
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Tushar Sugandhi <tusharsu@linux.microsoft.com>

New functionality is being added to IMA to measure data provided by
kernel components. With this feature, IMA policy can be set to enable
measuring data provided by device-mapper targets. Currently one such
device-mapper target - dm-crypt, is being updated to use this
functionality. This new functionality needs test automation in LTP.

Add a testcase which verifies that the IMA subsystem correctly measures
the data coming from a device-mapper target - dm-crypt.

Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
[ pvorel: adapt to previous commit changes, removed template=ima-buf,
further cleanup ]
Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
I wonder if $input_digest and $input_digest_found is needed to be
considered in loop. Maybe there could be return after first check when
$input_digest is passed to test_policy_measurement().

 runtest/ima                                   |  1 +
 .../kernel/security/integrity/ima/README.md   | 20 +++++++++
 .../integrity/ima/tests/ima_dm_crypt.sh       | 41 +++++++++++++++++++
 .../security/integrity/ima/tests/ima_setup.sh | 11 ++++-
 4 files changed, 72 insertions(+), 1 deletion(-)
 create mode 100755 testcases/kernel/security/integrity/ima/tests/ima_dm_crypt.sh

diff --git a/runtest/ima b/runtest/ima
index 5f4b4a7a1..123b6c8b0 100644
--- a/runtest/ima
+++ b/runtest/ima
@@ -5,4 +5,5 @@ ima_tpm ima_tpm.sh
 ima_violations ima_violations.sh
 ima_keys ima_keys.sh
 ima_kexec ima_kexec.sh
+ima_dm_crypt ima_dm_crypt.sh
 evm_overlay evm_overlay.sh
diff --git a/testcases/kernel/security/integrity/ima/README.md b/testcases/kernel/security/integrity/ima/README.md
index 68d046678..007662fae 100644
--- a/testcases/kernel/security/integrity/ima/README.md
+++ b/testcases/kernel/security/integrity/ima/README.md
@@ -37,6 +37,26 @@ see example in `kexec.policy`.
 The test attempts to kexec the existing running kernel image.
 To kexec a different kernel image export `IMA_KEXEC_IMAGE=<pathname>`.
 
+### IMA DM target (dm-crypt) measurement test
+
+To enable IMA to measure device-mapper target - dm-crypt,
+`ima_dm_crypt.sh` requires a readable IMA policy, as well as
+a loaded measure policy with
+`func=CRITICAL_DATA data_sources=dm-crypt`
+
+As well as what's required for the IMA tests, dm-crypt measurement test require
+reading the IMA policy allowed in the kernel configuration:
+```
+CONFIG_IMA_READ_POLICY=y
+```
+
+The following kernel configuration is also required. It enables compiling
+the device-mapper target module dm-crypt, which allows to create a device
+that transparently encrypts the data on it.
+```
+CONFIG_DM_CRYPT
+```
+
 ## EVM tests
 
 `evm_overlay.sh` requires a builtin IMA appraise tcb policy (e.g. `ima_policy=appraise_tcb`
diff --git a/testcases/kernel/security/integrity/ima/tests/ima_dm_crypt.sh b/testcases/kernel/security/integrity/ima/tests/ima_dm_crypt.sh
new file mode 100755
index 000000000..b49662f73
--- /dev/null
+++ b/testcases/kernel/security/integrity/ima/tests/ima_dm_crypt.sh
@@ -0,0 +1,41 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Microsoft Corporation
+# Copyright (c) 2021 Petr Vorel <pvorel@suse.cz>
+# Author: Tushar Sugandhi <tusharsu@linux.microsoft.com>
+#
+# Verify that DM target dm-crypt are measured correctly based on policy.
+
+TST_NEEDS_CMDS="dmsetup"
+TST_NEEDS_DEVICE=1
+TST_SETUP=setup
+TST_CLEANUP=cleanup
+
+. ima_setup.sh
+
+FUNC='func=CRITICAL_DATA'
+PATTERN='data_sources=[^[:space:]]+'
+REQUIRED_POLICY="^measure.*($FUNC.*$PATTERN|$PATTERN.*$FUNC)"
+
+setup()
+{
+	require_ima_policy_content "$REQUIRED_POLICY" '-E' > $TST_TMPDIR/policy.txt
+}
+
+cleanup()
+{
+	ROD "dmsetup remove test-crypt"
+}
+
+test1()
+{
+	local input_digest="039d8ff71918608d585adca3e5aab2e3f41f84d6"
+	local key="faf453b4ee938cff2f0d2c869a0b743f59125c0a37f5bcd8f1dbbd911a78abaa"
+
+	tst_res TINFO "verifying dm-crypt target measurement"
+
+	ROD dmsetup create test-crypt --table "0 1953125 crypt aes-xts-plain64 $key 0 /dev/loop0 0 1 allow_discards"
+	check_policy_measurement data_sources $TST_TMPDIR/policy.txt $input_digest
+}
+
+tst_run
diff --git a/testcases/kernel/security/integrity/ima/tests/ima_setup.sh b/testcases/kernel/security/integrity/ima/tests/ima_setup.sh
index 605db0ff6..22bb4649d 100644
--- a/testcases/kernel/security/integrity/ima/tests/ima_setup.sh
+++ b/testcases/kernel/security/integrity/ima/tests/ima_setup.sh
@@ -289,7 +289,7 @@ test_policy_measurement()
 	local input_digest="$3"
 	local test_file="$TST_TMPDIR/test.txt"
 	local grep_file="$TST_TMPDIR/grep.txt"
-	local i sources templates
+	local i input_digest_found sources templates
 
 	tst_require_cmds cut sed xxd
 
@@ -326,8 +326,17 @@ test_policy_measurement()
 			tst_res TFAIL "incorrect digest was found for $src_line $policy_option"
 			return
 		fi
+
+		if [ "$input_digest" -a "$digest" = "$input_digest" ]; then
+			input_digest_found=1
+		fi
 	done < $grep_file
 
+	if [ "$input_digest" -a "$input_digest_found" != 1 ]; then
+		tst_res TFAIL "expected digest '$input_digest' not found"
+		return
+	fi
+
 	tst_res TPASS "$policy_option measured correctly"
 }
 
-- 
2.30.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

