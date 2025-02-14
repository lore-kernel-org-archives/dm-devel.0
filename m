Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E4A1DC198
	for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 22:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739571041; cv=none; b=rqfqTArdxLCXYeJnbPy/d50nmN3eMptiq70bavpJpubc1vG+ENzse03moMYphR67FMA2Z6KKB6md5KxDwcymFSp5Q4ksAWMnQhElrblgwyxns700hcknjMsLdPikMwvHqj+ggkR1Hs5+OX9EfOqDzSIiPc6tNqePb/qdPjWs62w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739571041; c=relaxed/simple;
	bh=BiJT/zyMDu3V0a9lldikzsslrZ6N5FEnN4xq+yQ5HfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8IBo4IaIurnaEx9BvyhN/7uX2k7t9WJrKqvxBtQpaR58ogxOlnc66Slx6+5dIrvfm5IoMdpvCq6SXVSZFrM36ibk+bgrlL6s3cdOE44QZp4deJgW+W2BqFCz4noU/VL0sFV5PemWrMptIjHr0JBq9PzAqvtmw5iOx0CPhrPYHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=R08ukjsA; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="R08ukjsA"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5dedae49c63so2824059a12.0
        for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 14:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739571037; x=1740175837; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y9PcQyACG+DZ1jHwA/dnCv9ZwRSyMPSmU5F9DkIUBpI=;
        b=R08ukjsA1gGQsT73/pWNnuo4NI/wvSLbuoljlNd3F9cp4j+u12dgm0SF5myacLapl8
         Kr5CowNWMDczHb97yVYW5MxeM5a/pM8Jb4xfDYWG0H7yqbC2g2sPxIFCgs1PJhhJNo4X
         RXPzK2Lgn7DnKNNzp0k/0fGWei8IntVON2EOh2fCyuNXwjMwy2fKgcIV0RYV1wpeBu/O
         PQx3yQ3/W96tAQJ7UsyfhyLnNOpIGDIae60rNkvsAlWwx81MwNcUrAxqESo5sm1Bsd+r
         GFdqWhDhrjHtThjef/paG9tjP/siydIh3gR3TqJ147Z2x0hGoguf8K4W3keGPqSnWQM1
         CA3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739571037; x=1740175837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y9PcQyACG+DZ1jHwA/dnCv9ZwRSyMPSmU5F9DkIUBpI=;
        b=qzQCzGx8+DDep6IdtO2K+N6n4HM7iiaV/H4TsRP9ISSy3TaWbtCxd5sKXvxLVIvQ9p
         cjpn2AbKT8qE4jrbF6XUbQlIH/Hra0ccEAfbpBkuUVFkJfptcw19bkzeTV2Uv96NhjAE
         baTN3WF82UgtWX4X96TLbqlrso4+oAkml52m1cAFjp4ijNHXOSfylN7H/OwTLC8sdxij
         kTgiN00ODsSLzNGG2jDYaeUSS2Lj0I5UAjFSupdTJTqtc97WvGyuxCBHyUTQy3WhHsiB
         nJu/GZSFJqXf37kqMMJaCiPdAvMSsfHKmbuStL7romVXhlwQonvHIL/I+8LmUuYAkBA/
         qOSg==
X-Forwarded-Encrypted: i=1; AJvYcCWXJJaGTUMwu5hbYMIBtZCOfMCuSVBlOQUYlWIN7QKsjzlUhyrmIngZDJtmsPbxwMXtFZexvX4+jQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzzBv+hbwYKgiNBrTKjOqisRmL5mdOLcrEFmjizXsoBdGmBRhJK
	13quyVxQarXAPM+JXk7Uzs49x1QnDhmcEEBzWzAFv7AVP18hW8B4Y/JjQgDRRcg=
X-Gm-Gg: ASbGncs4e9AmRzvh9b1YdLWdxtBzJHXnCprxDQYuRAsRWvIFuoAG63DQV8ZG1WZK7a0
	mP6WYa5XCzxLW5wTBCmv2eLLNz3PdQJ8m2qgiJsc3ZAhIAeGnNsx8jAimAYSxpE/RmoNLo1f9tC
	6wG6alcQfTizD6BRNoLgU50PspgE1iDSJ88TZhPvIvRFsJB7uFMjyDEA7Gff+GPJC6D4GCd8XUl
	TyPNM+ab9c5P7jH/s0nspioy/BsT3LPvSCHPO5XNxK/fluM2dob+Gssx95tDYJ2/iy2nykHrhwx
	J/sb/DqiU413S6fjjlkhNVq0ioVtgPATiuGqYlBqnOb2c4JvAmc+iv9no6mLye4APPfOSSrilbh
	oUg==
X-Google-Smtp-Source: AGHT+IHaSPk2kFKKXBl/y2CGsWQzpoi1HB2jnhkjaTkm/j6uk7h8K5yTK2b2dUjYbXhKa7z5Vomp5Q==
X-Received: by 2002:a17:907:da4:b0:ab7:6d59:3b4c with SMTP id a640c23a62f3a-abb70aa65bcmr57355166b.21.1739571037273;
        Fri, 14 Feb 2025 14:10:37 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aba53376adcsm417678366b.95.2025.02.14.14.10.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 14:10:36 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alice Frosi <afrosi@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v3 10/10] multipathd: honor MULTIPATH_SOCKET_NAME environment variable
Date: Fri, 14 Feb 2025 23:10:11 +0100
Message-ID: <20250214221011.136762-11-mwilck@suse.com>
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

If multipathd is started via socket activation, it will obtain
sockets from systemd. The names of these sockets, and whether
the abstract and / or pathname socket is created, is configurable
in the systemd unit file.

Add support for passing a socket name via the environment, so that
it's possible to configure the socket name at runtime even without
socket activation. In this case, only this single socket will be created.
If creating the socket fails, multipathd startup will fail, too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index b41c181..3468b21 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1895,11 +1895,16 @@ uxlsnrloop (void * ap)
 {
 	long ux_sock[2] = {-1, -1};
 	int num;
+	const char *env_name = getenv("MULTIPATH_SOCKET_NAME");
 
 	pthread_cleanup_push(rcu_unregister, NULL);
 	rcu_register_thread();
 
 	num = get_systemd_sockets(ux_sock);
+	if (num < 1 && env_name != NULL) {
+		ux_sock[0] = ux_socket_listen(env_name);
+		num = 1;
+	}
 	if (num < 1) {
 		ux_sock[0] = ux_socket_listen(ABSTRACT_SOCKET);
 		ux_sock[1] = ux_socket_listen(PATHNAME_SOCKET);
-- 
2.48.1

