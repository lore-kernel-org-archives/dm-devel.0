Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EA515D2
	for <dm-devel@lists.linux.dev>; Wed, 24 Jan 2024 02:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706061634; cv=none; b=ThVKOg3k/70ADKLRwEFKeWSwC56+RtnsfHOpScfYozc7fgda5buKs3b2v0Hg3YSujydpBoDL47Rjj0OfJaglIm7gVHX4ENYZQuctd/m7HhZfdOtQwklYJgCbd1UO/FLx9FTVotoAkkZqCWahyL4IDPQut4nqHSGWF4Mmh5V+pD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706061634; c=relaxed/simple;
	bh=8d6WTmteQijPqRf83WskWT7kR/dWOXaY5i7rNx5+M/A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=luVpP3wkdxfCTnOpzlSQG42PvTgLHcCujJMO51/b25ZB+Sf8zmxsg4pVVfashV6OCmfDc3yWi3zRZutsyX38CzVzBOds4QDy8S//j3QxYPk4/vfDmAJT5BRJnryqzQrf1UJ1ZAnFi0fDdTI8IMc0FUffHkLKxQK3K6H75A7dNkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=PDCvyfuu; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="PDCvyfuu"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-dc25099b084so3220107276.0
        for <dm-devel@lists.linux.dev>; Tue, 23 Jan 2024 18:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1706061631; x=1706666431; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hEwMS+oLOZw79k9q7PdNYGfvvcesUSJ0i3k8Uwv3yis=;
        b=PDCvyfuumKpmworuToMZ0bnEPTp0a1FLahpXH+ddh4wDULlyrTTzF4KB/f5hHwXurR
         piwaH1qwCRCIqFNeg6bifmogefu7IKPSXcAuu0whxNIgKbLbtHvgREcjIB0B/6QDOEqC
         aTmjKbRguxuOI46Z+pQGOgy4YYsbYahL5pni1UIkLyk8D8zMuLaZn4mobsKGfjnKmt8V
         BxZUHwyQ8wcYWs1Li7HjJrbBrYsy0tMjD2Txv0XmRvc7U7i/gUlD/vUk/8vspLHAS64F
         8UUQWmt4NvDO4tNmMUXw6+NHCEh81qJJIzDKOXHiDZifgJDFMOToVKkKzFemvgadmjVB
         yn1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706061631; x=1706666431;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hEwMS+oLOZw79k9q7PdNYGfvvcesUSJ0i3k8Uwv3yis=;
        b=Tx8KoxlWY6oxxUMANNSpc26iX9Cbk3uk5jLQZ8JpHgq7+wijORoSc5euu8A62gKVcA
         8Wz9iicanpnDOl+mqfLnoBHWBRxuRJPCtdCMlk+VDdbex2qpftmBdeziHMLwu/Ow1py9
         wCkDAjSb60dy6Ekyl6x4BLUY/Gm9EVWJo6WmA+VXHBzyKpa6GvyJsuFmlFDlJgCs5FWs
         HNN0ZJTO7ZQGf9/lHxvisdKuT05h/6j+yrOmhq0+QlnbHffwM6WADcwFB4lHqM/HMcyf
         kZifWuSDAkCUAGdrIutlNflcpGjAinvORuEbsAFW3pGsf/pCVRhd3nhU4m50hJUJJZDv
         QoLQ==
X-Gm-Message-State: AOJu0Yy4eWRFlYpegy6h/lCkjcmIsBOUip0Czciz3z9Y4PfAjqkQZdUT
	SoHwAYZioKOP/IQz4UrbQyWkYMvzXFnnz3p1RAcT2eL/gw+j0/8rdO+l3GVyyLr4BnoyF/oSS0X
	S8gEouZxPQ1UoTalKWhNNfJQ5Z2mUwtf8ERn5lQqZSMKpwMPDAcov0dJlGG+n6DdQFXfkim3gr5
	vVeKMpX1WCE/OiaiDv16qChg3PmztQotbm+XvyD85OrD8=
X-Google-Smtp-Source: AGHT+IFr1j7Ai+JA+Vxb3oyjfqH6pQjPKZO9mgTLMOufjOrZ9AlS6d0O6mgLc5t+JsGsyDdfxAMX0w==
X-Received: by 2002:a25:9cc8:0:b0:dc2:4357:ad09 with SMTP id z8-20020a259cc8000000b00dc24357ad09mr88413ybo.108.1706061628982;
        Tue, 23 Jan 2024 18:00:28 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([136.226.79.24])
        by smtp.gmail.com with ESMTPSA id l38-20020a635726000000b005ce472f2d0fsm10481071pgb.66.2024.01.23.18.00.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 23 Jan 2024 18:00:28 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: mwilck@suse.com,
	bmarzins@redhat.com,
	Brian Bunker <brian@purestorage.com>,
	Seamus Connor <sconnor@purestorage.com>
Subject: [PATCH] multipathd: the sysfs prioritizer can return stale data
Date: Tue, 23 Jan 2024 18:00:07 -0800
Message-ID: <20240124020007.25259-1-brian@purestorage.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a path is lost and then reinstated later, the ALUA
device handler will not pick up this change and continue
to possibly provide incorrect (stale) information about
its ALUA state to the 'sysfs' prioritizer if the path's
priorities were changed prior to the loss of those paths.

On the loss of an I_T nexus, the path state should not
continue to use its last known state. Many things and a lot
of time could have passed between the path loss and its
eventual reinstatemnt.

The ALUA device handler didn't have this issue since it
always got the ALUA state from the target by sending an RTPG
request on the path and updated the priority. However with
the detect priority set to true by default, the 'sysfs'
prioritzier will be used on targets that support ALUA rather
than the 'alua' prioritizer.

Without re-evaluating the ALUA state when a path returns
multipath is left with path states which do not reflect
the actual ALUA states the target is providing.

3624a9370f0f545fc7c3e46a100011010 dm-2 PURE,FlashArray
size=3.0T features='0' hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=50 status=active
| |- 13:0:0:1 sdg 8:96  active ready running
| |- 12:0:0:1 sdf 8:80  active ready running
| |- 9:0:0:1  sdc 8:32  active ready running
| `- 1:0:0:1  sdb 8:16  active ready running
`-+- policy='service-time 0' prio=10 status=enabled
  |- 14:0:0:1 sdh 8:112 active ready running
  |- 15:0:0:1 sdi 8:128 active ready running
  |- 10:0:0:1 sdd 8:48  active ready running
  `- 11:0:0:1 sde 8:64  active ready running

 # sg_rtpg /dev/sdh (Active/Optimized)
target port group asymmetric access state : 0x00

Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Seamus Connor <sconnor@purestorage.com>
---
 multipathd/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 230c9d10..dd48be74 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1937,6 +1937,11 @@ reinstate_path (struct path * pp)
 	else {
 		condlog(2, "%s: reinstated", pp->dev_t);
 		update_queue_mode_add_path(pp->mpp);
+		if (strcmp(pp->prio.name, PRIO_SYSFS) == 0) {
+			condlog(2, "%s: rescan target to update priorities",
+				pp->dev_t);
+			rescan_path(pp->udev);
+		}
 	}
 }
 
-- 
2.43.0

