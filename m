Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226696;
	b=SdbKQNxYqC+6BvDi4u5w2hxVeihWaMazUS3zt3gefDNbZn/C9v8W9qaSRUAzdgWOTCG2
	 jhOI1odVLohQJB5MzcZjZSMhwpxq8EHUaONJIK/SXvezYvX0rH8kt+oDXVS0RLI7RKftv
	 qWwhvD6LEPVblcHIAV4cc+jUMzF8rhiSlqq0EZKZl6oJGow0ljv1Tf1uEqdngz+VbRsWW
	 S8jwatqElhak6oP4nX99mE4RFIJkyCfcOgQQ9DLYGduPKLvmnoWNsojVzQYWj/TtOCxS1
	 STpXBXX71vmZX2687YlugN6ZDwV7fG0KkV1pB+dUaq2eIRnd+9P9AwncFxnomSJTDOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226696;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 In-Reply-To:Message-ID:References:MIME-Version:X-Scanned-By:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=OBdiK9l8kFT4f0yo7evXfhDN4v7F5oYM4pE8DacBPJ8=;
	b=JGMJkIqWtopnE4TkGGpslVt5F0V0I4VF0+lkNtVbYK00oOZLwQLokL0UAbRFcaXcYpuO
	 Li/bCKbF0nCSBP4swIwejbMuJBUhPU9Vl0OeHPE3QqygnuX0KRYUw5L/goxe+OrwLns2o
	 zNCCrGqxRPGsAxdnMRqGh4YKuAlgzGMkrLSl1K8M5meWimoqQefiePE8YBM/Gg4deG91G
	 Cl6GvmTt7BcDLA3XiAmZC3Zdl7NuEobxYmALeDy6eME1cjs8yXPHD6otV2CS/qdEWY+Yh
	 sjkkuk9H8X7Kr3J8UDL/qf2CDSBvquYs81sNFEw4rNYDFndsfjPmkRWUFaTBrt/d5Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TAPvASjP;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2053606A323
	for <dm-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:18:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2053606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TAPvASjP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794226695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OBdiK9l8kFT4f0yo7evXfhDN4v7F5oYM4pE8DacBPJ8=;
	b=TAPvASjPl4eu8m+jnZ90lu4abwmDXPN7Jjfzz0hSHiApYJ17LsMb/vU1/QDd0mcQNMzvwd
	FCj5G3DWsd0lpwKNJz+oMGe4dFe3PQBCzVAKnAxp6btcspwbY235/EA9jHNdHPlFg15uTj
	uyGux73l6pIgW28nVJbqpBC2PElkjz8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-219-B2yFbfMxM02T4zTZ50vSbA-1; Mon,
 09 Nov 2026 07:18:11 -0500
X-MC-Unique: B2yFbfMxM02T4zTZ50vSbA-1
X-Mimecast-MFC-AGG-ID: B2yFbfMxM02T4zTZ50vSbA_1794226690
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 12EC3180055F;
	Mon,  9 Nov 2026 12:18:10 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 23EDA18004F5;
	Mon,  9 Nov 2026 12:18:06 +0000 (UTC)
Date: Mon, 9 Nov 2026 13:18:04 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: Josef Schlehofer <pepe.schlehofer@gmail.com>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
    Ignat Korchagin <ignat@linux.win>, Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] dm-crypt: defer async write submission to write thread
In-Reply-To: <0197be1d-1257-4597-aea2-1a065fe0a1d5@kernel.org>
Message-ID: <4093292e-1fa1-dc18-b185-18dff61a32bf@redhat.com>
References: <20261105072708.30722-1-pepe.schlehofer@gmail.com> <0197be1d-1257-4597-aea2-1a065fe0a1d5@kernel.org>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: P4a6UKbjN7jbu8RBUCdY6JMoS49g-EqFquBWUhTdBec_1794226690
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 9 Nov 2026, Damien Le Moal wrote:

> On 11/5/26 16:27, Josef Schlehofer wrote:
> > With no_write_workqueue, kcryptd_crypt_write_io_submit() submits the
> > bio directly, even when called from kcryptd_async_done(). An async
> > cipher may run this callback in softirq or with BH disabled, where
> > submit_bio_noacct() must not be called because it can sleep.
> > 
> > Submit inline only when async is false. Async completions are sent to
> > the write thread, as is already done for submit_from_crypt_cpus. Use
> > the async flag rather than in_interrupt(), since callback context
> > depends on the cipher driver. Sync ciphers still submit inline.
> > 
> > Tested with cryptd in QEMU (x86_64 and arm64) with
> > CONFIG_DEBUG_ATOMIC_SLEEP, and on a P2020 running 6.18.55 without it.
> 
> Originally, this was added to avoid write reordering for zoned block devices.
> So did you test this change with that (scsi_debug or null-blk) ? You can also
> use an emulated NVMe ZNS device in QEMU.

So, should we disable asynchronous crypto operations for zoned devices? 
Would you send a patch for that?

Mikulas

