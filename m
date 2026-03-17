Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0A22DECDF
	for <dm-devel@lists.linux.dev>; Tue, 17 Mar 2026 21:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773783188; cv=none; b=Kb1LB4WnJO59p3h1P17bAUwf7DWoRVhIqEpysarBuj/ekVhAmf9f33wFxsSsz4bKI0nCNDAC8KDQ7BQQhO1L+JT0i0kF5oSRv0tUyDyj3xNEAAUZ5avc4eCMg1RkcWwP5qE4+oWw4NdTty6BjfGwWnT/VJULVO/nygzvdsVYn0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773783188; c=relaxed/simple;
	bh=YHbHT9AJemHssuLOo73VnL6wbjXVR6hqjg5+7PWPXsc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GPn9f+ftjanoikwLypsCCIHYRcR3WtNjJxl3SJRqFjygmy/reCc24uc88j413apAv5p1UE/90KojudfnWIaSOQvqynH/faW16buQOYWlQ7kjfJoKIYBtJ9OZxT+5D+5H9ptEtsCg6gIbeApsRbQ3KCSJgdZVlYx7CD/85XaI7eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BHqpOZgY; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BHqpOZgY"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4856cd3f1ffso717895e9.3
        for <dm-devel@lists.linux.dev>; Tue, 17 Mar 2026 14:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773783184; x=1774387984; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9k1Q78vvWMlaqGXjHpQUyuVWvxrimwsZXLbDTbmHPWc=;
        b=BHqpOZgYh/+0p1gPVk9wd25Z+nqP+yn5N3TKYy5EMLgvVLVu1Hn4GNQ3ynZVV/GNGI
         l56hc6LIr9L+FNoPxZn11QOcKHGv5eclghVvmVIMvpk9ZvYOzifXaims2cSxllPExwg+
         k8R0sqykiIkYBRxJylXMv9PsZK2umToUinTWkGENu9PV9RBEuevNc8l/dQUaUJ9/wdjY
         nSVPftyNwNIpYz3v6B7baucs3qLOa5UZ5aclzKhXrfEWCMPGECe9q3DdUqpcnLVzBw+6
         5eFO/Cw9W86Jb34rWtWmJq9lMi9whdi4lNAqBwQtmWP05pDmBr3VgeOxCsoPAaidc1gf
         mlRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773783184; x=1774387984;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9k1Q78vvWMlaqGXjHpQUyuVWvxrimwsZXLbDTbmHPWc=;
        b=QcNJCuXTnPqMdTejyfgsinAhwXmEXVlnEO/9CNK4Rhw4zvY36PhOfPXa6J+1I09rG3
         vR8n2YT9M3k4TtGhqn7iDZzA2B8J6CNupbvQkTYw1lJi5foYF2LQ+GO9YemagTZDY75g
         nAA04pGvRac7966MomDUHlHge/rtBiu9N8zoJp0ACN/sJksq5t529j+Tz9m3JsLO+Tp6
         BG2HWRPaBxn6Kv6uWG+LY+OG1rl7mkpB/obTY7ffZ4miAKkBHYB19U94DUvhgo2mkims
         CuDh5/SYoOXgyEAArYOmALblc173EwrHVzvebb3756WNp/CyIwx7yM5qdc3C5hzTF3Xn
         Gppg==
X-Forwarded-Encrypted: i=1; AJvYcCVumfm1vJb0hD3vI3EDQMNsXwub0osTc3SH2Y9r3d/+57vSmnQ4UaAacbzH1lq+f33G5cucU6u4yQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyDNuthyOmjv3DM+ACKn9z+tDIdfVPw6ar7EBMcvWxzGVuwlWQM
	jhQzdtCXU389LVNg+FnxVkDcQadn0EeQzNedMmT0zHqeH4gCjXnnrzWf
