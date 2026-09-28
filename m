Received: from mail-dy2-f41.google.com (mail-dy2-f41.google.com [74.125.229.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0734F30F8
	for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790614527; cv=none; b=PjVNccumtzd6Z9HftnnTLvgs7Gjb+sXJ1K6ooG11YIlrZraDnPIW2IbAVDc67yRP8Wix3kVVKBkdZY+z7q43MGvkUNzXJcekqU0Y6dvIdbPR93NPei0/jrzbTYfwZ+DJ3f7+cw/fLFXwt+0oC4mcEpCTtoEwUabdNbI/kEvo6i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790614527; c=relaxed/simple;
	bh=VYDjuJd9uNXcpsiiqWB2rtTtzhR4cnGTjIWWOPdfhJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K10xgjXIm6mefUTUV5BgBNnkpJe7VT4QWBmpHDuMmiTIiqDwS2qk90zf5tTjAElMphSLt4RhO7/0ksikrp5tgvTKxUtp1lQd8UoTx2oiMS7cyZDwopkCPY+j//x+eR61urUzfU10YOlMgj3dZ2JWNtQ1IcJXFjgqjOZu7sC55OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=bpdLgGDX; arc=none smtp.client-ip=74.125.229.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="bpdLgGDX"
Received: by mail-dy2-f41.google.com with SMTP id 5a478bee46e88-346c612c7a8so1080904eec.1
        for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 09:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1790614524; x=1791219324; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3UOyJ+mnAyH50DbBN9IC32fulAIYODTQx3gDJkez0os=;
        b=bpdLgGDXAIT39RcSDmAZzyVlB37d+QlceRWTSHsm1lOa6FK6rBqTSjkRXn6kWbOHJp
         2d9OOkrPGIV7hCgi9cPoyr6HhIhJ8WdM626g09MriGVUzdJjQBDVQdPf7z1Pxu+2Z4US
         MTxqA4oHD72ws37vC69Zf9XyIUDRZsnzzJbHwzFa/dLVB6hFh1QlZi+VNJ6/nQClTLHE
         HzSGwEDlOV5wth1719GoIpGLoM1t/09sjFM77Yvi42yN6ucOAocAbIFPTdrofoFzXhMu
         vloxPtNZis/aWXr2eFgz3h7vzv3xm/JfPW72ogCn06ZXef8Rn9dXN1tEYMpM16MQQmL3
         jFuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790614524; x=1791219324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3UOyJ+mnAyH50DbBN9IC32fulAIYODTQx3gDJkez0os=;
        b=ciQVqQOqhm9/CEnUUH3TYC8d4bIqbd7nOX36fyjNrNu/L0y6h+lw7oy0FFtO6R0Ud1
         7V2dFwDarwaMTqYhKVNXz/fO3Iy0sjZw9WJo2fufAEpY/+qf1eF0mQYl9EwFHStyAMWJ
         Z8uSOCUkHcFr9VH+Xx9uru7oBefTV5yxA15Ea+HzRdQZ8LdaErGPFHYkxvB4V3dnvhDe
         S+fCrrz/uSOFbvFTTyzMX4WBJjROrkI8J5324/X36/li0Z9nGoixEibNkfV8iCW1UMOi
         ErtIMfbHaluwwydZr7wm62RxcwQttjsCMVxBtrTeaf/WB61Gs3CFmpO930iPpCb4Bu5l
         7Qbw==
X-Gm-Message-State: AFuF++kJLE68Xkq/bHNSBfgAcJ6Vp/txvAivsSdYNMTlyUfPv9EnfqRc
	Soercbg9VRHNxu7fGCZHrErjusnMnsmAvPUlmqU5humUsTvAdgBVdF0+nSpCiVjgcudljdvYlGC
	YUTeEmTtVBQS7quEWe6Rh7fZYcICMNxRHtxyi0zLBFEMyT74sdPG+6KulHM3hK9DESTDIwH8BYg
	zIpqq453onNPw2G3dAJ0REYfXsSJgDHr1G3elqo60hSk1mMXY=
X-Gm-Gg: AYBFou3jWKjbwBUIec7JH9f63pXEr/+4kv8Os2jFuULdqFfk29uWYxx1lTdn7rlOkC5
	YUtUDa+d5U0LWMEumgNK6yQhMGQQC0olfApbArMWO5qKGH0mLyWElDJreRAIxw5bCCnmNnCw8zx
	IFP0b1qEDH3hsbzzJwUkxyN8JfzUcrUPWEXajM2ovnn6Q5Gi/m/Hk8CTcBIumeYtiZwNsz38Bgz
	UNeJho5Gn5smiSZMe+ThlhLwkJo+0Zlic7wBRbnxulzAd3tGJI8NfHB9td+getgb0WlgubcXKrC
	eyz0EFNwHYh2H9IXmqLGlLr2WvBEzzXMdgP1MhT78rhKR/YqR7miquwCaNcbCAw7rGFprQSRekD
	pOOIRqjTH4I1hEPSqiRNKBPEg6azqEtaqX8/DVjsSzcKjhX+Ru62AE88/lOusiMeF9KTX3gwbFl
	UrdmRmom933/6oCROfVvpDUTqfkNkR8YvbG3lYjicoToyhFbYdJOkxTmVTvmRQkK9JDbiW7XHuB
	oIpGIFTkILm+LqMcOkONXfBxZ/2AnVsUWkAVlCfqr1aHIuAEXxIIWFbPUfCnk2YM/ABuuc3DRyv
	+fIXT3z1fBUtozCcb5f8dxZE3iArJdRM2cvuWTtBk0GCjfzhkSuKxKJLk4F2tjBCiIOzKA==
X-Received: by 2002:a05:701b:231b:b0:14a:5284:1bf7 with SMTP id a92af1059eb24-14a52841df9mr2450096c88.14.1790614523143;
        Mon, 28 Sep 2026 09:55:23 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.79])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145ac67c505sm25537557c88.5.2026.09.28.09.55.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Sep 2026 09:55:21 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Brian Bunker <brian@purestorage.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Simon Dodsley <simon@purestorage.com>
