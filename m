Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC1333C183;
	Fri,  6 Feb 2026 05:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354117; cv=none; b=KoKi3lnRl+fkZhchEv11guU8qaxBDRc9O/0gCyGuC9OZL99W1C4CObNSBd9+KmAn6iLW10FEMh4eOcqQNzKER/jpy/S8vE2U9/V6PjHS3jkukC6xkIFntH1K04L2hq1ctBw26O/UiNebWfF6Ia04W3Qb4LpmQsOavyFm2pBkwHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354117; c=relaxed/simple;
	bh=EimmtiTLQrF3E7DUZrtI9fJXkoOVz3amkyBv+hDIiC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTOYtveRY09tOqD6Efb4idmND/LIIyyDJsWqVRPeexwcbpcHAI+QUqNggQG3NHfsfejygUdN65O6ns5jLC+pf+ES8kRnze8WUo0ci6ygksMwKaWUixyoMuQlDb+9ZcOxe1P/GD3vqqITQcht9L1ZLoo8ffKFvutCAT6uymuImy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R1icAi/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1icAi/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEECC16AAE;
	Fri,  6 Feb 2026 05:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354116;
	bh=EimmtiTLQrF3E7DUZrtI9fJXkoOVz3amkyBv+hDIiC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1icAi/iVUx7AGGZ9dVB114ep+eG7MdzVCzkcXA/wCD3b5H1iq/F4farm2kSCs2YD
	 /ItQzzF9YEOdRBkiu329TKotwRomcCH23vO/+45IWINqIAcLbsbc/xuiqYkfOBZ4qj
	 ZWGKBWd/7juqzeT5suUFOu81LGLud3JBI20fgIXFoHkjDlJdlVwQc2/If3ia4bbdRt
	 tQeil9DldeJc6FOtBA91dDpUufsuudJWpNj0TOQMm8ZGFgFIggbJL2WqTqXD9lOyuZ
	 t7qK0lSV5FaamqBNE3v6PJmOtBOjXm3XyCiq3p1kOI8VeWxGlyUrxEr+dxgzNk9n8b
	 p90hncQASXGDg==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 07/22] dm-verity-fec: improve documentation for Forward Error Correction
Date: Thu,  5 Feb 2026 20:59:26 -0800
Message-ID: <20260206045942.52965-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206045942.52965-1-ebiggers@kernel.org>
References: <20260206045942.52965-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update verity.rst to add a dedicated section about FEC and improve the
documentation for the FEC-related parameters.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 .../admin-guide/device-mapper/verity.rst      | 122 +++++++++++++++---
 1 file changed, 102 insertions(+), 20 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
index 3ecab1cff9c64..eb9475d7e1965 100644
--- a/Documentation/admin-guide/device-mapper/verity.rst
+++ b/Documentation/admin-guide/device-mapper/verity.rst
@@ -100,33 +100,46 @@ ignore_zero_blocks
     Do not verify blocks that are expected to contain zeroes and always return
     zeroes instead. This may be useful if the partition contains unused blocks
     that are not guaranteed to contain zeroes.
 
 use_fec_from_device <fec_dev>
-    Use forward error correction (FEC) to recover from corruption if hash
-    verification fails. Use encoding data from the specified device. This
-    may be the same device where data and hash blocks reside, in which case
-    fec_start must be outside data and hash areas.
+    Use forward error correction (FEC) parity data from the specified device to
+    try to automatically recover from corruption and I/O errors.
 
-    If the encoding data covers additional metadata, it must be accessible
-    on the hash device after the hash blocks.
+    If this option is given, then <fec_roots> and <fec_blocks> must also be
+    given.  <hash_block_size> must also be equal to <data_block_size>.
 
-    Note: block sizes for data and hash devices must match. Also, if the
-    verity <dev> is encrypted the <fec_dev> should be too.
+    <fec_dev> can be the same as <dev>, in which case <fec_start> must be
+    outside the data area.  It can also be the same as <hash_dev>, in which case
+    <fec_start> must be outside the hash and optional additional metadata areas.
+
+    If the data <dev> is encrypted, the <fec_dev> should be too.
+
+    For more information, see `Forward error correction`_.
 
 fec_roots <num>
-    Number of generator roots. This equals to the number of parity bytes in
-    the encoding data. For example, in RS(M, N) encoding, the number of roots
-    is M-N.
+    The number of parity bytes in each 255-byte Reed-Solomon codeword.  The
+    Reed-Solomon code used will be an RS(255, k) code where k = 255 - fec_roots.
+
+    The supported values are 2 through 24 inclusive.  Higher values provide
+    stronger error correction.  However, the minimum value of 2 already provides
+    strong error correction due to the use of interleaving, so 2 is the
+    recommended value for most users.  fec_roots=2 corresponds to an
+    RS(255, 253) code, which has a space overhead of about 0.8%.
 
 fec_blocks <num>
-    The number of encoding data blocks on the FEC device. The block size for
-    the FEC device is <data_block_size>.
+    The total number of <data_block_size> blocks that are error-checked using
+    FEC.  This must be at least the sum of <num_data_blocks> and the number of
+    blocks needed by the hash tree.  It can include additional metadata blocks,
+    which are assumed to be accessible on <hash_dev> following the hash blocks.
+
+    Note that this is *not* the number of parity blocks.  The number of parity
+    blocks is inferred from <fec_blocks>, <fec_roots>, and <data_block_size>.
 
 fec_start <offset>
