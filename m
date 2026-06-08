Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7632C3C4557
	for <dm-devel@lists.linux.dev>; Mon,  8 Jun 2026 14:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780928256; cv=none; b=LfDyE2AOBAtiUpb1b8WoAmt0E55WwhpUCdryejvUOmRR31vGnj/PQO8XQHntDTskiCmq/DPV77BlpAzdh9m+24YUfSBc1Dxz/u3A4m/rK3BAw4TmAmB3gQCLEdBhBCwRerYEEt0VgPMmw9N8Vjgrq3128PR7zKeMsmpLit4I3kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780928256; c=relaxed/simple;
	bh=pXxvwbkYE2gjq7WR0Q7VjUVPyJ/OJ1GYbzDCAvTm7HE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=K8WiiDOEI4mOjSCS3Uk/zSpeyJeedw/ZgzIV5q0JKbB205SClglCqZpe22Xzk6rtJVD725Yr0m/5iJvB3G0s1I62F3KdATwsn2FH2ZzSbmnly1oQ7+lL8V8HkL1klcm88qIlgs0gVOpVOQIrTPxiTfgCYyj0hAwmeunYl4VNxbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T3blzZ6p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T3blzZ6p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780928254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6IbKKv69rHubHYnpBtSzGnIX3RFsZKJvIpaQT7dPb/o=;
	b=T3blzZ6pirTjH4UX65kHtvvapCpto+pN/LwaDRxEbMFztYSv0U1VcmmU8rM5RQP4TEFa5Q
	MCIVuXf62i8/2vPR3IGf00sugoLwQ4GtQyO+d5lcLg787Qve2DVOScByHtNgAolzlEq93L
	vQ6BBYzzGn+TFVZ93Qz2MUKUacbEeo4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-32-XZOSR7YAMfGGV9YUwUbQ4w-1; Mon,
 08 Jun 2026 10:16:21 -0400
X-MC-Unique: XZOSR7YAMfGGV9YUwUbQ4w-1
X-Mimecast-MFC-AGG-ID: XZOSR7YAMfGGV9YUwUbQ4w_1780928180
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 683D21955F29;
	Mon,  8 Jun 2026 14:16:20 +0000 (UTC)
Received: from [10.44.50.170] (unknown [10.44.50.170])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5C2491800583;
	Mon,  8 Jun 2026 14:16:18 +0000 (UTC)
Date: Mon, 8 Jun 2026 16:16:14 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Samuel Moelius <sam.moelius@trailofbits.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Heinz Mauelshagen <heinzm@redhat.com>, 
    "open list:DEVICE-MAPPER  (LVM)" <dm-devel@lists.linux.dev>, 
    open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dm ebs: drop dirty bufio state when discarding blocks
In-Reply-To: <20260603175151.25026-1-sam.moelius@trailofbits.com>
Message-ID: <f6c41bca-c80f-368e-f0bf-e6b57c4af9d0@redhat.com>
References: <20260603175151.25026-1-sam.moelius@trailofbits.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: R_hdSOo9nvSzYATeY4OW7ytqTlfEeos2Tezd8VYLeUY_1780928180
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 3 Jun 2026, Samuel Moelius wrote:

> dm-ebs can discard a block while a dirty dm-bufio buffer for the
> same block is still cached.  If that buffer is later written back,
> stale data can be written over the discarded state.
> 
> That resurrects data that userspace explicitly discarded and breaks
> the expected discard semantics of the target.
> 
> Invalidate or clean the matching bufio state when processing discards
> so that old dirty buffers cannot be written back after the discard.
> 
> Assisted-by: Codex:gpt-5.5-cyber-preview
> Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
> ---
>  drivers/md/dm-ebs-target.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
> index 1e52bde48b91..9fece535a0b3 100644
> --- a/drivers/md/dm-ebs-target.c
> +++ b/drivers/md/dm-ebs-target.c
> @@ -212,8 +212,12 @@ static void __ebs_process_bios(struct work_struct *ws)
>  			write = true;
>  			r = __ebs_rw_bio(ec, REQ_OP_WRITE, bio);
>  		} else if (bio_op(bio) == REQ_OP_DISCARD) {
> -			__ebs_forget_bio(ec, bio);
> -			r = __ebs_discard_bio(ec, bio);
> +			if (write)
> +				r = dm_bufio_write_dirty_buffers(ec->bufio);
> +			if (!r) {
> +				__ebs_forget_bio(ec, bio);
> +				r = __ebs_discard_bio(ec, bio);
> +			}
>  		}
>  
>  		if (r < 0)

Hi

There's a bug in the patch - when the "write" variable is false, "r" is 
equal to -EIO, thus __ebs_forget_bio and __ebs_discard_bio is skipped at 
all.

If dm_bufio_write_dirty_buffers returns non-zero, the error is erroneously 
reported on the discard bio (that is innocent) and not on the write bios 
that triggered the error.

Mikulas

