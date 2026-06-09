Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE86C22A1D4
	for <dm-devel@lists.linux.dev>; Tue,  9 Jun 2026 00:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780965107; cv=none; b=ndbi0khXY9B+/jY0b4e6ZbPbjfZAZjGiUo9UDk/7XbY7FCeEL3HNr1HNoyzPxV6CLNGVhsQFLsUPBsUoXkBp7Uh5rIHhG0kPKJIc1pRTwAzyTGTDfiCXZ4KbIvAyFZDBUP8Po7JCUU0/TLEMIcqgIzDjMXm/G9dwdaH2XzhdxUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780965107; c=relaxed/simple;
	bh=7ke8JB7+fiM0iJds0haxDqSsDY4qCARA0M53wqqrcDA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ee8oHLpApeSmCX/ny9QNJhStgDMV2Fqesev5cVgcsLdk3rW7iD/QdEGkYXgy3OEV0Fh5SHiwYgqc/zw1+tzunBMdCtnHlkk/meP5SP5o22MLkO3av6CDFEmgK8wYPelNl6dpsZ0WXQKTg8t4jKNIkWXmJoAuWUk5OB9FHoMYeV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=FB41rDK0; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="FB41rDK0"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-59cfbfe64baso1651601e0c.2
        for <dm-devel@lists.linux.dev>; Mon, 08 Jun 2026 17:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780965105; x=1781569905; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YKCMOQJcrAbA4HuK0fOhxpcyoQ6N78Rk5hD/FklPw10=;
        b=FB41rDK0E1iGSeqQTHJxWcxKMjGMs8FTCjwCx8x2xe4fIML1Mxqjw+nUDXp5nYW/vi
         Ht7g6JuF8Z3PTfDk2MTwPW0OaolxU/kew/XAaDUDoeR7tgs2Q5JOjSYq0gX8pLVKklZp
         EVIfGpQqVsqXv5VXoWp7MD2F+OtbpsHEM19KA8HWQ3QA9sFyEQwO6B72tsYGTcXJWFx7
         u2gnLiWWijKcoYH2mZYjxBQdEPqyBCBRpgckl7vJv4sVCSiPx6jkuN8iLIUE3GbxAtKj
         9ZczNsms6i7t8sJkQsc+AWJWPBBWiw71P216NjrnDB1UqoshC0bYi5T09PeN2yIHl/Qx
         v9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780965105; x=1781569905;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YKCMOQJcrAbA4HuK0fOhxpcyoQ6N78Rk5hD/FklPw10=;
        b=ebzRIPa5xi4ySl2rAuIIqcb57RNJMBftQHKqTI0LGg0KbjwxcFVhxSntAIU2SQoXmt
         ZHjG3najjPq7Sffbj8VmN2PgtFQBWcj91NKkTA4SvMNuGupdDsWI6qVoR7bTZ2zFb/8B
         1hW1CjV1ofUMS8s//4uCZ6Z2CZXqOwhZuceQYgLH0DXr4O+a1dL4cTqvmMOSLhJxIjEU
         rp0t+m4CxuhpU5d1bzvqSQPW32YXmMKphe7HiOpcqtSj8mT+QZZT2E06nakj0M0CA8iV
         7R9RsfYcmbtZGV2AxxmJUUXXKYq9vqcXHDnZeVbOGPXJC/VqCacBNaEUwFqWFX1azJs8
         uLCA==
X-Forwarded-Encrypted: i=1; AFNElJ8HOD3hL0+z7CsZiaBXCTYmheGtjjxQ5FjNKwlBNPR+cAKa9O3yMX9y5avBCEgFDxkTuVgm3GgLfQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyO4xHaTo2KoJ31iNF3ooJ45+Q8l0LdS1ufE63PTokFCH+Vf3au
	9fX3/L5i19REL1ojYmnd4csb6AylGM8AcY1wYG36V2pVlidlA8JstN4AYrYqmfUuoOs=
X-Gm-Gg: Acq92OHOYKovgHW6CGuD2n7pknfHiWdwb0M16upe8kVh/J+9C7eSx7etb6vBDcm4id3
	QoN8YIsq9nabAbY3kGDyKl0UHLLUtu1iV482RQXLYWHgLs30HWvc87VAqt7Sw7k/OYoQdEvk0Rd
	yMOe+xD74dz6Rkd5z6RBAUGw8ta+IDKH+Q27FDt75Dj+/0Qe6SupKNe/KzRyIZbU2nvpv8ueJhh
	aI6yz9IeGAiyFI19Fj/hxa9l6Oel1P+8dirlPXt6Sf43q5xyZ3ATy7QAOh6KFDsT/A9WMUDyMG8
	4Lajd4Iv3Z0tm1sveCSCnUhE9Ix2hqKE8vTkocHXpcvI6AP6kULYuuHUv94wHQanVfNNMc8ow8t
	k+e6pODg1oV/viCxLLGShPHnYmx8ggjSUSjIxYFAmE5gn1ylsiWccsRj7GSfBo31l2ROd4XmODa
	ftcSnxp3eBBwuiDSqT9Uo5IQGNJurGTIv5cbhG+A==
X-Received: by 2002:a05:6122:4692:b0:5a6:7838:d679 with SMTP id 71dfb90a1353d-5ac52c09f1amr8723686e0c.13.1780965104943;
        Mon, 08 Jun 2026 17:31:44 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-8ceccdb94b5sm187192576d6.15.2026.06.08.17.31.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 17:31:43 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm stats: report actual length for final partial stats row
Date: Tue,  9 Jun 2026 00:31:12 +0000
Message-ID: <20260609003111.1236975.394ba1811bb8.dm-stats-print-final-step-length@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm_stats_print() emits each row as "<start_sector>+<length> counters".
For a region whose length is not an exact multiple of the configured
step, the last row is shorter than step. The code already clips the row
end to s->end, but still prints step as the length.

Print end - start so the final partial row describes the range that is
actually covered by that row.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/md/dm-stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index c53cf07ab7b0..99e767f892a0 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -895,7 +895,7 @@ static int dm_stats_print(struct dm_stats *stats, int id,
 
 		DMEMIT("%llu+%llu %llu %llu %llu %llu %llu %llu %llu %llu %d %llu %llu %llu %llu",
 		       (unsigned long long)start,
-		       (unsigned long long)step,
+		       (unsigned long long)(end - start),
 		       shared->tmp.ios[READ],
 		       shared->tmp.merges[READ],
 		       shared->tmp.sectors[READ],
-- 
2.43.0

