Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793995588;
	b=1qT51vYfxlAijDlAmYWhxKOvDmTgvbcJV/YfP+a9Dw6bV66fH3ka/w4erAOOGmMv2xAC
	 K32uai6rccXLMEjAFznsbMrSYj7QtbmZYPXXoTwu0xK51iquuIp1NCxwEI8mJAIb3R7LN
	 ZRtvL0RxAxJUAiHobbMXmjHvk+BNXxmITNJ6eoN/JJ7Zat7aqWiZoRq5LOFlqnY4T5QS/
	 AgNlQD70u9kcGSEn5vK5xnxqhE0REaW1gGPMIKx/RyNZGgCBHYPeQhnlQlZ5m2brAUqea
	 BE/t7vcDG4CnZ0jEH+NwO4/YRtn7RvCcUupEVwVQ0K9ucXPuU3fRZ21HBGdH0Q+dBNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793995588;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=uptfdeAUqgPH01+drZQYI3DhqukTNPQ6i+MsgnL4Mzg=;
	b=Zxq0rUWYv+Qd51vJEqKAyZC7cfk8dv4j7d61qZVa19G0ZiXawqckF282Lf8gKuMMhyYW
	 SGMvzWbh6KkJEmbeMoN3z4MvOW0aJpTLkduHqgWfSk7GjU0Ggl/LWWF71d28JE8NXCrd4
	 9AlWsvrevguTIsJO91LrfXKrf9V/IcEryIFwhbWaMj60+S1Yd+/zdJBZl+AgeE+n3JlOC
	 +5+XPudkHhjTtlsfv8QaQCtghJmudGpvZgRuplDAam/q6mhk6fm3E+2+vcHLXtTsNfxc6
	 dKUxe3umRbhKSwNxzkRlB3q8cMLbrXF31QSyjnF5twSrywHfufJVtSuSmUuSsu8DTQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Mo2m9Z9t;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0CB606A32E
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 20:06:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC0CB606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Mo2m9Z9t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793995586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uptfdeAUqgPH01+drZQYI3DhqukTNPQ6i+MsgnL4Mzg=;
	b=Mo2m9Z9tTF0Y2CnmmIOUPUxonazUrGjKOWc63pyTh89r0IDIk+Cyukchqa17rOKKQdxj1Z
	6GiP1IIGyRj/LVNRuGafUEs9yl+4kIiz2XMTsCOkG2woU/sv7Bb3exkRqDMlJBJwAbi4K4
	SH6+VYSoKTHTwyjkMIvUbDuj0AcXzek=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-674-boO7LIzyP5iYBzCg8Dtqzg-1; Fri,
 06 Nov 2026 15:06:23 -0500
X-MC-Unique: boO7LIzyP5iYBzCg8Dtqzg-1
X-Mimecast-MFC-AGG-ID: boO7LIzyP5iYBzCg8Dtqzg_1793995582
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4008A1800653;
	Fri,  6 Nov 2026 20:06:22 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C426E3001DB1;
	Fri,  6 Nov 2026 20:06:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6A6K6K783695181
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 6 Nov 2026 15:06:20 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6A6K6Kb13695180;
	Fri, 6 Nov 2026 15:06:20 -0500
Date: Fri, 6 Nov 2026 15:06:20 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Alex Brett <alex.brett@citrix.com>
Cc: dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] libmultipath: open_file: rewind after writing the header
Message-ID: <au4zPAAiuq-yQpYQ@redhat.com>
References: <20261106152444.1541438-1-alex.brett@citrix.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261106152444.1541438-1-alex.brett@citrix.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BraahA23XfcvehO7rO289ao8FeK0EoUYBr9T-pLJ4Z0_1793995582
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 06, 2026 at 03:24:44PM +0000, Alex Brett wrote:
> When creating a new file, open_file() returns it with the offset after
> the header it has just written, but on opening an existing file it will
> return it with the offset at 0.
> 
> _read_bindings_file() reads sequentially from the returned fd, so on a
> newly created bindings file the header check in _check_bindings_file()
> hits EOF and declares the file bad. Without -B this is masked by
> rewriting the file, but "multipath -B" may not write it and aborts:
> 
>   ERROR: bad settings in read-only bindings file /etc/multipath/bindings
>   fatal configuration error, aborting
> 
> This affects the first "multipath -B" on any system without a bindings
> file, such as an installer environment.
> 
> The wwids and prkeys code paths seek before every access and are
> unaffected.
> 
> Fixes: 7eaeb33ae9f7 ("multipathd: watch bindings file with inotify + timestamp")
> Signed-off-by: Alex Brett <alex.brett@citrix.com>
> Assisted-by: Claude:claude-opus-5-5

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

