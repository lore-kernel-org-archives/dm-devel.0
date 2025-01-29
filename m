Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C8EBA4A
	for <dm-devel@lists.linux.dev>; Wed, 29 Jan 2025 12:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738155548; cv=none; b=kuql72WlJgxCVsmtSIHrqApPy0TvTltedWMaeHYtWrKzVGp3cm1Ge+01F2XYBW6ZQwiauWZ8ZBRE4A3IUEyeYEtSU8r7/Fz23lGkV6hM+1LXHrE5vj45FK+8D64P6NS1mRzSg/6pzHdbRfkHRWNoTKDqOK6wNjpP7V6QyxO/Ilg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738155548; c=relaxed/simple;
	bh=D5EJlDaTq1xvcK8GXnVUJKOt0a7vKxl95DFxHvHZ/0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9+suXTb3B6sfY0ly3YniSj4C9SDsyhPqFFkZVuHJ5IVOfbfZCqLsQ9zhdDByq3R9LSGxOp44n8AyqLhLsXg4C9ZzwlEVTSBNMkpeZDIDXwPes1PXe/rkRc3Z9bLVzxEMyZrnpidHJ3x2m2t6rBre6idGIv7//vrm2nYILemMNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FlTY9oW8; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FlTY9oW8"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d4e2aa7ea9so13358942a12.2
        for <dm-devel@lists.linux.dev>; Wed, 29 Jan 2025 04:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738155545; x=1738760345; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kZ6nySZDXEYnxo9zaQ2qibAXcWCySP1ewi7gpJhtdt0=;
        b=FlTY9oW8f9/fw/13pv4LbvawdmfSalb6DrCfSj5+evcKfoAE7XcmuEzxYr0JPsJxal
         +gAt+s5H41QlmTcZG/3ek2+0sxhEWI17En1t7QLinZHVcNK9Syf8zb7mv5tYdLLVrZuD
         3ptMraDy+KIcNGvXQY6bqhqYmlQBcRuAv+3uHsOemiH06BzlMKZlsY6XGYAFrzx0x7iD
         BvRGZy1NbpTG0JvVuxhL1Ayr/Is76QvAUG+f0x1S2n2WPgyGFWWV86NJXN3+/wL2NBxQ
         Ec5xMVZXHFE+Zy5KDvWnmzZSnmlfpQEnok64Y/orkcfhgF1+fj4rGg4T7WItwifCc9VV
         PzeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738155545; x=1738760345;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kZ6nySZDXEYnxo9zaQ2qibAXcWCySP1ewi7gpJhtdt0=;
        b=W8ymInN1mbi75iHp2RwiNu53zuusYiy7IFgxNnUYtvclqQqkogH6V36kNQr5tagvfw
         m/splryd2q8uN91k0PnqcLPfFJjbrvs+SCKLMVOg/H3jTvbvU2w1C5GW0SuFpiW8tjLQ
         X4M2YOSeMWnZfkH/JFMzpafJ5HOslEYL3Q3Bwl5xvESyCzKDgmJb9/u/SARcwPtVZqny
         q0LKnsgZL/KWy0ol4xz1o/n5AKFTXnebDV3xHwopx3OWEMRcyFVa3baB5PSeY961fzde
         K5aIl+iEGruA8obeW8vOeiiru0Qv422RF0Pz2wm0J18w39CcCpvVAEdoY32i8migNxMZ
         9v2w==
X-Gm-Message-State: AOJu0YwUTwZW6Wx8P6gUsVMPqqW86miW3ivsU4pPOgyXJoH1WrcCBC3D
	/ylYXNJdcDrav0qswWOH3sLhkj/o7XndWxG3WqsUXkmFgQrfA42qi+kqIQ==
X-Gm-Gg: ASbGncu51GYb4MRWcXGLfJ080EQXzmqgLblMuGwiT4kYMIiMDsTjJXfofKxeQmYJMRw
	yYgJbEVw9gdMUG0+CkjQHOIb9f1cAT+ogct2tvU/yVBjZo2aLtxiACHRDAH34S26D3x5AnfYEiO
	5dAEQGswxiC08W50a6vbE23fION6GnP4JbTb4EnYQMWMiotxG9aIozBKHwUKOt6Vt7z45jGh7jY
	dhMctuA4m3s2vAKDGWONn8lwo80CS8QEWTpxxAXp4zeFogXbzG+HAci9xJ0eDWVgmUe/z+zp2UM
	HOftDvRVThbaN1exDv4v+g==
X-Google-Smtp-Source: AGHT+IGPjXCbKMwb8El5TVeme64FwOdzK+yLz8nbF58j4Lk9outICHyLEOinjfOzdEUPyT7nhbmTIw==
X-Received: by 2002:a05:6402:3589:b0:5dc:6c1:816c with SMTP id 4fb4d7f45d1cf-5dc5efa8ee0mr2243435a12.1.1738155544817;
        Wed, 29 Jan 2025 04:59:04 -0800 (PST)
Received: from syrah.fi.muni.cz ([2001:718:801:22c:1369:c402:50e6:7236])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc186c9115sm8537417a12.54.2025.01.29.04.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2025 04:59:04 -0800 (PST)
From: Milan Broz <gmazyland@gmail.com>
To: dm-devel@lists.linux.dev
Cc: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 2/3] dm-integrity: Document Inline mode for storing integrity data
Date: Wed, 29 Jan 2025 13:58:56 +0100
Message-ID: <20250129125857.252448-2-gmazyland@gmail.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250129125857.252448-1-gmazyland@gmail.com>
References: <20250129125857.252448-1-gmazyland@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds documentation for new 'I' mode for dm-integrity
introduced in commit
fb0987682c62 ("dm-integrity: introduce the Inline mode").

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 Documentation/admin-guide/device-mapper/dm-integrity.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
index d8a5f14d0e3c..c2e18ecc065c 100644
--- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -92,6 +92,11 @@ Target arguments:
 		allowed. This mode is useful for data recovery if the
 		device cannot be activated in any of the other standard
 		modes.
+	I - inline mode - in this mode, dm-integrity will store integrity
+		data directly in the underlying device sectors.
+		The underlying device must have an integrity profile that
+		allows storing user integrity data and provides enough
+		space for the selected integrity tag.
 
 5. the number of additional arguments
 
-- 
2.47.2

