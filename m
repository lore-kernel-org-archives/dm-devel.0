Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792693184;
	b=FPW19+hOZ2idahtuDx4OEHd+U3BHwaoEinitIzqXZooi7ijgHAGO8hoKQ4DSegdCNO4z
	 VKgemSeIrE7SRnzz1HBUjd0KOwCaZDhT9yI+jvJCI+v1iIk9r5fOLBD27Ll3Z6MHOzTzg
	 9EA3AFXuFq2X0oBmZbSKZL7qshyFwzEJl8eQWK0xDkcoKir/93POL2Os/p1ACMmpM3DO3
	 A47nbVUV8uG8sXqmP5QlWuubAwhz9KCdIkX0Xy909IrLxNSlhhWn/BdT+ZAfzaYgKWNoV
	 qPWC5xAgYeyXkigNSvdf+n2QTjFgHMqiqQXR2/kE4JSaQknlMa8AA121jTQu4nHPGiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792693184;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=V68G4ECg0nxR7NLcm3kWEbTu8pdqcWjj0F2hAFNOQxw=;
	b=YqzBxwDMe8xVM5AbGhRKMDBwjeSbwawp66pqgSAlRcs6dOmLRMP7iKOk/pNRYQQlJsS8
	 1UFZzzNwvd7zfr+VjCrlpOHQXMsPC8eDDXWkYS1ngLCqk8sctEnfH7zkoQ0fetpRdOBnX
	 auxPsb3rZiC22qligqC+Elp60HLmTE2w2CfNrDBzyapBYl1dh1krSF7Uih/x7WAOrEOEO
	 oWnljRZKduxy37m21kuQcS59FOwdRuYw7KzgCaT5G7IPxoX58kwB1+mxLPqe6YPhPjpY7
	 Nc0UCaKcnuSaAMfaJPomByGzk3TobUjvt0m3Tcmc1M4m7POhK+4YlaIxCNeZZ4n90Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=artiphishell.com;
	spf=pass smtp.mailfrom=artiphishell.com;
	dkim=pass header.d=artiphishell.com header.i=@artiphishell.com header.a=rsa-sha256 header.s=google header.b=QXZALAlD;
	arc=none smtp.remote-ip=209.85.161.49
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DD5606A31D
	for <dm-devel@lists.linux.dev>; Thu, 22 Oct 2026 18:19:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9DD5606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=artiphishell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=artiphishell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=artiphishell.com header.i=@artiphishell.com header.a=rsa-sha256 header.s=google header.b=QXZALAlD
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6dde81a6820so62256eaf.2
        for <dm-devel@lists.linux.dev>; Thu, 22 Oct 2026 11:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=artiphishell.com; s=google; t=1792693183; x=1793297983; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=V68G4ECg0nxR7NLcm3kWEbTu8pdqcWjj0F2hAFNOQxw=;
        b=QXZALAlDVB6ve4A+E9NZX1qQ0mwHd+Xl0g7R4pSYEBYVpPG5QZO0wYXey8zcOZNO2p
         zmVqpHe95pgJUtKcKM6tCRMBVxW2ih1k64d4e7BuVaiyaSz3rN5ZcH6Gb+Cl6G1DZGSt
         s6kqdSZAyspmQvhlTmfSbfmIKxew1NiDG0pP5Nq57xy0bLOERz324GKxOg4+TR6UamkX
         aKumg/m2t+iv6jrTujewEQpZettloYW3K8DOWIwRWLsDj0n1okNmwlTGlFXFidq5kitj
         6bE0Az8BwtlUF5BBAoYXWENnIYfH8WVeKIsXXBcwtklwN4HFCY0CJdfZRghvF40/koz3
         y37Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792693183; x=1793297983;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V68G4ECg0nxR7NLcm3kWEbTu8pdqcWjj0F2hAFNOQxw=;
        b=kC0SdaR0sXRcRG9u6l7AhhPo0Pbvvtdghm+vRp9TrGpiiKAV0qIVyGnLdFBtH1nC2/
         zWL25h40HnK+e9HjLsrjydzyLW9bWoMsu9AwiI5ajykGr63Aat7761fkSiKo7g0jk2Se
         FHLX0+jeSUI9oJyNv5Yuw+ihv6OH6TrBF7Sk2EwcyJNQ18Q5xThZafcmjlpTW2uhDHrG
         4LMDCM587DOsCmvIn8jRFZTVzUwlz4GGTLzaVJH2NBBY/r34UBT6lucqV3zEZDKXQkFR
         nNIN+U5YccvF3zBoM3y5J9BRPSzFrkkApfvvVjfckAMBmOgKgIU+T7P+EkYc+Q4Kjf7o
         rJ0w==
X-Gm-Message-State: AFq9FYISWkYmPt61BX6kAKf1I54ikWQ2Vk2pJe9cgiGWgJQ6Jh8UML6X
	EFLI97v4SZ2Kyf+zSvzAlMGFCv9joAAVz3HQ0zBtqzUfu3eqgajVSZhZvFwI8l62Od5w
