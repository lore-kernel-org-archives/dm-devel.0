Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9A119995E
	for <dm-devel@lists.linux.dev>; Tue,  1 Jul 2025 22:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751407784; cv=none; b=ROYAsPXG7loRNMJjeRkAs7xMCP+f6E4eLsTpM++TXPaU5OUdfEqlMAqubyYU8ib0iXq0wmJE0T5ju0gG0cicXYc3sgEQRLRAep1fwZ/DPGHV18thaIl3yAIDGP5pp2QJhWoT8c3E1x/JBadtsAkO2G43v2tCAon+urGiKQNR3PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751407784; c=relaxed/simple;
	bh=U1USNfKvgEhtIje+N5xRLwQdxL6+tXRbZk+VGz5ahpw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e1RaExm7Uw+y6Iwmg7Wlqj/BJQroPUcNLtvi2R9Wf9HHkCbSdlRl7+Kwy7ebEKeEUZ9GtgFtcRjEkSCOZh2ibYj32H9ih5ialvsCUNUAglvRurihIml+7yL8YpOnFkOZELDuMjO8LvKIypLa5z6uSRRmvXawhx5IpEh9oG6nr2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QNtkSEmR; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QNtkSEmR"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-450cf214200so31337665e9.1
        for <dm-devel@lists.linux.dev>; Tue, 01 Jul 2025 15:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1751407780; x=1752012580; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D1R1rZ5ek5rV24vJbYuVNHdf9wjHT0qCcvlDPbnz78M=;
        b=QNtkSEmRCm7+liZBSxltQfUyB8foYQHBraBHhEIT7HllDLqCx48RdQnsE3Xiu1LiZr
         eInhF3rbUtjmoU9FefvIfEgYUtwK8TcB9/91hVbpPBVGpUL1BgkX5e4jxOkNLuVsi3Dw
         I5Szxw7JIk3c5pP454/tUIJtGEZYhi5355U4B/x5N5K7OUIJ2wbcoADZ0UYvcTAqxg2w
         AMUIlNuFx0hP2G05F5i4t+i/T6+QuOJesv1xL+upYqU3l6Cw4zQm+Z6gWEgLdxcwqSzU
         Uka17gWCzW71MaKQXUNY/YxgQ3GLi+/kWy1p6Fa6rsEKzGuEiTWtN1XzuogdPwJsYtU0
         VqDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751407780; x=1752012580;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D1R1rZ5ek5rV24vJbYuVNHdf9wjHT0qCcvlDPbnz78M=;
        b=oWdlRd1vfcOn0drYhG4JxflInazKkQmvBTdNFZ12tH/d0xXKy7USY0CWGtKX44/AP5
         uuT35BAZ90EL4AnS7J9cKLHiBZqcAH+pAMDP8rx7N1vYcnePdlfTNP3a7M5AGoJwZ07z
         oGS9ZO5O6U2nf1zgnscKyaUpFYdLLg1JNJT3cPESljCTvi1HWAAD8HrwZA2rvDdj1wnI
         1f8rOpEpTA9ALHIsEBnJ8/fyce/4a78kAcTsxBnMLpNIX+dT/etpaGNt42lgHZOdGH77
         YjNtk0Jg8/XQ6/rAyRqWYq/gPmbLOjDS/tTNlONnMeGQNYCIbEHOrpRu0SKrMTVsgI4/
         ofZw==
X-Gm-Message-State: AOJu0YzEo+lqorr+gZs41FIWw6yy9g3Pt6ZTJlwC8AqfoSu8WgB1uUR9
	McdnC55XVM4jRCHc1/L7hhcB/vyySO5SJc90xX0nAeoEX1A5Vj2e4v/aAOBzFQBpnb8=
