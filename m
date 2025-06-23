Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043F824BC07
	for <dm-devel@lists.linux.dev>; Mon, 23 Jun 2025 10:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750675003; cv=none; b=mwVrlD3t0haky2shN+iiWTdC9TvrC204QebA9buajquQcZKnuA3JqCO7RnwACZzl3dv2Zk8C6eSn+Q3bjqeQLOKHRc3OJFi8rvU3jgxiGEFDe4TZmfPjH9II0NLXP3BVlJDwvoLbyunh51cfW9dGV2zV2wetHfdh/qiglolN0zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750675003; c=relaxed/simple;
	bh=uLpO5/MXjDGinPMYM/Loug4wXGeMJ8aRFN9mJGnhGB4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZUlphjEQxriSFyKdg3ODf8iwuLb7XpY7oPe9WxoaEIzuiK6M7JPkDnYQ0vMrC/AvkzRPm/DbWCdpK6H8vyJqoDzy+m6UBWua3+flAMo8gpkDMi3Y0I082Nj4z6tT/gqLht+OdC8XNxVISC/tb9lc8SjBS6Nk2C7Oeq0BtGghwkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Et+1dhrr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Et+1dhrr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750675000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JbKHH//UBNF1fahBWjybSC5NQ1aBF5NhDpLwUp3WA1A=;
	b=Et+1dhrrIVps3X1loIfLnGwjNZgSPCCSNAkgMIr5WuJ06V8MdL6F+YJDXMecsOp//t3s9P
	cbougMkIpcZvKRxaX5ktu4jd3vsuqnMrM2qj1ss0GqSWUbCQQ7GaKhOQLmdgNdrwZIMv32
	+VWf1pFosJKb8wm1x+X/VNOTZadaBlc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-182-EYGigdE_NSqahpMDrTAqlQ-1; Mon,
 23 Jun 2025 06:36:39 -0400
X-MC-Unique: EYGigdE_NSqahpMDrTAqlQ-1
X-Mimecast-MFC-AGG-ID: EYGigdE_NSqahpMDrTAqlQ_1750674998
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94B211956096
	for <dm-devel@lists.linux.dev>; Mon, 23 Jun 2025 10:36:38 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A627018003FC;
	Mon, 23 Jun 2025 10:36:37 +0000 (UTC)
Date: Mon, 23 Jun 2025 12:36:33 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: heinzm@redhat.com
cc: dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm raid: add support for resync w/o metadata devices
In-Reply-To: <1609b0317c5776b4228fc65d06700ec9bcc547ce.1750078622.git.heinzm@redhat.com>
Message-ID: <5678eb5f-0869-5b81-4f18-371878100798@redhat.com>
References: <1609b0317c5776b4228fc65d06700ec9bcc547ce.1750078622.git.heinzm@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 90ux3aB9WdPkWU9w1ZlgDAOJu33VP4HskN9AWE6URNs_1750674998
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 16 Jun 2025, heinzm@redhat.com wrote:

> From: Heinz Mauelshagen <heinzm@redhat.com>
> 
> Target does not honour the "sync" argument when activated w/o metadata
> devices, e.g. with table line:
> "0 $(blockdev --getsz $data1) raid raid1 2 0 sync 2 - $data1 - $data2".
> 
> Fix this to support temporary, transient raid devices useful
> for data duplication.
> 
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> ---
>  drivers/md/dm-raid.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 99e15a005bfb..435b366224f0 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -2532,6 +2532,10 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
>  	struct md_rdev *rdev, *freshest;
>  	struct mddev *mddev = &rs->md;
>  
> +	/* Respect resynchronization requested with "sync" argument. */
> +	if (test_bit(__CTR_FLAG_SYNC, &rs->ctr_flags))
> +		set_bit(MD_ARRAY_FIRST_USE, &mddev->flags);
> +
>  	freshest = NULL;
>  	rdev_for_each(rdev, mddev) {
>  		if (test_bit(Journal, &rdev->flags))
> -- 
> 2.49.0

Applied, thanks.

Mikulas