-    This is the offset, in <data_block_size> blocks, from the start of the
-    FEC device to the beginning of the encoding data.
+    This is the offset, in <data_block_size> blocks, from the start of <fec_dev>
+    to the beginning of the parity data.
 
 check_at_most_once
     Verify data blocks only the first time they are read from the data device,
     rather than every time.  This reduces the overhead of dm-verity so that it
     can be used on systems that are memory and/or CPU constrained.  However, it
@@ -178,15 +191,10 @@ tampering with any data on the device and the hash data.
 Cryptographic hashes are used to assert the integrity of the device on a
 per-block basis. This allows for a lightweight hash computation on first read
 into the page cache. Block hashes are stored linearly, aligned to the nearest
 block size.
 
-If forward error correction (FEC) support is enabled any recovery of
-corrupted data will be verified using the cryptographic hash of the
-corresponding data. This is why combining error correction with
-integrity checking is essential.
-
 Hash Tree
 ---------
 
 Each node in the tree is a cryptographic hash.  If it is a leaf node, the hash
 of some data block on disk is calculated. If it is an intermediary node,
@@ -210,10 +218,84 @@ The tree looks something like:
                     /  . . .  \                 . . .   \
          [entry_0_0]   . . .  [entry_0_127]    . . . .  [entry_1_127]
            / ... \             /   . . .  \             /           \
      blk_0 ... blk_127  blk_16256   blk_16383      blk_32640 . . . blk_32767
 
+Forward error correction
+------------------------
+
+dm-verity's optional forward error correction (FEC) support adds strong error
+correction capabilities to dm-verity.  It allows systems that would be rendered
+inoperable by errors to continue operating, albeit with reduced performance.
+
+FEC uses Reed-Solomon (RS) codes that are interleaved across the entire
+device(s), allowing long bursts of corrupt or unreadable blocks to be recovered.
+
+dm-verity validates any FEC-corrected block against the wanted hash before using
+it.  Therefore, FEC doesn't affect the security properties of dm-verity.
+
+The integration of FEC with dm-verity provides significant benefits over a
+separate error correction layer:
+
+- dm-verity invokes FEC only when a block's hash doesn't match the wanted hash
+  or the block cannot be read at all.  As a result, FEC doesn't add overhead to
+  the common case where no error occurs.
+
+- dm-verity hashes are also used to identify erasure locations for RS decoding.
+  This allows correcting twice as many errors.
+
+FEC uses an RS(255, k) code where k = 255 - fec_roots.  fec_roots is usually 2.
+This means that each k (usually 253) message bytes have fec_roots (usually 2)
+bytes of parity data added to get a 255-byte codeword.  (Many external sources
+call RS codewords "blocks".  Since dm-verity already uses the term "block" to
+mean something else, we'll use the clearer term "RS codeword".)
+
+FEC checks fec_blocks blocks of message data in total, consisting of:
+
+1. The data blocks from the data device
+2. The hash blocks from the hash device
+3. Optional additional metadata that follows the hash blocks on the hash device
+
+dm-verity assumes that the FEC parity data was computed as if the following
+procedure were followed:
+
+1. Concatenate the message data from the above sources.
+2. Zero-pad to the next multiple of k blocks.  Let msg be the resulting byte
+   array, and msglen its length in bytes.
+3. For 0 <= i < msglen / k (for each RS codeword):
+     a. Select msg[i + j * msglen / k] for 0 <= j < k.
+        Consider these to be the 'k' message bytes of an RS codeword.
+     b. Compute the corresponding 'fec_roots' parity bytes of the RS codeword,
+        and concatenate them to the FEC parity data.
+
+Step 3a interleaves the RS codewords across the entire device using an
+interleaving degree of data_block_size * ceil(fec_blocks / k).  This is the
+maximal interleaving, such that the message data consists of a region containing
+byte 0 of all the RS codewords, then a region containing byte 1 of all the RS
+codewords, and so on up to the region for byte 'k - 1'.  Note that the number of
+codewords is set to a multiple of data_block_size; thus, the regions are
+block-aligned, and there is an implicit zero padding of up to 'k - 1' blocks.
+
+This interleaving allows long bursts of errors to be corrected.  It provides
+much stronger error correction than storage devices typically provide, while
+keeping the space overhead low.
+
+The cost is slow decoding: correcting a single block usually requires reading
+254 extra blocks spread evenly across the device(s).  However, that is
+acceptable because dm-verity uses FEC only when there is actually an error.
+
+The list below contains additional details about the RS codes used by
+dm-verity's FEC.  Userspace programs that generate the parity data need to use
+these parameters for the parity data to match exactly:
+
+- Field used is GF(256)
+- Bytes are mapped to/from GF(256) elements in the natural way, where bits 0
+  through 7 (low-order to high-order) map to the coefficients of x^0 through x^7
+- Field generator polynomial is x^8 + x^4 + x^3 + x^2 + 1
+- The codes used are systematic, BCH-view codes
+- Primitive element alpha is 'x'
+- First consecutive root of code generator polynomial is 'x^0'
 
 On-disk format
 ==============
 
 The verity kernel code does not read the verity metadata on-disk header.
-- 
2.52.0

