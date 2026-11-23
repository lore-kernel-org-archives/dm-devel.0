Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795414436;
	b=uNRuM52IaR6XUV8NQ5zJ1DdnzrYEF2DRRQmX4dwyJPtYRZFaCc19FXxJtGOSo0gyhOwZ
	 X3w1IF87hjVKrx7oCe5w5eJtjnyQnAZJItn+dNAc6EuAg6+2l2uGZ8StYLbDLMU2yaP16
	 e5Ze+pGwYdwZiWTq9ckIyCGTTXD1w8lxlwRhbNxgQQIaBSP0ewk1+xOS1tayaS4PqCuK8
	 BWI5t+XtDSjZCo13tniHNu6/jCC7gV5ThdMOKGJxuiTjticHVdO88ZyP87ORwP/5EgAxb
	 bNR5CAxEhcHKiBiiyowuLZZDLaUFZjKyQb1ESLxu0nt5vXmGLhy233L1knvZXg2Pnmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795414436;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Subject:From:To:Cc:
	 Date:Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=cC9gVRTaITRF0x2YlnTwc7AlwbCdAsD7C4t5cMZ3xTI=;
	b=rSQa4OSSdgzFtdZ7vPmEGAcdbxTgZHncP/N4OEW8E7Qd4ey+IRZsW0iVIYvKP3AaZtJ1
	 nxA9c2meEerEm21OCZ7YH0YwiQa/P1UUPUE5SLKw7PPJ0zD/vmcFnEDeu9GXq7AQstLLv
	 /7ntVLAr6mo7eoX/y34BixTqNaeu0ZXT36q/y3T49kz4vflBJyyPiQ77QxsW3TnC0EjJJ
	 dMW97R6suZUFHgsIUwnM1JSrYyPzU2YL7LApXBCS8HDthFWf/yr8ll43WCj0zt+ney+q0
	 HE182Gwq3Xk74+5qTufs4pKqw8jCEhQ8vsI0YiZXd1mFClkYwJDttNKwlringZEroqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SL01D5SL;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03121606A31E
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 06:13:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03121606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SL01D5SL
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8c700d6cc0bso2030953b3a.1
        for <dm-devel@lists.linux.dev>; Sun, 22 Nov 2026 22:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795414435; x=1796019235; darn=lists.linux.dev;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :cc:to:from:subject:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cC9gVRTaITRF0x2YlnTwc7AlwbCdAsD7C4t5cMZ3xTI=;
        b=SL01D5SLMPTJABDdEn8nDd16oFfxX8LnR0mKVbeCQsbxdDabC4PkzqlGYxsFPGuE3u
         ggozZLLzGFOxQmh/EqHOn+meYjYtNuGzC4jVcDA/oU200KbMezkVUtZ2SalzScPfkhco
         xbbxu4QHRVksBQ5ky1BahZE1+BIpgxLWbrL7xJZ72n4bqJDxvhRXHQHWxKrGHBB5KYSp
         Jn398pw9M+yxCnE50ubdxwrALb1NJTiPy08oEo5yTtEeo6azFl2kmj+Xdev3BrXzoBXm
         Y/gsYFUB9yizzEvvd5jUUCnLE5jI0yiAwUQKazmU+3KVTPXrc7ltWsVe+KVq138yOQpP
         q5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795414435; x=1796019235;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :cc:to:from:subject:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cC9gVRTaITRF0x2YlnTwc7AlwbCdAsD7C4t5cMZ3xTI=;
        b=onqCSNda68DKZe5pjQteYruo29Q4re00EJYNLc2OS0TvPk5Qh4vk5vgO8DEmfv3U6i
         88YiFUhNqwkbTr0U9JINB0FPTvqa/qe1SWx7WlGYdrKRHrHfUf16rtWu49mWCvRaJeMA
         PejrcgWVHl2f7qFzBihJKEV6CvvxKnb5tbpE6dg/QYPPog24rccdBSlwmYSqpi6bMzgP
         0wJz376QfVDuBB1G8SrA09Bp7CrsAkT5tMUA4o4kF1F9b4pZ+/FfCZZ5IWKE1CLqJ/aN
         sv3FZAxZ9RKLJnsozfi+sffwG6SP0XzFqmpBhf01o7GlUpfbS2yk2lSuQAP0V2MXDIT7
         GP7Q==
X-Gm-Message-State: APuU4Z/sbCNF4+ZJH0YeuqJy62P0oQPi9/nyyEDviFzfxcMmTNHKfTK0
	bd+be6W+78a1Ks3GSLdG/GKtLmK7TFJhjZMXzA16XvUdbL2Obpo3q8xs