Subject: [PATCH 1/1] multipath: resolve map paths before delegating -f to multipathd
Date: Mon, 28 Sep 2026 09:54:43 -0700
Message-ID: <27189ec36e897519735f76a26833e39b0f4557bc.1790610404.git.brian@purestorage.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790610404.git.brian@purestorage.com>
References: <cover.1790610404.git.brian@purestorage.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since 0.9.8, "multipath -f" fails with "device not found" when it is
given a path to a map, such as /dev/mapper/<alias> or
/dev/disk/by-id/dm-uuid-mpath-<WWID>, and multipathd is running.

get_dev_type() accepts such a path as DEV_DEVMAP, because it stat()s
to a device-mapper block device, and delegate_to_multipathd() sends
it unchanged as "del map <path>". cli_del_map() only strips a leading
"/dev/", and find_mp_by_str() only matches an alias, a WWID or a dm-N
name, so the map is not found. Before commit a4dbdcec, cli_del_map()
looked the argument up with dm_get_major_minor(), which accepted any
path to the device. And before commit 8c0c12ef, a failed delegation
fell back to a local flush, which also resolves paths.

This breaks callers that remove maps by path. OpenStack os-brick's
Fibre Channel connector flushes /dev/disk/by-id/dm-uuid-mpath-<WWID>
on every volume detach, so detach works on RHEL 9 (0.8.7 based) and
fails on RHEL 10 (0.9.9 based).

If the -f argument is a path, resolve it to the map name with
dm_mapname() before delegating. The local flush, used when multipathd
is not running, gets the same name. Arguments that are valid map
names are passed through unchanged.

Fixes: a4dbdcec ("multipathd: simplify cli_del_map()")
Reported-by: Simon Dodsley <simon@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 multipath/main.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/multipath/main.c b/multipath/main.c
index f20d701c..5068a659 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -729,6 +729,30 @@ get_dev_type(char *dev) {
 	return DEV_NONE;
 }
 
+/*
+ * multipathd resolves "del map $map" arguments by alias, WWID or dm-N
+ * name, not by device path. If a map was passed as a path, e.g.
+ * /dev/mapper/$alias or /dev/disk/by-id/dm-uuid-mpath-$WWID, replace it
+ * with the map name.
+ */
+static void
+resolve_devmap_path(char *dev)
+{
+	struct stat buf;
+	char __attribute__((cleanup(cleanup_charp))) *name = NULL;
+
+	if (valid_alias(dev) || stat(dev, &buf) != 0 ||
+	    !S_ISBLK(buf.st_mode))
+		return;
+
+	name = dm_mapname(major(buf.st_rdev), minor(buf.st_rdev));
+	if (!name)
+		return;
+
+	condlog(3, "%s: using map name %s", dev, name);
+	strlcpy(dev, name, FILE_NAME_SIZE);
+}
+
 /*
  * Some multipath commands are dangerous to run while multipathd is running.
  * For example, "multipath -r" may apply a modified configuration to the kernel,
@@ -1027,6 +1051,8 @@ main (int argc, char *argv[])
 		condlog(0, "the -f option requires a map name to remove");
 		goto out;
 	}
+	if (cmd == CMD_FLUSH_ONE)
+		resolve_devmap_path(dev);
 
 	while (1) {
 		int ret = delegate_to_multipathd(cmd, dev, dev_type, conf);
-- 
2.55.0

