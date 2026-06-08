Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1CE33BBCF
	for <dm-devel@lists.linux.dev>; Mon,  8 Jun 2026 16:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780934895; cv=none; b=ETcRsVMqGR7wxOawGijVISuqABSQl+hoaRSb9R5Kr0jSlHDq58c5NghaYBqYODgT6tusL3K3IqPvcaeUkFlWgpk4TTi94s/+kR479VzWdotFUwn38G5nB1TKakKy/XjMBZ22rqZm4MV8GTboeqT+oKcVIwSKv6XB+MczWuCV2Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780934895; c=relaxed/simple;
	bh=2GhRHyVAlyUGenZyKYbrYLs63DlEoRgcYFmu+i/5cCM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mm7MllOIVT+8ZtLZT9bRTqji91KYMzOEuqGkiHmEoKKv1jxS4lB5IaljYd8NFt01DqTZ+ZTc2bd3sQMWBjEPQst9rkvzMk4FbSs4db2ZL7r94uG7WKpAhFQzDqs5TznpK+tyd8nw6wWabWgg0ta6UJD/jQo/KNYXnSFmXtsm8UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=IrvF+nZp; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="IrvF+nZp"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-915e1354934so32064085a.1
        for <dm-devel@lists.linux.dev>; Mon, 08 Jun 2026 09:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780934893; x=1781539693; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NmTLhb4vOLAl9gtjuNKa9IpLiHeFhQUx7aBr9QenpC8=;
        b=IrvF+nZptXPvBwxHr6gGB/3b+3/n19IFskVrgLtDmV7Jq12gTAvuTSb5LIFVk7OIWi
         AAklI+Ko6dhA2zCfgsJkAbCBaEILnthp3EJoj3zoPB6sQWRMBjIxbar9SLoDEqccSEvx
         limukBi0sdJvUikpgoIIa8KRPk0DKE1gsNMWD+J2ycXOzBaRIQ+ahCjtfnO0RSygj+FR
         MpAwXUh0PCU2aq7w18yW4fW1MnjkxccZHK82itb2QIxus1UtZuv/cDaz0Ej79yjkDXqc
         CtGSZ9RhClkXsL1uGD4DnsyxFFoiBfcCL3rA7SZZLMIeoxgRvRfzERVGFhE3r+8bv+GC
         mkEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780934893; x=1781539693;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NmTLhb4vOLAl9gtjuNKa9IpLiHeFhQUx7aBr9QenpC8=;
        b=dKOA4YKVVBVeb+ba/uzIx4V28P47yD+q8VAZPGcT7HI4bMFkb/cgYvW5pValInOy4/
         ODPaMHqXzjoqBxFZ4d2DdB+a9CGVocnIdNeLMgrz/fTyQ98peGBN5ui/2PF624UsAScu
         Q3IsytaLeBY/DKeXUaPfEgTIzUYHuPJgJAyuXr3JXe9U4tLyiol+a9nsVnIdnrjITeoO
         cOj6BZUWNLTfJZjRlD2j97UkIgKke6iOYTF8O8aQCAPDnLdCUA2Mg/hPvefrLJVz8Qf4
         2wCVMS3g6RwFtmg+UQJZn35ayTOKjOMh2PPsubN0L78rowvuLtwwNmCySPaOyr6fs4uw
         iQSg==
X-Forwarded-Encrypted: i=1; AFNElJ/6I/S1sOZl9PH5jJT/21E90CkVdP6E1/O4tEkUn+utGUKw7nXwPyHYLtv7JN5ZB7eOhbwBCamt+g==@lists.linux.dev
X-Gm-Message-State: AOJu0YyEhMemh/qVRxXOSjngYsSqBx/ZE1buVRmHLNRg+gpev4bF4/R/
	sxgEP5SwgEENp54h2jnDUKUCUnKePXqiZH3cvn0k07uTW0lQMBM2weaU523DYwOspCA=
