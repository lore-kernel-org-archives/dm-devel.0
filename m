Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853BE2DE1E5
	for <dm-devel@lists.linux.dev>; Tue, 17 Jun 2025 16:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177427; cv=none; b=tAbn8TGqaEoY1rTU7FiVjU9eaVvJnEfh/QhJmEdATFNmQO2T8ab36L+dPjswk8TmMvvufoJ2HWPCkmVNJo17bnsXS+Q4yy5p4yHqCvKa6rAcKITiXTrU63zhcwUHykKrnXqP4pzEnN5dbRoQ6OBpST8AFGtwPZZbXD78ur9exBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177427; c=relaxed/simple;
	bh=Xzm6IN79bmQ6QQK6SeI0wcJe1lTfPf7pkOqd3OI04rQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=WbTMgUAONnGwru7Ifnu/bt5QVUOEzXMzI00SXzzedQcN1hMzuiZNipeXjS0wER1Gk56vSGhyja3N3PMxEvouSNiv8V49hYp0ka5E5Gfnk7a/0yw6pYPVO3zivmSOzzWbP1oMO5WMpmn8p2RFLybSH95qQ5htzw97h66G/ikmH2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y0ePY4Bf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y0ePY4Bf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750177424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qPV52jXyRPYd7SJI9P4iGfNukgS8ZyMHGhxRY38Ctjk=;
	b=Y0ePY4Bfhhjn63U1pqIBZfDneCme0N3G1USPPd6TB62BFWwmUSVrQUd0bp0GjGVGwLsSvZ
	rVqO08YjbhclZErPrzvASZFDRmAw2s5v6XzXDSEI4JEXiJYKi160Nwt3+sFMIqISao16hr
	A0bNruQMCFGmmmui8P60NViE0Am/vq8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-131-Xm-un1bYNHGrHwUVcPeVew-1; Tue,
 17 Jun 2025 12:23:40 -0400
X-MC-Unique: Xm-un1bYNHGrHwUVcPeVew-1
X-Mimecast-MFC-AGG-ID: Xm-un1bYNHGrHwUVcPeVew_1750177419
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7259119560B6;
	Tue, 17 Jun 2025 16:23:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22E6C195608F;
	Tue, 17 Jun 2025 16:23:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 55HGNbk52996644
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 17 Jun 2025 12:23:37 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 55HGNbON2996643;
	Tue, 17 Jun 2025 12:23:37 -0400
Date: Tue, 17 Jun 2025 12:23:37 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-flakey: Fix corrupt_bio_byte setup checks
Message-ID: <aFGWiZkvqsJUfozi@redhat.com>
References: <20250611191221.3011309-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250611191221.3011309-1-kent.overstreet@linux.dev>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rLwcXSFuENrICumEUm1j9J_XSmILrfc1KPb17l5gFpY_1750177419
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 11, 2025 at 03:12:20PM -0400, Kent Overstreet wrote:
> Fix the error_reads mode - it's incompatible with corrupt_bio_byte, but
> that's only enabled if corrupt_bio_byte is nonzero.
> 
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: dm-devel@lists.linux.dev
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

This commit header should include:

Fixes: 19da6b2c9e8e ("dm-flakey: Clean up parsing messages")

So that it gets picked up by the stable kernel.

-Ben

> ---
>  drivers/md/dm-flakey.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
> index c711db6f8f5c..cf17fd46e255 100644
> --- a/drivers/md/dm-flakey.c
> +++ b/drivers/md/dm-flakey.c
> @@ -215,16 +215,19 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
>  	}
>  
>  	if (test_bit(DROP_WRITES, &fc->flags) &&
> -	    (fc->corrupt_bio_rw == WRITE || fc->random_write_corrupt)) {
> +	    ((fc->corrupt_bio_byte && fc->corrupt_bio_rw == WRITE) ||
> +	     fc->random_write_corrupt)) {
>  		ti->error = "drop_writes is incompatible with random_write_corrupt or corrupt_bio_byte with the WRITE flag set";
>  		return -EINVAL;
>  
>  	} else if (test_bit(ERROR_WRITES, &fc->flags) &&
> -		   (fc->corrupt_bio_rw == WRITE || fc->random_write_corrupt)) {
> +		   ((fc->corrupt_bio_byte && fc->corrupt_bio_rw == WRITE) ||
> +		    fc->random_write_corrupt)) {
>  		ti->error = "error_writes is incompatible with random_write_corrupt or corrupt_bio_byte with the WRITE flag set";
>  		return -EINVAL;
>  	} else if (test_bit(ERROR_READS, &fc->flags) &&
> -		   (fc->corrupt_bio_rw == READ || fc->random_read_corrupt)) {
> +		   ((fc->corrupt_bio_byte && fc->corrupt_bio_rw == READ) ||
> +		    fc->random_read_corrupt)) {
>  		ti->error = "error_reads is incompatible with random_read_corrupt or corrupt_bio_byte with the READ flag set";
>  		return -EINVAL;
>  	}
> -- 
> 2.49.0

