Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795189475;
	b=27pWR02xSTDigMYkrVbI02tcW5LPTE+O8bvefaYZ2MwVkIeIfmTMn/v2kBRjUt0zTGlh
	 3L/EO+7foYiz9Ts0wMFpjlOlSi+o741PzkdAAAe7WIaX9Byefo/Ca2YfbpNXAooDHpqfL
	 Zj3jwTphWyF9nPqFxcIzrPsbEKRRamsPE/iBr3RLh1w1vbq4CXARqA9AKbUkS3qc8Yq74
	 0ziHLvOz2ZtfBJOv+9BT/BQ63Htjlr+Agl3OvagE9gSWLMILjir5hSlmLjtNFMqmYxK6g
	 duuhvJqYcnI9CgrOrQ7t59ZXuCRuhpntgVQXzSHMkUcLLDKi9KLS3EYdicDUtubTdJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795189475;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GfUBKih/WvwZ1LHmvcOgeJWb83DeVvZPOpIvvFLMJPI=;
	b=ArKC5mVleuyx96OEBfjdum5Tnfcppt3XY5zdO0fHjWxaaIWxw2GZ5jmHR3m7WbmENUqn
	 ywBZXgw1E5m4xJ5kS8Y1ugE+TSZZ8DdPtaw34xq057bq7nbcYfW1Q2qnf178j9QEKi31K
	 n0gVMlQ9ix/vhQ8p5bMdbL4n54cjlzJdhWYkXN5iIgpya9JgNjONgLINwaH/vrDoLwtLy
	 bqdc2rkd1RGuji4yH1v6sC08GhtKCFnZ6Pk7ZuJVpgOU4oThRqZpOdffbIXvoSm1njEkx
	 Cqupy6kqMr60aJLPhFPXhnj3gQMIGDOezLTiCt6qkKQsh4Wx+WNrLw1Gag532FTvP5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GPXR7jLA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954B3606A325
	for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 15:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GPXR7jLA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04591F000C6;
	Fri, 20 Nov 2026 15:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795189475;
	bh=GfUBKih/WvwZ1LHmvcOgeJWb83DeVvZPOpIvvFLMJPI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GPXR7jLAuEQeczlYqqYqGJn/lj1kobOo9r7mdMdUPOKTyc8bdpsUOq9NLxjJJao5Z
	 kqJ1fxt2fZw89pAMxv2oKiCPOiOvs/5RRO0rgjcEMNT/qZRwJFtfpIOwrrFTfsT08J
	 qKyJsIUAqiRkxP7tCPQOnzHiwLfsT1JVKKMUio6gmZ3ufSIqfaoApJuyGzLOvmSm5q
	 7HlKlQrJ1I9M5SaoSeqXJh37nZ03PCDBHAYB2+1oOPE38tIXMeDXCSbKsSTn6zqMks
	 AvDUDiKPlj5F84iT2gm+mnjMFEb/Od7b8dGgf/eJnMVJ3bwK+vpHHnpl+Qz1bZwXMQ
	 2ycMO/ti/mDFQ==
Message-ID: <sashiko-outbox-225476@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm-integrity: reject recalculation when recalc_wq was
 never allocated
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yang Luohan" <ylh440104@gmail.com>, "Mikulas Patocka" <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, "Mike Snitzer" <snitzer@kernel.org>, "Benjamin
 Marzinski" <bmarzins@redhat.com>
In-Reply-To: <179518869380.2402.12815883988413214937@gmail.com>
References: <179518869380.2402.12815883988413214937@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 15:44:34 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] dm-integrity: unrestored superblock on recalc error in
  dm_integrity_resume()
--

commit 1f55191efead476e43582fdac18ace4fb279e159
Author: Yang Luohan <ylh440104@gmail.com>

dm-integrity: reject recalculation when recalc_wq was never allocated

This commit checks that ic->recalc_wq is non-NULL in dm_integrity_resume()
before queueing ic->recalc_work when SB_FLAG_RECALCULATING is set in the
superblock.

> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 6968e38888db9..deddec9de3e1b 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -4046,6 +4046,11 @@ static void dm_integrity_resume(struct dm_target *=
ti)
>  	if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
>  		__u64 recalc_pos =3D le64_to_cpu(ic->sb->recalc_sector);
> =20
> +		if (unlikely(!ic->recalc_wq)) {
> +			DMERR("Recalculate requested, but internal_hash is not used");
> +			dm_integrity_io_error(ic, "inconsistent superblock", -EINVAL);
> +			goto skip_writes;
> +		}
>  		DEBUG_print("recalc pos: %llx / %llx\n", recalc_pos, ic->provided_data=
_sectors);
>  		if (recalc_pos < ic->provided_data_sectors) {
>  			queue_work(ic->recalc_wq, &ic->recalc_work);

[Severity: Medium]
Should this check run alongside superblock_changed() and restore ic->sb
from ic->sb_copy before jumping to skip_writes?

Checking !ic->recalc_wq at the end of dm_integrity_resume() runs after the
journal replay and superblock write paths have already executed, and leaves
SB_FLAG_RECALCULATING set in the in-memory ic->sb->flags.  As a result,
dm_integrity_status() reports recalculate enabled without internal_hash,
and if the on-disk superblock is repaired while suspended, a later
dm_integrity_resume() captures SB_FLAG_RECALCULATING from the stale
in-memory ic->sb into flags before sync_rw_sb(ic, REQ_OP_READ) and writes
it back to disk:

drivers/md/dm-integrity.c:dm_integrity_resume() {
	...
	flags =3D ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING);
	if (ic->discard_keyed)
		flags |=3D cpu_to_le32(SB_FLAG_DISCARD_KEYED);
	r =3D sync_rw_sb(ic, REQ_OP_READ);
	...
	if ((ic->sb->flags & flags) !=3D flags) {
		ic->sb->flags |=3D flags;
		r =3D sync_rw_sb(ic, REQ_OP_WRITE | REQ_FUA);
	...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/179518869380.2402.1=
2815883988413214937@gmail.com?part=3D1
