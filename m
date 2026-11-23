Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795400126;
	b=fuuDVT9BTackv4L/EAWYHHFbG07iESYKZi04pA32hgTG/zPPaxHEHgpJvbqtI+ByzUWM
	 FCA2ieKgz3YVFiUaZ7RviE8DLM/S2EIXkKkbPltGs8Mh0ofemgqHhw5ysdXOCBf6Ypnuy
	 KF0j3bpFhfy1igIvg/g7+xzUznqd+WeleqyzDjiaZRLEGk9zkHN54KmIaQuAOjHjcwxzB
	 VYWdVATrkSewBYYO4811IYZtJio+ikTVnwWyBNLsdcucBQFusaQFzCwwCUCJ+4BHmeZVp
	 fvQp9WCcdNzTfg2OaNNb7GSglojDbLSHNXIPXaH6D0GLooBGyBmU7sj/WS3XqmBTrzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795400126;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Subject:From:To:Cc:
	 Date:Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=Rkyx+AAwBDqEzfOhBV88iO5QEcgZ4mRADs3tiKBytS8=;
	b=PR57K5HjwXYB5Yy79TMbSXW55qQeEBWgVt4XS1Ntx2VO8KSHk7AZxymtgcDb7vWGugHg
	 x6bjZc3J/2e5ZRuY0+IhyNB6kxFeNy5D5KUnW2xjdEoRrBUGoWPXJxAXeI3a+H+jxhpMR
	 2WSrqO0vriTztTHpMmI0IDBblZwskzrJyviDRx2dpLHq7t7JEYYsjbI7T/Ih5i3D+RXV+
	 QKnVqsZ2PW7RS2w316uMiBwRfN9YhaLM7zx7V152fXTkzzRKqLhkCEF5+z0kMTgRsS82n
	 XJ58tFTw+OLW+H5FZecFcpMvAhEqWYtCYw1JpUiPh1U8vuGyOs9iTsXy1gsRbtzXWXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gzyHv5sr;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBA7606A320
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 02:15:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CBA7606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gzyHv5sr
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-3863db981d4so3636964eec.0
        for <dm-devel@lists.linux.dev>; Sun, 22 Nov 2026 18:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795400125; x=1796004925; darn=lists.linux.dev;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :cc:to:from:subject:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Rkyx+AAwBDqEzfOhBV88iO5QEcgZ4mRADs3tiKBytS8=;
        b=gzyHv5srU3C1951omN4A4Zp4Ed0XU5qDg3YlY5JI9oP4J2TkfSSAg918jZUlXBoQCb
         G9SABPJQ2bfHhbsu5zNsPKi4trtgxl5n7IcOfSungguvhexnGWnONGThdmDwHPjWQ3je
         8FkbM4j0en7JyNAizA84JTtBJPjUiRob4GGMVjVBsw1nOqZvUbow9nUKoweL8FRePaEf
         bP9jN+wndEShKil+qDK4NB7cVkl7C4V8jYnMEepsA8b3/1f8oJ3qFNXGWmXWFWxYICDA
         zWtRMvjwJhFh6S4RZYqT0Hcz0Zzu4aG1qyo9lqsRexuaQ5+saLLOa1vVpq36mvpSQPOU
         iqVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795400125; x=1796004925;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :cc:to:from:subject:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Rkyx+AAwBDqEzfOhBV88iO5QEcgZ4mRADs3tiKBytS8=;
        b=IT2WaGO79an/JKUYrccxl+8/n54mRV0CTJsnNksbODaJm3yrakVdVLDqX/VLVdFZxx
         TKa6MqMWAPheFMJhIDWdI93jSLkIK25++msFAC6T222+6gCMQK4tc+zLbmXm3fu6ojRv
         eyL1GulFcA6oHP+N6hB8ACP4ppkkpYFWI+y5f7XwOlFzq2hcQMMgN+uf3SYTKpRr2yd/
         edQ5zP9xqBRPYqDsZGg5Ikw4RDLmouwMMDXjiOE24NjHdTfMuhSim6lhqggNfUTAc1YL
         90JscAt6tMQ04/mv1uxYIK/lHKGR+Oi+Cw1bptv9YJ0BOgBZtjVZmC6nzN2Oteh8DzNI
         Pfug==
X-Gm-Message-State: APuU4Z+81/WaUYYDawU9ekDW/39pgtVtt7xgNePKfLsMxUfPqdsiLzqr
	dRUD4WxNBR3PDBxqe+nH9yovzDRGDWJAEmXtGmySs5eK8+fDlIsyfviIJL9/KFeu7tA=
X-Gm-Gg: AZFdTZfx9RPOOKSyFrORoBJEujaIYi2b9zVpMcduhpRd+vYb8noa4BLSsCkJQAHtwn1
	FBXKPT5IalhV2xAMBieCn+160/3H4+Q6PVz+j0Bvcd+se6XYXG2Fs0f9li/TCur2uT8qPnaWHPL
	zm9srr/eq9YEW5YfyOyxOK1HxHHx8BTG5My38bj8XSoRSGgihQ9r5gY/2Wyop6xTsu3TzYYSUC4
	R8z0icIHBIl9X1YMKoWhdrjxw+1YN8SJLWHBRufiyzm4TPfmUe2ICuIskiGtY/Z+t+Ld+SrF4Wb
	E40qPXBopEkomq6LT6g/ezoGFXv+EV438gg4ulFSXP6SD3ZLTq6JYuGaKu/4b2VCHndXlzyGwHx
	zfZXfXZNsp6fdWJHLeO3VDS/BvStSSIUp3qmtuVvh9x/ACyAOJC9pDNlIXcrJ5AgNygZ8HDtBhd
	t6I1O4k13u5m8LAMTAaN8y8vWTzXvT2gaj1MK3SmDAhO18xWpYKTaWlj+2Y9aj4TatBMO4wbP3t
	kDr3xjCM3qv8r8WXLHQll5hgQbcAMhApQbqJUTIEjjgd9f+DPj65wdfbtgiytsEr5DSWaxqYAGm
	3sftJUpR7jgYhFiXinOcJJRrsnPJhBdxI6Trw99a9u7F5I+37DkG3EQypUXFzyd3hiP+iwdxIPW
	rn2Pfjt/DbsauaAdMFvRlYztU4Wo=
X-Received: by 2002:a05:7300:f68e:b0:386:240c:19d6 with SMTP id 5a478bee46e88-386241b6d72mr8613390eec.6.1795400125325;
        Sun, 22 Nov 2026 18:15:25 -0800 (PST)
Received: from runnervm0hi8g.vld3mfsqhe1uncfgcs4bzya0gb.phxx.internal.cloudapp.net ([172.182.243.48])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-386b1965c02sm3021818eec.27.2026.11.22.18.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 18:15:24 -0800 (PST)
Subject: [PATCH v2] dm-integrity: reject recalculation when recalc_wq was
 never allocated
From: Yang Luohan <ylh440104@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 23 Nov 2026 02:15:24 +0000
Message-Id: <179540012414.2174.4959926607245086522@gmail.com>
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
Changed in v2:
- reject the superblock right after it is read, next to
  superblock_changed(), and restore ic->sb from ic->sb_copy, instead of
  only checking ic->recalc_wq where the work is queued

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
