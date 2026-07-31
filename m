Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1448377AA6;
	Fri, 31 Jul 2026 22:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785538495; cv=none; b=E9mhhIxpjkujARYzKUaCndiU/xXmI26mLGS67wZLBrtX9vhwJtwxq6+6ReAhRTXjAlaDWa4O7Fh55FQhgkk6CM1XD7H8LCih0ToaUD+Jg9USWqQ2K8L8nwMTbtFRlw3c8FomeSokB/00ibCFZoCqiJbaNdRScqswqywIqiuS+eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785538495; c=relaxed/simple;
	bh=3szjRRUOnQWAmqw62BCFpRphKGY+rm6LLuIDNM7/6Pg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=a8BRpVR0NyQbdNFkpHQZ1tQG+9s47hh+30e9jW3wTgb61zJrMTwvot6vdydJ8ttT1LVCpcqo0TpMxJgWchw+egFDCcolKmpYFs3sk8VtaX0seqGbaPzBc6AhMOoMhF4LjscmLhKy8CaEBFfqWA0JJxh+l6cnZfSECZUKyRdD+ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bEZbz5BD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bEZbz5BD"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9AAF7C2BCB9;
	Fri, 31 Jul 2026 22:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785538494;
	bh=3szjRRUOnQWAmqw62BCFpRphKGY+rm6LLuIDNM7/6Pg=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=bEZbz5BDAH6pOvX8XsI+NQlvyON3tsMvKQzezwuhBDvb9ofS1QVeRm0tNZc7+ZUu2
	 I/xYA6f1B5V1OzwbSzQQNciNYl2sKGe+N2zDV+fiWnA/f+i0l5L5Ctgr8/5y2j3gnw
	 pZvqGKwjygR54oNdcrbi/S8dIVHul2DCc8Z4idUd81cVA01Sw4gjXMYd/uAWaRkaoo
	 G0qkE1Ao1oQzgxCimUK46plHJeYsj2zK1cQH0rQbEjwJ1o7JMZRWBeMNrqrP3kvn9u
	 cAgx0leRgK+6trXkZQC9m0ODx+ncBOPdNZ5vojgPs/Kv3z/jyXkq3w0aIaz0zvcmxg
	 M7nIGI6UnKlow==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA0DC5516F;
	Fri, 31 Jul 2026 22:54:54 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Subject: [PATCH v2 0/2] dm array: validate array block headers, and against
 the caller
Date: Fri, 31 Jul 2026 17:54:53 -0500
Message-Id: <20260731-b4-disp-4fd3bed9-v2-0-7b1835e4e7f6@proton.me>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHQUlJIzE
 vPSU3UzU4B8JSMDIzMDc2ND3SQT3ZTM4gJdk7QU46TUFEtdYwvzZOO0VCBpYqQE1FZQlJqWWQE
 2MjoWwi8uTcpKTS4BmaNUWwsA9nuJUnQAAAA=
X-Change-ID: 20260731-b4-disp-4fd3bed9-387c3fe87c42
To: Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Ming-Hung Tsai <mtsai@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, 
 Joe Thornber <ejt@redhat.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785538493; l=5489;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=3szjRRUOnQWAmqw62BCFpRphKGY+rm6LLuIDNM7/6Pg=;
 b=qYgRhwTPKzpkpDwvwFv73L/Ak43L6PePAY9nxbV8z+FLKXYScp8QHERA18yOT79H7rwq6ySj4
 d+emCVLxZh/B7Mh5PDONNOTLSqkpYWcHt17OT4ya/BylXmQQ+CaKW0F
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

v1 fixed one of these and mentioned the other; this is both, and the second one
is here because Ming-Hung Tsai said how to reproduce it.

An array block header can be wrong in two independent ways, and a validator can
only catch the first. 1/2 makes the header consistent with itself: value_size
non-zero, max_entries exactly calc_max_entries() for that value_size and block
size, nr_entries within it. 2/2 catches the header that is perfectly consistent
with itself and still wrong for the array reading it.

The review of v1 [1] asked for three changes to the first, all taken: compare
max_entries for equality rather than bounding it from above, since a count
BELOW the real capacity reaches BUG_ON(new_nr > ab->max_entries) in
fill_ablock() and trim_ablock(); split the !value_size test out with its own
message; and print
the counts rather than a bare "max_entries too large". calc_max_entries() moved
above the validators so it is in scope there -- it is unchanged, and
open-coding the formula was what I wanted to avoid, since max_entries is what
dm_array_get_value() addresses with.

