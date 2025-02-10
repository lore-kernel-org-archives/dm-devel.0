Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B909F23F282
	for <dm-devel@lists.linux.dev>; Mon, 10 Feb 2025 15:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739199742; cv=none; b=s/s0u0sO7neRGzElBbnOJ5ABGojfSvIRDBZL72SsCwFbFrqXdYTpvxDQuEQ0KUqftoO1U36dx4lg4aP+hJh58/63QEZ4q36lodbx02i/S+xQ3ICgcbbulP2kGsWYwE7zu5faFxO6lTmGErPne4++/nTaD+v5ZHw/G3YBEvo+I4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739199742; c=relaxed/simple;
	bh=CA0Ku8F2+XjIP/PbebNiDWblBvz7TllwbFKv+zR7cFY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rVqVOGpZSwsflxcq1Zwhlhwd7UR4fPwRyHZ8SItNT5x6K+LqR9TYiy/4DupYp7PKpFmp5mfVQsKLY1NFuCeV/2enEsnXGxOnk8sTHYTlaB1cG4gkVx0wIxOcvudVMU7As+wIuyNeYomK8Dh3XFTPAuYfTcTgJxx4V6Uzq8UvPKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ge75XCFd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ge75XCFd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739199739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KUElCZB+zt493sEWNNJELr/dmuAAGcpgZcq+xytcBjk=;
	b=ge75XCFdHx2ZAmw0d+9f9nF8TwPTfkQy83CMkqujgHw/S5E+dRk/s3k68gnUbnpV+O07hF
	DX3mGOTeh1i7PG4+rmacA3WU5QrO6CxrN1ZBRI4519MfPP1jOXIEjtiPyJ1+e77GhpaVC8
	UaZyo1yH3FT8tpybeOiGdlPBH1bTLO4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-264-DAQbic_hPR2u1fHa1-gITQ-1; Mon,
 10 Feb 2025 10:02:16 -0500
X-MC-Unique: DAQbic_hPR2u1fHa1-gITQ-1
X-Mimecast-MFC-AGG-ID: DAQbic_hPR2u1fHa1-gITQ
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 585ED1801A23;
	Mon, 10 Feb 2025 15:02:14 +0000 (UTC)
Received: from [10.45.225.131] (unknown [10.45.225.131])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A6C61956094;
	Mon, 10 Feb 2025 15:02:11 +0000 (UTC)
Date: Mon, 10 Feb 2025 16:02:08 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Akilesh Kailash <akailash@google.com>
cc: Sami Tolvanen <samitolvanen@google.com>, kernel-team@android.com, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm-verity: skip verity_handle_err on I/O errors for
 metadata
In-Reply-To: <20250208231923.1952228-1-akailash@google.com>
Message-ID: <63ce8426-8f6c-b941-822d-0437d6906f04@redhat.com>
References: <20250208231923.1952228-1-akailash@google.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Hi

This doesn't seem correct - bio->bi_status is not set at a place where you 
are testing it.

If metadata I/O fails, the code goes down this branch "if (IS_ERR(data)) 
return PTR_ERR(data);" in verity_verify_level - i.e. it doesn't reach the 
piece that your patch is modifying.

I am sending a next patch (untested) that does forward error correction 
for metadata I/O failures.

Mikulas


On Sat, 8 Feb 2025, Akilesh Kailash wrote:

> Handle I/O error for metadata blocks if FEC correction fails.
> This is similar to handling I/O error for data blocks:
> 'commit 2c0468e054c0 ("dm verity: skip redundant verity_handle_err()
> on I/O errors")'
> 
> Fixes: 2c0468e054c0 ("dm verity: skip redundant verity_handle_err()
> on I/O errors")
> Signed-off-by: Akilesh Kailash <akailash@google.com>
> ---
> 
> Note: This patch should have been included in the data block fix patch.
> A "fixes" tag has been added to address this.
> Link: https://lore.kernel.org/all/20210913092642.3237796-1-akailash@google.com/
> ---
>  drivers/md/dm-verity-target.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index e86c1431b108..e1ce3b256f0a 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -353,16 +353,26 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
>  		} else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADATA,
>  					     hash_block, data) == 0)
>  			aux->hash_verified = 1;
> -		else if (verity_handle_err(v,
> +		else {
> +			if (bio->bi_status) {
> +				/*
> +				 * Error correction failed; Just return error
> +				 */
> +				r = -EIO;
> +				goto release_ret_r;
> +			}
> +			if (verity_handle_err(v,
>  					   DM_VERITY_BLOCK_TYPE_METADATA,
>  					   hash_block)) {
> -			struct bio *bio;
> -			io->had_mismatch = true;
> -			bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
> -			dm_audit_log_bio(DM_MSG_PREFIX, "verify-metadata", bio,
> +				struct bio *bio;
> +
> +				io->had_mismatch = true;
> +				bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
> +				dm_audit_log_bio(DM_MSG_PREFIX, "verify-metadata", bio,
>  					 block, 0);
> -			r = -EIO;
> -			goto release_ret_r;
> +				r = -EIO;
> +				goto release_ret_r;
> +			}
>  		}
>  	}
>  
> -- 
> 2.48.1.502.g6dc24dfdaf-goog
> 

