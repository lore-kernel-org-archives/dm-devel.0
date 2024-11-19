Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855441CFEA9
	for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 16:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732032752; cv=none; b=IOfGEK3ZoqBd9HxnxnM3vrkXHWTAcdA3gZzICMC1v8dCHq0RqwiZerIFM6vLKJAliDJpLbtRG3dfkvL72OlBxDMb9UPKgOiDkzvAwOBN4Q2n08XQ9XuzTjiTrcq9SAkmxj0cO02cRexayfE470oXhl/uN9pHUW7MWFRpeCkSJ08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732032752; c=relaxed/simple;
	bh=mvtobT3QJJVAGCqCEoxngVTq1vcMx3u3nVEDyfENtvU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XmCYguUqpCMYZSNTkSv1YatdC6kwpfsEIp6t6k268zFqDv+nu/h15PYy5+8qtIMjdB7kZ5W62xBJ2Q4P7u93vn4ZeBEAPTUBGYuXiFC+DgNadQiC/OI9KPD9sD38MlBY2btB0zzPk6gVof5+RJ08KQz//iTvuzRbG7j+eA+9hyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Hgo65WqM; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Hgo65WqM"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-53d9ff8f1e4so3984817e87.2
        for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 08:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732032748; x=1732637548; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tMqYT+fDMXMdxa5Q7pcsJq/DvKI1O03VCq+/fox3gqc=;
        b=Hgo65WqMsxkcTVSvu1TTAXrDQIfpmkyvZI+xiGeXaEMjoOzrz9+oqLp0L+PxS47b3w
         BY5ra8V/pyRuJXx5x4KfQVKWoH8n+bqmWzSF/XiReskEQU9V1rBLjaCXXOvyBOHzg3Zl
         g3yb4VnuXlV+/8EEVixpu7lz1b3WRBCtl7TsxaQ5OA+oby0KZ2maE+irK3ulLNU8YHIB
         aZm5jHRWdf5wZwLEQLdIuG2Nkv9LVjbIU9a+JRQo+p0+73qEt6cEEZnrjZlAhwOOvFIY
         piBzSNCepsCdPBzUnF2KX1EH1JTcjhUK2xKGjUoFTHn/8JEynKxUUoXuhEA9keLFRrFa
         O0kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732032748; x=1732637548;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tMqYT+fDMXMdxa5Q7pcsJq/DvKI1O03VCq+/fox3gqc=;
        b=R2QapD85wxbvaIbqU7SyLjkTUO6ZTqQrcM3AeWkKrhnjyhKSUahoyl/SUU1e8jZcFw
         GUzI+zlm+r/Ey4p5wj8dMkQl4mB1xoJz0dAXsZdT61uZUFSbrGZLTF9+qPn03dK5ae3t
         Q3JVcnM9Ub097Y1Zgd+5+vViqDGdBKPj/s0rInJE9FWY1mvw5zRYETwmgCG81uhyetMa
         gQLdjeQRtM/BNJ7bABVCYAsBnuNyxVRG6wpdVW8UP9F9klHhqsT4iVsgQz+RwHSmqRPl
         EKduhKbl6/0WjygRXwlHcmtYRENZmjeqw1j6tgW/c0M3nYpUoUVeRfBD47k/9MKDVmL/
         zrXQ==
X-Gm-Message-State: AOJu0YzAaXjqHjPL7q8zjJSNpaqnqcZtqS28IF2+Ugr2KBHoqa1OeIRA
	GsI79fHCdrMITtkwO67CqvM4LpoVSSQW3If8RiAY4/SeS86co0aNYqbv4XPcOwM=
X-Google-Smtp-Source: AGHT+IFOhXuM4rbOnZDfBNxrNr2/PhItmGbgUDKyRanExz1E3ZFPH8uAD3kpQmlDJ+z/1k6vz8YNyw==
X-Received: by 2002:a05:6512:3ca0:b0:539:8bc6:694a with SMTP id 2adb3069b0e04-53dab2b97b8mr8527758e87.43.1732032748217;
        Tue, 19 Nov 2024 08:12:28 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-432dab72141sm197054185e9.1.2024.11.19.08.12.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 08:12:27 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 0/1]  multipath-tools: fixes for systemd watchdog
Date: Tue, 19 Nov 2024 17:12:17 +0100
Message-ID: <20241119161218.708117-1-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After Ben Marzinski's feedback to v1 of this series, reworked the
watchdog logic completely, and moved it in to multipathd.
The watchdog interval is now independent of the checker interval.
systemd's watchdog enablement logic is correctly followed, and
better fallbacks are used in case of unreasonable settings in the
unit file.

Changes v2->v3 (suggested by Ben Marzinski)
- Use time stamp in watchdog_tick
- Use unsigned long long in get_watchdog_interval

Changes v1->v2 (suggested by Ben Marzinski)
- Complete rewrite.

Martin Wilck (1):
  multipathd: move systemd watchdog handling into daemon

 libmultipath/config.c | 25 ----------------
 libmultipath/config.h |  1 -
 multipathd/main.c     | 70 ++++++++++++++++++++++++++++++++++---------
 3 files changed, 56 insertions(+), 40 deletions(-)

-- 
2.47.0