X-Gm-Gg: ASbGnct+HbvN2tm8UmB9z69mGX5HJmxfXwsBlzDfmMJ+NFE6Dn7UsktOSbtJfKqvh1o
	w57UgDymPqwS0Ks7JbxQX89L8hc65YpY6+GQMl1ygYpOA6ObgUw0ZCd/mCzpZTMyMbnVEzUeBqy
	4ki2Xc8MsgKuCrHKWVygc6HJz/JvUO9+HetQXPhjbzTkukDNdZo4CclauLc5/mx3geyaxkMA2G/
	RbVWWsT/rEnh+Sxei5Etp6v4e4lEr+Ic6HGgRMuAYhXlWr7uo7jobjpt9ZhInfqyN51T/B37ae4
	ps1gue3CyDnEkNDcYeEi/1dI/y3PyjjoKjN4H10FoRA+QsHrMZvpi/JKhTxy5cc6i6rc0Rxut2n
	X4jtEs49MHmAHzBh/DQQs+w2za5gmt+NMQxHrpnecGNdBX1IZaA==
X-Google-Smtp-Source: AGHT+IFvA7aTnPHd3wSvAqCL77JLXlMhTx23ZXKp4zhx+YtULvow7f56lGEiCRUakt/f5+oUbxtshA==
X-Received: by 2002:a05:6000:4810:b0:3a6:d2ae:830 with SMTP id ffacd0b85a97d-3b2013eea74mr108987f8f.56.1751407780352;
        Tue, 01 Jul 2025 15:09:40 -0700 (PDT)
Received: from localhost (p200300de3732f6008099d8a4e4f5c830.dip0.t-ipconnect.de. [2003:de:3732:f600:8099:d8a4:e4f5:c830])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a88c7fa5easm14063011f8f.26.2025.07.01.15.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 15:09:40 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH] multipathd: cli_reinstate(): avoid reinstated paths being failed again
Date: Wed,  2 Jul 2025 00:09:33 +0200
Message-ID: <20250701220933.156676-1-mwilck@suse.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After manually failing some paths and then reinstating them, the
following pattern of events has been observed:

[1535664.790944] localhost multipathd[26335]: mpathc: reinstate path 8:48 (operator)
[1535664.791422] localhost multipathd[26335]: mpathc: devmap event #4
[1535664.793140] localhost kernel: device-mapper: multipath: 254:6: Reinstating path 8:48.
[1535665.219024] localhost multipathd[26335]: mpathc: reload [0 125829120 multipath 1 queue_if_no_path 1 alua 2 1 queue-length 0 2 1 8:144 1 8:240 1 queue-length 0 2 1 8:48 1 65:80 1]
[1535665.290268] localhost multipathd[26335]: sync_map_state: failing sdd state 2 dmstate 2
[1535665.292442] localhost kernel: device-mapper: multipath: 254:6: Failing path 8:48.
[1535669.291320] localhost multipathd[26335]: sdd: tur state = up
[1535669.291531] localhost multipathd[26335]: mpathc: sdd - tur checker reports path is up
[1535669.291531] localhost multipathd[26335]: 8:48: reinstated

We see that sdd (8:48) is first reinstated, then failed again during
the reload operation, and finally reinstated in the checker.

This happens because multipathd doesn't update the internal path state when it
calls dm_reinstate_path(). If sync_map_state() is called, it will see the path
in PATH_DOWN state and fail the path again.

Fix it by setting pp->state to PATH_UNCHECKED.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli_handlers.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 4bcc82a..fcb8775 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1115,6 +1115,18 @@ cli_reinstate(void * v, struct strbuf *reply, void * data)
 		pp->mpp->alias, pp->dev_t);
 
 	checker_enable(&pp->checker);
+
+	/*
+	 * A path previously failed by the operator will be in PATH_DOWN state
+	 * (set by update_multipath()).
+	 * After the path has been reinstated in the kernel, and before
+	 * the checker updates the path state, we may need to reload
+	 * the map (e.g. for failback, while handling a dm event).
+	 * If the path is still in PATH_DOWN state at that time, sync_map_state()
+	 * will call dm_fail_path() again.
+	 * Avoid that by setting the state to PATH_UNCHECKED.
+	 */
+	pp->state = PATH_UNCHECKED;
 	pp->tick = 1;
 	return dm_reinstate_path(pp->mpp->alias, pp->dev_t);
 }
-- 
2.50.0

