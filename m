Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E40853D0D7
	for <dm-devel@lists.linux.dev>; Tue, 22 Sep 2026 12:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790078656; cv=none; b=sYhREphOuAxK7GLD7I4o/uCjDNDAbABzXxGPRKKkPfIVeFGHdPTAm/02CBHw/mYryIIZdFgivf8mSyKa6mPPMFM+AITKylKPws3iNZKOJR9o+09juH1v7uDmgGMyVJKOlF7GgF6FVSWppy2wn4iU2T2aiCgQocPG/DQq0IHHEw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790078656; c=relaxed/simple;
	bh=v22sBIzYdVl9buaoLnuNOFzN2VDCCr/DjOQhVovMXGs=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=hxQJ3Y2PhRUWnZCfRXwwme4lYs0taGYUgB3Gr95/uSNgfVN3D3rJCTID9yqU2Ad5sUJwnx9Ii5kIyyCQy4498+kuLxDeoOCPvw7Iy/LXuGaGSDRkybn6NQm3gZ7r55U2O+CWyDeRvDe3XEXD5tDfsOc7WqPkeus/gNo2SGBpu8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mz5QSOkd; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mz5QSOkd"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49fbfe95bccso686935e9.0
        for <dm-devel@lists.linux.dev>; Tue, 22 Sep 2026 05:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790078652; x=1790683452; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qml2PbOBMg4u6d68pHNR0xGKGyBdB48smU89SM0opl8=;
        b=Mz5QSOkdO+ICUkOVY0jeKOfDTFEZcY4ogIlzoNLrVh/8kCX9dhmaqgT2f4hKs4KuGP
         dnCEU1IZaog8wPzWltSnGXPdT1omSFtenuoBbumQ1R6tQk91QoZ9NTQHDXi7uSt5dYrc
         dPsqudDqgmg/5cqmsoR5LowdK3zPvEpCvFP5Qt4DRYVvuRu1t+rHHRzhQ3N79fp6H2uL
         Exx0SpM/8VVNBHTrbwpk+1+0NWe/3V4OcH1F4GReXJ15UOh59CQ4QeVnQqWAbahFHtRb
         MyCHfT9YPHTxmBG1SYHephiZefvk779fflIvC3eM64RwP2bDXAwikc+kaueoLW4l30R8
         sbpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790078652; x=1790683452;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qml2PbOBMg4u6d68pHNR0xGKGyBdB48smU89SM0opl8=;
        b=Ml+vJ9uiJipRtbRD+Pnj2dhLbM/MFBhPG8s/JwJeFBqxnMJlPDIFw3uYU2N+gCM9mO
         xspM/zyb3rqyYL6NwkAGi80hM7gfuwK0wdyW43qgLjYk+UZlVpkZDsB7nE5AKVfXHWbO
         JAv7kVRVB37yiERgQxSTMCFb0TNxS/nvR4gw498AsainCSWqIv0D7frdzfAlQqaJncTk
         4NWB6/0Ln2K3yq7yiYKLkEoJIYn1XyJf2B+oWayy69xVB5WkBSbS+pGdz9cPshHolm6r
         AY1MXonyTZeO/bt4pW4UHdrU7i+dQsYpD0Duc9tDZeI74xup3MloAgktXZozb4bNeCK4
         SEKQ==
X-Forwarded-Encrypted: i=1; AKwUvBxAseeGqOPjly9tNI1mU35v5txZaTLio5aoIUkwucyBDeNT1J1HUPnbOnTq9TFiToAAjMVkP0XtrA==@lists.linux.dev
X-Gm-Message-State: AFuF++mFeBSLhMYQztx0jyGP8GyneYfOkkFitMbKJwugGaCq37iRC4Ck
	C02h3neLsdwH2++utcoWIAFuJ4svMZ0qE2e0P7AIK4gVG2gBq4uenYrM
X-Gm-Gg: AYBFou1ITQelfpftNwHvh93Vu5ceJFyM0EWMaV2ayORXJDj1xMInckDh9En9nbFMDhf
	+Iq2ATb73jqp3mApTJUZP/j56/eGBlfplJynENAY59yJjzFf6RewmVmZU26kIex/PNY05/tOETx
	+f3TSIfhHehpNNAZxyWFjtPr6fh4hAPqvnmH2ABNaYzC7rU/khUTq6+omCNzFe/kja6DdQJqCMB
	oVjPzrz9ZLCfkx6r3b7We906hpGo9acinOuNSxx/sPCJKagVX7W6v/IxihysShhurHMFkZ2Qh7r
	TGhdscxL80b/CmjugV7B5NAdV3dESkJZIwOCrlv8Vb5J6dZirPVm/Bs7WFKltCUEyTKSDhqi9ub
	hMrv/J4n710dg+kCxFJNKrtL1sjOJIBWZC+/qkfTr2xcTkcrnTH4lmVyctZptNJIwyEfp8w3tnk
	smeKreFs3w8GOaQob8LpaEi+Eotv6OJdk43LnDiHPYVYOSG3tKwaTpOcySRIh94TlXgdcr1v2k0
	UgsrSP+q/FLNY5CiZE=
