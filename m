Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118DD1DFE35
	for <dm-devel@lists.linux.dev>; Fri,  6 Sep 2024 18:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725646066; cv=none; b=hOaytK26GrP2SZEHD3GHJsmw6e62eW3qJbyvLk+XS6j2PwzAi+NsuOZYlIP7JvokkXAPQTlIzduIxPkC/Htw7wI9EorLJtQk5G4rt7N+Rx6wy5qmYT0QPL0LA9Ob8VQ8bHLtYugufQ3DZvTtycLY8n9XtMuQxiz7MS73f0qNvLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725646066; c=relaxed/simple;
	bh=O3UAXZkcz3UN6Dt/w3KBYY15sBZvOlJPv1+hEhOfltg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jtLq/DzOpy4IYGv7B2n5mqx0jDzsQ/boaEROX0mTxd18BlgDd/jlHpBm2TGbWgffN8JFYTGwZq2K3aBZx9ThxpWUpzNQMMJfykgvSd43/UF8j2Nhe2jfMjkoeUJ+7+C2wFhOnheT/KgqRCOzGOA/WgcyTaKh4x3fpPX7R28Nnzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=An5JvkaQ; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="An5JvkaQ"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-42bb72a5e0bso19084805e9.1
        for <dm-devel@lists.linux.dev>; Fri, 06 Sep 2024 11:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1725646059; x=1726250859; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LQZ8L9mTC0Pfg84h3ii9NcoUeyvY6PYOcS19dKaWwCk=;
        b=An5JvkaQtPx+Us5UT8jOWSE720EJXlK505Qx51vXVdDKcgJjUNidrD3+dUncy2eZ/0
         r9PwwU2fBiuABQwmgaGvz+4YIobDmma8H1tYkSKzICKUX4CWO08Yd9PAq4jH8X4ObYvh
         AukxafuHZgyqa2S+ICDBLgeekR4UaCT0yjDbTpMzSJKrALL7Ew7m3f58W1WxgUCv/sKd
         W0meY4ti0pgq6r9GkI/uaNlIM2JkV5dV7DZCmBHP7G6g//8M6uybPHA09Yl+FQodnaRG
         y9wVY3wvL/EiN56qAlHE5scUS79JAQjP9LRfn1MfhoRdntHtxtVUjFd7JVDS8vq2ceNw
         hhcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725646059; x=1726250859;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LQZ8L9mTC0Pfg84h3ii9NcoUeyvY6PYOcS19dKaWwCk=;
        b=TKhMdR1x6XSYSlxVm9gTmuZm6Etuw8ePu4Dos4+0XLuIb/XstJCOCQnWkM2wfLLFUd
         EfAL5Af9erlgbTVbp6U947qU+bmpEiTxcVeI5W5W0xJk1VdEt0mL2sXdcwMiqU07xORp
         ocSebV7dos5ZfjzTQIwKIvJoV8ekcTqQ2WXItttXVH2lv99LVkC0kHPCoBj/Ydy2Jy5r
         I1DRVsMNTKJq8mh7zAbO68cmK1QkWD79JiUESqbqQ7JaYexQlPGuk9xrdKVfNwIfWONp
         apof1lrmdZ3q13FGK6oHIDWfUUY/j7+RtIIdbpP8y7CdMad+rakElQsjXmSiF3dqBpwP
         sd6g==
X-Forwarded-Encrypted: i=1; AJvYcCVRML4mIFTFVLbz3XxfuQnqwlFJpyxnRhhPTC04HgC81oplBctC7CxkapEboT22BfUyjAz8ri3InQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yws522z17bNuE1EcCw3ipc/WykaFPO0GBXalHCBea/9hioPnbyP
	qeCwX3EcgeuASQsSrj5cYbzAUYEyB59aHdlDQWmsu8LxiXn7QlE1ZXEPDevloDY=
X-Google-Smtp-Source: AGHT+IGPZLXu/CHj/rLRmdlAqy7bYTugOiqN3QyU7RcaHyeQJxCZac54FlLdGR672RRz0E8AtwaFmg==
X-Received: by 2002:a05:600c:1f93:b0:426:6308:e2f0 with SMTP id 5b1f17b1804b1-42bb01e6bfamr181416295e9.26.1725646058643;
        Fri, 06 Sep 2024 11:07:38 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:b9fc:a1e7:588c:1e37])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42cac8543dbsm5880485e9.42.2024.09.06.11.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 11:07:37 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 06 Sep 2024 20:07:11 +0200
