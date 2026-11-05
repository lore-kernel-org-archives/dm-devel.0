Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793863641;
	b=O+xe4w6RzMRyUdziajIyC7Hr8QoyYxq/80+K1oQJNdY0X6En1d1qUU5GAJMFLS1bJGO+
	 2ne6dyrcQ0JxhMWLDsYweA8PwweykbG70SeKboI4HjU2K500f239QAF0j+HcT0pjr9/yZ
	 cKSCVc0aV24UQWw205/RyQ/dRUdBLqQnvT2mWkZp90F68OEMcidYdLsz0FhgI5ZDc/zqn
	 vamws2RGsbB34W+GlbtzDeBK8+mTKoOcq5XCArhvIrqNrBJd021n7y6KbfpGcVRZNNwMd
	 gLEepPBx6fprjLnmplq9AeY72kl9yusrLnIm27Y1L1myfnIHHQsU6I1E16kgkvgnNwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793863641;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=y8GAjCpq+HU/Y8vWHx3dnsVw82gvuCD3uIlkSHruyoA=;
	b=ErzzCGllv3eUMlFIJp3FNjYqUCKnHdphBm5vWljkh5q6ezY6yUXsJ9dK22QEKQv3Scb/
	 1r3v7VeMqOSwOU0QPMdr24/r2bagxE3hOhw0OsVqbs+yjv1ZDwwrKW7jiwmMadNNLDo1T
	 /mIh4y7OMq+odKvVe5nxj4e2Y9FTaV7jmuW0yIfuQjlBEl1Z6ERTNi+TPwBgZSlWC4EZv
	 X+OzdfJRiAhabjWF5KS+s1pjESVFN33RrNWV9PgUjAGf4/EQB1T+11UIN+9udwHdkBMGU
	 CCx+BKNDUv6HIIHMnA++rRlH5MSZMvLf80z67Z8VeDmQIZ1juhwsVQwPbDcMfXRvaGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="MFWUH/v6";
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7301606A33A
	for <dm-devel@lists.linux.dev>; Thu,  5 Nov 2026 07:27:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7301606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MFWUH/v6
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a35db1f202so11442175e9.3
        for <dm-devel@lists.linux.dev>; Wed, 04 Nov 2026 23:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793863639; x=1794468439; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=y8GAjCpq+HU/Y8vWHx3dnsVw82gvuCD3uIlkSHruyoA=;
        b=MFWUH/v6La+bafKrta8KcW9u60ra1iOt5/rk9IpBiEFRXhmraH4LVefdsVal33jnk8
         sFD8eUoy2xReMe6fRfDh+p+7OqhvnehGIq8C2UC3/nHtUJPv5sgR6ABwj/Yr8x6NacNl
         3USw1WmQMiXcoF0HSMv5YavOG4IYz1KrJb21MUgvgz+gZ2/Ce91g4z/5Ay6uVCYra76K
         rxpqHFB5T/8F13UMfegJDfWVf6p9AVOryMBnt5iDuk90PGvMak59UlItNxhWCmxXo9s0
         bJIDrDOiRjgThhYBaU4iRDTd29K60S/GSnM5TxulSXjqHZiicgEuQsA2xvjZgrw23kcr
         yD6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793863639; x=1794468439;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y8GAjCpq+HU/Y8vWHx3dnsVw82gvuCD3uIlkSHruyoA=;
        b=Sdo0ApZpuuN9uDW6xSfjFZkKkROsnZ+UOxdDjpL99FmMtNxxf63bizg2E7MDgFh7Gi
         49SrdSqIQj93EfB/1VaEHo8/CctjbjXOPaUcFFlO6Gm/WZnZdd95GNKLpoe+bI6FByEj
         HSpRsgjL6r5QE9wZhn333jGeDLm+2AYYLx40wkG1+PkXaBRU/N1AMjBH4+fQAHeormUK
         spw0Ugtt92a/QLT/axRhGG/OCyJgxdALfvqkoHLBnbEBtZQL1xksjMYUYDemfl2Nb6/F
         9kD04/iwSLXtJUeSnG5XY+655QVExlUoHg1FoKh9X4r3cUzNK8/NXLHeV0vCJL3AxBca
         FmjQ==
X-Gm-Message-State: APuU4Z8jzwsBXfmRrpAjGch9Do4mZ6RNEr9a4nnysNPANMiM7Rn5Y/4U
	N9YILKWlFmZyLP/TQeqYdBDlVdViU1JWHNJJ9/sqDBcL0oJjGDFubxrP
