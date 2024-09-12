Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6839C185B5D
	for <dm-devel@lists.linux.dev>; Thu, 12 Sep 2024 11:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726142306; cv=none; b=OExUF81b9/AHMzqbZ2wEPPjbeZ9dtqW8GfS5oltAYiw9b5/VFO2LwteJeWhrK5UVD4qAnqHdgYvcTdtxhw9pw/hH9Le7u4TnQkWIj9WIv82gNzY/sFxQPe+lQjriJEf9MW6ugVYTUPcdeOrViXsM08m8XuCuBBjmbE7uI1HhbQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726142306; c=relaxed/simple;
	bh=33n/LZy/LllIo+4Msofqqe2VDlDFj8gHB0wiN45awIc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Ar0OqX9B4Y5Vh6Qav6pq/NnrWLafLCjNtQrjz7oQrErEpoaW7VzydDNOy2Jol2LobC44BXvmCamj7GAby8hG9+z5SMzFvaDp4j9T5A6XZ4DUeWfHgqNWUrATg5974AByhPPmyPWRJ/MIaQfuMNdSpEB6oehi72z3yD33RSZ0mUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OA1UEScS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OA1UEScS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726142303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PPTJg/4GKHGUOs7YBRlTtT1pLyNZS3rTjpw7tAl2knM=;
	b=OA1UEScSe0GyJ2Z0IDF0Zk3oeAGdTYetYkdhKd5C/Xo7zPrjVjrt8yLhFD9DsCp+QGmgHR
	eMpye7byLKUpRsjUZGiYGKi4lAxsBmv69+a4rrCHcNUqD4Y/bTpe30fFVjYaWwENpcGfqG
	FMgJXQmnaJVBozROy1TuCM70elG98yk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-45-G9ZkvD4sMDa9qOAJzsFmLg-1; Thu,
 12 Sep 2024 07:58:20 -0400
X-MC-Unique: G9ZkvD4sMDa9qOAJzsFmLg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABB2A1955D53;
	Thu, 12 Sep 2024 11:58:18 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 509FB3000238;
	Thu, 12 Sep 2024 11:58:16 +0000 (UTC)
Date: Thu, 12 Sep 2024 13:58:12 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, kernel test robot <lkp@intel.com>, 
    Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] dm-integrity: check mac_size against HASH_MAX_DIGESTSIZE
 in sb_mac()
In-Reply-To: <20240910175259.28620-1-ebiggers@kernel.org>
Message-ID: <f0771a6b-6654-a957-8ad9-76060d988352@redhat.com>
References: <20240910175259.28620-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 10 Sep 2024, Eric Biggers wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> sb_mac() verifies that the superblock + MAC don't exceed 512 bytes.
> Because the superblock is currently 64 bytes, this really verifies
> mac_size <= 448.  This confuses smatch into thinking that mac_size may
> be as large as 448, which is inconsistent with the later code that
> assumes the MAC fits in a buffer of size HASH_MAX_DIGESTSIZE (64).
> 
> In fact mac_size <= HASH_MAX_DIGESTSIZE is guaranteed by the crypto API,
> as that is the whole point of HASH_MAX_DIGESTSIZE.  But, let's be
> defensive and explicitly check for this.  This suppresses the false
> positive smatch warning.  It does not fix an actual bug.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/202409061401.44rtN1bh-lkp@intel.com/
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/md/dm-integrity.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 51e6964c13054..3b9738787c855 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -489,11 +489,12 @@ static int sb_mac(struct dm_integrity_c *ic, bool wr)
>  	int r;
>  	unsigned int mac_size = crypto_shash_digestsize(ic->journal_mac);
>  	__u8 *sb = (__u8 *)ic->sb;
>  	__u8 *mac = sb + (1 << SECTOR_SHIFT) - mac_size;
>  
> -	if (sizeof(struct superblock) + mac_size > 1 << SECTOR_SHIFT) {
> +	if (sizeof(struct superblock) + mac_size > 1 << SECTOR_SHIFT ||
> +	    mac_size > HASH_MAX_DIGESTSIZE) {
>  		dm_integrity_io_error(ic, "digest is too long", -EINVAL);
>  		return -EINVAL;
>  	}
>  
>  	desc->tfm = ic->journal_mac;
> 
> base-commit: 8d8d276ba2fb5f9ac4984f5c10ae60858090babc
> -- 
> 2.46.0

I applied the patch.

Mikulas

