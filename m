Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1321096D
	for <dm-devel@lists.linux.dev>; Wed,  6 Dec 2023 06:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="izYy211M"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6ce46470647so2252867b3a.1
        for <dm-devel@lists.linux.dev>; Tue, 05 Dec 2023 22:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701842795; x=1702447595; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p8wgNl1PchXcHI5F0qOFxbj06sbuE+5yXttvrgVz+ro=;
        b=izYy211MqX6bUpmz7F3ax2GxltffF0ZlT+vLa1IxcxkOFohbVsIbbb9mWRwBM5ObvH
         Ow4weZcgwkNpYbK/NEuHPHVI378Aay4/KM2peAHwn25l9KIJAXPBb/TjncU260+quhAt
         cdy4p74HD+yTLGe/Y6I8VKrGEIMlDA30VILBVjqQXOkDfczNzBrhVos2chUNLKxdrZXv
         5Qbbx4iOEKDbDwurzacOYiuVxTEroGtzwOOYAwT7YNPasFzyh0Sbl6eIUPge2xsJJcj+
         ft9WSlEDG0dphW3sCsXgVmJANZi07mhPxNP+KVAznQDMJgWmta6PMKLYIXAtO8siOl6J
         9VUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701842795; x=1702447595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p8wgNl1PchXcHI5F0qOFxbj06sbuE+5yXttvrgVz+ro=;
        b=uhaPmZKhc3eKaAOAQwG+fMFSgDFTckVAcYVLuDrCL/lvRu8OYbxbLpt5XP6D7J3yib
         G9U9BON0qtVJIHzqvvNiOZhMNZn5cnxf55DNWl6gbtwNu4k+T/ySVxcmPOxjKK6QYFGV
         BjTlQr/R+bHk243p1bZy8ykbd84DDGd0poryDydozMjFqW3t4PBzeEw3pXhUZ9npHpeW
         zioihovQNyLzSzKh5P2E8v0aPCfIrnuS31qrh7BAS1BzpXbxt6/r22DpfLnNIwtqMeRQ
         5FUrsxMDHIoRBqFviXu2eK+p+DIuQGVI4cRFr7OHlKyciYF7APQL7zL89WoW+rhldmVM
         YF+A==
X-Gm-Message-State: AOJu0YwzvJ/6y3Uf+wodF7lN1Wr1VwM1PhcZrUoWa54tDNO5Edj/3KkP
	lvv+GOIC4DEM4/AvG0pi7sbMMA==
X-Google-Smtp-Source: AGHT+IEdPXfNmvKvrswUKJHm+sFsPS7aPY/u0WjJJT2ny1b5k9BwlvRmtzalQC13yVeEtaaHy4KiTw==
X-Received: by 2002:a05:6a20:c19e:b0:18f:97c:8254 with SMTP id bg30-20020a056a20c19e00b0018f097c8254mr292006pzb.94.1701842794864;
        Tue, 05 Dec 2023 22:06:34 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id p12-20020a170902bd0c00b001d0c5037ed3sm2322833pls.46.2023.12.05.22.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 22:06:33 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rAl3I-004VOz-0c;
	Wed, 06 Dec 2023 17:06:31 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rAl3H-0000000BrVV-32vJ;
	Wed, 06 Dec 2023 17:06:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	linux-cachefs@redhat.com,
	dhowells@redhat.com,
	gfs2@lists.linux.dev,
	dm-devel@lists.linux.dev,
	linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] hlist-bl: add hlist_bl_fake()
Date: Wed,  6 Dec 2023 17:05:36 +1100
Message-ID: <20231206060629.2827226-8-david@fromorbit.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231206060629.2827226-1-david@fromorbit.com>
References: <20231206060629.2827226-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

in preparation for switching the VFS inode cache over the hlist_bl
lists, we nee dto be able to fake a list node that looks like it is
hased for correct operation of filesystems that don't directly use
the VFS indoe cache.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux/list_bl.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index ae1b541446c9..8ee2bf5af131 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -143,6 +143,28 @@ static inline void hlist_bl_del_init(struct hlist_bl_node *n)
 	}
 }
 
+/**
+ * hlist_bl_add_fake - create a fake list consisting of a single headless node
+ * @n: Node to make a fake list out of
+ *
+ * This makes @n appear to be its own predecessor on a headless hlist.
+ * The point of this is to allow things like hlist_bl_del() to work correctly
+ * in cases where there is no list.
+ */
+static inline void hlist_bl_add_fake(struct hlist_bl_node *n)
+{
+	n->pprev = &n->next;
+}
+
+/**
+ * hlist_fake: Is this node a fake hlist_bl?
+ * @h: Node to check for being a self-referential fake hlist.
+ */
+static inline bool hlist_bl_fake(struct hlist_bl_node *n)
+{
+	return n->pprev == &n->next;
+}
+
 static inline void hlist_bl_lock(struct hlist_bl_head *b)
 {
 	bit_spin_lock(0, (unsigned long *)b);
-- 
2.42.0

