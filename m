Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CEF227E8F
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 20:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753130352; cv=none; b=chbsAOSebzIQrFKR6xldFsnRqUtqxGzXIKvf2NHKleA65wBP5q7L2c7NCjVwatY+r5roMqXMfAgC+gtCNbxvlxIUbLyCOcZPbudnJ7CXGbi2b9c7U+FG+FyeeQB7gdgrIpyPkHcvy7b60xanhrJ91RaiKO1KJi5pgHoWjhCN2gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753130352; c=relaxed/simple;
	bh=FfTpwIEXmUU2boGaS+rPfHHp4SzYM2E6JAOpIRfNdxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=uHELDbS0Jh5+l+RDqIYrJjfLQZO5ekFG1Bbu01tMSQKJMqV5WHv77TyL0tfba2sAEAOFuwfxGzk+wzw0jNA7Qh7FfGhJP755pDVSjm/PYXaF81OZZHWThvhkJHoA47wz87LgTL3TxI7p5eXNUF24V8tqZ3zj6atDN16KMv3vhkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gS8f3mYy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gS8f3mYy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753130349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dxPYJ11lWQFDBqIE3lp98lbwuPdTXFjo5BPEhmsPpvc=;
	b=gS8f3mYy59IzBM7+qBUtZKX22dGW/GU0QeI3kjc7YCH3AARN1OGMwrmo37wc4p/jypTGwY
	UEDjkN+PYuqSK8DkVAPM2Ic7nhbX6x6Vhfk6BrUxadHgxToJ1DlECmlIcZl0dZFe2pJZrF
	RggLENGc1j8Xcl87BtwgcXLQ7zqQBbg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-U5GE2_jnOkORLyNnbGntiQ-1; Mon,
 21 Jul 2025 16:39:05 -0400
X-MC-Unique: U5GE2_jnOkORLyNnbGntiQ-1
X-Mimecast-MFC-AGG-ID: U5GE2_jnOkORLyNnbGntiQ_1753130345
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CAE861800447;
	Mon, 21 Jul 2025 20:39:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C8C618003FC;
	Mon, 21 Jul 2025 20:39:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56LKd3UG202806
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Jul 2025 16:39:03 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56LKd2EV202805;
	Mon, 21 Jul 2025 16:39:02 -0400
Date: Mon, 21 Jul 2025 16:39:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Funda Wang <fundawang@gmail.com>
Cc: dm-devel@lists.linux.dev, mwilck@suse.com
Subject: Re: [PATCH] multipath-tools test: add missing include for stdint.h
Message-ID: <aH6lZpZ-ZltVZNgj@redhat.com>
References: <CAOfq2QS2rh7_+rbqeDMa1gjEFht2QThnLqfes_kzwt02uafbvg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAOfq2QS2rh7_+rbqeDMa1gjEFht2QThnLqfes_kzwt02uafbvg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MDxKqRj_iHbo2Ldux1pUiSTVNbtn14kxU8hkKr1cNaY_1753130345
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 22, 2025 at 01:28:33AM +0800, Funda Wang wrote:
> When building multipath-tools with cmocka 1.1.8. it produces following
> error when make test:
> 
> In file included from test-log.c:6:
> test-log.c: In function '__wrap_dlog':
> test-log.c:24:20: error: 'uintptr_t' undeclared (first use in this function)
>    24 |         expected = mock_ptr_type(char *);
>       |                    ^~~~~~~~~~~~~
> test-log.c:10:1: note: 'uintptr_t' is defined in header '<stdint.h>'; did
> you forget to '#include <stdint.h>'?
>     9 | #include "debug.h"
>   +++ |+#include <stdint.h>
>    10 |
> test-log.c:24:20: note: each undeclared identifier is reported only once
> for each function it appears in
>    24 |         expected = mock_ptr_type(char *);
>       |                    ^~~~~~~~~~~~~
> test-log.c:24:20: error: expected ')' before '_mock'
>    24 |         expected = mock_ptr_type(char *);
>       |                    ^~~~~~~~~~~~~
> test-log.c:24:20: note: to match this '('
>    24 |         expected = mock_ptr_type(char *);
>       |                    ^~~~~~~~~~~~~
> make[1]: *** [Makefile:74: test-log.o] Error 1
> rm parser.o.wrap dmevents.o.wrap hwtable.o.wrap uevent.o.wrap
> blacklist.o.wrap util.o.wrap
> make[1]: Leaving directory
> '/home/lkp/rpmbuild/BUILD/multipath-tools-0.9.5/tests'
> make: *** [Makefile:121: test] Error 2
> error: Bad exit status from /var/tmp/rpm-tmp.7qc9Bd (%check)
> 
> The attached patch solved this issue. Thanks.
> 
> GitHub pull request: https://github.com/opensvc/multipath-tools/pull/117

Looks good, but for future reference, it's easier to apply if the patch
is inline ("git format-patch" and "git send-email" will make sure it's
in the proper form. We use the same email workflow as the linux kernel,
so you can look at linux kernel patch submission instructions for
how to use git to submit patches). But thanks for the fix.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

