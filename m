Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC26202F72
	for <dm-devel@lists.linux.dev>; Mon,  2 Dec 2024 12:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733140977; cv=none; b=lBHAO6aMfAT8IOHgjvg0VWWX9CAHFF/QAr/YE2IskVeeTKouary0kc7FnCMx2KCL3S8hn8W+2uMexnGOgx5kLEJFkox8zdNK4ueHREuUlF4E0anNzPVcic9iOPKf5bUJHxBTNBEcJGA6ZpGKBMvxXH/yW9nTVBk0Cw7YEKHFCww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733140977; c=relaxed/simple;
	bh=aRvxC21BhTxDXUKjx9ruTN4tMTQfge2gVFw2Pfe7Z+8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dOQ574zj5v3IoDZ1KJKvR3aXLJXSRjUb/vFnDqhC7RZJhVjWxI7pDPexHAwN1BL2a9RKrAsgAsb5tNF8pGC+s5pV2P8WnSb3k8tqaLmEHvsiti4VsQDFpoeYESh6elHVv8m6EH3xUVmnctIf33e/Ta34gdwDWnRuYdlM14BpqEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=tLVJbSa3; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="tLVJbSa3"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-434a742481aso33374305e9.3
        for <dm-devel@lists.linux.dev>; Mon, 02 Dec 2024 04:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733140972; x=1733745772; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=touQmIBQiXzWh1JEM9Gfn3mWpH6OCuAp3TCnoOv4GIQ=;
        b=tLVJbSa3x9Qq9ypsnaq7+VNsJame1VtLHC/xhg8/7BbA3K8wwuDCpywjWBsXU6JWbY
         TMSHmog4uZJANin9+BJiV/hp6hMHxyudfh+wlIboDjCT3T5xu97jZnffak0tgqFkfjCB
         qXIHwKdeF9Tg2PkfRR4XHD7iETbIbqb0GL8SBJzqbOMb5NqU33uD6Z47y7xdjzHhpq2Y
         yRXcp1mpgO+ZCazqUn+awBVBcD6cutz1S8cWd3ANmFTEsPR1oc9iPu14+kP6gTqc58f7
         1vqCPszQ1nAJfZdz4eB6mTyYX8ys9i9G0n8ieDNAvPc6atmWs9AdRnVJvgZl6qD87s4N
         1PpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733140972; x=1733745772;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=touQmIBQiXzWh1JEM9Gfn3mWpH6OCuAp3TCnoOv4GIQ=;
        b=eHz+XsX5/nVsAIrYVnpiy/Qk71UaNY7Kr3+UDGrDihYwQ93VpyGczUZYhEwHEjAN3p
         igGCY5s5Mc4nHO35yuZRcqR2UUXqW7Geu0UPIGdroRR5Q2i6ss4jUVIatc33wAKrLt0X
         0X5r2ypv1Th2oVYKHcghmRohiyk5EdqFwMSIeHsfeXBhxbbm9jjnJqN18Cavo8bL13CN
         C/vBwPdqTXB0dDJvcW1DwLFGXDvBvdCLkt3Ze5nToGdWZ8B6PBrHz9x4LGAn9LfZ8BNY
         8cR5+LS4ISrnW0Jg1JcdO8S2XvzmF8Qpr90M4hO9pIrHWlNqgaprJLuCfglaqsU7prii
         AZwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUnJpxXsaALt+UE/UhlCt58FSm+dZ2bh7Ro2Na5fFxyeyk1d9wDuUieKsrS5dSk1zYn0xO+DXSqA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyfBQh/pTXPf1nlAIF5rvtYGRQWTL08gXRcQVeWbD0mifwSTImv
	/UZs98y28PLZ4mvNBoD05wVYfA3JjmlRPR+YM2lXWob5LB+7SoD5Ky6TdZhViUc=
X-Gm-Gg: ASbGncskoI6rXL963SUmhDJTB6MtzOK9zgxWeaKz/MXrak9yw4sZliqPrwODuP0jpiU
	VBnsLWRYmi0ESUJcWsY/epohmAc/2pqvR1uy2WsU4V8I6aDrArX4RZyXrGo++7J59iIalWlighW
	nDErboPpJN3ILmAQUzZ55AfMl+nS5zHa2bDuMkkps4a5c4hDWw6mR6OaeqZJNmUqZdQx/7p2j0I
	7j2TBPZuFwN415NWj8jFhUbholD14J8tj17s4bO
