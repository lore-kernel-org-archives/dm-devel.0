Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E902134CCF
	for <dm-devel@lists.linux.dev>; Sun,  4 Oct 2026 10:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791109028; cv=none; b=iuJB3uhpJicPJgLyvL32Y2fI81szzgMhgZ4RWQct7Bzzp7iCxo42ahVU9g29wRqmpyCyfF5JPqLDtnPSOUsqq7YYGFso5k5PVJ3sd/8DuUpZmaTHeVnL2NzhcSxiNLS1PwwemBo/wo47dp55xtOz6B+U2EqSbBurPRvDHrXFsmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791109028; c=relaxed/simple;
	bh=TqOTmq/yqt4X48ByT3CHpiQMcfSnIr6FZTijTvhLnCw=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=DTXMSWjt0i0593LSTB6isAsBl8Nb9oHkK+ZylAAXadPLs/v+QgRirlAXiuasQcljq9QnFFn3+Si+g16AZgE5vuz1hpm4PnI4uT+I9YszPTSHSIvQwQ3o+Y1GXp4EqeYi3NjWbbj6EQooyIVt2d84dpT+LIfZ2IjW1qMIgkOSD0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JevoW6gP; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JevoW6gP"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49d1ddd5d0aso289945e9.3
        for <dm-devel@lists.linux.dev>; Sun, 04 Oct 2026 03:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791109025; x=1791713825; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OW15eEn6Sigou5G6oIcfaDItgZ8Hirf/PtUeQhnIzDY=;
        b=JevoW6gPE1t/2myJpA8MQPmcJJQCWlKVymxP1zkrC93waICD65KtSjrZnfoaYQp6az
         pQVCsSN8ggQUYp8lyV1rb4h/Z23MjbGdTxr5Ad33IQYpXxrRkLywTH96c1/IjoHt68Qg
         vwFkKQ1lsZUCPhIsqrUJf4NU0ssX3Ztvf3PID/+g0p1h7O5mnwKldjsdBiXdpNF0A9fl
         LGsfRxybYbcGp78bx5A9LkVVWvNOXtRChixtO8a+nR8EzXbGWXqkJHifRlOunyjdFrBh
         CJ351WW+RD/h0HKGz8ctnHQ9EB3snW9TXxsYLPBO0k+nkqHFDmES8UdFOHyXPMHGxDph
         kt1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791109025; x=1791713825;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OW15eEn6Sigou5G6oIcfaDItgZ8Hirf/PtUeQhnIzDY=;
        b=Y+Vc/kbUywmRH0GBekT5ZCoAu+DsDf5V0TBuavOhnNgfy+Y0MMfVXpBwucoS7OuPuA
         0KxqlX3BOF1llzy/nHAnbTARSVCEoMcyByD2xK5ohnAziieWK4FEyBClh2CU4ILlOKAh
         fPXfWh31Jxwowvh7czJ8lOLtH408yg4cvrD6gaYtsJfFLVQ+yx3DqFV1/gdUZdprZFLi
         aZoRbkhkYK/pHGW1KPTlThQtA2EXmq5GDSxfV60HEfymM8PkZ+022bZL4a+eqRRuxcfX
         1VrilqVpILRJll4b5tLZ5QhBXAMjXP91gHBMj9PaYfWte/ykueXNYkkuFiILHFL400nF
         3pgg==
X-Forwarded-Encrypted: i=1; AKwUvByD7yz4E6cC4HsMAJ3qKuqgLOzpf5raR+OXAJJ3RHlICBoEG9dpM7Ko9JIvwO8znle30e3br9oR0Q==@lists.linux.dev
X-Gm-Message-State: AFuF++nzX08sKCZdwsuOnWVrbvnCxB9WJz3mnhPkNaBNX1AQwbZdCj+5
	Gl9BMsTv3sEv86JvyITIUiyif9U0c8NAnxqsfawD+PEUQLnWmcVUwE8R
