Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795188696;
	b=WlgZV3GX1y8tJwmKMAZvcQLNGHckEErPcFk/GbbapHlebGaLUsJyqvNlCM8qjGqkvLbr
	 +T6CxCpRP4LZ4Y4wKUTWW8Nwrf6NzvAmkNW8c2XWSDg26UsAUfTE4sqJXE7lbQPoh1z1Q
	 ZwCLIebAlh9vEQMWF+sUqtfUUFA4o0VTGKOkcxIuVKDRI6SgIQGNh6TzU7omiCW5fUB9q
	 wcwsROELF3PgO6vkUwZuroLD2a4NEeMV45dyk8hbmrB1iuDpvuxsSJDoWEbTWErmyiH0N
	 cG6sQk+EWtyJ1q9C2QONyQNsmf76+PTGp6FUfVuKDVfCpv79HzaVY4z8yEqVvUGk4JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795188696;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Subject:From:To:Cc:
	 Date:Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=2Fk1w9jeAUcBKJwd/lnefIUkj5jtEhXzNyw129b7Mp4=;
	b=zMFJs/Su6iNTFzJTVncicEahVNaj80gzh/YZm+w0kUL+Zhe1FBOUAfm0Ip0C5VmUnvhv
	 v/boFhx0sF8blNw9d9Pz7Tku38Or6X0TaX51AVx/Z2ZjGHGSdCKPyr7bEzxq09/tccV2t
	 qOATy3ZqFCKs2B62COAP4U8HoGNpxLr2+sL01hT/0rMP+C9J58SvKs8W2U/gso9hIeekz
	 d0ZJD59QxUqYOtzfnFwgXoty6RXgmfJTeqbPX4dcyQjjtEIHhA/OL0CRqxODImHp+bgN4
	 rXWHhNOiYZjn0O3Qo0Kjv+1r51Z57rv39CjBGbjsAc0ZPbPjn9yGCHlICroSJ8kzOLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GNwWWXXs;
	arc=none smtp.remote-ip=209.85.217.52
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3898606A335
	for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 15:31:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3898606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GNwWWXXs
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-7d6554d96d3so583659137.0
        for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 07:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795188695; x=1795793495; darn=lists.linux.dev;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :cc:to:from:subject:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2Fk1w9jeAUcBKJwd/lnefIUkj5jtEhXzNyw129b7Mp4=;
        b=GNwWWXXsRFBoaUSZU1UdNxyTMcilfvOm80M8YR4OHgnArdMYKaKUrSezr2mORQ2BuM
         zgqSWhnftwwYJM8XsA/xBzUjybSs9c2UcgAEEiKAqoiGb7vZVNqADpcLxC+OgE4nY6nJ
         SWuPGE4IMU/7vnX6pAzy2UZC4lPZe109preOlJFzM9EwBl71no3X9iR4KFkvtoh/VHu7
         J5BnNrP4oSfpYPjbCNqL04jquGLXX9j+G6ULHxPRKo2l2yFF/8gHgT7n7MVlaCkIEBvz
         YIDn44GSJQfZjhohtHdLz5ZpIWFPZeHF8QvM6r30biOMJ0r35fvkp3YrOh0WVl01LRm7
         LTWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795188695; x=1795793495;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :cc:to:from:subject:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2Fk1w9jeAUcBKJwd/lnefIUkj5jtEhXzNyw129b7Mp4=;
        b=P6V5ZjjcGVL6unuTDye6Ra2CaEHHJIG+f3fbgnRtEFsmJ4wGlFhM6fktqOsbKSEnIM
         zDlPMTG/r66wXiYalXvL16x4Q36VSGwqdCO4c40Egk4e+vD+K8A/pL1dwwcZshsf4AAJ
         LXdXbw10sCMYSC+uNWEnmAn1cs0pIbCV5P3FLMKcoRIueb/TJBNEwrwIA8c+yFpdWul7
         SSadTvU0OjudyDIgPOqTzZhH80AhsexFOnNn1QrHFOzrcB4X4h/PiRyY1fDp5is2c3DS
         tbjs0WawOyDm7/s8NX+l4rSmhZk81iOYOm/NvmoyNPBa43eKlpNIGT8dgJX4JRhkGfs7
         30Ug==
X-Gm-Message-State: APuU4Z+JmrOAFZovpT69BoVVPEOqoB4tXHXVJPaeE32JqWUStEdDz4cQ
	pHyNy7oiOC9bBcVq3/PSf8duNxeVe650fKA3FnITTteCjFYzNZyPiOG2
X-Gm-Gg: AZFdTZffbcEZ8im2/K0LFvguuTWl2s+C9utdSPiuWnyqIOO2L3hXxmtOOHm/zP+qeUY
	Pxu6db+ykFalDPqGByJL4QxTYREVCKdr6QX5AkHcrD4kVOx0r2flL7f6IqZgMJ044atntbXQ7jW
	PvoL94zlttfHmoHoO7M4pwethaei4idBGUSoYX1T3EOWPs0ycuoAMQNpR1roZWaBZDGqY0YpSZK
	2fu2PbsoA2lArrS+2Y2KK7mWFtVD0dXIeTHURr1iBerTjqecQlvmPH2C9LdZptDHCvbZLwzNRzo
	gEKJ461c+5/QSLA73Iadig5185SeGgkdBTIei0fqoOE3FHdujKKzQ9Lg+56TvUpuMEZbmHIErU7
	s6CLICI01hS5/VL6v43bVMwThr1adT67t6JDuGC0XTfiD4bn3AlnvtQEZb6rrU7aL8PK8gg9cik
	brOfSLPbBSN6pURqsArFA1kzh4nCExT16o2ZUn5VGRW54v8+p842WWKOAag536pbuAPWQkHZJpl
	HDEc+a63eBE5lEh4+Qvv4v9Ov0ka34kIMxcpgnOFI6L0HfJYeIGRdLCQfVADWXU31oEZjVpa3Ou
	Qi3Wp13grmzk7JmAHh9rZ/znvQNpuD9tujKa2+sGJ3Pjj9idSJHIL+V57TOD4w5dNn4hJX6w/fP
	RpjV58pwgF2lHDvotyqqSWopyLrzURumu/AjzVz3OCMWWDFY=
