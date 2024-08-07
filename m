Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7443B84A51
	for <dm-devel@lists.linux.dev>; Wed,  7 Aug 2024 20:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723062950; cv=none; b=VmJJD0jFnhn+LK7NhP4VmwQxSVRfk1XhNNDKhATFocDaXy9RsrdNFxDtSyq8/iw0wV5FnG42Chn/SepXIMHWBo/NfhRHxnPkfnhyz9rLFlIVldY0eLppsyuwmVgLUVE36rsC8vEiXRS/Qd0dg5hUvlJv6L8Az+C5rXJ6vLBKfEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723062950; c=relaxed/simple;
	bh=CvpcEutqJciU1sfO01v3Z5pbjqAw3fLkIrVF0e7m9LQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Pt8vsX9Y3DdedszATpUCdM7hnniEi0n6dwjhJIvyxDXu5xEZrGPpNXd7XtpZCT6qkRy7V90Y25lhQ4bcwR3KsTp1GsSfs31SWDqa0KxmODbWuJZR7VLQwB5XT2Jhdr7DxAc5LzJKCEkhgoGQUyeSAYJVwJNaH2i42qlJLSvee6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WADjvtAq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WADjvtAq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723062947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nhfoZeCiJb4NspeCJGRi3F0x8ZSKb4MHjV1peYiM8wU=;
	b=WADjvtAqlqD2BOlMEsf6lvW8Pb5bo37OlBiX6o8rS3hJfx9iMB6bsfFi+PGxETQN57sbvf
	B5+XFGzVcWJnzqdkZKjNM5bQ2DVhEIE4EjlI4ACf8Iks7nJGik3uCqUsWDZhb3tdn/L1/R
	G00KwQKT8GB5HKtVhXngudqrsa7Qny8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-Rm0cGiFJPS6xwT45YiDeOg-1; Wed,
 07 Aug 2024 16:35:43 -0400
X-MC-Unique: Rm0cGiFJPS6xwT45YiDeOg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 315FF19560A2;
	Wed,  7 Aug 2024 20:35:42 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C9A0A19560A7;
	Wed,  7 Aug 2024 20:35:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 477KZema3261060
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 7 Aug 2024 16:35:40 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 477KZdMZ3261059;
	Wed, 7 Aug 2024 16:35:39 -0400
Date: Wed, 7 Aug 2024 16:35:39 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] libmultipath: fix ontap prioritizer snprintf limits
Message-ID: <ZrPamzWZwgINRIgt@redhat.com>
References: <20240802172650.3063016-1-bmarzins@redhat.com>
 <b2caea99035d97739460d8eb87231b16f57171ee.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <b2caea99035d97739460d8eb87231b16f57171ee.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Aug 06, 2024 at 09:12:21PM +0200, Martin Wilck wrote:
> On Fri, 2024-08-02 at 13:26 -0400, Benjamin Marzinski wrote:
> > The ontap prioritizer functions dump_cdb() and process_sg_error()
> > both
> > incorrectly set the snprintf() limits larger than the available
> > space.
> > Instead of multiplying the number of elements to print by the size of
> > an
> > element to calculate the limit, they multiplied the number of
> > elements
> > to print by the maximum number of elements that the buffer could
> > hold.
> > 
> > Fix this, and also make sure that the number of elements to print is
> > less than or equal to the maximum number that the buffer can hold.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/prioritizers/ontap.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/libmultipath/prioritizers/ontap.c
> > b/libmultipath/prioritizers/ontap.c
> > index 117886ea..28e663ac 100644
> > --- a/libmultipath/prioritizers/ontap.c
> > +++ b/libmultipath/prioritizers/ontap.c
> > @@ -39,8 +39,8 @@ static void dump_cdb(unsigned char *cdb, int size)
> >  	char * p = &buf[0];
> >  
> >  	condlog(0, "- SCSI CDB: ");
> > -	for (i=0; i<size; i++) {
> > -		p += snprintf(p, 10*(size-i), "0x%02x ", cdb[i]);
> > +	for (i = 0; i < size && i < 10; i++) {
> > +		p += snprintf(p, 5*(size-i), "0x%02x ", cdb[i]);
> >  	}
> 
> This seems incorrect, too. We should pass the remaining size of the
> buffer, which is ((10 - i) * 5 + 1), unless I am mistaken. It's bogus
> to use the "size" variable in the calculation of the remaining buffer
> size. Plus, we should break the loop if i >= 10, and check the return
> value of snprintf (if we don't, we might as well use sprintf in the
> first place).
> 
> Actually, this code is horrible and we should rather use strbuf.
> Strange that none of our many compilers found this, and even coverity
> didn't.
> 
> >  	condlog(0, "%s", buf);
> >  }
> > @@ -56,8 +56,8 @@ static void process_sg_error(struct sg_io_hdr
> > *io_hdr)
> >  		io_hdr->host_status, io_hdr->driver_status);
> >  	if (io_hdr->sb_len_wr > 0) {
> >  		condlog(0, "- SCSI sense data: ");
> > -		for (i=0; i<io_hdr->sb_len_wr; i++) {
> > -			p += snprintf(p, 128*(io_hdr->sb_len_wr-i),
> > "0x%02x ",
> > +		for (i = 0; i < io_hdr->sb_len_wr && i < 128; i++) {
> > +			p += snprintf(p, 5*(io_hdr->sb_len_wr-i),
> > "0x%02x ",
> >  				      io_hdr->sbp[i]);
> >  		}
> 
> Same here, the remaining buffer size is (5 * (128 - i) + 1).

Sure. I'll send a v2.

-Ben
 
> Martin
> 
> >  		condlog(0, "%s", buf);

