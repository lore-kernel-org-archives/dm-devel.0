Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4A42F3C3D
	for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 13:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781356207; cv=none; b=mi6ZxzhD/CXUyrekr2qdpzNIYRl948Z2VGp1j/Bp8epe0pe7qJlWGRJnVdlfloDjYVJD/VjRDUx49/3Sgcl8wmnPwOOkVWksXGI8nN2zMsejp5pG5NBcEMaib73iSLsv49ufWeXrtRor8qAlR7b5K6K1Jzf10ABBwsiYNDiVCb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781356207; c=relaxed/simple;
	bh=EPo9MqFwd3g8QBcrSKo0kHhaYSdqqcbRcr1BKYDKhis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUzeN+FxUkzicS9bZU40IXZQtnpfso9Syas70Idr3djHyNek0JVwb4UChnm9cLxvEq8KfcQ+QxFafCGaft1YNgAgzPNgT5wKWwt6yFfVXM+U2umRccIcMz8Tw3mEsSrg3FScfAPfWoR0GEM+/LroxVq8Tn1H6ac//W2316SQia4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tFr3l1Yf; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tFr3l1Yf"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490ae34298aso1754315e9.1
        for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 06:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781356204; x=1781961004; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=27Ya0B/cyv9jJ0xkkollEps9gbMrbAPucLjqgxhCC9k=;
        b=tFr3l1Yf9U7kxIWFBUN92XFhCWfafigJkcRsx3vs7B7Ytawi+j1eBOoKbRLBz399r/
         ZGFGwmSwU66x08WxAaekmiTgnOoJAf7/d0fAE8nWnsO+QHIrSrY6Bxnour+Mc/zRGfSl
         ZH3+Zlo7UbxSkWfMos8NfIcJIP7i2t9XsXso1NGaRW5XU5gT9kmrhPbzdeywr75ICYDH
         dp8vp78bBr+CAKo01CmFeq/97t6thhDL2BXlpJ0ZRc9wpQLnPyc0FDEqOHil6pjX1Ch7
         fPIjKo/jVOP/ijnCcqJ45xFZ2hEnDQuqIGejMw84u/Ho3OfTVjqBqdgyF4ATvMNksf10
         BejQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781356204; x=1781961004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=27Ya0B/cyv9jJ0xkkollEps9gbMrbAPucLjqgxhCC9k=;
        b=sIBsEvAQcNPjv66s2Llu5n2lAstxKXBIIYDIO0BKQ3KHNeSgYnGQach3MUdjxS9lUD
         ZM2OW+2zVN8K9HxFdwBPAra0E4FZ06pWwex/7VVTFF0EM1rT/tQYFeyDIYORaruSWDyU
         o8vY42uaOMQULGvBGgzZ8aSfdACK2akS6AVuMcQIv33mS8yhpK684YstUgHZ8hx23jnU
         AIm2sqZB+71Iem3F0nj6wsdWmRMzqHrogbKuavLFWeGUqBS6qg9HfuUZLkwAY2s4MO27
         YKOKv2jQvvdwWcID64MOU3bn7OPqXmWRWE0o9F40LZ2Zy4S/lC+fo63NCwQOdbg3EG/S
         WPJQ==
X-Forwarded-Encrypted: i=1; AFNElJ90aTIwIiwLhzyvHiZ0K8G5T4bsxoi+TiPlXtVWQpzs5h39vB3M08hkNWERxn8X3lqC+6cwVhL+1Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxbEv4bitPciFWnydUks+wGxHHp+F54PpkF0/f2fJ4EZltb7w8+
	Cgt6LsFmo5d+vmxLIiiV1aiBVg9hVMeRB3An0CWttUwh0tn2TJryvhc=
X-Gm-Gg: Acq92OE2ADupMEUNTO/gWBkp70QAj/APCzKKpcF5GgQ8k0xv7GoeQUYpC1pA7rCqoLe
	viOD26oR3g7N0adt8ZbP7TwCohjmvSzE9xYFO2ut26KdR7sKEWD95t9KrLGVaXeF/h0BWDoOvLy
	Jv1HndmzYTzPtN1uXk2p8rMsplM7GlWGlUQm4/JkWpsr5/04UcFBUqE5XOI5wlaKm6hAeMnSY14
	wojlU+6ldtHuojtJRPAdlhyQKl7C6o62EG5Q4osDjWoJK5OLXg7PSnpAwewww3+IL+7j1GcvpyM
	hVmLUHJIPj45MSBEYW0QwSDf+kgGqe+NUFnO75Er8AIDoOQ86tcgefwtj+YlU0fZKF1ztgAcMk9
	vqNC4LswRCSGW7jS3+WcSlF8bD8kn3mpTURbx2aM7yWjppLLMoZQUSnqP3kq3oT3YC3h5nBoQ+9
	wKd9RGgE/XvQd83dpoITj5d8LTQqvbtd2JfhjVY0qdaCw477/gpMH8Arw5T5KbdQTP