X-Gm-Gg: Acq92OGHJ02XKNIQ9yq0+fMLz6MNym1MBca1COGVmB0Lq2A0SDc5tMLBFSIQO4EjoDB
	ZhhgT4Iu0I+8HeYMHvgrNkD0V+sLDN8jLKU9IxL83azYybv7YWemEMuf7LVXeFl6+3fPPqwWn2a
	2RrsQmQBbDDFiQdNAd4wyTYmVgcq53O1d1bNYMabr9F/WaQbFpg6s5qDgMV/sWgoXjJ89A4kp6i
	Jn/pd4gbqIYD+IXHAqTHFkf0wCwrF/VUnwwhr0x76HAmHBGXJvZAuMbnptUKTvWoQ+khKoCA5W4
	rGH37ZDeQ1WjjRXktwgg0djnAlwU+2Sv2fYAR6qxBDGNRROeThvzVE5M0CKv7wWxBIZGW0s4RGw
	17S2NsclWpwyNeCICfCFSmUbFN4Nh5PRd93fVApqmiZLyYcoqA5s2GLWFEGl/nQSBZHGdKPm1/G
	51oFggrxVNeHHMfzfXul7GW3NeMUGPOYvPrdAigXVVBW9GneuJ
X-Received: by 2002:a05:620a:1794:b0:915:a4c1:8c55 with SMTP id af79cd13be357-915a9d7d4b5mr2561594585a.34.1780934892611;
        Mon, 08 Jun 2026 09:08:12 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-9158a3d3a0esm1800744785a.40.2026.06.08.09.08.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 09:08:12 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] dm ebs: drop dirty bufio state when discarding blocks
Date: Mon,  8 Jun 2026 16:06:07 +0000
Message-ID: <20260608160606.1134881.c0f6c631029b.dm-ebs-discard-dirty-buffer-resurrection@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-ebs can discard a block while a dirty dm-bufio buffer for the same
block is still cached.  If that buffer is later written back, stale data
can be written over the discarded state.

That resurrects data that userspace explicitly discarded and breaks the
expected discard semantics of the target.

Flush pending dirty buffers before processing a following discard, then
forget the matching bufio state and issue the discard.  Keep writeback
errors separate from the discard result so a flush failure is reported
to the write bios that dirtied the buffers, while the discard bio
reports only the discard operation's own status.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
Changes in v2
  - fix how dirty bios are handled and how errors are reported

 drivers/md/dm-ebs-target.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 1e52bde48b91..5bdd1bf6c206 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -176,8 +176,8 @@ static void __ebs_forget_bio(struct ebs_c *ec, struct bio *bio)
 /* Worker function to process incoming bios. */
 static void __ebs_process_bios(struct work_struct *ws)
 {
-	int r;
-	bool write = false;
+	int r, rr, write_r = 0;
+	bool dirty = false;
 	sector_t block1, block2;
 	struct ebs_c *ec = container_of(ws, struct ebs_c, ws);
 	struct bio *bio;
@@ -209,9 +209,15 @@ static void __ebs_process_bios(struct work_struct *ws)
 		if (bio_op(bio) == REQ_OP_READ)
 			r = __ebs_rw_bio(ec, REQ_OP_READ, bio);
 		else if (bio_op(bio) == REQ_OP_WRITE) {
-			write = true;
 			r = __ebs_rw_bio(ec, REQ_OP_WRITE, bio);
+			dirty = true;
 		} else if (bio_op(bio) == REQ_OP_DISCARD) {
+			if (dirty) {
+				rr = dm_bufio_write_dirty_buffers(ec->bufio);
+				dirty = false;
+				if (rr && !write_r)
+					write_r = rr;
+			}
 			__ebs_forget_bio(ec, bio);
 			r = __ebs_discard_bio(ec, bio);
 		}
@@ -224,11 +230,15 @@ static void __ebs_process_bios(struct work_struct *ws)
 	 * We write dirty buffers after processing I/O on them
 	 * but before we endio thus addressing REQ_FUA/REQ_SYNC.
 	 */
-	r = write ? dm_bufio_write_dirty_buffers(ec->bufio) : 0;
+	if (dirty) {
+		r = dm_bufio_write_dirty_buffers(ec->bufio);
+		if (r && !write_r)
+			write_r = r;
+	}
 
 	while ((bio = bio_list_pop(&bios))) {
 		/* Any other request is endioed. */
-		if (unlikely(r && bio_op(bio) == REQ_OP_WRITE))
+		if (unlikely(write_r && bio_op(bio) == REQ_OP_WRITE))
 			bio_io_error(bio);
 		else
 			bio_endio(bio);
-- 
2.43.0