X-Gm-Gg: AYBFou0YCLSiqNjA9StAncNOM87kXJh+Yd+xLs6fy+ws+RFAd/dWLT+7tHO4tRCT9ck
	Ds/zgfc/4BfTP6GaopXi1sWLvD5K9avPi+oi6+azv+RkCXbWkz8RtkmUxVsrJzrmouAQXOqV4zN
	O6VHqF8xHVkHVC6gKlKZZOWRyYMbWgNikqpJIH0us3Av9OgweiJ5RY+2zdE+iCY0AWMKzy7AFpz
	QLn0xK9Q1Nxb5GSIFQ+EKVCgXAehCSB0REf7Ma4rQZV1zY+0uN57wd7c6dS1CN+pdFkuF8nennR
	6xvkLvNI7WDXXHlEOEbf7c20M+kMP6JwDKSOgycvjxvf5c43zwwhVxTKfGBvC20xM1V96XIeR1P
	sM17VgDtqD764VqE1jZZQb3/dFZPqM7eKFky7puaFDmq6rQxpexcqrr3kJfd8i23uGHwtyN0NZZ
	tGXI3czZUd334Dwfw7WmTV4mKDck4Nmn6ONYcarE4xmWIvmjI1AFC5DX5tq5XG0ucQrYsh089yK
	stJUkXXxB2tSeSEU04=
X-Received: by 2002:a05:600c:601:b0:4a0:73b:a222 with SMTP id 5b1f17b1804b1-4a02744cc57mr88146065e9.0.1791109024484;
        Sun, 04 Oct 2026 03:17:04 -0700 (PDT)
