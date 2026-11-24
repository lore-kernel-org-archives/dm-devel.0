Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795523169;
	b=3Soa0+4KWePWhfoh84cXkbAJjrrAKlK2FQGDKZ6k16aqGVVV8c+M1dy6kpQ5CnkbJF/u
	 kLxnOWC5HmG55d9vYp0Tc2AwiOhOLEkQfch/iUVhJN3mw/TFYd++zr7ZzRh32RSDC1PYQ
	 B+6C/PKcp87lgkAYFh0BiLlsUfxDdhw0gM29S7fpU6Ojuk5lNw+XvNpEgb8tUELWCqY6t
	 84akctw0LOY0GhSGu/n+OWHLCLfThYSZTen5NdUnzvfdPhDjT2O1iQ4vIyfS93pshG8wW
	 Wu0qWKxU2dOdu2/ohV37iPDK9exY/0SkxsedCmrxXlHRoxV/tarc9qXYFar31cu4tHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795523169;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nKW0ygY+ZRbJKMAuc0hDt6Xe++SkVaN6uVm3JumCZoM=;
	b=EWfGt0xvPNyah4ALpn/A81hSO/o3KFta4KwPIfCPGPOzG4DbrYbQySjU11DSCxeXWuRr
	 4ZnrDcRjDou6rmr22OcrYQLfBlhJYyjOFTzMLaGbFomvzWJwmrSxVvzu7qPjvL/aPRmCx
	 bJ0o9po934n/CFqNvQkAOcUd98eZSZCUCDQWPgiqM6Ec1nH3I1Zc73AfhlmW+/29SYQI1
	 zUluXFD4TmJYiaft4p89HTBdX0++yGz9VnyGd/WMTo1tJ0Xz8rsHMXee9kXwUQSzcThBB
	 SWDslE+GeGv3/wTiU4Y4ut2NG9nSvNj4/f5Qdf9MRt+PN6yx0eg6l72sGPZCuO+NPHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openvz.org;
	spf=pass smtp.mailfrom=openvz.org;
	dkim=pass header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=XWIDsrFZ;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC523606A692
	for <dm-devel@lists.linux.dev>; Tue, 24 Nov 2026 12:26:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC523606A692
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvz.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvz.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=XWIDsrFZ
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so29979495e9.0
        for <dm-devel@lists.linux.dev>; Tue, 24 Nov 2026 04:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz.org; s=google; t=1795523167; x=1796127967; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nKW0ygY+ZRbJKMAuc0hDt6Xe++SkVaN6uVm3JumCZoM=;
        b=XWIDsrFZ6Ijh7cSMRksWyjtOrgrju4kjLI+oNsgvPM6+NvTc/ZBbiVkONkOVt3QdmQ
         w7sqcOeUwauTbZEhRi9in1Upx0G6z5NV0BfgS8faCgSmq9jC0OCiwjSx2mANJjV/BEl/
         nvC7Nr/mVVirKnBvX3mI04CGNqxu7ib072aFYGzWhS9F60J0jcsZMjzm72LtGiPcNwn8
         P7KqdA03C9FAyqmk1Koeid8X5KpKAA/ik8dWN+B7zI11iYsIldQMoEKCM6sWYGZIYs+w
         8scQTsQEmG3+5q5TBFgEdXii+/dfrK+DQhM0zvGjudx7GErZ9kJzkCOFC7GMCq0Hd6ra
         ABTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795523167; x=1796127967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nKW0ygY+ZRbJKMAuc0hDt6Xe++SkVaN6uVm3JumCZoM=;
        b=Ek6H+T7E3ftiqzqsCbKTPTIeLwOkkPAhiHHi13wkiB8zqXzCE3TaHGPCwocvAMuM6I
         rQHLeTGnWU9/MHU6zh07aExtM5uSvx8iCThdUzUJO3lAS5HBE79rYZLgmoRhJexmFKDu
         YZig4r+lndUcX6Wvmg4pVBQjX4EAmn9Jb8IdMXabcmhzbTo8NpyI9YrGw0O2LxhnftuA
         4ARVvNXTsk4HcIqDpiwqXviuuSre1aEZD1hmNCYk2wgOTHhIPOiAsUDzKpTxV6yFZtdn
         kp65QYgUpxIVmwqJ8skn0Om36IFe/fulHt44PtjnmxEF8YsvJvXo7cyk0MqL8XjVDZjW
         2bnw==