Subject: [PATCH v6 08/17] firmware: qcom: scm: add a call for checking
 wrapped key support
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240906-wrapped-keys-v6-8-d59e61bc0cb4@linaro.org>
References: <20240906-wrapped-keys-v6-0-d59e61bc0cb4@linaro.org>
In-Reply-To: <20240906-wrapped-keys-v6-0-d59e61bc0cb4@linaro.org>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Asutosh Das <quic_asutoshd@quicinc.com>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Ulf Hansson <ulf.hansson@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
 Gaurav Kashyap <quic_gaurkash@quicinc.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>
Cc: linux-block@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
 linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1760;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=pphwd759/DBj3RgaxEbArwd2xYzTPPPYY/h8eurM+S4=;
 b=owEBbAKT/ZANAwAKARGnLqAUcddyAcsmYgBm20TX188iijodsFONRyoGdwvLJZOBeZr0JN+mf
 VDp5ZeQvEKJAjIEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCZttE1wAKCRARpy6gFHHX
 ck7mD/YxTU7++nR61a8rJAuSjLlvkE3LHUhGXlN+L6xIK+NQgd/WhNndEXvaO19A2LKuq35NfId
 9tsEXEUxEpcP8AldJIY7agNQkC70eBsE+6veWO/nBZuxAgPCqgPGNs0f80LbVtcQ+n0heTYX1XI
 RguzbIU84KxoOr7k0Rf8PXDMltYANZb6baizCLD/JHHKi+6jBuUE5l/BvfF/TjigCJcja86BG9Z
 DETOfIF9QpPBWNs76SjOEaE2vZ+O3YSrVgAAwteUuTZEIt1UMRGH0A5D3i9f4cFZKIpg3Ftf98p
 I4pJbrfL3tTpxXDQ4oHy7ypBIXkVGr8vOt+iMfN2sjfQ1Cpwuc5b1Bc/QLJWgTB/3VK1Bj1r0yj
 RccuoIqBLyTVSleRE56JcbeMBD1nYD8CvYhkbliQbJn+RM6Cl+SbfOdyc0V4T1EAzxKHUUQX//z
 vkVzkeeph5QcDU487pl+bf/a39PJA0VP8J/2g7E3gmVx+zrA79NWKl8uZN9N1UNJqoDYXwCoJc5
 MMU3JvmxTsiAwNhJihI82wdaiWG8rNHC3kP+zGZi4jdNZrBTnUyere1kG02iO1O7BbKgHIun2O5
 0a1fJkkq4N/lYU6LlwZ13nJ5zRpVV4Pb/oULa5O6Gi4IyN4HoW7btZf3JpGgkH3SGZ6wYhlpvo+
 VjcGDAGm9XfQi
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Add a helper that allows users to check if wrapped key support is
available on the platform by checking if the SCM call allowing to
derive the software secret from a wrapped key is enabled.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/firmware/qcom/qcom_scm.c       | 7 +++++++
 include/linux/firmware/qcom/qcom_scm.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 27d8cb481ed7..1053c16d5e50 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1252,6 +1252,13 @@ int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 }
 EXPORT_SYMBOL_GPL(qcom_scm_ice_set_key);
 
+bool qcom_scm_has_wrapped_key_support(void)
+{
+	return __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+					    QCOM_SCM_ES_DERIVE_SW_SECRET);
+}
+EXPORT_SYMBOL_GPL(qcom_scm_has_wrapped_key_support);
+
 /**
  * qcom_scm_derive_sw_secret() - Derive software secret from wrapped key
  * @wkey: the hardware wrapped key inaccessible to software
diff --git a/include/linux/firmware/qcom/qcom_scm.h b/include/linux/firmware/qcom/qcom_scm.h
index b5ab39b35490..94d4e3c96210 100644
--- a/include/linux/firmware/qcom/qcom_scm.h
+++ b/include/linux/firmware/qcom/qcom_scm.h
@@ -110,6 +110,7 @@ int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
 			     u8 *eph_key, size_t eph_size);
 int qcom_scm_import_ice_key(const u8 *imp_key, size_t imp_size,
 			    u8 *lt_key, size_t lt_key_size);
+bool qcom_scm_has_wrapped_key_support(void);
 
 bool qcom_scm_hdcp_available(void);
 int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt, u32 *resp);

-- 
2.43.0

