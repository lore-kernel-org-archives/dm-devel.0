Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795582573;
	b=o7P5ZBEDcDnec5ttGvX5m7dGZuUDhDAAVob9TTAIe7VKZ4os5ipYLBUR4SlPn/A1kFsF
	 e1oR8Xy38N3ssbxIyWX9Rc5jgQL6mp1/2u+tbAAofL52FgIjzzF6Sc/Ds3qVRtZT2J/s5
	 yebSi6hwvIWfa36sQeDx050DSAgNbWVFRAZIXp4JWDu/3Kn1EejbHBELAyYgtVqgS/HVv
	 pUGzZoFuqsB1YzuqqlbsbPdmZMUTK5zKkgI5/3F6J586GSJO3QJ8WhoVUkiy/2GJoVoVf
	 CXVcK6jPTf6HpxL9Z1ojkb/K2MzglB4PruJi8o9wi99s5RHuHINbhWvbK7X2heYOiAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795582573;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NFYXbE8vTMJjd/82VS45AL7GoY6oKZ60KBeoq13V57o=;
	b=rcbZUUR89HERS6u8NurNTuuIHMYGPEktkdx6lLmDPKGJtTXopuxtfbS0FzlKuYRQdm8s
	 rsmsjDwgnHgdq7JBGCE5TmaqxDmEhXlGyEwbVmQTh0yppGUxVsvkezj0QJwWbbE6Fce+2
	 BfFJJ2mYzq0w2k6UT246CZCiGx4h7CcSf4ymKEcJVNEur5eYyTWb2yTM+oM3PQt/t85mQ
	 VjJzi3dXJH+4bGq/S0yNRl8Kiyx8glJfOH17rWaPsei01/XAXwR3sh6CBpUvbJTyoRAid
	 j9E7MMtF6ubtpLGhePOSfM46RykJnUVS/JyeOknhooDG4Iui/y2QEZrwdM5YCYTZKcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="QRBCkS/g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88EF606A321
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 04:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QRBCkS/g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F521F000C0;
	Wed, 25 Nov 2026 04:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795582572;
	bh=NFYXbE8vTMJjd/82VS45AL7GoY6oKZ60KBeoq13V57o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QRBCkS/gRQ9mL3COzxEoOz+V7mXLrGlxARdtJoZxRQMaHGTwD5SvmzGRJflWy6Nbc
	 p8vPnn6eLf+zRMCoCUjLQvXPLpvdss3YFst9M8aRYLg/jCU+viDm9rdj4985RZzm2w
	 w16CFTHP75b6C7obuzqRhhFqAz1IEv6TRZSNlkkwfH0Jzfgc3G7GDENbS0ujaLtN61
	 nmxmzSZBIVPswtKChoAKikPBiD5jN72ycNLv5dpO1N6l3RyXX94ZI8HVCDtsMc5And
	 urueoBJf9RZEXRL5jqENQhgCLA+JUdwKsNvLcKAcU7FF9JTIHZDwTN4Uw3kYmlpP2i
	 8Gw3h23CFpuzA==
Message-ID: <sashiko-outbox-232598@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] dm thin metadata: report uncommitted state and
 refuse commits after a failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Peng Yu" <yupeng0921@gmail.com>, "Alasdair Kergon" <agk@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Mikulas Patocka" <mpatocka@redhat.com>, "Benjamin
 Marzinski" <bmarzins@redhat.com>
Cc: "Joe Thornber" <ejt@redhat.com>, dm-devel@lists.linux.dev
In-Reply-To: <20261125043325.138351-2-yupeng0921@gmail.com>
References: <20261125043325.138351-1-yupeng0921@gmail.com>
 <20261125043325.138351-2-yupeng0921@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 04:56:11 +0000
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
- [Medium] dm thin metadata: inconsistent td->changed state after
  __commit_transaction()
--

commit 0a571384422ac18472855b719999a78add089dae
Author: Peng Yu <yupeng0921@gmail.com>

dm thin metadata: report uncommitted state and refuse commits after a failu=
re

This commit tracks metadata commit failures via a pool-wide commit_failed
flag, exposes whether a thin device or lookup result has uncommitted
metadata changes, and optionally refuses further commits after a failure.

> diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
> index e60e1326376a0..7b56c970a524d 100644
> --- a/drivers/md/dm-thin-metadata.c
> +++ b/drivers/md/dm-thin-metadata.c

[ ... ]

> @@ -1796,6 +1815,17 @@ bool dm_thin_changed_this_transaction(struct dm_th=
in_device *td)
>  	return r;
>  }
> =20
> +bool dm_thin_uncommitted(struct dm_thin_device *td)
> +{
> +	bool r;
> +
> +	down_read(&td->pmd->root_lock);
> +	r =3D td->changed || td->pmd->commit_failed;
> +	up_read(&td->pmd->root_lock);
> +
> +	return r;
> +}
> +
>  bool dm_pool_changed_this_transaction(struct dm_pool_metadata *pmd)
>  {
>  	bool r =3D false;
> @@ -1836,6 +1866,14 @@ int dm_pool_alloc_data_block(struct dm_pool_metada=
ta *pmd, dm_block_t *result)
>  	return r;
>  }
> =20
> +void dm_pool_metadata_set_refuse_commit_after_failure(struct dm_pool_met=
adata *pmd,
> +						      bool refuse_commit_after_failure)
> +{
> +	pmd_write_lock_in_core(pmd);
> +	pmd->refuse_commit_after_failure =3D refuse_commit_after_failure;
> +	pmd_write_unlock(pmd);
> +}
> +
>  int dm_pool_commit_metadata(struct dm_pool_metadata *pmd)
>  {
>  	int r =3D -EINVAL;
> @@ -1848,9 +1886,18 @@ int dm_pool_commit_metadata(struct dm_pool_metadat=
a *pmd)
>  	if (pmd->fail_io)
>  		goto out;
> =20
> +	if (pmd->refuse_commit_after_failure && pmd->commit_failed) {
> +		DMERR_LIMIT("%s: refusing to commit after a failed commit",
> +			    __func__);
> +		r =3D -EIO;
> +		goto out;
> +	}
> +
>  	r =3D __commit_transaction(pmd);
> -	if (r < 0)
> +	if (r < 0) {
> +		pmd->commit_failed =3D true;
>  		goto out;
> +	}

[Severity: Medium]
Does setting pmd->commit_failed after __commit_transaction() fails leave
td->changed and td->aborted_with_changes inconsistent with the actual
on-disk state?

Inside __commit_transaction(), __write_changed_details() clears
td->changed =3D false (and frees closed thin devices) before dm_sm_commit(),
dm_tm_pre_commit(), save_sm_roots(), superblock_lock(), and dm_tm_commit()
run:

drivers/md/dm-thin-metadata.c:__write_changed_details() {
	...
		if (td->open_count)
			td->changed =3D false;
		else {
			list_del(&td->list);
			kfree(td);
		}
	...
}

When a commit fails in any of those later steps, td->changed is already
false, while dm_thin_changed_this_transaction(),
dm_pool_changed_this_transaction(), and __set_abort_with_changes_flags()
still read td->changed directly:

drivers/md/dm-thin-metadata.c:__set_abort_with_changes_flags() {
	...
	list_for_each_entry(td, &pmd->thin_devices, list)
		td->aborted_with_changes =3D td->changed;
}

When commit() in drivers/md/dm-thin.c fails and calls
metadata_operation_failed() -> dm_pool_abort_metadata(),
td->aborted_with_changes is set to false.  Subsequent REQ_PREFLUSH and
REQ_FUA bios then see both dm_thin_changed_this_transaction() and
dm_thin_aborted_changes() as false in bio_triggers_commit(), and since
wait_for_commit_write() in commit "dm thin: add wait_for_commit pool
feature" skips op_is_flush(bio->bi_opf), those flush and FUA bios silently
succeed instead of failing with an I/O error.

In addition, when pmd->refuse_commit_after_failure is false,
pmd->commit_failed is never cleared if a later commit or abort succeeds,
leaving result->changed and dm_thin_uncommitted() permanently true across
the pool.  Could __write_changed_details() defer clearing td->changed (and
freeing closed td entries) until dm_tm_commit() succeeds?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125043325.1383=
51-1-yupeng0921@gmail.com?part=3D1
