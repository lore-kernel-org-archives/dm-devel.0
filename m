Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3611A23AC
	for <dm-devel@lists.linux.dev>; Mon, 17 Feb 2025 21:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739828118; cv=none; b=FkF7Vg/ujc9h1xRmSBVfxcFgmGdkLFuJ5tt1z7OIrduIG+rSvEohvcC9SYu7X6Vg4AJiq+MN0LxvRVlJZr0UI9jnBAeVPIPSNKP9t4oal1Mb8xZl9V5oEMTwIXScdThdtkk+0dLrB7cnymYWDkMyU7zuAwNir8ps6GdKIDGaA/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739828118; c=relaxed/simple;
	bh=TKxRvXZ7VvY3hoejBXS9lX2vbfV6aZTnDpwIzgU5zw4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=KjmBHAVlejXLrYho1FQS57Aoic8N90hRgJ9en61fvWbVQqd2uvwPGujz2zr3Qj/tu84NocIQ81r4G1WHQpU+pQh9wUbLINdGo6LjIMNLl3MR1HRSjKaN6Mtw4BvXLWfw7mmgG6nlrUN3sbFGnjoDsW8t24zOUxFJwX2gq8hQ200=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D3J5gFQ/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D3J5gFQ/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739828114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IAsBeO7QEXCMkG2i59ntC0fIpRLguzfE4gQOK8o30k=;
	b=D3J5gFQ/T7yCZQmndiZQH+Rvge5F/IOkwNtXygaJNikzGot8nu88UIK/ssZ9p17dFvAR6c
	ZxNxfX5mZmwsTi9nD9PasktXZtw+hILw9o6gear0bIxjuahAhoI/JwBDcPDnSAraL9Sr+Q
	Q8cUuF7Z0ShOx3YOt6A/FyjvpnyxNDM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-44-_gZl9WTlNMu9Gh3QhUSH4A-1; Mon,
 17 Feb 2025 16:35:11 -0500
X-MC-Unique: _gZl9WTlNMu9Gh3QhUSH4A-1
X-Mimecast-MFC-AGG-ID: _gZl9WTlNMu9Gh3QhUSH4A_1739828110
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB120180087F;
	Mon, 17 Feb 2025 21:35:09 +0000 (UTC)
Received: from [10.45.224.44] (unknown [10.45.224.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A479180034D;
	Mon, 17 Feb 2025 21:35:06 +0000 (UTC)
Date: Mon, 17 Feb 2025 22:35:02 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: Sami Tolvanen <samitolvanen@google.com>, 
    Akilesh Kailash <akailash@google.com>, kernel-team@android.com, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Milan Broz <gmazyland@gmail.com>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm-verity: do forward error correction on metadata I/O
 errors
In-Reply-To: <20250210190541.GG1264@sol.localdomain>
Message-ID: <d9d5c8b1-8d47-1b9c-fbf7-c84db6843a9f@redhat.com>
References: <629167c1-9be0-6128-8605-eb02391e821d@redhat.com> <CABCJKucmOTVF1jY3vM7VKHuLkDeUxK1EU7YK=C+vgfWvgZFWPQ@mail.gmail.com> <20250210190541.GG1264@sol.localdomain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-2032485996-1739828109=:63297"
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-2032485996-1739828109=:63297
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Mon, 10 Feb 2025, Eric Biggers wrote:

> On Mon, Feb 10, 2025 at 08:57:55AM -0800, Sami Tolvanen wrote:
> > Hi Mikulas,
> > 
> > On Mon, Feb 10, 2025 at 7:04 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> > >
> > > Do forward error correction if metadata I/O fails.
> > >
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > >
> > > ---
> > >  drivers/md/dm-verity-target.c |   19 +++++++++++++++++--
> > >  1 file changed, 17 insertions(+), 2 deletions(-)
> > >
> > > Index: linux-2.6/drivers/md/dm-verity-target.c
> > > ===================================================================
> > > --- linux-2.6.orig/drivers/md/dm-verity-target.c        2025-02-04 13:52:45.000000000 +0100
> > > +++ linux-2.6/drivers/md/dm-verity-target.c     2025-02-10 15:55:42.000000000 +0100
> > > @@ -324,8 +324,22 @@ static int verity_verify_level(struct dm
> > >                                                 &buf, bio->bi_ioprio);
> > >         }
> > >
> > > -       if (IS_ERR(data))
> > > -               return PTR_ERR(data);
> > > +       if (IS_ERR(data)) {
> > > +               r = PTR_ERR(data);
> > > +               data = dm_bufio_new(v->bufio, hash_block, &buf);
> > > +               if (IS_ERR(data))
> > > +                       return r;
> > > +               if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADATA,
> > > +                                     hash_block, data) == 0) {
> > > +                       aux = dm_bufio_get_aux_data(buf);
> > > +                       aux->hash_verified = 1;
> > > +                       goto release_ok;
> > > +               } else {
> > > +                       dm_bufio_release(buf);
> > > +                       dm_bufio_forget(v->bufio, hash_block);
> > > +                       return r;
> > > +               }
> > > +       }
> > 
> > Don't we still have to check for io->in_bh before trying to correct the error?

dm_bufio_get doesn't return an error code. But adding a test for it 
doesn't hurt.

> > Overall, it would be nice not to duplicate code here. Should the
> > metadata error correction / handling be moved to a separate function
> > similar to verity_handle_data_hash_mismatch?
> > 
> 
> It's also incorrect to do this when skip_verified=true, since in that case
> want_digest (which verity_fec_decode() uses) has not been initialized yet.
> 
> - Eric

Yes, I changed it to return "1" if "skip_unverified" is set.

Mikulas
---1463811712-2032485996-1739828109=:63297--

