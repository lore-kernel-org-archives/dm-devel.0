Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3F023768
	for <dm-devel@lists.linux.dev>; Mon,  5 Feb 2024 12:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707137213; cv=none; b=jdfPam1QNFmtZgIJmtR/qczNrYep9JhBVeFXFR2oloTe5riN1+OxJzQWguh/ysoyYa8V4/x1osTVSTqYQFIL/O6o6CsK7YBEFq/dWNYDKZr/tlCyEFZUJv0M3BUYkFbupL9NBiGL3kxzi4hqRXgPXPgieQfBXgnGwmlzxE0ZFsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707137213; c=relaxed/simple;
	bh=lBn7URuszkpHT+5AnuxcemTzKmPsCPPZ4laUvqRgF6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4A7jqZRgad9ngrFxCjsVHNO4CRLbkMrwEeiBcTr1qSSWrFL1WnWTzD0aqDCmwie2/rxpUbo2hMNIvcEQBSrRSqwByFCvLpJedzJnAMRw+D1Dq52UevLy9WVazdo1EXbAs47oasHBq1niVuzUeBJjEmx4sr1Z5O76n4JcY4E888=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OFDuB0aS; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OFDuB0aS"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-40fdd65a9cfso4473175e9.3
        for <dm-devel@lists.linux.dev>; Mon, 05 Feb 2024 04:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707137208; x=1707742008; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bb97CUPZUoldczzs3axUAOhdvUQBJIcClp5cbcA1EPw=;
        b=OFDuB0aS6e1eiMQOi58+hMbylX5Ds7YleprTIe2kKwFc5oe+B0bGf2A7Ohbmz/bqYq
         58qNkNYDp2kNBtwpMuiNz8uZm2c2if0970rfK4HfDppr+GpK8B4KSLxdGuZTC1lHNK+7
         x3Ors1gIw8V+LcNRTm6xCqSQ4Ul89CQwUJioUAZwAMq7UkKO/O//D3F7A5+ruzbYlqZM
         uSaL2wZkUSEWpZ626GnFX8sYRczGXOtCrR4r7HW6Qh2Kmki1mhzbV7xXlm++oJZ8jga4
         aUl7cCIozDfXbJqeooOB9uM/Oa1PMY/5yTVUcHeaqamgo/HV9qS1/4M2EKTQcieN/mWj
         ErRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707137208; x=1707742008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bb97CUPZUoldczzs3axUAOhdvUQBJIcClp5cbcA1EPw=;
        b=e9anFKSWMyqqdQl72U6OnqqeJlu7gKq7FX5fJmASI9xjXt8EeIF9FRvHF+ULmSKYqB
         In/480mGCNSDppQQQpVHfLf9+u1R+NdIwL01QWEfoAAFEZ4I6Aeev8ovRcfVyd7I1Y4h
         FpoyBSFQhA5v47xcfvI9kIE1vH2EWMRE40CgRRUV3TxRti5SORvu+Wd+dUFEoSCszi7H
         tLEE8m+nNc7qpSZRMuALbbxBF9kzIY3Xxx7Yf9BQw/AX8x8py6Lu0any8exGfRl4acnC
         danNRFAkv9lXnp1h6LCz70o+TDsEuHU8hnyadapPGAS8zhgp7J06XAJkQ/4EyX0s87v8
         3+BQ==
X-Gm-Message-State: AOJu0Yz0n5z9vDWt2G9N3yplUyjLBWY5AGOqZuZWaivZdvwhlyMHIYbe
	aHO7DsfHhRL+7wXsD+NNahxWbZxrbfgTkm3s+DjbkO6ztnAaVEpWGJ3x0ZC8Elw=
X-Google-Smtp-Source: AGHT+IHswfurlsOxMiBC6tTM4NPVbL+OXOQgZj27n2UTvs68eWcVwcbrbDKqbIllqo8TL2ItPNG8Sg==
X-Received: by 2002:a05:600c:4f47:b0:40f:dd0e:9e14 with SMTP id m7-20020a05600c4f4700b0040fdd0e9e14mr1204271wmq.7.1707137208251;
        Mon, 05 Feb 2024 04:46:48 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVdnwc8x2bPMOyOEoN+ouc4He7RBEopExgeSO/nZHGNsJZVmqEi1GXWchN5KWm50dyUF0T2Ww4Snymjco6xiTBKNS6C5Jh1wd5SDSVWkLeAQoyRVaNuw+WZi9Ptpb31AdcIQQAU2wq3WLjO5fKYfMFqemyOQ5BHzsHSrKZmX/JevLH+NoXdkC5O
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id q11-20020a5d574b000000b0033ae4a3b285sm8002392wrw.36.2024.02.05.04.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 04:46:48 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH 2/6] 11-dm-mpath.rules: fix list of imported properties
Date: Mon,  5 Feb 2024 13:46:34 +0100
Message-ID: <20240205124638.17877-3-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240205124638.17877-1-mwilck@suse.com>
References: <20240205124638.17877-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure we import all properties that are also imported in
13-dm-disk.rules. Keep importing ID_FS_TYPE for now to avoid
breakage, even if 13-dm-disk.rules does not.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
index 2c4d006..43d227c 100644
--- a/multipath/11-dm-mpath.rules
+++ b/multipath/11-dm-mpath.rules
@@ -92,11 +92,13 @@ LABEL="scan_import"
 ENV{DM_NOSCAN}!="1", GOTO="import_end"
 IMPORT{db}="ID_FS_TYPE"
 IMPORT{db}="ID_FS_USAGE"
-IMPORT{db}="ID_FS_UUID"
 IMPORT{db}="ID_FS_UUID_ENC"
-IMPORT{db}="ID_FS_LABEL"
 IMPORT{db}="ID_FS_LABEL_ENC"
 IMPORT{db}="ID_FS_VERSION"
+IMPORT{db}="ID_PART_ENTRY_NAME"
+IMPORT{db}="ID_PART_ENTRY_UUID"
+IMPORT{db}="ID_PART_ENTRY_SCHEME"
+IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
 
 LABEL="import_end"
 
-- 
2.43.0