X-Received: by 2002:a05:600c:35c2:b0:49d:1da4:511b with SMTP id 5b1f17b1804b1-49fc7dd94c0mr206347865e9.1.1790078652203;
        Tue, 22 Sep 2026 05:04:12 -0700 (PDT)
Received: from L-P-ITAIH2-L-RF.rf.local ([193.169.70.108])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdab0c240sm32469425e9.4.2026.09.22.05.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:04:11 -0700 (PDT)
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
	Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v2 0/1] dm-crypt: allow encryption sector size up to PAGE_SIZE
Date: Tue, 22 Sep 2026 15:03:29 +0300
Message-Id: <20260922120330.127262-1-itai.handler@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-crypt caps the "sector_size:" option at 4096 bytes.  This raises the
cap to min(PAGE_SIZE, BLK_MAX_BLOCK_SIZE), so that a kernel with a
larger page size can use a larger encryption unit.

dm-verity already bounds its data block size exactly this way -
verity_ctr() rejects "num > PAGE_SIZE" - so this is the bound dm targets
already use, not a new kind of limit.  Nothing changes where PAGE_SIZE
is 4096, the default stays 512 bytes, and no table that loads today
stops loading.

This is v2 of

  https://lore.kernel.org/dm-devel/CAFpOueRBb9y_Fgb3-c6_eFTKZR9DoAXZmxqqx0UH1Yb2rbV0RQ@mail.gmail.com/

which was NACKed in 2021.  Below is what was objected to and what this
version does about it.

1. "4096 is the smallest page size all platforms support; with a larger
   sector the device cannot be activated on a platform with a smaller
   page size, and LUKS is portable by definition." (Milan)

   Agreed, and nothing here changes that for LUKS.  Portability is a
   property of the on-disk format, so it belongs to the format layer:
   cryptsetup caps LUKS at 4096 on every path that writes a header, and
   that is untouched.  What this patch changes is the plain dm-crypt
   mapping, which has no on-disk metadata and no portability contract.

   See "Userspace" below for the one place where that split needed
   tightening, and for what is already posted.

2. "Such a patch MUST increase dm-crypt minor version." (Milan)

   Done, 1.29.0 -> 1.30.0.

3. "It doesn't come with any understanding of all the nuanced reasons
   for 4096." (Mike)

   Fair.  The 4096 was two unrelated constraints in one number:

   a) the portability rule above, which belongs to the format layer;

   b) an implementation limit of dm-crypt itself: crypt_convert_block_*()
      passes one sector to the crypto API as a single scatterlist entry
      built from one bio_vec, bio_iter_iovec() never returns more than
      PAGE_SIZE bytes, and crypt_alloc_buffer() may fall back to order-0
      pages for the write bounce buffer.  That limit is PAGE_SIZE, not
      4096.  The patch states this in a comment next to the new bound.
      Letting one sector span several vectors would lift it further,
      but that is separate work.

   BLK_MAX_BLOCK_SIZE is in the bound because crypt_io_hints() announces
   sector_size as the logical block size and blk_validate_limits()
   refuses anything above that cap.  It does not lower the limit on any
   configuration that exists today - it is 64K only with transparent
   hugepages enabled, and the only architectures with a larger PAGE_SIZE
   (hexagon and ppc44x, both 256K) cannot enable them - so the effective
   bound is PAGE_SIZE.  It is there so dm-crypt cannot announce a block
   size the block layer would reject if that ever changes.  Happy to
   drop it and cap at PAGE_SIZE alone if you prefer.

4. "The numbers are from a proprietary driver and from tcrypt, which
   says nothing about dm-crypt." (Milan)

   The numbers below are dm-crypt throughput measured with in-tree
   drivers.

5. "No random access numbers; write amplification will hurt small I/O."
   (Milan)

   It will, in the same way a filesystem block larger than the I/O size
   does.  Nothing changes unless it is asked for.  Random access numbers
   are included below.