2/2 is the hole v1 described and did not fix. dm-cache keeps two arrays,
mappings at 8 bytes and hints at 4, and both roots sit in the superblock. A
hint block stores value_size 4 and max_entries 1018, and 24 + 4*1018 is exactly
4096, so it is internally consistent and 1/2 passes it -- the validator sees the
block, never the caller. Swap the two roots and __load_mappings() walks the hint
array through an info whose value size is 8. get_ablock() and __shadow_ablock()
are the two readers that hold the block and the caller at once, which is why the
check has to be in both; covering only one is why this was not in v1.

A/B on v7.2-rc1 with KASAN; dm-array.c, dm-bufio.c and dm-cache-metadata.c are
identical between that and the base of this series. dm-persistent-data is a
module here, so an arm is the .ko that is loaded and the tested code carries no
scaffolding. Every image is derived from metadata dm-cache itself wrote:

  pristine,                  unpatched:  activates, loads its mappings
  nr_entries 0xFFFFFFFF,     unpatched:  reads past the block, below
  max_entries 100,           unpatched:  ACTIVATES CLEAN -- accepted today
  roots swapped,             unpatched:  reads past the block, below
  nr_entries 0xFFFFFFFF,     patched:    "too many entries", -EILSEQ
  max_entries 100,           patched:    "max_entries 100 != wanted 509 for value_size 8"
  roots swapped,             patched:    "get_ablock failed: value_size 4 != wanted 8"
  pristine,                  patched:    activates, dmesg empty

Three crafted images, three different rejections, and the real image still
loads. The two overread arms, with the consequence dm-cache reports on its own:

    device-mapper: cache: 252:0: unable to shrink origin; cache block 509 is dirty
    device-mapper: cache metadata: policy couldn't load cache block 509     (nr_entries)

    device-mapper: cache: 252:0: unable to shrink origin; cache block 911 is dirty
    device-mapper: cache metadata: policy couldn't load cache block 911     (roots swapped)

509 is exactly the first index an 8-byte-value block cannot hold. 911 is only
where the swapped-root walk first decodes a mapping dm-cache refuses; it depends
on the data, not on a boundary.

Those two lines are the oracle. KASAN adds little here. One run of the
nr_entries arm reported

    BUG: KASAN: slab-use-after-free in dm_cache_load_mappings+0x9b1/0xb40 [dm_cache]

but that build carried an extra warning I had put at the read site to locate it,
and no run since has reported anything. dm-bufio serves these buffers from
__get_free_pages(), the page allocator has no redzones, and the first byte past
the block is the first byte of the next page, so KASAN only speaks when that
page happens to be poisoned.

Scope of the max_entries arm, since it is weaker than the other two: it shows
the header is accepted today and rejected with 1/2, which is what the equality
is for. It does not show the BUG_ON firing -- reads bound themselves by
nr_entries, so a too-small max_entries only bites on a later resize, and I did
not drive one. By inspection from fill_ablock() and trim_ablock().

Forging any of this costs nothing: dm_bm_checksum() is crc32c(~0, data, len) ^
xor, a corruption check rather than a tag. Each crafted image differs from the
one the kernel wrote by four or sixteen bytes plus a checksum.

All of it needs CAP_SYS_ADMIN to load the table, which is why this is hardening
rather than a security report. dm-era reaches the same accessor directly and
dm-clone reaches it through dm-bitset; dm-cache is only the shortest path from a
crafted image to an observable read. dm-thin uses neither. cache_check and
era_check have caught the value_size case offline since v1.0; this is the online
half.

[1] https://lore.kernel.org/all/CALjSBEt-PGxY7y6tQYx6iCmFRXqVcwr633FoFsE+L13A=gre4Q@mail.gmail.com/

---
Bryam Vargas (2):
      dm array: validate array block headers on read
      dm array: reject an array block whose value size is not the caller's

 drivers/md/persistent-data/dm-array.c | 54 +++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 8 deletions(-)
---
base-commit: 8ba098e6b6ff0db8edf28528d1552be261af30d4
change-id: 20260731-b4-disp-4fd3bed9-387c3fe87c42

Best regards,
--  
Bryam Vargas <hexlabsecurity@proton.me>