X-Gm-Gg: AYBFou3TLmtj/RkIuemHKPXzCvloPyl38LBy69lziu8nfqPzzUjmXhO2uphUbIK8vRi
	OqxL6ah+rdbwC6zdGDzDyv7yZm1QkLUU7GR3puW04syWOy6NwAR7ccTgMFrdZT5+rptiWYJ3Mue
	PWzj4aINbzZMwHofkCY4aMYE6S3Pw0NSwpEMpc7W/u3BnZCWWQfLV/x6Fx2XurdV4R+pPGaAktm
	nB+THhAFlE0K+3SaZdO/AwffzzLFOvh4yPRbHUiMuGHOk+qXn3AEqh+0QslyVLFgiuXa4SeI/C9
	kjGff7GeZKmNc59MrnPUPi1WuXdXDeKIcWwvRGGy+x2kzU8WfxwGjvXP6H1TMpVsSRnC98PHcbH
	zqooOUVQQjoBB6QjrXUaT2QrGEa7f0LrXeScco+GVzZBn6VU6Lm/yWQXDXxmNTNfWgTtFIsjSub
	1gXx5/Yj/cbBzc7USfV0uO+JL7wxMbVA9lEYMvOS/tJRsS22TXX5C3OCM/N88fB5V9bCfefE77u
	yycAAZqi6ofEhkJRP2rKRkqDVAZfHvnPn1jXmtXNBQcARkHAeZu
X-Received: by 2002:a05:6820:4589:b0:6dd:25a3:94cd with SMTP id 006d021491bc7-70b88a87127mr172354eaf.52.1792693182739;
        Thu, 22 Oct 2026 11:19:42 -0700 (PDT)
Received: from nixos ([2601:280:4a87:2c8d:3b7b:2fa6:c84c:64a7])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-70b895f270bsm12151eaf.2.2026.10.22.11.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 11:19:41 -0700 (PDT)
From: Jay Vadayath <jay@artiphishell.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jay Vadayath <jay@artiphishell.com>
Subject: [PATCH] dm-raid: bound array_position before indexing failed_devices
Date: Thu, 22 Oct 2026 11:19:34 -0700
Message-ID: <20261022181934.35685-1-jay@artiphishell.com>
X-Mailer: git-send-email 2.51.2
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

super_init_validation() reads role = le32_to_cpu(sb2->array_position)
out of an on-disk dm_raid_superblock and then uses it as a bit index into
the failed_devices bitmap via test_bit(role, (void *)failed_devices).
failed_devices is a uint64_t[DISKS_ARRAY_ELEMS] (DISKS_ARRAY_ELEMS == 4,
i.e. 256 bits) living on the stack. The only guard is role < 0, so any
on-disk array_position >= 256 makes test_bit() read past the end of the
stack array (array_position == 256 reads failed_devices[4], 8 bytes past
the object). For a raid1 set the role != raid_disk reorder branch falls
through to the same test_bit().

A crafted dm-raid superblock therefore causes a stack out-of-bounds read
during table load. Reachable by anyone able to issue a dmsetup create
with attacker-controlled metadata (CAP_SYS_ADMIN in the target
namespace); the crash fires in the constructor / analyse_superblocks
path, before any md_run or array sizing.

  BUG: KASAN: stack-out-of-bounds in super_validate+0x1cd0/0x3390
  Read of size 8 at addr ffff888007b17828 by task poc/152
  Call Trace:
   dump_stack_lvl+0x64/0x80
   print_report+0xd0/0x630
   kasan_report+0xe5/0x120
   kasan_check_range+0x105/0x1b0
   super_validate+0x1cd0/0x3390        (super_init_validation, inlined)
   raid_ctr+0x2c4b/0xa0f0
   dm_table_add_target+0x66f/0xf80
   table_load+0x2ee/0x780
   ctl_ioctl+0x362/0x9f0
   dm_ctl_ioctl+0x9/0x10
   __x64_sys_ioctl+0x134/0x1c0
   do_syscall_64+0xe2/0x4b0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

role is a device position that must refer to an actual member of the
array, so reject anything outside [0, rs->raid_disks) instead of only the
negative case. rs->raid_disks is always <= the 256-bit capacity of
failed_devices, so this both closes the out-of-bounds access and matches
the intended semantics.

This bug was discovered by Artiphishell's vTriage pipeline, which
generated a crafted raid1 superblock (magic "DmRd", compat_features=1,
num_devices=2, array_position=256, level=1) and a dmsetup-create
reproducer that reliably triggers the KASAN report on an unpatched kernel
(the precursor DMINFO "raid device #256 now at position #0" is visible in
the serial log just before the splat). The fix below was drafted with the
Claude coding assistant; a userspace reproducer is available on request.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jay Vadayath <jay@artiphishell.com>
---
 drivers/md/dm-raid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8f5a5e1342a9..d497d7c68596 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2420,7 +2420,8 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 		 */
 		if (!test_bit(FirstUse, &r->flags) && (r->raid_disk >= 0)) {
 			role = le32_to_cpu(sb2->array_position);
-			if (role < 0)
+			/* Bound @role before it indexes the failed_devices stack bitmap. */
+			if (role < 0 || role >= rs->raid_disks)
 				continue;
 
 			if (role != r->raid_disk) {
-- 
2.51.2

