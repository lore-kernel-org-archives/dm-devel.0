Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442232F25F3
	for <dm-devel@lists.linux.dev>; Mon,  1 Dec 2025 14:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764600057; cv=none; b=LSjIcmMx/+VCT5HF7U6/qGEeniBmlwQOYMtoyKhrJV3A6tQKu+z4vZ9XgPvfcv7+kmsXBzcm/WxR0D515q8oCusRCxAqnCIAQwx/kkrM1pmr+RXeXILnVSQioy06QkcIXoFdFoFZH6ZpZ2n8vRC/3/zPQyySmdS2XYY/zkhOPvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764600057; c=relaxed/simple;
	bh=5dkXiKSxUQ9SEFscoRGJFs2rgySLECpu9pA63DaNVQA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Jq+ZBUahCQ8ld3SDhxa1zvKnQ/ZRVhSk3acdDsPz+zOuOeXiwGyi9/DwbTQCsp0CDVX2UeL8PzPCMR1qmjj9Ux3ldbN5BVTXp+sdi/DoXH/4wz/y9SCEYjQuCxLPC3Pr2VnC840AvXnEp3z2lwVok3v9jlIkrHPHMDQDtkcCEm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iKwoAnZs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iKwoAnZs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764600054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=w1JoHkqA7g0GDvFhwIAgt4kO+Idxg7efZdJ0ms1hkMA=;
	b=iKwoAnZsAJNMSFS6Ue3pihQgScQcQUSmBnBidTJKybIqVC4KtibYMxjCgCuXsyjUVfobjY
	bHlIfzANkFC/eXFV0OoRd8yZ02d649bQIkWZK/ghdPVWtPb4GKxJ37W0kE3exptb10Gawx
	GGeOm27FhO0EsQggfBT4wGpPfH23Vgk=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-a3B8HTUgOySBbTLjrkvIEQ-1; Mon, 01 Dec 2025 09:40:53 -0500
X-MC-Unique: a3B8HTUgOySBbTLjrkvIEQ-1
X-Mimecast-MFC-AGG-ID: a3B8HTUgOySBbTLjrkvIEQ_1764600052
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-5db1f7f4a36so1254382137.2
        for <dm-devel@lists.linux.dev>; Mon, 01 Dec 2025 06:40:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764600052; x=1765204852;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w1JoHkqA7g0GDvFhwIAgt4kO+Idxg7efZdJ0ms1hkMA=;
        b=fw5P/OQ4/NUNsVK8nNgOMlEwQJNil43R++En8Eg2hk+BQ4PlVMv/FHTqWE/4dim5k+
         6u8+m6dCzcPy1O0I5UjhsQQJcUTWva/fv3xI4U0ADj658DEnAIGVEDtUUqackhFIlf7/
         CvLjj5FabVRnp7UGBIHlrl9YMh+5bNWXeJ5LFUBpt32a8tVKJaqMzJ1TrypQoZO5809u
         p0BzZQ0ibzGPP/ITJQiJL/9BnU5z4jYenNnL2CaMSDcRu5B5FhG9S5eKBqNgZMUwIj83
         VgdE0Aus/MnDbbX4i6D8P/w/gMOzv6uul8KPzxVLTFZCYNa+Wyk66WK0fYsnd8TFFas/
         KU7w==
X-Gm-Message-State: AOJu0YyUM+Fl5taAWDLv1Lw5b0hTexD851C/1FSJkoQpP9SQkkeyqmFK
	+oxRE/mL1THdsTIKibjqZfCDQUpC6FfX4Qdf9vB+TSWdny8oU/xK6f/whLWne4cGN4xlSIXTYoF
	VVlyGjRxH3hUFsDS2ZLUNGtofI5qIvVEcC24R0Zr8hXeLDlXmZ0xjUDVdo0enam14elbpIcQ8u3
	xARj/zp3ARIX+w5sZpOcwPU1PZsUglwvkA6Hu3TD/5y66HJQ==
X-Gm-Gg: ASbGncslRc9SVzbkPlFY6halEgieyxSd64JYJA7+VYoqEaOcahHjsa9NATkonjue1iq
	Fck3JCRHFwYSXEhKeUWCK4j9LfzYto/tDHvreRyAiyEz5vDv9mTVKShZx2jkA2V0bZN6/CDMTiQ
	Du24OxHjBTeYyN56r75X6714MMKlSXj0kSigJo3ThRZoVBMwuEBmBJE3SkjijDzhrI
X-Received: by 2002:a05:6102:8014:b0:5df:c4ec:661a with SMTP id ada2fe7eead31-5e1de3c8be5mr14271942137.27.1764600052294;
        Mon, 01 Dec 2025 06:40:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHmgupcvszhU4KXioGvHtFcydsCeF2xaPas27oPTxzopIzwHB2PGXoVJ4F6pezmJ7C6hBfCjRFNNBIjKpwOP9o=
X-Received: by 2002:a05:6102:8014:b0:5df:c4ec:661a with SMTP id
 ada2fe7eead31-5e1de3c8be5mr14271825137.27.1764600050735; Mon, 01 Dec 2025
 06:40:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Heinz Mauelshagen <heinzm@redhat.com>
