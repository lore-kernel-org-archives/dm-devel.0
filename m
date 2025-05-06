Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F9E280310
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 12:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746534511; cv=none; b=AbukaFUYVAH+f9TxMtr8HrZ2ofPHK0UurHsBz2oPEiuJPxGDEv8ojJQbM4rtpxqTdT8tfJwq/gWZm9nAKHhzi4ZQNjKa32JrkUbL/2bY3xoPDwBSemJmlC99dI5VqtTj01jJmjzC0wxetpqt2tjKI2z+CDTKdv8a2kgfsk6pipY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746534511; c=relaxed/simple;
	bh=svjgCeA4okvl7uFO2WfawpA/ktNJ2XCIYkBBNa1uT1k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=pUkj5/Sg7pV9bd2U6UkigJAL0ayU0rwdWjhpfKFSBwss79TfVgCV3bEnLc22FlgJWaNkYofR5HIY5DUaGpXMYgXzUHjRpqmyavT1MjIyDGZFLq8xgoyyIQ5HIW5rukmRjjr6BmFvNrULR7fUXLFrkZfaHw1nQ/OQVJikToMUR0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=inkq4A0l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="inkq4A0l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746534508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4RqHIHWGcV5oq3BR6dRROKyVGbZDU2ZQtpUE9Q3QM1c=;
	b=inkq4A0lC/zr9ey/0HG/VL45IbMaiRxKpytfr0W19Oe10Awm+fRhGeGdw6jdqcCpuCHuMd
	RRXVxt0M7WzIDWz2VaiR043QrjqObW97mSOv/K6ykq6YaFFwhyzq8keFb63AuzrS7sX2OF
	leIQWU6LHWvMvSfLzld0Zyb+IDzDNTY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-176-9m9TwKlAPGe_uChjA179IQ-1; Tue,
 06 May 2025 08:28:27 -0400
X-MC-Unique: 9m9TwKlAPGe_uChjA179IQ-1
X-Mimecast-MFC-AGG-ID: 9m9TwKlAPGe_uChjA179IQ_1746534506
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A2B33186A72A;
	Tue,  6 May 2025 12:28:18 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 44F4519560AF;
	Tue,  6 May 2025 12:28:16 +0000 (UTC)
Date: Tue, 6 May 2025 14:28:13 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Tudor Ambarus <tudor.ambarus@linaro.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] dm: fix copying after src array boundaries
In-Reply-To: <20250506-dm-past-array-boundaries-v1-1-b5b1bb8b2b34@linaro.org>
Message-ID: <f9f3b82e-dd37-eff8-3718-1b71746e8c01@redhat.com>
References: <20250506-dm-past-array-boundaries-v1-1-b5b1bb8b2b34@linaro.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40



On Tue, 6 May 2025, Tudor Ambarus wrote:

> The blammed commit copied to argv the size of the reallocated argv,
> instead of the size of the old_argv, thus reading and copying from
> past the old_argv allocated memory.
> 
> Following BUG_ON was hit:
> [    3.038929][    T1] kernel BUG at lib/string_helpers.c:1040!
> [    3.039147][    T1] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> ...
> [    3.056489][    T1] Call trace:
> [    3.056591][    T1]  __fortify_panic+0x10/0x18 (P)
> [    3.056773][    T1]  dm_split_args+0x20c/0x210
> [    3.056942][    T1]  dm_table_add_target+0x13c/0x360
> [    3.057132][    T1]  table_load+0x110/0x3ac
> [    3.057292][    T1]  dm_ctl_ioctl+0x424/0x56c
> [    3.057457][    T1]  __arm64_sys_ioctl+0xa8/0xec
> [    3.057634][    T1]  invoke_syscall+0x58/0x10c
> [    3.057804][    T1]  el0_svc_common+0xa8/0xdc
> [    3.057970][    T1]  do_el0_svc+0x1c/0x28
> [    3.058123][    T1]  el0_svc+0x50/0xac
> [    3.058266][    T1]  el0t_64_sync_handler+0x60/0xc4
> [    3.058452][    T1]  el0t_64_sync+0x1b0/0x1b4
> [    3.058620][    T1] Code: f800865e a9bf7bfd 910003fd 941f48aa (d4210000)
> [    3.058897][    T1] ---[ end trace 0000000000000000 ]---
> [    3.059083][    T1] Kernel panic - not syncing: Oops - BUG: Fatal exception
> 
> Fix it by copying the size of src, and not the size of dst, as it was.
> 
> Fixes: 5a2a6c428190 ("dm: always update the array size in realloc_argv on success")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
> ---
>  drivers/md/dm-table.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 9e175c5e0634b49b990436898f63c2b1e696febb..6dae73ee49dbb36d89341ff09556876d0973c4ff 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -524,9 +524,9 @@ static char **realloc_argv(unsigned int *size, char **old_argv)
>  	}
>  	argv = kmalloc_array(new_size, sizeof(*argv), gfp);
>  	if (argv) {
> -		*size = new_size;
>  		if (old_argv)
>  			memcpy(argv, old_argv, *size * sizeof(*argv));
> +		*size = new_size;
>  	}
>  
>  	kfree(old_argv);
> 
> ---
> base-commit: 92a09c47464d040866cf2b4cd052bc60555185fb
> change-id: 20250506-dm-past-array-boundaries-1fe2f5a1030f
> 
> Best regards,
> -- 
> Tudor Ambarus <tudor.ambarus@linaro.org>

Thanks

I sent a pull request to Linus that includes this patch.

Mikulas