X-Gm-Gg: ATEYQzyU+Lh5WUy+h150Oa6NhOtvMQLk9z1DUkE9hBPc+DS3qEHALSX3VQY9xiyB7YE
	b2RbsaUNhUP6DKVmpAH9Ywj2HXnqBg8aOyU8+HGovmPOw/q7WwmK2eGHsx5ySCchLhkNk4dW64z
	MZ7taLR9F3/CNzu9K6HKWLCAkXyoyHMqPbcZ78f9hFNBZn7TwfLAWXFiUzmcT5B6Op2iuz1gBSt
	p4NdUamgrJJOlKFzeUX1UTRUg/HSMfbCi9bEE0C8RdDqOIFHWq28E7I2JQwyuQdlqMLF7Ktw1tF
	8AYOhYI5nhe2dB3WXgojkZhp4gleCPQfU+sEdZ8KxX+UGpyig7m6ZKlrtttA8e1+ORlekNotXe0
	lfceGW74W8dgpLkXL+3fzBKjo31rd86/Mg0WPJtC0Blbmgg0yy34k+AjTKXgxjtZhpXr2UWw3gG
	Lfd0vfoKpaskZbJ93OfdNfUA/0rLo9CPDrGA4=
X-Received: by 2002:a05:600c:3107:b0:47f:f952:d207 with SMTP id 5b1f17b1804b1-486f4448679mr18144485e9.19.1773783183884;
        Tue, 17 Mar 2026 14:33:03 -0700 (PDT)
Received: from LT2202712.home ([2a01:cb14:322:b900:b58d:d83a:3509:7c0a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f4b9beb0sm5120755e9.8.2026.03.17.14.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 14:33:03 -0700 (PDT)
From: Guillaume Gonnet <ggonnet.linux@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Peter Korsgaard <peter@korsgaard.com>
Cc: dm-devel@schwermer.no,
	chanho.min@lge.com,
	jaeyuel.im@lge.com,
	Guillaume Gonnet <ggonnet.linux@gmail.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dm init: ensure device probing has finished in dm-mod.waitfor=
Date: Tue, 17 Mar 2026 22:32:28 +0100
Message-Id: <20260317213229.18371-1-ggonnet.linux@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The early_lookup_bdev() function returns successfully when the disk
device is present but not necessarily its partitions. In this situation,
dm_early_create() fails as the partition block device does not exist
yet.

In my case, this phenomenon occurs quite often because the device is
an SD card with slow reading times, on which kernel takes time to
enumerate available partitions.

Fortunately, the underlying device is back to "probing" state while
enumerating partitions. Waiting for all probing to end is enough to fix
this issue.

That's also the reason why this problem never occurs with rootwait=
parameter: the while loop inside wait_for_root() explicitly waits for
probing to be done and then the function calls async_synchronize_full().
These lines were omitted in 035641b, even though the commit says it's
based on the rootwait logic...

Anyway, calling wait_for_device_probe() after our while loop does the
job (it both waits for probing and calls async_synchronize_full).

Fixes: 035641b01e72 ("dm init: add dm-mod.waitfor to wait for asynchronously probed block devices")
Signed-off-by: Guillaume Gonnet <ggonnet.linux@gmail.com>
---

Hello,

This patch is my attempt to fix the dm-mod.waitfor= issue. I had this
fix for quite a while now, but I've never made the effort to contribute
until recently.

Some have tried to fix it this issue in the past but without finding
its real root cause (ie. not waiting for device probe to end).

Here are the links to those patches, for reference:
https://lore.kernel.org/all/b5c5cd56-b9dd-4368-a8e1-b9e0a07b79b4@schwermer.no/
https://lore.kernel.org/all/20250410080056.43247-1-chanho.min@lge.com/
https://lore.kernel.org/dm-devel/20251211073426.123026-1-jaeyuel.im@lge.com/

 drivers/md/dm-init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index 7403823384c5..c1bacba92c65 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -303,8 +303,10 @@ static int __init dm_init_init(void)
 		}
 	}
 
-	if (waitfor[0])
+	if (waitfor[0]) {
+		wait_for_device_probe();
 		DMINFO("all devices available");
+	}
 
 	list_for_each_entry(dev, &devices, list) {
 		if (dm_early_create(&dev->dmi, dev->table,
-- 
2.43.0

