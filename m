Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793729359;
	b=0Tqz1u/ICNcET83133k3NTEYzsF88XGzHXD44q9EwdoaZmadwx5E59cixJbdKwSzKgfC
	 +SEmMDSOOggraskJFbnL4uAPjdBsVy7Kw1kYZ97UVXOXOl6MofnCgFhYVyZHQhAz9SC7X
	 lxWXiglC38zUb0iS7dKoaSCL5FF/nXX46J0dul/xTK1nuUBDnm/SuicQXD5N5OR76JyIf
	 7Hopve584jWI+lP4LbjsRRA3QckqmcjS9u3UNe8hSBzqU8sHhxN14t3wYntnxkC0hziWB
	 zXM+c3vMiVS2mXk2lnpL9+hS3yhVyMRV5t5RBfGrv7qMmL5cA7Vv8qkYGZDjofhNi9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793729359;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 In-Reply-To:Message-ID:References:MIME-Version:X-Scanned-By:
	 X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type;
	bh=DW5wZ7cix9WWu3Y1870HF3zplpdEFHT7ED9wVFfnNA4=;
	b=b2hR+0FuDcYoC6DU0GToMBgrMQcvQLQpmxyCu19lu5wesDTqrHH3MSMH4B9M0Q6tV95a
	 NmGNHOs+dwwi9181wrq1FKVlBqoRJ5jm4gM4Vj2vtOkLEIYf0/s7tfl7flW+zW6YgO8Gk
	 Pd2xFDC9gFoLEvTvFZPTSu8vbqfim2LAqS0Jy1DDbQtvfHDCExBtQztfL13uiagz515go
	 iV1CuPq2mlsHh4WVfppA6w/ti2CW6+PWoNBj4cSa82pWw/GWQjSq3pznSnoYAm55obOSI
	 v8bH1wfsZSCUbgw3WOFS2F/CzdaxJ9QT7v/5rOzH4vAlJ6Rt1LWJ0tyFBzrBrntIm8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="e0Ei5/hn";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4755606A31B
	for <dm-devel@lists.linux.dev>; Tue,  3 Nov 2026 18:09:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4755606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=e0Ei5/hn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793729357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DW5wZ7cix9WWu3Y1870HF3zplpdEFHT7ED9wVFfnNA4=;
	b=e0Ei5/hn46GPaqfGr5Nf1kgdRnMszl0l76hcNhE01CPptNTY7+Xmj/KJTkeP1EXbNDMhFC
	VSNdnd8Z7gRNH5kX1a3Mg62bG9T8NarPxl/KU5aEJsmSBJHiQntRtLrbTrNF0dgjt8YXyW
	zaF+lokh1eUD+qFAHlQxfJfxyZHzoE0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-jYLvm_6RM7eJsHhAJj4VDQ-1; Tue,
 03 Nov 2026 13:09:14 -0500
X-MC-Unique: jYLvm_6RM7eJsHhAJj4VDQ-1
X-Mimecast-MFC-AGG-ID: jYLvm_6RM7eJsHhAJj4VDQ_1793729353
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 85CBA1955F7C;
	Tue,  3 Nov 2026 18:09:12 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7304F30002CB;
	Tue,  3 Nov 2026 18:09:09 +0000 (UTC)
Date: Tue, 3 Nov 2026 19:09:06 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: sashiko-reviews@lists.linux.dev
cc: Igor Putko <igorpetindev@gmail.com>, Mike Snitzer <snitzer@kernel.org>, 
    Alasdair Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
    Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev, 
    syzbot+8e6fc64255334ccf3ab3@syzkaller.appspotmail.com
Subject: Re: [PATCH] dm snap: fix use-after-free when origin and COW devices
 match
In-Reply-To: <sashiko-outbox-183792@kernel.org>
Message-ID: <00a426d4-5caf-03eb-8ebb-a6aad0099d5a@redhat.com>
References: <20261024161459.5539-1-igorpetindev@gmail.com> <sashiko-outbox-183792@kernel.org>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 80IHdyxOixt_WS8kcxyVzJiXHRhROaw7zA5yPKEGWfE_1793729353
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Sat, 24 Oct 2026, sashiko-bot@kernel.org wrote:

> [Severity: Critical]
> Could a race between the two path lookups still trigger the use-after-free on
> s->origin and leak the device reference?

I'm wondering why is Sashiko doing such wild claims?

This bug can only be triggered by root and none of the commonly used 
storage managers trigger it - so it is really not "Severity: Critical". It 
is not a security bug at all.

Mikulas