X-Google-Smtp-Source: AGHT+IFVcG0WNXyZYjt32w+M6ShxZPiZDTgzJ1i2L8r2rKvxPJYT9RhXpy10UK6vs45kZUSgKb1ygg==
X-Received: by 2002:a05:600c:4686:b0:434:a962:2a8c with SMTP id 5b1f17b1804b1-434a9df6af9mr185930165e9.22.1733140972279;
        Mon, 02 Dec 2024 04:02:52 -0800 (PST)
Received: from [127.0.1.1] ([193.57.185.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0d9bed7sm152396095e9.8.2024.12.02.04.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2024 04:02:51 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 02 Dec 2024 13:02:24 +0100
Subject: [PATCH RESEND v7 08/17] firmware: qcom: scm: add a call for
 checking wrapped key support
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241202-wrapped-keys-v7-8-67c3ca3f3282@linaro.org>
References: <20241202-wrapped-keys-v7-0-67c3ca3f3282@linaro.org>
In-Reply-To: <20241202-wrapped-keys-v7-0-67c3ca3f3282@linaro.org>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Asutosh Das <quic_asutoshd@quicinc.com>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Ulf Hansson <ulf.hansson@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Gaurav Kashyap <quic_gaurkash@quicinc.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: linux-block@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
 linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1817;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=+R6JPSKxZAYNPKLIpsJZoN7OEYE2IK3CNpaiaGjz6AY=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBnTaHUvjd2zifuwXGVatR1JdebHWc/LZaLwgmus
 WGS0vMLua+JAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCZ02h1AAKCRARpy6gFHHX
 ctfPEACUk/7ZHHbhr8W2JfWwwmaiESzyTdR99Tou0BMLTIZyn9sJx0cMYsTClkr7tiSefKwqE4g
 A820hXjV7BEcEXwPxeJx5la8tQwsM7TuIP7TQakNzw+7HVZgviuxbez66ieom/ien9ksULr6dbC
 oGbUgUvT76nFiqf9lbMvgPgIjZkWqbu2FRmHZ4oodKwmYDerflRYUYY7IiqZUuEqVpyPNLRU4hG
 lH0PELE8mXUy6uqTukt1hUfiIrWPl8K6wY2RnWmeTT1I6wmAYXnQtk1YmxiBx2iTP0/eb2cf5HH
 RLJiBAd5aw2IlKRoCQpnSi0kWp2ltZbKyNWS0oP0eCc7/mFTJvPDjQviA09N1xcDW1lH3LjbCje
 6aatX/buSYuHDD2UId9EtMN7yfPC9n3YL9GvQsuVAN2rFyKaFt9xUTXgu0d2DJVjsiKeb1vd/In
 9rZ7c6bmHqNWRQjr22FT7YFz0xn1vxbKBObpWgkMdRxGC8qYnWuTO0UztFmHv5G3LUegTbFKLWT
 rXSJVszMxetXS5xKZTRRC/JW/+GHLVgl3QahGu9MPz6IuhuenA6ppDctI+TrMtmHD3NtzxM7vpa
 OHpol0GySgnRNelpG3cVBYIbrp1N2qHzbUnLkMz2VEhh/vlfzV1Xzy5d+bzPG6H9q8e6nhTBWVx
 cSYraZo571HQOpw==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Add a helper that allows users to check if wrapped key support is
available on the platform by checking if the SCM call allowing to
derive the software secret from a wrapped key is enabled.

Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/firmware/qcom/qcom_scm.c       | 7 +++++++
 include/linux/firmware/qcom/qcom_scm.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 14ba2c798f4d7..915b3fc388baa 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1279,6 +1279,13 @@ int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
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
index 9a585c1af959d..f4aed380ace5d 100644
--- a/include/linux/firmware/qcom/qcom_scm.h
+++ b/include/linux/firmware/qcom/qcom_scm.h
@@ -112,6 +112,7 @@ int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
 			     u8 *eph_key, size_t eph_size);
 int qcom_scm_import_ice_key(const u8 *imp_key, size_t imp_size,
 			    u8 *lt_key, size_t lt_key_size);
+bool qcom_scm_has_wrapped_key_support(void);
 
 bool qcom_scm_hdcp_available(void);
 int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt, u32 *resp);

-- 
2.45.2