Received: from L-P-ITAIH2-L-RF.rf.local ([193.169.70.108])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1698f7910sm73030505e9.3.2026.10.04.03.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 03:17:04 -0700 (PDT)
From: Itai Handler <itai.handler@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	dm-devel@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Milan Broz <gmazyland@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 0/1] dm-crypt: allow encryption sector size up to PAGE_SIZE
Date: Sun,  4 Oct 2026 13:16:21 +0300
Message-Id: <20261004101622.2184287-1-itai.handler@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-crypt caps the "sector_size:" option at 4096 bytes.  Commit
8f0009a22517 ("dm crypt: optionally support larger encryption sector
size") gives the reason: the sector has to fit the page limit, so the
cap was set to the smallest page size any architecture has.  This
resolves that same rule against the kernel being built instead, so a
kernel with larger pages is not held to another architecture's limit.

v2: https://lore.kernel.org/dm-devel/20260922120330.127262-1-itai.handler@gmail.com/
v1: https://lore.kernel.org/dm-devel/CAFpOueRBb9y_Fgb3-c6_eFTKZR9DoAXZmxqqx0UH1Yb2rbV0RQ@mail.gmail.com/

Changes since v2
----------------

- Dropped the dm-verity comparison.  Milan pointed out that dm-verity is
  read-only, so its PAGE_SIZE bound says nothing about a writable
  target.  It was never load-bearing; it is just gone.

- Dropped qce as the motivation.  Eric was right that it is slower than
  the CPU cipher and marked BROKEN, so numbers from it argue for
  nothing.  The commit message now works from the reason the limit was
  given when it was introduced, and mentions DMA offload only as a
  possibility that depends on the driver.

- Documented in dm-crypt.rst that a sector larger than the device's
  atomic write unit can be torn by a power failure, and what that costs
  in each cipher mode, AEAD included.

- Used MIN_T() rather than min_t() for the bound, so it stays usable as
  a constant expression; min_t() expands to a statement expression.

- Dropped the claim that the documented range tops out at 65536.  It
  does not: without transparent hugepages BLK_MAX_BLOCK_SIZE is
  PAGE_SIZE, so on a 256K-page configuration the bound is PAGE_SIZE.
  The documentation now states the rule rather than a number.

On refusing other cipher modes
------------------------------

Mikulas asked for sector sizes above 4096 to be refused for modes other
than XTS and ECB.  This version does not do that.  Since the decision is
his rather than mine, the patch for it is written and tested and will go
out on request.

What gives me pause is only this:

- An allow-list of two mode names has to be revisited whenever a mode is
  added, by someone who remembers why it is there.

- It gives 4096 a safety meaning that the block layer declines to give
  it.  nvme_configure_atomic_write() trusts only NAWUPF and otherwise
  falls back to a single logical block, and nvme_update_disk_info() caps
  physical_block_size by atomic_bs precisely so nothing above it assumes
  a physical block is written atomically.  A drive advertising no atomic
  write unit, which is the common case, can already tear a 4096-byte
  sector.

- Selecting on tear-tolerance alone admits ecb(), which nobody should
  use for disk encryption, while refusing cbc().

Against that, his point that the modes differ in how badly a tear hurts
is right, and v3 writes it down per mode in dm-crypt.rst - which is the
part I should have done in v2 instead of only arguing.

On a 64K-page kernel the restriction refuses aes-cbc-essiv:sha256 at
65536 while leaving XTS and ECB working, including ESSIV-wrapped XTS,
and changes nothing at or below 4096.  Either form works - patch 2/2 of
a v4, or a standalone follow-up - whichever is preferred.

Answering Milan on NVMe
-----------------------

"Which NVMe supports 64K sectors?" - none, and none has to.  The
encryption sector is dm-crypt's own chunking unit, not something the
backing device has to support.  bdev_logical_block_size() appears once
in the whole target, inside a max() that aligns the I/O size.  The
mapped device announces the larger block upward through
dm_stack_bs_limits(); the device underneath keeps its own.  In the
testing below the backing device is /dev/ram0 with a 512-byte logical
block, carrying a 65536-byte encryption sector.

Testing
-------

Built for x86_64 and for arm64 with 4K and with 64K pages; no new
warnings.  A temporary static_assert confirmed the bound is 4096 on
x86_64 and on arm64/4K - so the patch is a no-op on both - and 65536 on
arm64 with 64K pages.

Booted under qemu-system-aarch64, loading crypt tables over /dev/ram0
with dmsetup and reading back what the kernel recorded:

  sector_size   v1.29.0        v1.30.0, 4K   v1.30.0, 64K
       512      ok             ok            ok
      1024      ok             ok            ok
      4096      ok             ok            ok
     65536      EINVAL         EINVAL        ok, lbs 65536
     69632      ok, 4096 (!)   EINVAL        EINVAL
    131072      EINVAL         EINVAL        EINVAL
         0      EINVAL         EINVAL        EINVAL

Every row was run with aes-xts-plain64, aes-cbc-essiv:sha256 and
aes-ecb, and the result was the same for all three: this version refuses
nothing on the basis of the cipher.

The 69632 row is the truncation the patch fixes.  It wraps to 4096
today, the table loads, and the device announces a 4096-byte logical
block.  logical_block_size in sysfs followed the recorded sector size in
every accepted case.

Also exercised at 65536 on 64K pages: aes-xts-essiv:sha256, the capi:
form of xts(aes), and iv_large_sectors, which is where sector_shift
reaches 7.  256 KiB round-tripped through the mapped device
byte-identical at sector_size 65536 and 4096, with the ciphertext on
/dev/ram0 confirmed to differ from the plaintext.

Not covered: dm-integrity caps its block_size at 4096, so the AEAD and
integrity-tag paths cannot be driven above that today and were tested
only at 4096 and below.

Userspace
---------

Nothing is needed for this patch.  cryptsetup caps the sector size at
4096 on every path that writes a LUKS header, so no LUKS device gains a
larger sector however new the kernel is; on-disk format policy stays in
userspace, which was Milan's point in v2 and is why no LUKS2 change is
proposed here.  The LUKS2 header-validation patch posted alongside v2
was withdrawn - Ondrej was right that the missing bound is deliberate.

Itai Handler (1):
  dm-crypt: allow encryption sector size up to PAGE_SIZE

 .../admin-guide/device-mapper/dm-crypt.rst    | 20 ++++++++++++-
 drivers/md/dm-crypt.c                         | 30 +++++++++++++++----
 2 files changed, 43 insertions(+), 7 deletions(-)


base-commit: c0df022cb0fa2bbee74bd9b90c66790bcd4e3050
-- 
2.34.1

