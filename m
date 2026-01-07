Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D4C338F36
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817134; cv=none; b=tEQaHWJ7gSG4fygkeOaAIgJxqgqeyBUinwnIhN4la1S1DIue590Tm8+m29ewrHfNcmfJ5nbRMuUgUKF7jWi1kGdIn5A7l8hbwhrcX2WTRTXslhm6Zon0iwSjXrJmq2ykqkhZvmsALAUdL/scViVOM0uXiXhR6efe7JRxgflVbwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817134; c=relaxed/simple;
	bh=o9uBkq/+gfz/QftCHnvbINOYkESQuRw1gwCYm64CsLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLAGZWKafXdFFCpqMxAfvi9xTGO2LRxGwLFiNVbWhLsMc6uITZTCdaHlkehL5OcRvGy0xBgsJ+zpkwvLg9kldqz6R+cmQgBjd54ip7/6jUuubpucsA3/Vk4wOqSpE/fayqYUvkYPQp3GFCmCTLMVTtpYELpcfDpJ7RZTKZKgNak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TpbQ13vX; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TpbQ13vX"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b79e7112398so439234066b.3
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817127; x=1768421927; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HkQUVSsmjL7WOp5eg+Q5YR6DmNgLDpYLqJsAxThNx4o=;
        b=TpbQ13vXGeGFwAEgynn5Npva5ZIptkADcb4gpxjh+jw9FiHpwJ0pxkwkTnxFs//k6/
         gtTjJ40REiSznmySurqoNzfAyQwSCtaYnPPQf6oj3iZvgsHmG19ImoRisfo1MzWQZ5N6
         2k6rBh7BlNFwU9qRzmea4XR1+v8BxIjlfhA0InM3m6MlRvVVv4ZdCv62NQX4lmJj0K02
         lLA4wgDxLFq18RjZ6r0BTTswIf9M8vfyba5EF6dqN2d9+W2r+ChrjurdsWgxL2ZLiVos
         PqIfok3OV0/hwaqN0jA4DQQxi+/5JtfmCkhlDTQM2rBsQnWbBHJmxv6+wOlsYXDi5Jb9
         DRiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817127; x=1768421927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HkQUVSsmjL7WOp5eg+Q5YR6DmNgLDpYLqJsAxThNx4o=;
        b=HC/Cq7HAvDNJNtUX4Dp9MTUhYZXFw2omVffncDCZpCxTxxpHrz5ijeMgoJoc5pYwTh
         bEvXoQnS/oLWLyNbEZkANnmbwHDRAbCjL5xNaNMZR9pa8nQkNgzCCRcqmTvDLTEoH5mb
         g4wUkURuK4sK50Xj70wTJhrWSC6U70KZJ9JTRoCN9p60wq+etxGgXEWNDZHBwh6ch7U2
         qUblW6CrHCKdlUq3EsN3zPRkpPmM4HfE+zeBw8YrRH4niDDrtdyd7Nnnpj3OtNbREnyP
         2znRbNQum2xGHcIeE5efKH1VSsFPK74ISYs6r4TEDJwpApvoupfXuSmiP9LVXdKT5vw2
         2FcA==
X-Gm-Message-State: AOJu0YxpEuvNBUvJOBdMp98LOsBACteE8SrgI2rSzAptIHPD9Q/Vn6EV
	oZzJ7KUWcv9v57JEkipUYCLSfSUmCNwMd8RRWn4C5bPRanEo6BS7z3ZUPsIbKvGnIJkhndrsWOM
	4NfO5
X-Gm-Gg: AY/fxX79JNKkneLig99xLj5zNJO9jeEKeJMI1BPWyekSK4OVc9dkZkijiS23Nvo4AHe
	wDmdhGjMKtxpmAHcWSqkLGwMJnO44jLedwXKgWM3yvqQusNsA3J31yYPmFZTZEsrOHNwnuxWj9M
	dQAinr6KrroMEBpMb6aZ1WH32d6hpcrkkLZomtxzR+yhoy5ruR8QkAaa4iNfGiK1Ky+GtVA9EES
	J+73OFAUsG6MfAz3cXmDYKqUMt8sjj+L6EHKDHa+SWaifnoFz9ke1YdvlijBIXIHa2AbV0konyB
	nJY1BtVfm5t+Ew9vPArKtYTob5w6NrEO7XhWSXeHSdvUPjX1UmejoRYSwVsYlYM+Xfcy5qVyuaT
	+4oWye1OrAMFMDtAGq6WHzl4Nfa7ySYrayv67UEGhXPX/hL7H6mSF/nQ5y6Njazte/qBHrIEKWF
	ma2+OAVvW8DBL+eGpbYUH+6kxTPTeBaPM8VRJ2hnp4AbfxEyBZeYxISRrdkanfrw+YOAI5b+3R7
	1MqKSu6sBbw
X-Google-Smtp-Source: AGHT+IFNV3f5lOMy9GkmgmsKQ2Zpo32tZ7C2roTRZlNSHs7n7PopGX7gCGaNLgDJdwg64PX1H7aTrA==
X-Received: by 2002:a17:906:9f8e:b0:b77:f4a:ca1b with SMTP id a640c23a62f3a-b84451c0394mr384412566b.16.1767817126639;
        Wed, 07 Jan 2026 12:18:46 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b842a564255sm616008866b.63.2026.01.07.12.18.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:46 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 06/26] libmultipath: add cleanup_pathvec_and_free_paths()
Date: Wed,  7 Jan 2026 21:18:06 +0100
Message-ID: <20260107201826.323977-7-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cleanup function for a pathvec. Will be used in a follow-up
patch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/libmultipath.version | 1 +
 libmultipath/structs.c            | 5 +++++
 libmultipath/structs.h            | 1 +
 3 files changed, 7 insertions(+)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index e37e9e4..f62b4da 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -70,6 +70,7 @@ global:
 	cleanup_lock;
 	cleanup_multipath;
 	cleanup_multipath_and_paths;
+	cleanup_pathvec_and_free_paths;
 	cleanup_udev_device_ptr;
 	cleanup_udev_enumerate_ptr;
 	coalesce_paths;
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index cde5991..08d8b87 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -199,6 +199,11 @@ free_pathvec (vector vec, enum free_path_mode free_paths)
 	vector_free(vec);
 }
 
+void cleanup_pathvec_and_free_paths(vector *vec)
+{
+	free_pathvec(*vec, FREE_PATHS);
+}
+
 struct pathgroup *
 alloc_pathgroup (void)
 {
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index e7a0585..d89582c 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -577,6 +577,7 @@ void *set_mpp_hwe(struct multipath *mpp, const struct path *pp);
 void uninitialize_path(struct path *pp);
 void free_path (struct path *);
 void free_pathvec (vector vec, enum free_path_mode free_paths);
+void cleanup_pathvec_and_free_paths(vector *vec);
 void free_pathgroup (struct pathgroup * pgp, enum free_path_mode free_paths);
 void free_pgvec (vector pgvec, enum free_path_mode free_paths);
 void free_multipath (struct multipath *, enum free_path_mode free_paths);
-- 
2.52.0

