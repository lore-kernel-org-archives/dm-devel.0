Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795109917;
	b=wy46CmqiZ3O1TxUjXhMtMU9ycnH5u5+T2l523EilrKXpZZrgOGgB451IbfKPnvNghZ1q
	 sGhnOjWptRAxXj4XY2Z2u9KJ5KtcAnDNjkqAzogkpxjp6DsghyOqlaHstovah2wXLafce
	 16IJzNXlA/C0tlNiutesCYU2kHk6oVlsHbkS1GFczJJaGyDRz0ZWsnlRr/mB20Oz+MSCD
	 /i3dR2UcUPVuqGSxPLhC9v5odDwSC+WW35BZf/w/Lj65gRj8LPXdXRWQsoIBzkGMcKNiN
	 UVQgl3pqrtONvUgifMK1KUdnMA+Dayck4f9J4vXg9+CDPi5NT4xxHdtDuEdrWHENArA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795109917;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=zSaENEsvHzNw+tFXHAFqohX6GQoQsvUJJGL3w2CqS1w=;
	b=Wx6Ha7GFSITLgK1YD0k19w3p3LhjkZDkeNtnMQs2jPXx6BVZPL0tMEBf2wb3AZuUPlJe
	 j9+uODCH3yE26E9MemFdMgOAkK2HPEDC3CNf4O7VIpclyZj6CrX7afADU2oopCDsCE35p
	 m/0SjWK7dt/X+2BBHuOmQkZ21qYVB06ThQQcueRhML0R0z3myDCA2EIsersgSz/gfYQMP
	 DPFW14I0ogireOGxJrprWTRHZ7Hfsj420XrpH7gN1BjLE5DnF/5Pacyw50PzaX7PN+jwG
	 ymNvFCUJcVDuooxuOyNJDuA2C+/lLD8scCI2TIxx+16u6OZj7fqu8w/KZUNhaBTGU+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UNFjutZ0;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E85F606A324
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 17:38:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E85F606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UNFjutZ0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795109915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zSaENEsvHzNw+tFXHAFqohX6GQoQsvUJJGL3w2CqS1w=;
	b=UNFjutZ0fMto0hg4sA2uW5keb/miwGg36T9tWWCjXPxcBz6V8iZPpSUeax4JEeLZ6D7aV5
	KZHlCgtbiUAXDwnO9GYEYR3TQVRFlK+1EKSocQuqRlvq+0u7QnfYkcqV51pJtR9blGqekU
	cbb3gzjvHifUg9zL0XRaM6uA013Hj74=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-370-S1oovbNKObCX4mbfMZXZEg-1; Thu,
 19 Nov 2026 12:38:28 -0500
X-MC-Unique: S1oovbNKObCX4mbfMZXZEg-1
X-Mimecast-MFC-AGG-ID: S1oovbNKObCX4mbfMZXZEg_1795109907
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95FE41955F05;
	Thu, 19 Nov 2026 17:38:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 344C31801971;
	Thu, 19 Nov 2026 17:38:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AJHcQ6Q835683
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 12:38:26 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AJHcQMW835682;
	Thu, 19 Nov 2026 12:38:26 -0500
Date: Thu, 19 Nov 2026 12:38:26 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 01/13] multipath-tools: multipathd.8.in: fix mandoc
 WARNINGs
Message-ID: <av80EsBawOfxfHXK@redhat.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
 <20261113125549.504780-2-xose.vazquez@gmail.com>
 <avt3vc307mk4FHZK@redhat.com>
 <ac29a29d-9932-495a-b75f-1fe4fe7948c7@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <ac29a29d-9932-495a-b75f-1fe4fe7948c7@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OtSXsXi1aOn_hxVolaY-cDGkl0BE_C7BxdJfN748I9c_1795109907
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 18, 2026 at 04:02:58PM +0100, Xose Vazquez Perez wrote:
> On 11/16/26 10:38 PM, Benjamin Marzinski wrote:
> 
> > On Fri, Nov 13, 2026 at 01:55:33PM +0100, Xose Vazquez Perez wrote:
> 
> > > @@ -77,7 +77,7 @@ multipathd executes the given command (see \fBCOMMANDS\fR below). If the
> > >   command contains whitespace or shell special characters, it needs to be quoted
> > >   like in \fImultipathd -k'show topology'\fR. No whitespace is allowed between
> > >   the \fB-k\fR and the command string.
> > > -
> > > +.br
> 
> > Nitpick: If we don't want an actual blank line in the option
> > description, I'm not sure the line break really matters here.
> My intention was simply to replace the blank line that mandoc was
> complaining about and remove the visible empty line while keeping the
> rest of the formatting as is.
> 
> That said, if you prefer merging it into a single continuous paragraph,
> I have no objection to dropping the .br in v2.

IMO, it's not worth doing a v2 just for this. But if you are already, then I
think dropping the .br makes sense.

-Ben

