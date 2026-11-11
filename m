Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358608;
	b=4QuoKLWFFYKWs6rZznDPdK0UQBM6jaLhd0BR5fiAFuR97KVqnUaGrbQlRrimAcZ+bbsq
	 Eg2IaSR/CtdjKO6VmgU5CAceEoQw6MwmV0jBHNVA/xNCGEiR3OgH1JzXZk65LsGJjVMQJ
	 8K+m/YH2Xa6jPvhc7hMLRbNxJ7On5Vyw53EylSjasjXnQZjPE5VYJA2QFac5B1fEQFEk5
	 lKRmOTnM40ZoShEXoyfINVjICYQPiOMyjIzhY62RQKHo2IgmYdxKaXhcISNTTj2nj9SHR
	 DPX490MEXGQunqBvJs4UBE/WYiCdkEK3NV18iBHgkr2YQHG+JOIJmjyNukKANP4NsDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358608;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xo74nUNyY+vOW0GfFR8DLLmrYxbydhxDWE8LwTi7wsg=;
	b=zqSHVP4NEuzH2Ofhq5dbqbaRzJSEeWO3A69C7W7+Aj3xd4ePpyClpMnEAHsiM0LVnUMj
	 0/nXwtxg74NKOGgDyIDJe1YzbQp2u8c5oLQHpCgD6q1S7SEM79znMALsrLxbo+p0v7lGG
	 qfT/NAz+/ZlZgWr7mllYDJlhSToFGdAMW5SDQ3u/hxQmz8rLoBifuvNrM9zP6sUi3MDlK
	 iIZ4HztouX+Hn+H4AvbViU3Exujq9mOnAo+SvagFkyyiVXYq6lITsVcHFsvC7qn2AxkYe
	 9c8XCiWPWHj6H/nPZecA4HMT/0UKk8uwXqJD4eeIdDkSU09GYSK8difpD4YyxSrr98w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hQvkv57w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE40606BA3A
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 00:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hQvkv57w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F08A1F00A03;
	Wed, 11 Nov 2026 00:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794358608;
	bh=xo74nUNyY+vOW0GfFR8DLLmrYxbydhxDWE8LwTi7wsg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hQvkv57wWMVBGf0CdNcY4Cj+WdUevniWA2+fY28+jgDA0lYhOO2nH0R/feGnWazzz
	 nDPtUOpTgGxOOBfIbWyUHjEvSJlxqZkDNkVyKlYYT2KcgvbV27GjImtOC1TKjeAbxd
	 1OvJ4xJLw6BpjsdxAtwi3pW97cqGACgJ7UCF6cZJVeR06v5OEwWIrdsSLWdT5Iu8dC
	 KuFD8yYukf+F06GwGLXwSgXE1l03bmvUhniK4xHI3NQ8Vy8qbxFNYxmgsD3m8WODm6
	 gDVS/BrSo7qj39sntdjFWbNQ+HQBYw5X/wGLbjJ3hfrE/SnMA1JkvR22m+hFGZ0jOi
	 g0Oy1tin70OYQ==
Message-ID: <sashiko-outbox-208043@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm-integrity: initialize journal accounting in
 dm_integrity_ctr
Reply-To: sashiko-reviews@lists.linux.dev
To: "Benjamin Marzinski" <bmarzins@redhat.com>, "Mikulas Patocka" <mpatocka@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com
In-Reply-To: <20261111004905.1047753-1-bmarzins@redhat.com>
References: <20261111004905.1047753-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 00:56:47 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] dm-integrity: NULL pointer dereference in dm_integrity_resume()
  [1]
--

commit 8723480dc905caec3ed05a2dfe72dc8d6472ba26
Author: Benjamin Marzinski <bmarzins@redhat.com>

dm-integrity: initialize journal accounting in dm_integrity_ctr

This commit initializes ic->free_sectors to ic->journal_entries in
dm_integrity_ctr() so that journal accounting is valid if the first resume
enters a failed state due to a changed superblock and skips journal replay.

> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 802b377613b06..bb2ec9bad6f0d 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -5410,6 +5410,12 @@ static int dm_integrity_ctr(struct dm_target *ti, =
unsigned int argc, char **argv
>  		if (r)
>  			goto bad;
> =20
> +		/*
> +		 * initialize journal accounting like a cleared journal, to
> +		 * handle a changed superblock on resume, where the journal
> +		 * is not replayed.
> +		 */
> +		ic->free_sectors =3D ic->journal_entries;
>  	}
> =20
>  	if (ic->mode =3D=3D 'B') {

[Severity: High]
This problem wasn't introduced by this patch, but can modifying the
on-disk superblock while suspended also cause dm_integrity_resume() to
dereference a NULL pointer [1]?

In dm_integrity_ctr(), ic->recalc_wq is only allocated when
ic->internal_hash is set, and ic->journal is only allocated when ic->mode
is not 'R' or 'I'.  However, dm_integrity_resume() rereads the superblock
from disk and checks SB_FLAG_DIRTY_BITMAP and SB_FLAG_RECALCULATING
without verifying that those resources were allocated at constructor time:

drivers/md/dm-integrity.c:dm_integrity_resume() {
	...
	if (ic->sb->flags & cpu_to_le32(SB_FLAG_DIRTY_BITMAP)) {
		DEBUG_print("resume dirty_bitmap\n");
		rw_journal_sectors(ic, REQ_OP_READ, 0,
				   ic->n_bitmap_blocks * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT), NULL);
	...
	if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
		__u64 recalc_pos =3D le64_to_cpu(ic->sb->recalc_sector);

		DEBUG_print("recalc pos: %llx / %llx\n", recalc_pos, ic->provided_data_se=
ctors);
		if (recalc_pos < ic->provided_data_sectors) {
			queue_work(ic->recalc_wq, &ic->recalc_work);
	...
}

If the superblock is modified while suspended to set SB_FLAG_RECALCULATING
on a target without an internal hash, queue_work() dereferences a NULL
ic->recalc_wq.  Likewise, setting SB_FLAG_DIRTY_BITMAP on an inline-mode
target causes rw_journal_sectors() to index into a NULL ic->journal.

[1] https://sashiko.dev/#/bug/linux-824a598f-b950-4742-b4b6-ae6b1159c25b

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111004905.1047=
753-1-bmarzins@redhat.com?part=3D1
