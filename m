Received: from mail-108-mta3.mxroute.com (mail-108-mta3.mxroute.com [136.175.108.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A112D33A6E0
	for <dm-devel@lists.linux.dev>; Thu, 18 Jun 2026 12:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781784064; cv=none; b=vGgESEOrMGnXPfo4al889xsRqPzgLpN+hnrBj+BGF5NA4zwtQbqWkY9GaQwTyXBu8F3uKRokKaKUGJemyICUfcMW03MUOhjcJRnannoPR398hvOcq+6ufmvXM4tMO+SjzNszwiZgJsdT2fsbEfPfOmTwVsIxssUROwtebefqwMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781784064; c=relaxed/simple;
	bh=z53SshA5Hk8gU684/HogGkXFnHqCakrjqlo6KZPFpkY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aExXp4gDJElcOhejk1eXPRKdvYRbCjYOlu4q8Me/e9s+BvZxrqkbiH/QpQHgQFoeQiC5zUSvbb3I875VLpGGD1bAS4KV7ma4bgM3eqdgOBZDQKipTwf5LJlsvFiH2FVL8fV27ZF2rs5SHOd8RLOuS9AB9PM90MJjgTWHCarNGl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=hR5SMqgJ; arc=none smtp.client-ip=136.175.108.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="hR5SMqgJ"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta3.mxroute.com (ZoneMTA) with ESMTPSA id 19eda965b2300067f7.004
 for <dm-devel@lists.linux.dev>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Thu, 18 Jun 2026 11:55:47 +0000
X-Zone-Loop: 29df8775bdfda0910a38c92e39219ed6495f3dcf81d0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bDeDrMBVzzGo05zBIB5kpykRTQgCrH9WVICWTW7tP2U=; b=hR5SMqgJWhtANIAxk72a64UE02
	RdY99CePAbHEk6a/FSVrGopomubxGzNGSx3+kjyNUhHN9YhkdAQPQvevaaSx1tTCsGe7sKCcqgR6D
	FSGmlHfzD48BYqZ8bKrFLqNarOi5sDLCvicWbkY1XtYGXd9gRlrDcg0TAPwictut1WQwxTXbHF9Ft
	ZLo2btRAaO/Ci1HBf/NBqGrvy2NxGaSe5Zz031mQEC6wbG9qXHG3VJUfWFI9tcleiPxKIsGhGPmSS
	iY8jQTzXUEGLo8xS4tL2IWE51v+zz2pQZgkYBxe3KJHaDpp3poF0UvfyAxvoodCHtSZ8LAHCGMXBT
	YwEEN0AQ==;
From: Su Yue <l@damenly.org>
To: ghuicao@163.com
Cc: Mike Snitzer <snitzer@kernel.org>,  Alasdair Kergon <agk@redhat.com>,
  Mikulas Patocka <mpatocka@redhat.com>,  Benjamin Marzinski
 <bmarzins@redhat.com>,  dm-devel@lists.linux.dev,
  linux-kernel@vger.kernel.org,  Cao Guanghui <caoguanghui@kylinos.cn>
Subject: Re: [PATCH 1/2] dm era: fix NULL pointer dereference in
 metadata_open()
In-Reply-To: <20260617060053.71051-2-ghuicao@163.com> (ghuicao@163.com's
	message of "Wed, 17 Jun 2026 14:00:52 +0800")
References: <20260617060053.71051-1-ghuicao@163.com>
	<20260617060053.71051-2-ghuicao@163.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Thu, 18 Jun 2026 19:55:39 +0800
Message-ID: <o6h8t64k.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Wed 17 Jun 2026 at 14:00, ghuicao@163.com wrote:

> From: Cao Guanghui <caoguanghui@kylinos.cn>
>
> metadata_open() returns NULL when kzalloc_obj() fails, but the
> caller era_ctr() only checks IS_ERR(md).  Since IS_ERR(NULL)
> returns false, the NULL pointer is treated as a valid result
> and later assigned to era->md, leading to a NULL pointer
> dereference when the metadata is accessed.
>
> Fix this by returning ERR_PTR(-ENOMEM) on allocation failure,
> consistent with dm-cache-metadata.c, dm-thin-metadata.c, and
> dm-clone-metadata.c which all use ERR_PTR(-ENOMEM) for the
> same pattern.
>
> Fixes: eec40579d848 ("dm: add era target")
> Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
>
Reviewed-by: Su Yue <glass.su@suse.com>

> ---
>  drivers/md/dm-era-target.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm-era-target.c 
> b/drivers/md/dm-era-target.c
> index 05285c04ff2c..08ce96e8cf4f 100644
> --- a/drivers/md/dm-era-target.c
> +++ b/drivers/md/dm-era-target.c
> @@ -810,8 +810,10 @@ static struct era_metadata 
> *metadata_open(struct block_device *bdev,
>  	int r;
>  	struct era_metadata *md = kzalloc_obj(*md);
>
> -	if (!md)
> -		return NULL;
> +	if (!md) {
> +		DMERR("could not allocate metadata struct");
> +		return ERR_PTR(-ENOMEM);
> +	}
>
>  	md->bdev = bdev;
>  	md->block_size = block_size;
