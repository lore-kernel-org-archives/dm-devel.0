Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E2B4F218
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 23:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721258439; cv=none; b=iJoq+itixK4PZuBmgQGycojBwE491oAG7aTn+1ARbIvtqMQuHBTYxgbbUAwNibApAchvgWy+d/0Gwyfz2Xq+FOx8iCws1e3ccqU8uKeAvyzsNcQRs6F56QhIJpxNf5pbrGK1emPkKrW2e566vmWYxJfJHr7Axx//XXjazpK6wCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721258439; c=relaxed/simple;
	bh=alkn7u8DptvmEkL2WvLNybsQ9pA+gLO09vP+UQQNaMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lB+e+KnHnn2muiS7Uyc5++sDEHuhmgRy5iSnbDEp8m0G1Qhvdpk8NE3GQ2Bv512I+rqZQHLcSeWk9dOGmUHbZMEXjT8T+RFtMu4d/jrZhOujS/TCEjwE+ue1oCyC9sNL3Htpscre0/1LTvhfRhO42PsOiJhHhXMMFhrnPq1AJjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ATJW6Y/c; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ATJW6Y/c"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2cb217f17acso161734a91.1
        for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 16:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1721258437; x=1721863237; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PJ4Rtgfw1crxH82KHr40tMf+xK9HrNqVoA0f8i6QWg8=;
        b=ATJW6Y/cfSWrS0/VezwtKCB3Gl2T/vCM8XuJ2m1WFlmlFo0q00o/7zyKQg1AGpPfU7
         PbATHQJAvhjwzvmkJUVu6apBkclfGpdfBKDZf4LFuEaNW4+hIQ8vFkbh34n9KXSnJrob
         g3uqBvvYpoHCyI0xTO5sKg2jEbQ77pOGnqUEo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721258437; x=1721863237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PJ4Rtgfw1crxH82KHr40tMf+xK9HrNqVoA0f8i6QWg8=;
        b=SwklsecMrPzGNIxslk//R/vg9JyWPBlsWazsBN4bHQA/4U2U5uqAwm7S8/kH9AxJMJ
         k4OnBPlKlHvtwwjxmjTP+3u/rqxKSfcd16viRyyIUPbb02cJmzDKftp07JO0X9vI85xU
         8C1DAy/9sKnWvyOIm2cofa6hTcXRITBWO9kfea9kbdI3sJgyykSPwHnmSQ78+d98/x+n
         kNs15hmpIt4vGqMQCl1lolOVaB8RS1QzoBqf3Uh7vUhIdhG+xM3NyzPXOCPk2lpkCC/x
         usI/Qzx0tOohKtycFAksEVD7nAf8ku3akf+/FuIsrrKYzMM6fk9owMzSnqEm+OS5UZuY
         cI+w==
X-Forwarded-Encrypted: i=1; AJvYcCW83D92KFwM95AqgFI0y9l4gWfa0Y/cAz/APpoGsZVrV0AADmPBWSSrnrnIO40ZRYxGNMRki0wdqalA9dXLARefGtF0BU3ZpbE=
X-Gm-Message-State: AOJu0YyYtqUBmp8VNJ10ZroDvAWGoYOGu8Eb8/uyQ2fsrxJERMeQvMNO
	/N2xKpDPgAWiieyJjxRpLxqLk9mbzY0ohzBipvOTr7fuP+JSCKK5GlSIZc49Hg==
X-Google-Smtp-Source: AGHT+IGSq9WFJ24jFHe7nZE5xQPf4XbD2c2tgVy5+rSjm5TliJ99S5ZpUoONUIfw0XUZLKuOlJXl9w==
X-Received: by 2002:a17:90b:a51:b0:2c9:7803:1cf6 with SMTP id 98e67ed59e1d1-2cb527a1155mr2419597a91.20.1721258437108;
        Wed, 17 Jul 2024 16:20:37 -0700 (PDT)
Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2a3:200:62a5:b19:9711:d3a6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cb60219d21sm510034a91.53.2024.07.17.16.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jul 2024 16:20:36 -0700 (PDT)
From: Khazhismel Kumykov <khazhy@chromium.org>
X-Google-Original-From: Khazhismel Kumykov <khazhy@google.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Khazhismel Kumykov <khazhy@google.com>
Subject: [RFC PATCH v2] dm ioctl: fix erroneous EINVAL when signaled
Date: Wed, 17 Jul 2024 16:18:33 -0700
Message-ID: <20240717231833.2090430-1-khazhy@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
In-Reply-To: <CACGdZYKbdyALADEMDV+Vg+eog+UjjgGigEpmJTSKw_64RM8rbA@mail.gmail.com>
References: <CACGdZYKbdyALADEMDV+Vg+eog+UjjgGigEpmJTSKw_64RM8rbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

do_resume when loading a new map first calls dm_suspend, which could
silently fail. When we proceeded to dm_swap_table, we would bail out
with EINVAL. Instead, attempt to restore new_map and return ERESTARTSYS
when signaled.

Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
---
 drivers/md/dm-ioctl.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

v2: don't leak new_map if we can't assign it back to hc.

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index c2c07bfa6471..0591455ad63c 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1181,8 +1181,27 @@ static int do_resume(struct dm_ioctl *param)
 			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
 		if (param->flags & DM_NOFLUSH_FLAG)
 			suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
-		if (!dm_suspended_md(md))
-			dm_suspend(md, suspend_flags);
+		if (!dm_suspended_md(md)) {
+			r = dm_suspend(md, suspend_flags);
+			if (r == -EINTR)
+				r = -ERESTARTSYS;
+			if (r) {
+				down_write(&_hash_lock);
+				hc = dm_get_mdptr(md);
+				if (!hc)
+					r = -ENXIO;
+				if (hc && !hc->new_map) {
+					hc->new_map = new_map;
+					up_write(&_hash_lock);
+				} else {
+					up_write(&_hash_lock);
+					dm_sync_table(md);
+					dm_table_destroy(new_map);
+				}
+				dm_put(md);
+				return r;
+			}
+		}
 
 		old_size = dm_get_size(md);
 		old_map = dm_swap_table(md, new_map);
-- 
2.45.2.993.g49e7a77208-goog