What has changed since 2021
---------------------------

"4096 is the smallest page size all platforms support" was also the
block layer's position in 2021.  It is not any more: 47dd67532303
("block/bdev: lift block size restrictions to 64k", v6.15) raised the
block size limit to 64K on the grounds that blocksizes larger than
PAGE_SIZE are now supported.  dm-crypt's 4096 predates that.

This patch is deliberately more conservative than the block layer now
allows, because of (3b) above: it does not go past PAGE_SIZE.

Numbers
-------

arm64, 64K pages, qce (in-tree Qualcomm crypto engine), plain dm-crypt
with capi:qcom-xts(aes)-plain64 over a 1 GiB ramdisk, fio with 1 MiB
blocks, --direct=1 --iodepth=4 --ioengine=libaio, MB/s:

  sector_size   seq read   rand read   seq write   rand write
        4096        13.3        22.8        27.2         24
       65536       581         582         586          588

arm64 Cortex-A53, 64K pages, xts-aes-ce (CPU crypto extensions), plain
dm-crypt over a Samsung 970 EVO NVMe, fio with 64 KiB blocks,
--direct=1 --num_jobs=32, MB/s:

  sector_size   rand read   rand write
        4096         966          841
       65536        1054          983

This only helps where a crypto request carries a large fixed cost, that
is with drivers offloading to hardware over DMA: a 64 KiB sector
replaces sixteen descriptor setups and DMA round trips with one.  A CPU
cipher has no such cost and gains little, as the second table shows.

Userspace
---------

LUKS portability is enforced by cryptsetup, and every path that writes a
LUKS header caps the encryption sector size at 4096.  No LUKS device can
be created with a larger sector however new the kernel is.

One gap is worth stating plainly rather than leaving to be found.  LUKS2
header *validation* never bounded that field: hdr_validate_crypt_segment()
only requires it to be non-zero and 512-aligned.  A header declaring
65536 is therefore accepted as valid today, and is refused only because
dm-crypt refuses the sector size.  On a 64K-page kernel with this patch
such a header would activate.  It is a header no cryptsetup has ever
written - it takes metadata corruption or a third-party writer to
produce one - but the check belongs in the format layer either way.  A
patch doing that is posted:

  https://lore.kernel.org/cryptsetup/20260922100554.28692-1-itai.handler@gmail.com/

It is not merged yet.  It is independent of this patch in both
directions: it is a correct fix for cryptsetup on today's kernels, and
this patch does not depend on it to be correct for plain mappings.

A second cryptsetup change, lifting the cap for plain mappings only and
gating it on dm-crypt 1.30.0, will follow once the target version here
is final.  LUKS stays at 4096 in it.

Testing
-------

Built for x86_64 and for arm64 with 4K and with 64K pages.  A temporary
BUILD_BUG_ON confirmed the new bound is 4096 on x86_64, so the patch is
a no-op there, and 65536 on arm64 with 64K pages.

Booted under qemu-system-aarch64 and loaded a crypt table over /dev/ram0
with dmsetup, reading back what the kernel recorded:

  sector_size:  v1.29.0        this patch, 4K   this patch, 64K
                 (4K and 64K)
       4096     ok, 4096        ok, 4096         ok, 4096
       8192     EINVAL          EINVAL           ok, 8192
      65536     EINVAL          EINVAL           ok, 65536
      69632     ok, 4096 (!)    EINVAL           EINVAL

v1.29.0 behaves the same on both page sizes, which is the point: 8192 is
refused today even where the page size would allow it.

The last row is the %hu truncation described in the patch - 69632 wraps
to 4096, the table loads, and the device announces a 4096-byte logical
block size.  logical_block_size in sysfs followed the recorded sector
size in every accepted case.

Exercised on arm64 with a 64K page granule: plain dm-crypt with
sector_size 65536 over NVMe, block level round trip, fio random
read/write with crc32c verification, and a filesystem round trip on the
mapped device, with KASAN, lockdep and kmemleak enabled.  sector_size
512 and 4096 were run alongside as a regression check.

Itai Handler (1):
  dm-crypt: allow encryption sector size up to PAGE_SIZE

 .../admin-guide/device-mapper/dm-crypt.rst    |  8 ++++-
 drivers/md/dm-crypt.c                         | 30 +++++++++++++++----
 2 files changed, 31 insertions(+), 7 deletions(-)

base-commit: 704340f1cd0dcef829eb62f5b48ae95a2ce17bdf
-- 
2.34.1

