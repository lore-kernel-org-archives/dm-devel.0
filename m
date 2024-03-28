Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5553D1CF9A
	for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 18:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711650993; cv=none; b=qSpJcsAmPkqL9o1o8DACPrDwsMUEzkS3hEYZQSEHEazW6UqC24lmJtooiMHTVwsUv+V07xGlQ5Fu4fOB6GG9EH5NkHGYQZlDPNWnVXhWoz1+oqAUpyCvpp5O82aRJu1P2CgTN06mTALYhiceHr67mM2wlqdtZbIzDCW16UkPc+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711650993; c=relaxed/simple;
	bh=Sp5jvlLKNP32D8rGHjbzJDshNB/ON9laKdFiq1xs/3c=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=l9foRORe65RP8aWh9JiL9Gbjj0CmU4qgaohxO+HO1lroRDlquTrYl2h6NQnWILMsoD1ZNmqJn9TsimwuQUrYSSX8bjepgAgdmh1eThQRlZB0MkkMawSvj8epGurjYf9u3R4hVxrka2sPAEGdnuDjq6EBVkAUsQSkK3zF7LE4JtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fbPiNO1B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fbPiNO1B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711650991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JEF8L6USQ1hLDps3RdI620BNw20PF30fu98tAKwws1U=;
	b=fbPiNO1BLr9EvT8ceIZBweITN8d2/aGUr6DXLzsTlIOmbHpa82ZVGnokRt+THtPS2IM2/p
	5EMtpRynw2y05bcJk2bTp6+H5zZ+jtEB2wWftheNkp3RIKeT4z+AW4OgPP1+udZJL+P7Qm
	vW3TsDAZOhNdO1zIGRfATQPCk+XtDwQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-02DqlTmTObS6YAizG9d5GQ-1; Thu, 28 Mar 2024 14:36:29 -0400
X-MC-Unique: 02DqlTmTObS6YAizG9d5GQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0899785A58C;
	Thu, 28 Mar 2024 18:36:29 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED25C1121312;
	Thu, 28 Mar 2024 18:36:28 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id D729B30BFEC2; Thu, 28 Mar 2024 18:36:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id D355E3FB53;
	Thu, 28 Mar 2024 19:36:28 +0100 (CET)
Date: Thu, 28 Mar 2024 19:36:28 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Arnd Bergmann <arnd@kernel.org>
cc: linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, 
    Nathan Chancellor <nathan@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
    Nick Desaulniers <ndesaulniers@google.com>, 
    Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
    Eric Biggers <ebiggers@google.com>, llvm@lists.linux.dev
Subject: Re: [PATCH 1/9] dm integrity: fix out-of-range warning
In-Reply-To: <20240328143051.1069575-2-arnd@kernel.org>
Message-ID: <3573cc6-9a74-4eab-92aa-e66afe18cbf@redhat.com>
References: <20240328143051.1069575-1-arnd@kernel.org> <20240328143051.1069575-2-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3



On Thu, 28 Mar 2024, Arnd Bergmann wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> Depending on the value of CONFIG_HZ, clang compares about a pointless
> comparison:
> 
> drivers/md/dm-integrity.c:4085:12: error: result of comparison of constant 42949672950 with expression of type 'unsigned int' is always false [-Werror,-Wtautological-constant-out-of-range-compare]
>                         if (val >= (uint64_t)UINT_MAX * 1000 / HZ) {
> 
> As the check remains useful for other configurations, shut up the
> warning by adding a second type cast to uint64_t.
> 
> Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-integrity.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 37b9f8f1ae1a..7f3dc8ee6ab8 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -4221,7 +4221,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
>  		} else if (sscanf(opt_string, "sectors_per_bit:%llu%c", &llval, &dummy) == 1) {
>  			log2_sectors_per_bitmap_bit = !llval ? 0 : __ilog2_u64(llval);
>  		} else if (sscanf(opt_string, "bitmap_flush_interval:%u%c", &val, &dummy) == 1) {
> -			if (val >= (uint64_t)UINT_MAX * 1000 / HZ) {
> +			if ((uint64_t)val >= (uint64_t)UINT_MAX * 1000 / HZ) {
>  				r = -EINVAL;
>  				ti->error = "Invalid bitmap_flush_interval argument";
>  				goto bad;
> -- 
> 2.39.2
> 