X-Forwarded-Encrypted: i=1; AL+hErEg8OjL5ZvfMY20qz6mZZUzT2Gpgm6qOGAr7WvMvUw+bMUJ6/VMBnOG0nbSxzXTJaWa4XKPRxbnUw==@lists.linux.dev
X-Gm-Message-State: APuU4Z/e8/9q8V26bf0iMo0GjSBInKyqwPJBn5hIRfZls3qzuDtnBxq4
	7gAY+JdYtevlq8PGAPXfRQJBgFP2/RfabC1wgK1D5ePRDkd6el9NInfsFqkGee/U02U=
X-Gm-Gg: AZFdTZfaAv4hv3K1FxLY+n6ZBoncvssIdjM7wU5jHgMdNB35VpLqJ5es7cdZtjY9Fk8
	bAZLrtVXE+bBskA4U1Weo4WmipEJiN6UZVHCDa+gfPOKAQyYoVpf3wNicvA8YUCdNh+aVSuRyao
	yfCX+hiR2ptpjUhiPHy+OR+yAb97ECXkWY43ArPuAhZC0jic5GPntmUzQsUkEtaoWKooGgEZUF/
	Xesoodz2iutixTZsCAVT6+lcNeXQYj5eaItcc5Q9LNyYSfG9YQQDQnfg2q1h7OQx0/x/60h74u2
	XYqstVJQliYMA6vAovUK+McdOtsfaue7GASqTSvxgTLdxMpnSyDOyhGAWy/s8DM48kXcUS5iDGk
	AzRytEqv1gmEpgp4p7/wZVmE7R2MZwn93L7NLgc/Hfr5+doeQ0+bs2IGuLltIFtxEkPKc0rQ1je
	2el7ODeHpiybkSSXtWS/WxlkhhWEHltC6XUcMxWW0eysU1FEn30fAV5xdPrgFW5STQKCaVBIOhf
	WQZ5CMRNdCOsE8gFYiG2n+Vr9m2Qr7fhlgNVduBTB6sltd8gAK17rYPGNCwcm4TFcSf+9uYGGVL
	J2OOlJfvbq7WiNTG7l2T1AXIaZg=
X-Received: by 2002:a05:600c:1549:b0:4bb:6a2d:b440 with SMTP id 5b1f17b1804b1-4bb887e0699mr301232885e9.2.1795523167182;
        Tue, 24 Nov 2026 04:26:07 -0800 (PST)
Received: from artemis.sw.ru ([2a06:5b06:b600:300:8dcd:31dc:bf64:9564])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853ca452sm423615975e9.15.2026.11.24.04.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 04:26:06 -0800 (PST)
From: "Denis V. Lunev" <den@openvz.org>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	thornber@redhat.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	den@openvz.org
Subject: [PATCH v2 3/3] dm era: construct the target suspended
Date: Tue, 24 Nov 2026 13:26:01 +0100
Message-ID: <20261124122601.436965-4-den@openvz.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261124122601.436965-1-den@openvz.org>
References: <20261124122601.436965-1-den@openvz.org>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Denis V. Lunev <den@openvz.org>

era_preresume() resizes the era array and commits the metadata in the
thread that resumes the device, and starts the worker only once that is
done. That is safe only while the worker cannot run, and nothing makes
it so: struct era is zeroed, so era->suspended reads as running from
the moment the target is constructed, and an rpc arriving before the
resume wakes the worker alongside the resize. Both allocate from the
same space map and take the same metadata block, which corrupts it:

 device-mapper: block manager: validator mismatch (old=array vs new=index)
 device-mapper: space map common: unable to decrement block
 device-mapper: era: metadata_commit: pre commit failed

Every commit after that fails the same way, the target reports "era
Error", and the writes it tracks fail, which takes the workload's
filesystem read-only.

Userspace gets there without trying. multipathd asks every
device-mapper target appearing on the node for its status, over its own
uevent socket, to learn whether the target is a multipath map, so a
target is asked exactly while it resumes.

Mark the target suspended when it is constructed, which is the state
start_worker() already assumes it is leaving. The resize and the commit
then run with the worker held back, as they must, and a status query in
that window is reported busy rather than served beside them.

Fixes: cca2c6aebe86 ("dm era: only resize metadata in preresume")
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 drivers/md/dm-era-target.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 29b0602e7849..d40a98169b04 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1557,6 +1557,7 @@ static int era_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	spin_lock_init(&era->rpc_lock);
 	INIT_LIST_HEAD(&era->rpc_calls);
+	atomic_set(&era->suspended, 1);
 
 	ti->private = era;
 	ti->num_flush_bios = 1;
-- 
2.55.0