X-Gm-Gg: AYBFou1WpMt/Z8Rmebx4TDudczcuklMA8K1hPXiLfvOp/Pl5iIpr0Vvg+hAdwkIgxE9
	/Fs8JitV8A486UKxpr9zDt4WS7/2gamgeF5MwHYmC+fdMSRm/7PmEKNvwSgof5yqFAlZHnGLcvQ
	ubMr3PTGvFl+qmE8Nwf8sFozplw/iHgD5h/GGB1SXPccxkvSPGpN7kvoqeBv+E1kwd8CYBBBOhS
	QcTnSkJTkUVjI+Z+XRJSN1imAJZKDMasgOc3ahariEFBkQLQqUtQpVZLRtVPeZucQk5ye07taAq
	Oips6Wl0qU3G10JIOawZZNlAk1UeekDowT/uLq+XgEGMnCAtcY/+lnoHXgYibFU9YNLXOsh7Tat
	vMzlV5Nb5D8coZ08V0C17x9drhoBhosArvL7hSZEAWBJ9nNzIRVNtSMmw7PIv+mHQGMiUJ8LqFR
	mCMCrYOtxpoyYRWgyWk57G7hfxfWBwN2Wa860jMoqtx2S+UFIxXtEac7hlJVdezYoHiHoiEHfrm
	mYO7MvNOgbx53nTz07gc4tvOKoNqOusK2Bb0qMaxYks5tCKJdG8bKLcz2QIl+jV1ac6sGt0iCJL
	Lq5LWH4QVg2kx1IAi8ZJUtv3yhyFbmjpOP4riTYQoFz3hGqcA187RZ7J0reWGWZp0x9OBF18cYy
	GtnN9Lc/AcWKYw37LbPUkTndg9rhs3pjW52LK+0A0jTO7uKiPriyMmQZlVLrpB8UkGkMF51D6Tf
	7QKsAYokH162msatiQVYKTsTG6VGs43J1UYYi8yzyuk9a2fSWrGfbnQA==
X-Received: by 2002:a05:600c:4708:b0:4a2:167a:c93b with SMTP id 5b1f17b1804b1-4ac19234ad8mr404040655e9.30.1793863639149;
        Wed, 04 Nov 2026 23:27:19 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a00-1028-8388-a84e-947d-5f15-1dc3-a8b4.ipv6.o2.cz. [2a00:1028:8388:a84e:947d:5f15:1dc3:a8b4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56ef2e968sm51013815e9.8.2026.11.04.23.27.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 04 Nov 2026 23:27:18 -0800 (PST)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Ignat Korchagin <ignat@linux.win>,
	Damien Le Moal <dlemoal@kernel.org>,
	Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] dm-crypt: defer async write submission to write thread
Date: Thu,  5 Nov 2026 08:27:08 +0100
Message-ID: <20261105072708.30722-1-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
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

With no_write_workqueue, kcryptd_crypt_write_io_submit() submits the
bio directly, even when called from kcryptd_async_done(). An async
cipher may run this callback in softirq or with BH disabled, where
submit_bio_noacct() must not be called because it can sleep.

Submit inline only when async is false. Async completions are sent to
the write thread, as is already done for submit_from_crypt_cpus. Use
the async flag rather than in_interrupt(), since callback context
depends on the cipher driver. Sync ciphers still submit inline.

Tested with cryptd in QEMU (x86_64 and arm64) with
CONFIG_DEBUG_ATOMIC_SLEEP, and on a P2020 running 6.18.55 without it.

In QEMU:

- 4k writes logging "sleeping function called from invalid context":
  100/100 unpatched, 0/155 patched.
- nr_requests=4 on a loop device: 0/6 unpatched runs completed,
  4/4 patched runs completed.

On the P2020, a warning in blk_mq_run_hw_queue() appeared in the
6th unpatched run and did not appear in 30 patched runs.

Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
---
Based on dm-7.4 (dab527d83462).

To reproduce, with CONFIG_DEBUG_ATOMIC_SLEEP, DM_CRYPT, BLK_DEV_LOOP,
CRYPTO_CRYPTD, CRYPTO_XTS and CRYPTO_AES:

  modprobe -a cryptd dm_crypt loop
  truncate -s 256M /dev/shm/nowq.img
  L=$(losetup -f)
  losetup "$L" /dev/shm/nowq.img
  KEY=$(od -An -v -tx1 -N64 /dev/urandom | tr -d ' \n')
  dmsetup create nowq --table "0 $((256 * 2048)) crypt capi:cryptd(xts-aes-lib)-plain64 $KEY 0 $L 0 2 no_read_workqueue no_write_workqueue"
  D=/dev/dm-$(dmsetup info -c --noheadings -o minor nowq)
  dd if=/dev/urandom of="$D" bs=4k count=1 conv=fsync
  dmesg | grep 'sleeping function called'

For the nr_requests=4 case, run this instead of the dd. The writes did
not finish without this patch:

  echo 4 > /sys/block/${L##*/}/queue/nr_requests
  for i in 1 2 3 4; do dd if=/dev/urandom of="$D" bs=64k count=512 seek=$((i * 512)) conv=fsync & done; wait

 drivers/md/dm-crypt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8853e9af1c3d..c0552a300e62 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1982,8 +1982,9 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
 	/* crypt_convert should have filled the clone bio */
 	BUG_ON(io->ctx.iter_out.bi_size);
 
-	if ((likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags)) ||
-	    test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags)) {
+	if (likely(!async) &&
+	    (test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags) ||
+	     test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))) {
 		dm_submit_bio_remap(io->base_bio, clone);
 		return;
 	}
-- 
2.54.0 (Apple Git-157)