X-Received: by 2002:a05:600c:314a:b0:490:a2f4:c498 with SMTP id 5b1f17b1804b1-490ec504ca0mr38876115e9.6.1781356204417;
        Sat, 13 Jun 2026 06:10:04 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49220345528sm84506395e9.8.2026.06.13.06.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 06:10:04 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 1/5] multipath-tools: remove syntax check comments from man pages
Date: Sat, 13 Jun 2026 15:09:56 +0200
Message-ID: <20260613131002.144263-2-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260613131002.144263-1-xose.vazquez@gmail.com>
References: <20260613131002.144263-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Remove the embedded groff/man command lines from the header comments
of all man pages.

Suggested-by: Martin Wilck <mwilck@suse.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/kpartx.8                                | 4 ----
 libmpathpersist/mpath_persistent_reserve_in.3  | 4 ----
 libmpathpersist/mpath_persistent_reserve_out.3 | 4 ----
 mpathpersist/mpathpersist.8.in                 | 4 ----
 multipath/multipath.8.in                       | 4 ----
 multipath/multipath.conf.5.in                  | 4 ----
 multipathd/multipathc.8                        | 4 ----
 multipathd/multipathd.8.in                     | 4 ----
 8 files changed, 32 deletions(-)

diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
index ef8051a5..fbc8f726 100644
--- a/kpartx/kpartx.8
+++ b/kpartx/kpartx.8
@@ -1,8 +1,4 @@
 .\" ----------------------------------------------------------------------------
-.\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t kpartx/kpartx.8
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z  kpartx/kpartx.8 > /dev/null
-.\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
diff --git a/libmpathpersist/mpath_persistent_reserve_in.3 b/libmpathpersist/mpath_persistent_reserve_in.3
index 871242d5..5109fb03 100644
--- a/libmpathpersist/mpath_persistent_reserve_in.3
+++ b/libmpathpersist/mpath_persistent_reserve_in.3
@@ -1,8 +1,4 @@
 .\" ----------------------------------------------------------------------------
-.\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t libmpathpersist/mpath_persistent_reserve_in.3
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z libmpathpersist/mpath_persistent_reserve_in.3 > /dev/null
-.\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
diff --git a/libmpathpersist/mpath_persistent_reserve_out.3 b/libmpathpersist/mpath_persistent_reserve_out.3
index bf44777c..09708b93 100644
--- a/libmpathpersist/mpath_persistent_reserve_out.3
+++ b/libmpathpersist/mpath_persistent_reserve_out.3
@@ -1,8 +1,4 @@
 .\" ----------------------------------------------------------------------------
-.\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t libmpathpersist/mpath_persistent_reserve_out.3
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z libmpathpersist/mpath_persistent_reserve_out.3 > /dev/null
-.\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
diff --git a/mpathpersist/mpathpersist.8.in b/mpathpersist/mpathpersist.8.in
index 9a5a716b..d5f5a452 100644
--- a/mpathpersist/mpathpersist.8.in
+++ b/mpathpersist/mpathpersist.8.in
@@ -1,8 +1,4 @@
 .\" ----------------------------------------------------------------------------
-.\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t mpathpersist/mpathpersist.8
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z mpathpersist/mpathpersist.8 > /dev/null
-.\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
diff --git a/multipath/multipath.8.in b/multipath/multipath.8.in
index 0b170101..da5effb0 100644
--- a/multipath/multipath.8.in
+++ b/multipath/multipath.8.in
@@ -1,8 +1,4 @@
 .\" ----------------------------------------------------------------------------
-.\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t multipath/multipath.8
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipath/multipath.8 > /dev/null
-.\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 6990d2bf..422ab120 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -1,8 +1,4 @@
 .\" ----------------------------------------------------------------------------
-.\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t multipath/multipath.conf.5
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipath/multipath.conf.5 > /dev/null
-.\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
diff --git a/multipathd/multipathc.8 b/multipathd/multipathc.8
index cf7ae5be..5e97fb81 100644
--- a/multipathd/multipathc.8
+++ b/multipathd/multipathc.8
@@ -1,8 +1,4 @@
 .\" ----------------------------------------------------------------------------
-.\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t multipathd/multipathc.8
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipathd/multipathc.8 > /dev/null
-.\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index d766dc65..93625a90 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -1,8 +1,4 @@
 .\" ----------------------------------------------------------------------------
-.\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t multipathd/multipathd.8
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipathd/multipathd.8 > /dev/null
-.\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-- 
2.54.0

