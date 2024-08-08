Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98295148316
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 14:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723127049; cv=none; b=pvBW51J834t2yfk0kAgoOM7/IwFZ80i95W29cPHXmbrHVUPtInUGMAJEIIf9qi1fAGksTNt8JElL2ZVBti00TJO66G/XZHmk6vuoypExq7kjl/0E5sx4wc7Dww2ReBW8OWPJYr+4kE+5d/f13AcKRaSdLLDQLCp7KstVfJKvMFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723127049; c=relaxed/simple;
	bh=K2exqiivt6s/l8Tp7R3o4jUE1rj4m3zmRo63AGztQVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=q4W5a48/IIf9wj+kr06ApRIEeCzYN7+NSuZZMCMYk+MT5yWBUbvjOtZWObBlCIJSzABplFhNcvoKnoUPi6RgBJyVucPFQAGts8GeFHiCvQOnIQoim5go1EVs46V/gf+1dA5hoymNcGFIgzSNjeM9rnrCssJEzgS+38kUfCxOI/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zk+8vl3l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zk+8vl3l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723127046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WfIwUA3DI4zvOUBPVAOoJkbvhe37qIatBV+orWYafMA=;
	b=Zk+8vl3lfvKguCilmhg8l9KGB7Qj2aJiHvQr2sRXxivrAW7+eEluLpt39U6sQEPXbd+RbV
	u/2jW/7rFAi8j8l/2QPBOOL9yU2s3lm679yQWT0uzP91NB1LVefTibG5bmwSjZUjF+eLDf
	E22lhcEfwZN3tMO4XNHDovlKKRELJc0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-193-_a_jmoENPFSOv24OA1mXcQ-1; Thu,
 08 Aug 2024 10:23:59 -0400
X-MC-Unique: _a_jmoENPFSOv24OA1mXcQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E7F11944B34;
	Thu,  8 Aug 2024 14:23:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA26E1953976;
	Thu,  8 Aug 2024 14:23:57 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 478ENuaL3288460
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Aug 2024 10:23:56 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 478ENtGQ3288459;
	Thu, 8 Aug 2024 10:23:55 -0400
Date: Thu, 8 Aug 2024 10:23:55 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2] libmultipath: fix ontap prioritizer snprintf limits
Message-ID: <ZrTU-0Ks8P0BCilu@redhat.com>
References: <20240807225910.3266004-1-bmarzins@redhat.com>
 <c57cc983f1e226b284a67a9e801c97602fed0783.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <c57cc983f1e226b284a67a9e801c97602fed0783.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Aug 08, 2024 at 10:55:19AM +0200, Martin Wilck wrote:
> On Wed, 2024-08-07 at 18:59 -0400, Benjamin Marzinski wrote:
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
> > Fix this by making these functions use strbufs instead.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > 
> > changes in v2:
> > Use strbufs as suggested by Martin Wilck.
> > 
> >  libmultipath/prioritizers/ontap.c | 28 +++++++++++++++-------------
> >  1 file changed, 15 insertions(+), 13 deletions(-)
> > 
> > diff --git a/libmultipath/prioritizers/ontap.c
> > b/libmultipath/prioritizers/ontap.c
> > index 117886ea..b508371d 100644
> > --- a/libmultipath/prioritizers/ontap.c
> > +++ b/libmultipath/prioritizers/ontap.c
> > @@ -23,6 +23,7 @@
> >  #include "prio.h"
> >  #include "structs.h"
> >  #include "unaligned.h"
> > +#include "strbuf.h"
> >  
> >  #define INQUIRY_CMD	0x12
> >  #define INQUIRY_CMDLEN	6
> > @@ -35,32 +36,33 @@
> >  static void dump_cdb(unsigned char *cdb, int size)
> >  {
> >  	int i;
> > -	char buf[10*5+1];
> > -	char * p = &buf[0];
> > +	STRBUF_ON_STACK(buf);
> >  
> > -	condlog(0, "- SCSI CDB: ");
> > -	for (i=0; i<size; i++) {
> > -		p += snprintf(p, 10*(size-i), "0x%02x ", cdb[i]);
> > +	for (i = 0; i < size; i++) {
> > +		if (print_strbuf(&buf, "0x%02x ", cdb[i]) < 0) {
> > +			condlog(0, "ontap prio: failed to dump SCSI
> > CDB");
> 
> If print_strbuf() fails (very probably because it failed to allocate
> memory), condlog() is unlikely to succeed, either. I thought we agreed
> that trying to spit out error messages in this situation makes little
> sense.
> 
> Anyway, I guess the condlog call doesn't actually hurt, so:
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> (If you consent, I'll edit the commit and remove the condlog call).

Feel free to remove them.

-Ben

> 
> Regards,
> Martin

