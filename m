Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793832120;
	b=MyYEFHcUj6SANdcDsKjnsxlTA7n6MAofDjpUJWl/WSchu+zMBGgTVegE8H9L8fTY1iE9
	 jqjOwnWCZE4LydU7fC6WR/MwaDYViEazYc7rRVc1K+j0QSm8tNv5imsTFt7vwF7g4Htxd
	 H5i2Fmw4CYSvQQRvD42ylaIpLDtO/o+1DS674sPcyrtL8xgiF1MpBun6o1/MpqzNkDyq+
	 cOkcSmKDxwhEv8cV9Jri3qHe/FfUyc4kBbWDkMHDa/u2ci8tNaXWqYUuL+kvnm2An74fV
	 hTrri9OW04KyB05YGhYT5dCswA+IewGP+FpwnTjwX3obhOFeWxxMKES4OJz2RaxNFcQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793832120;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:From:X-Mailer:
	 In-Reply-To:References:MIME-Version:Date:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=Le7HKNyvunzvQx/aShnNzGNgI0iOTWFy0ku1BiRO6Xk=;
	b=LL4pr99KRfszvPF2slH5xRkzB2acWejSCdqArudqqoKhew1kJCJwbmAQii191G/wYNvF
	 ZzGnSy5+GUtEwTAo72TlA1Wppo79VN98AN7svUxxkcJDEWTJqTthr4NUW6jNMTUymPeA2
	 swHobsH2lgo847jS+HtuHBbHgwPT8iJcnVoolKzR4UaRmZRuQH/lJcqtFRe3imS3/6Db6
	 cgF2XQKelHoNitfUUZ5F5G0I81zHtzNakO0AK6Z59vchL7QcaEHyImNbiGS5uQCOeyF8b
	 yavPXLHGV5dSU0uTPsZK5GkXytjCfq4Yv8esxBbchZ14//TyzP9BWlJH2fCOyjI9kRA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S2gMV0ei;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.41
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4572606A332
	for <dm-devel@lists.linux.dev>; Wed,  4 Nov 2026 22:41:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4572606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S2gMV0ei
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-48eee44b908so730657fac.1
        for <dm-devel@lists.linux.dev>; Wed, 04 Nov 2026 14:41:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793832119; cv=none;
        d=google.com; s=arc-20260327;
        b=b2kso/FfsyPWUH9sPsq7H7Z71TVMSi9Kv2tSHv0kaIcGuy0xKauZ/AgQJ/XR2fPT5Q
         UDS3UItBvMz+HC6WvUODn8uK0TN8w5rBSagImJCrrt0mukScYVswNC7nvPhCIGBG4PBw
         BCGRdc9/11kO+S82hllpCJOkovUZ7gZBsTVLnuOSHa70NL3Wp3BGSXMo5YgGu3nGjcV4
         b4TKHqMDwXVk5C7zaZF1TnKMlEHBSow5DTTTW08URKYhG/ZAL336IjjEgGRdufoJJnD/
         n0j3ki2LMJxGGaUzqMII/rIqHeoALB9Y5Ds3+zXD9tRBWXApuwGYn4Lqxhe0duh0J+Vd
         sugQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=Le7HKNyvunzvQx/aShnNzGNgI0iOTWFy0ku1BiRO6Xk=;
        fh=J+DDlYQ9bPScT6ri09CRkxCdeRtk/GtYWJpbQR443Ik=;
        b=dGYKmjbY91hsPP16Z9KX4oTms7h3COXzXA9UGKzXpTkAYqtnIikjR+OfBwIauwPxzg
         yxD2dLiBpAbEpPPFW+QkbsY4Jm/oIqxvB2Ch2brNttawmG6r5chEwGKJxJpSG9zThDHh
         Tp3NjCI+1hTSKJKJ10K8ydAxarGl1xxBwgCE9Sg2TwdeZJxBRFz5JHam06KdrbZZwpxa
         oTaTaljxVEaB33WynwH2ro0L0DZ1CKWizORPNVhiXTUUaCbqUaTjGpUCfcR13I1anUVt
         9x7eVEH9HYvDUy19p7ItbybfAAnS7IqR8dDr6og9Bg2aHjYPHt/iyDayb+T6ZVHEzdv3
         Pmug==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793832119; x=1794436919; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Le7HKNyvunzvQx/aShnNzGNgI0iOTWFy0ku1BiRO6Xk=;
        b=S2gMV0eigK85J83U+IlYJ7TGbmUChzY8+8aw6NPjxDdpvWfNPGcvP/3EVrLwPsoAEe
         lW76HzD4Xf8Q+qSLrYAId6MJrFvw5rT6G6o9QwNGDrABo+O9bj5wFDqb+cqJ0BHMIXm8
         djk7RqCCjN0GbOoa0SHxLrWeeKNNcn3xjsBiFkfAvH/lIQB00E7y4UovZWeO2N9pMpBq
         6fhcUXbhOpFyI/Mk5wb26KWQpV7JbfcgB4L731gclz/bqhreqqkQGd25E4JEDAjUqG4A
         z22ByaFguL3lNmOtfQ5uFZwdsAmDHgP7PmB229CDy2TCU99WRCS7mZc+qpMe1eVfnBqB
         +R2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793832119; x=1794436919;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Le7HKNyvunzvQx/aShnNzGNgI0iOTWFy0ku1BiRO6Xk=;
        b=u57wIKDXvMXQ5pVuu120fiNkQDSjQT0qPV6RBxISNuvUkbgEnt/76VXcKW2xj0w17r
         55ShxhLKzcMkuXFgsGWozrS9AGmOFLsOFVJIMrspoJRx0c/jbkP/svw3PUVvRebTM1GC
         WDYoQAL2lubA4ctkDaEjtzyI2d/1uwZWz3TxAnL02YEQ0mWhqSqelxFBfYL3jKGsxZeY
         fl5UOz3uIg6gO4FW3KIxFucb9qLXttwonb5tLByWlWgKeWaWqPRDIOc947JS7/gx0Uvl
         Yt3bB9L9cXDzWHVeoueTEUyi0p7rOj06WNjs1B4d8h6Pw/xKcCvGk1M0HVyxE5okyGJ8
         CbyA==