X-Gm-Gg: AZFdTZdQ1l8Bu6ED4imJycBPGJXyWo4wvhdfEKD6jMWWWo197sF36xUzmMVPFa4nnGZ
	2OfrvkZoAVc5YqDwgbFI958UVgeiIbVh9rDSrXzo96lwWgTxeMkm5zAiuJ2hG1eDZwsQI3ZFN04
	js37CfhUPLFoME52U8GyhYmQukjdOOH0Cn+1mlCoBi9/DKkDWmQRzy1OzepY4v2Ejo5Mcl+Cof6
	YGGFFCE8z0bpL2LWddZbK9og7HuDb783FjLr3LpV5Peaz4PkrMQr8c/1KqYXguoOjoh/NpFL+/J
	1vFW/kBn56dqV8ldCHQK1Nsl+fKlXVcc+Nf8HTogrTxG6Mj8eGJ+6fClaMggm5BFqAv2DBuxc2s
	nSBH5c8xsRlWXfOMbfaylqtWoLxg1h3LHYw0ZwhtkxYLLyqTKgDX6yLlLKFpYjait8qVXwFF/e7
	eYU7EVG9cuFNICzI6TavHlH8kE9NxiEPfRFTMDZauGNcbpWsVBskYmuQq1uxnHXoK94EEVYNCFc
	LjLsPkaDrpiUwHP59jXSVRNX8qYpq5/4xYR4bSt42SdN+6iU+Kw+AglghIhZdcueG1bivYwzQlO
	+BBL0ldqLKflFVxVu+xREORKgk1XC7UCRNjdpkCzBEwUsoJ5YEZJslrWNda7Fa4p2muT5vJP2bI
	uQoByyOzEUMbD/W1ZtnviE1U=
X-Received: by 2002:a05:6a20:7f8e:b0:3e2:81f5:a864 with SMTP id adf61e73a8af0-400aea11bf9mr8689588637.41.1795414435189;
        Sun, 22 Nov 2026 22:13:55 -0800 (PST)
Received: from runnervm0hi8g.cxrikbqfcygehnd5bg50p3ctfh.dx.internal.cloudapp.net ([13.83.233.98])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d05c0cfsm4644962a12.26.2026.11.22.22.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 22:13:54 -0800 (PST)
Subject: [PATCH v3] dm-integrity: reject recalculation when recalc_wq was
 never allocated
From: Yang Luohan <ylh440104@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 23 Nov 2026 06:13:52 +0000
Message-Id: <179541443270.2416.6401739253063141536@gmail.com>
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

Reject the superblock next to superblock_changed() instead, before the
journal is replayed and before any superblock write, and restore the copy
that the constructor validated.  Checking it at the point where the work
is queued would leave SB_FLAG_RECALCULATING in the in-memory superblock,
so dm_integrity_status() would report recalculation as enabled on a
device that has no internal hash, and a later resume would take the
stale flag from ic->sb and write it back to the device.

No path inside dm_integrity_resume() sets SB_FLAG_RECALCULATING without
an internal hash: the bitmap mode branch requires internal_hash in the
constructor, dm_integrity_may_recalc_dirty_bitmap() rejects it, and
reset_recalculate is rejected by the constructor as well.  The flag can
therefore only arrive from the device, and rejecting it after the read
is enough to keep the work queue call safe.

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
---
Changes in v3:
- the v1 patch checked ic->recalc_wq where the work is queued, which is
  too late: the journal has been replayed and the superblock may have
  been written already.  Move the rejection right after the superblock
  is read, next to superblock_changed(), and restore ic->sb from
  ic->sb_copy.
- the v2 mail carried the diff twice by mistake, so the same hunk showed
  up twice.  This version sends it once.

drivers/md/dm-integrity.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3941,6 +3941,14 @@ static void dm_integrity_resume(struct dm_target *ti)
 		goto skip_writes;
 	}
=20
+	if (unlikely(!ic->recalc_wq &&
+		     (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)))) {
+		memcpy(ic->sb, ic->sb_copy, sizeof(struct superblock));
+		DMERR("Recalculate requested, but internal_hash is not used");
+		dm_integrity_io_error(ic, "inconsistent superblock", -EINVAL);
+		goto skip_writes;
+	}
+
 	if (ic->mode =3D=3D 'R')
 		goto skip_writes;
=20