Date: Mon, 1 Dec 2025 15:40:39 +0100
X-Gm-Features: AWmQ_bl24YZoIuLR4PMOJyyjgf3qwE_ptvu0k7q2LB8S-1_i9gdmiB2FjBG4a2c
Message-ID: <CAM23VxrJpHE4SBo82AnTwD14qA-GXfs48kfaaoenGAnEqTEUtw@mail.gmail.com>
Subject: [PATCH] dm raid: add takeover/reshape raid1 -> raid5 table line examples
To: dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: T3Tbc9dOc09UAloYKmE_lKARe-rLANEyQBV_W8uLLUM_1764600052
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Also enhance possible takeover/reshape information and do some reformatting.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 .../admin-guide/device-mapper/dm-raid.rst     | 49 +++++++++++++++----
 1 file changed, 39 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-raid.rst
b/Documentation/admin-guide/device-mapper/dm-raid.rst
index 3554c44414e63..e11f107647709 100644
--- a/Documentation/admin-guide/device-mapper/dm-raid.rst
+++ b/Documentation/admin-guide/device-mapper/dm-raid.rst
@@ -20,10 +20,10 @@ The target is named "raid" and it accepts the
following parameters::
   raid0 RAID0 striping (no resilience)
   raid1 RAID1 mirroring
   raid4 RAID4 with dedicated last parity disk
-  raid5_n RAID5 with dedicated last parity disk supporting takeover
+  raid5_n RAID5 with dedicated last parity disk supporting takeover
from/to raid1
  Same as raid4

- - Transitory layout
+ - Transitory layout for takeover from/to raid1
   raid5_la RAID5 left asymmetric

  - rotating parity 0 with data continuation
@@ -48,8 +48,8 @@ The target is named "raid" and it accepts the
following parameters::
   raid6_n_6 RAID6 with dedicate parity disks

  - parity and Q-syndrome on the last 2 disks;
-  layout for takeover from/to raid4/raid5_n
-  raid6_la_6 Same as "raid_la" plus dedicated last Q-syndrome disk
+  layout for takeover from/to raid0/raid4/raid5_n
+  raid6_la_6 Same as "raid_la" plus dedicated last Q-syndrome disk
supporting takeover from/to raid5

  - layout for takeover from raid5_la from/to raid6
   raid6_ra_6 Same as "raid5_ra" dedicated last Q-syndrome disk
@@ -371,6 +371,7 @@ to safely enable discard support for RAID 4/5/6:

     'devices_handle_discards_safely'

+
 Takeover/Reshape Support
 ------------------------
 The target natively supports these two types of MDRAID conversions:
@@ -398,16 +399,44 @@ raid10 with near layout and even number of disks
-> raid0 (select any in-sync de
 Reshape:
 linear: not possible
 raid0:  not possible
-raid1: change number of mirrors
-raid4: add and remove stripes (minimum 3), change stripesize
-raid5: add and remove stripes (minimum 3, special case 2 for raid1
takeover), change rotating parity algorithms, change stripesize
-raid6: add and remove stripes (minimum 4), change rotating syndrome
algorithms, change stripesize
-raid10 near: add stripes (minimum 4), change stripesize, no stripe
removal possible, change to offset layout
+raid1:  change number of mirrors
+raid4:  add and remove stripes (minimum 3), change stripesize
+raid5:  add and remove stripes (minimum 3, special case 2 for raid1
takeover), change rotating parity algorithms, change stripesize
+raid6:  add and remove stripes (minimum 4), change rotating syndrome
algorithms, change stripesize
+raid10 near:   add stripes (minimum 4), change stripesize, no stripe
removal possible, change to offset layout
 raid10 offset: add stripes, change stripesize, no stripe removal
possible, change to near layout
-raid10 far: not possible
+raid10 far:    not possible

 Table line examples:

+### raid1 -> raid5
+#
+# 2 devices limitation in raid1.
+# raid5 personality is able to just map 2 like raid1.
+# Reshape after takeover to change to full raid5 layout
+
+  0 1960886272 raid raid1 3 0 region_size 2048 2 /dev/dm-0 /dev/dm-1
/dev/dm-2 /dev/dm-3
+
+# dm-0 and dm-2 are e.g. 4MiB large metadata devices, dm-1 and dm-3
have to be at least 1960886272 big.
+#
+# Table line to takeover to raid5
+
+  0 1960886272 raid raid5 3 0 region_size 2048 2 /dev/dm-0 /dev/dm-1
/dev/dm-2 /dev/dm-3
+
+# Add required out-of-place reshape space to the beginniong of the
given 2 data devices,
+# allocate another metadata/data device tuple with the same sizes for
the parity space
+# and zero the first 4K of the metadata device.
+#
+# Example table of the out-of-place reshape space addition for one
data device, e.g. dm-1
+
+  0 8192 linear 8:0 0 1960903888 #  <- must be free space segment
+  8192 1960886272 linear 8:0 0 2048 # previous data segment
+
+# Mapping table for e.g. raid5_rs reshape causing the size of the
raid device to double-fold once the reshape finishes.
+# Check the status output (e.g. "dmsetup status $RaidDev") for progess.
+
+  0 $((2 * 1960886272)) raid raid5 7 0 region_size 2048 data_offset
8192 delta_disk 1 2 /dev/dm-0 /dev/dm-1 /dev/dm-2 /dev/dm-3
+

 Version History
 ---------------
-- 
2.52.0

