Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A6213ADC
	for <dm-devel@lists.linux.dev>; Wed, 29 Nov 2023 17:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WH1cW0Oc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701278779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DPMxPCyUCiU/DiBoTo+PVsbSuI7/XmfmesVjgz8N+MA=;
	b=WH1cW0OcDzl/zzXX1hF75qsvnAQXgClBoxSofZURVLmPf9ILaCchJpW1wvHwJIve7jMyUz
	jOrGpAyArjm0A9i5GDAFgv0dZZ9/MJWv1q/nhMPcHeIMlavKFwkY6Nkm9RZEfMFh1uxytn
	JsAjnsnYeR9nMqACF3UhBHVR7uISd48=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-Ev4XW5WYNuOjmwnPQnEKOQ-1; Wed,
 29 Nov 2023 12:26:15 -0500
X-MC-Unique: Ev4XW5WYNuOjmwnPQnEKOQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B84438143B2;
	Wed, 29 Nov 2023 17:26:08 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 472775038;
	Wed, 29 Nov 2023 17:26:08 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 3149230C1A8C; Wed, 29 Nov 2023 17:26:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 2EAB63FB76;
	Wed, 29 Nov 2023 18:26:08 +0100 (CET)
Date: Wed, 29 Nov 2023 18:26:08 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Wu Bo <bo.wu@vivo.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    Wu Bo <wubo.oduw@gmail.com>, Eric Biggers <ebiggers@kernel.org>, 
    stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] dm verity: don't verity if readahead failed
In-Reply-To: <b23a4fc8baba99010c16059a236d2f72087199a1.1700623691.git.bo.wu@vivo.com>
Message-ID: <b84fb49-bf63-3442-8c99-d565e134f2@redhat.com>
References: <cover.1700623691.git.bo.wu@vivo.com> <b23a4fc8baba99010c16059a236d2f72087199a1.1700623691.git.bo.wu@vivo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5



On Tue, 21 Nov 2023, Wu Bo wrote:

> We found an issue under Android OTA scenario that many BIOs have to do
> FEC where the data under dm-verity is 100% complete and no corruption.
> 
> Android OTA has many dm-block layers, from upper to lower:
> dm-verity
> dm-snapshot
> dm-origin & dm-cow
> dm-linear
> ufs
> 
> Dm tables have to change 2 times during Android OTA merging process.
> When doing table change, the dm-snapshot will be suspended for a while.
> During this interval, we found there are many readahead IOs are
> submitted to dm_verity from filesystem. Then the kverity works are busy
> doing FEC process which cost too much time to finish dm-verity IO. And
> cause system stuck.
> 
> We add some debug log and find that each readahead IO need around 10s to
> finish when this situation occurred. Because here has a IO
> amplification:
> 
> dm-snapshot suspend
> erofs_readahead     // 300+ io is submitted
> 	dm_submit_bio (dm_verity)
> 		dm_submit_bio (dm_snapshot)
> 		bio return EIO
> 		bio got nothing, it's empty
> 	verity_end_io
> 	verity_verify_io
> 	forloop range(0, io->n_blocks)    // each io->nblocks ~= 20
> 		verity_fec_decode
> 		fec_decode_rsb
> 		fec_read_bufs
> 		forloop range(0, v->fec->rsn) // v->fec->rsn = 253
> 			new_read
> 			submit_bio (dm_snapshot)
> 		end loop
> 	end loop
> dm-snapshot resume
> 
> Readahead BIO got nothing during dm-snapshot suspended. So all of them
> will do FEC.
> Each readahead BIO need to do io->n_blocks ~= 20 times verify.
> Each block need to do fec, and every block need to do v->fec->rsn = 253
> times read.
> So during the suspend interval(~200ms), 300 readahead BIO make
> 300*20*253 IOs on dm-snapshot.
> 
> As readahead IO is not required by user space, and to fix this issue,
> I think it would be better to pass it to upper layer to handle it.
> 
> Cc: stable@vger.kernel.org
> Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
> Signed-off-by: Wu Bo <bo.wu@vivo.com>
> ---
>  drivers/md/dm-verity-target.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index beec14b6b044..14e58ae70521 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -667,7 +667,9 @@ static void verity_end_io(struct bio *bio)
>  	struct dm_verity_io *io = bio->bi_private;
>  
>  	if (bio->bi_status &&
> -	    (!verity_fec_is_enabled(io->v) || verity_is_system_shutting_down())) {
> +	    (!verity_fec_is_enabled(io->v) ||
> +	     verity_is_system_shutting_down() ||
> +	     (bio->bi_opf & REQ_RAHEAD))) {
>  		verity_finish_io(io, bio->bi_status);
>  		return;
>  	}
> -- 
> 2.25.1
> 

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

