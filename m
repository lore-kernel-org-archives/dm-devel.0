Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6C41FC0EF
	for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 22:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739571030; cv=none; b=VqFMdRIvVzLOEGUtkjc/92bGTQVVf9t2J5USIbg8hI8h0wJqwo0PPHLAfkJGqwdr02JsnbBUEsOMx5RGGRLOW1LFDJc0xO1JHvkFv/0IuBpaQWm/7Mb6Lt2XYspTzoZxV4il9XjS8yIU1U+ZSwPWJ7EwuTOtjriRHUrdCtiq5JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739571030; c=relaxed/simple;
	bh=bm9Kzd16pC2B9V7BvdDWRHLEPCLhUOf4OZrbihI+ZFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPqwEGveeS+tZZdUyVBsNEXy5KvHn7K/vdovzly0KgNQiynrPqVVdQMbEnF1k6ZZB4WoUD39dj3krJPkkwARzWQ7fDKyJHXMuvYIvWQ9BReHfBOL4uBo/rZqwbRM9Ni6ZLr30920gI2IpPk/t9ZIIquu0voh+nDi34NUl73pOA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XAW0zR8/; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XAW0zR8/"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ab7f2b3d563so449445766b.1
        for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 14:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739571026; x=1740175826; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PQoaQcQuNqZP44VAQcbs31kOA1Z5W8AtyFETAYOlwpo=;
        b=XAW0zR8/7TIvIhzLN1Ynle9w5sbH4BMX2JawQ4jUAbnY8TgG9O+xfx9yCIPbGRQgd1
         FQ9BIU5aPiJJPo1Bg7ukc3iedlgTAbxjy/OcivlCXoRvYmCVBnTkJLjmGPK9ONNJlSHE
         BOydnxk/jc7Ynq3AK0GSGFIoj2HR/1L4SmUuwCANk4IKW5LUZgofX1Bl9FT0Iq7J4qeU
         +nS4PNWzXQAd45ynEHDZGFKE6vUGjenJ58SiEVIhV1XJ0Zd01uS1E6HIbZahytrHLeG5
         Dc3t4KaApRz7aqbZSZxXMBJuxcppC4foyNcmHfeURk/Vr5SjazVj75Cd1zZheVfk7eq4
         LXdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739571026; x=1740175826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PQoaQcQuNqZP44VAQcbs31kOA1Z5W8AtyFETAYOlwpo=;
        b=l0mSM3u20ogCVslT8X21vrmbno5ond5oN1HEgySuknmbfxFe1KJ1Ym7q8s4eYOLZ+e
         XofgTSxkBHAJkgyvjF9QBIJiQzUuHXnm5UFIfcIO//iiBQpUtCYSS5gF7jpaKB3Y0LBz
         BcaUV2i896mIcnN1/s5pIMadxDyxenQleaSnBwvHgfdug31uFtxFA1YJ9zAPZcaQTZks
         KDVamp5E4fTYU7JMK1PGbKtwXvICrmzRoQqD7/ySaibYCpOyDhlxnoiL53q4NTvkKJxk
         l9XIIMnf8T1nVspqjkC+6JodGALZMqoHM9d66OrcfWB4K7xZ4D3/yeRp1pvXUn+QXPiq
         E6sg==
X-Forwarded-Encrypted: i=1; AJvYcCWAJozEszuXzR/jFYK7zsCRVJrYr2bmGVQ4RNChjb/XgDZh3W2RXdB5qbtoxP9orOng7ICd4Kd/BA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwceK/yuS916nLUtnxRlJdyy+3r/aO/PZSLmse6r+9PUdatJZjI
	FNYAfNxgwdLKTqSgBlGEHCxq3Wt1NWH/CGmOSn5C/FW1ZwLuk6sTxP4kTamRg9A=
X-Gm-Gg: ASbGncuvpeJKaodYeqBHAC4O060sx268wIPgBrFW/q1dWa/YUXi6XEeO8+VslzYw/O8
	ClzTvZI5Z/bzcbvwXd2KTqGxPgTtnpvPwjmmXlfbMeeIZ2RN+v9Hn0ImCpIUUJtjF+90yyiPCGd
	33Ssje1JYNu18SuSxkKKnRfPbvWbfaw5r+YA1g90VPaGo79qxKzKdcHu4OCcfJeMs1VZDfTmF+p
	5EE6CPuUh3th8/yXd9oxTEJL2F1PHcWnCNEe15vojL2SZzD946UXWxyOGBI7lh5skBHyQPshieZ
	RGQXlU+Rilc+RaOyGYfpKwjdqIACMpBq7pri2jkXfG0tbLLi7kqDekDyf2OAejR7UMyoftFWnI3
	nkw==
X-Google-Smtp-Source: AGHT+IE8mMkukwxvc+2R8qXEkziHchW5ziEoJIew594Jfi61vo/Dx5K4hzMNP4EHQkgf5TIieRrCTw==
X-Received: by 2002:a17:907:1b23:b0:aab:c35e:509b with SMTP id a640c23a62f3a-abb70e435abmr83310566b.55.1739571026338;
        Fri, 14 Feb 2025 14:10:26 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aba532594a0sm423089566b.68.2025.02.14.14.10.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 14:10:25 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alice Frosi <afrosi@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v3 03/10] libmpathutil: add support for Unix pathname sockets
Date: Fri, 14 Feb 2025 23:10:04 +0100
Message-ID: <20250214221011.136762-4-mwilck@suse.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250214221011.136762-1-mwilck@suse.com>
References: <20250214221011.136762-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pathname sockets need to be world read/writable in order to allow regular
users to read information from multipathd. Our SO_PEERCRED permission check
will make sure that they can't make configuration changes. Also, SO_REUSEADDR
doesn't work for pathname sockets as it does for abstract Unix sockets. A
possibly pre-existing socket file must be removed before trying to recreate it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/uxsock.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/libmpathutil/uxsock.c b/libmpathutil/uxsock.c
index 12c4608..889d7a1 100644
--- a/libmpathutil/uxsock.c
+++ b/libmpathutil/uxsock.c
@@ -62,6 +62,11 @@ int ux_socket_listen(const char *name)
 		return fd;
 	}
 #endif
+
+	/* This is after the PID check, so unlinking should be fine */
+	if (name[0] != '@' && unlink(name) == -1 && errno != ENOENT)
+		condlog(1, "Failed to unlink %s", name);
+
 	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
 	if (fd == -1) {
 		condlog(3, "Couldn't create ux_socket, error %d", errno);
@@ -75,6 +80,14 @@ int ux_socket_listen(const char *name)
 		return -1;
 	}
 
+	/*
+	 * Socket needs to have rw permissions for everone.
+	 * SO_PEERCRED makes sure that only root can modify things.
+	 */
+	if (name[0] != '@' &&
+	    chmod(name, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH) == -1)
+		condlog(3, "failed to set permissions on %s: %s", name, strerror(errno));
+
 	if (listen(fd, 10) == -1) {
 		condlog(3, "Couldn't listen to ux_socket, error %d", errno);
 		close(fd);
-- 
2.48.1