X-Gm-Message-State: APuU4Z8RD+/Hbv4VyfVG2MahHV1r/vSN+8HOCiyGLln5BJsPWMkX/sGw
	69KEHcvzAvM3nwLH7XwqDD0+obdUjQGQTulhutmrhXeGfo7fB45uAt0+ZJ+xt9q2q1SjA34Xaob
	DgeloIUQe3qUmCJibn6V1lEm2sjfsQR0=
X-Gm-Gg: AYBFou0jRlCHeYqispUqYHvTN5crkwgfLr9nhO+2s5r/RZqip3/qaU/dm45VZG52bHv
	FrgAh4s+RG7EdcGBSTFb+7Geaxt0/dmfMJ2UMOyVQIbHaer/miEe0HgaLge2pcYJCPNpByy+2MY
	8OarVzQcA02sCzB19zwGelSXGtzv7qKo7cHKL8seSSbTAJtE1gHgwSmmGCCIy+APlIMlqAGE+ok
	YsL/HDbGxOiy9qEsM5bLRV0IjGew2+Jubnwtv1x86P5Nq0Q065y8lL+ZjXtggN7FESAFx7H1BiZ
	FLD4QbKXHdbopDfiSUQndRTUkctCP2b9ImJNGnhlFJwQZdMQ/njEKESRxO2XzHZKzNwzdyu0q+s
	+K6QlqVwKVLv9Whu+HzxRcplN5lNTmPkwYS3Mt/g5JTa/RFA6H1zenbS9FnLo/8zzibKAkoQ=
X-Received: by 2002:a05:6808:3a13:b0:540:5827:6d8a with SMTP id
 5614622812f47-5640de8d663mr11690958b6e.66.1793832118868; Wed, 04 Nov 2026
 14:41:58 -0800 (PST)
Received: from 41474967715 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 4 Nov 2026 22:41:57 +0000
Received: from 41474967715 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 4 Nov 2026 22:41:57 +0000
From: Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>
X-Mailer: git-send-email 2.54.0.windows.1
In-Reply-To: <CADZg-m1A5qKMfXGtQw_s9-tYDL-NinDX8bNAxurFkrWRRq7ZeA@mail.gmail.com>
References: <CADZg-m1A5qKMfXGtQw_s9-tYDL-NinDX8bNAxurFkrWRRq7ZeA@mail.gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Date: Wed, 4 Nov 2026 22:41:57 +0000
X-Gm-Features: AclHuK8G_S36ePhSP8ix8BUldjXx979HTJRdUgyJDXB9GJjPu8eEhpUl8IqLEfM
Message-ID: <CADZg-m06Zf1c63em8uJaDKVQu68sHbdBi1oZw7JAbhUtvk5nXQ@mail.gmail.com>
Subject: [PATCH v2] dm: Reject table setup after queue or disk teardown
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	bmarzins@redhat.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, 
	syzbot+5307e3bcacec2ce4c2f0@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

A failed table load can leave a mapped device in a state where its
queue has already been initialized or its disk has been removed, while
md->type is still DM_TYPE_NONE. A later table load then calls
blk_mq_init_allocated_queue() on the same queue. If del_gendisk() exited
the old hardware contexts, blk_mq_exit_hctx() dereferences their cleared
flush queue pointer.

Reject setup attempts after queue initialization or disk removal. A
failed request queue initialization still leaves md->tag_set NULL and
can be retried. Set the request-based disk operations only after that
initialization succeeds, so an unsuccessful attempt cannot leave a
bio-based retry with request-based operations.

Reported-by: syzbot+5307e3bcacec2ce4c2f0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5307e3bcacec2ce4c2f0
Signed-off-by: Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>
---
Changes in v2:
- Resend as plain text after the previous mail client reformatted the diff.

 drivers/md/dm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1881d86..2f3f1ec 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2606,13 +2606,17 @@ int dm_setup_md_queue(struct mapped_device
*md, struct dm_table *t)

 	WARN_ON_ONCE(type == DM_TYPE_NONE);

+	/* A failed setup may have left the queue initialized or the disk dead. */
+	if (md->tag_set || test_bit(GD_DEAD, &md->disk->state))
+		return -ENODEV;
+
 	if (type == DM_TYPE_REQUEST_BASED) {
-		md->disk->fops = &dm_rq_blk_dops;
 		r = dm_mq_init_request_queue(md, t);
 		if (r) {
 			DMERR("Cannot initialize queue for request-based dm mapped device");
 			return r;
 		}
+		md->disk->fops = &dm_rq_blk_dops;
 	}

 	r = dm_calculate_queue_limits(t, &limits);

base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