X-Received: by 2002:a67:e7cb:0:b0:7d0:6e40:f3e2 with SMTP id ada2fe7eead31-7d7396249a8mr1610590137.28.1795188694660;
        Fri, 20 Nov 2026 07:31:34 -0800 (PST)
Received: from runnervmccnms.p0xmmthrhzuuvfcj5u5s3tz0nc.bx.internal.cloudapp.net ([74.235.125.184])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349b456csm28334916d6.13.2026.11.20.07.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:31:34 -0800 (PST)
Subject:
 [PATCH] dm-integrity: reject recalculation when recalc_wq was never allocated
From: Yang Luohan <ylh440104@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 20 Nov 2026 15:31:33 +0000
Message-Id: <179518869380.2402.12815883988413214937@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0

dm_integrity_resume() re-reads the superblock from the underlying device
so that it picks up the flags and the recalculation position.  The
constructor refuses a superblock that carries SB_FLAG_RECALCULATING when
no internal hash is configured, because recalculation needs
ic->recalc_work and ic->recalc_wq is only allocated when
ic->internal_hash is set:

	} else {
		if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
			ti->error =3D "Recalculate can only be specified with internal_hash";
			r =3D -EINVAL;
			goto bad;
		}
	}

The superblock that is read back on resume is not subject to that check.
superblock_changed() only compares magic, log2_interleave_sectors,
integrity_tag_size, journal_sections, log2_sectors_per_block, the salt
and the SB_FLAG_HAVE_JOURNAL_MAC, SB_FLAG_FIXED_PADDING,
SB_FLAG_FIXED_HMAC and SB_FLAG_INLINE flags, so SB_FLAG_RECALCULATING
can be added to the on-disk superblock while the device is suspended.
Resume then reaches

	if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
		__u64 recalc_pos =3D le64_to_cpu(ic->sb->recalc_sector);

		if (recalc_pos < ic->provided_data_sectors) {
			queue_work(ic->recalc_wq, &ic->recalc_work);

with ic->recalc_wq =3D=3D NULL and dereferences a null pointer.

When the recalculation support was introduced, the call was guarded:

	if (ic->recalc_wq && ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))

commit 468dfca38b1a ("dm integrity: add a bitmap mode") dropped the
ic->recalc_wq part of the condition while restructuring the surrounding
code, so the null dereference has been reachable since that commit.

commit 875a7161fe15 ("dm-integrity: don't recalculate with HMAC because
of a dirty bitmap") re-applied the constructor's policy inside the
SB_FLAG_DIRTY_BITMAP branch, which avoids the null dereference for a
superblock that gets SB_FLAG_RECALCULATING set by resume itself, but the
standalone SB_FLAG_RECALCULATING branch further down in the same function
still queues the work unconditionally.

Check ic->recalc_wq before queueing the work.  If recalculation is
requested but no internal hash is configured, report the inconsistent
superblock and leave the device alone instead of panicking.

Reproduced on 7.3.0 by loading a dm-integrity target in J mode without
internal_hash, suspending it, writing SB_FLAG_RECALCULATING with
recalc_sector =3D 0 into the on-disk superblock of the backing device, and
resuming:

	Oops: general protection fault, probably for non-canonical address 0xdffffc0=
000000020
	KASAN: null-ptr-deref in range [0x0000000000000100-0x0000000000000107]
	RIP: 0010:__queue_work+0x95/0x1030
	Call Trace:
	 queue_work_on
	 dm_integrity_resume
	 dm_table_resume_targets
	 __dm_resume
	 dm_resume
	 dev_suspend
	 ctl_ioctl
	Kernel panic - not syncing: Fatal exception

Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
Cc: stable@vger.kernel.org
Reported-by: Yang Luohan <ylh440104@gmail.com>
Signed-off-by: Yang Luohan <ylh440104@gmail.com>

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4046,6 +4046,11 @@ static void dm_integrity_resume(struct dm_target *ti)
 	if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
 		__u64 recalc_pos =3D le64_to_cpu(ic->sb->recalc_sector);
=20
+		if (unlikely(!ic->recalc_wq)) {
+			DMERR("Recalculate requested, but internal_hash is not used");
+			dm_integrity_io_error(ic, "inconsistent superblock", -EINVAL);
+			goto skip_writes;
+		}
 		DEBUG_print("recalc pos: %llx / %llx\n", recalc_pos, ic->provided_data_sec=
tors);
 		if (recalc_pos < ic->provided_data_sectors) {
 			queue_work(ic->recalc_wq, &ic->recalc_work);
