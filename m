Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17828130AC4
	for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 18:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713549874; cv=none; b=XgPWBbdl2tD1sgpuhM3LYCwEKyf5uM+dvbokfDZDnYLUKv0Mwka+MDNP3cnK4gZEQj4wISze0mGrpEObs4fz0HaeA5Mjf7cj9hK5v3p9Zxq1YaFAySYtQogGIFBpVCsGXS8qMw5OpugaFubdOs+st1Ruc0+80EWwvtqvt4agfpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713549874; c=relaxed/simple;
	bh=nq4wyBQrDr8crTxxWe8pKniZDlTVIGpGa3EkcYKFUo8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=f3Bc+ov3JbldvAZc2uiVV8rlcvYgIlTqmHMOJutUMRu9jyMIuDpEWXs6Jcq3LzfrxbYUeiecCIpSLdYYXhEtKv5phodmW9gRflsyRK/v/Gb8o4T3q0j53hFPWZf32d91pYETruvmIzrdcvivsWFCp+O4cQ9OHksluOK+J5kjZRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UfeORXWv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UfeORXWv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713549869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o5DiIAaypFQCUiSRGZEBukKmwVEfN80CNyFVQ1IBze8=;
	b=UfeORXWvD4HE7d0kseiwkqSisC999zFhl2VGXRg1NxxoI9AIQUwScMsRw7dnavhpKircXK
	dWTer53T9llGjS9FWIB8E9Z7C2R81qSrhuyedg3dq5rnLvhALeEY5/1SD7yTR6JDaEVclG
	CKjBiWm0IQQGpLZM5VxQkE7h0qZkPCc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-301-ueozs9dlNKOFAXYlvJG9tA-1; Fri,
 19 Apr 2024 14:04:24 -0400
X-MC-Unique: ueozs9dlNKOFAXYlvJG9tA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29D5B3C3D0DD;
	Fri, 19 Apr 2024 18:04:24 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 23CDC40219F;
	Fri, 19 Apr 2024 18:04:24 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 0B37B30C2BF6; Fri, 19 Apr 2024 18:04:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 0783E3FB54;
	Fri, 19 Apr 2024 20:04:24 +0200 (CEST)
Date: Fri, 19 Apr 2024 20:04:23 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "H.J. Lu" <hjl.tools@gmail.com>
cc: libc-alpha@sourceware.org, Zdenek Kabelac <zkabelac@redhat.com>, 
    Ondrej Kozina <okozina@redhat.com>, Milan Broz <gmazyland@gmail.com>, 
    dm-devel@lists.linux.dev
Subject: Re: memcpy is leaking secret data through ZMM vector registers
In-Reply-To: <CAMe9rOpz5Uft3MKXneYd3VqW1CaSXFF_GLBqKEZFiZsidKA43A@mail.gmail.com>
Message-ID: <e35dccca-a1e7-93c4-f797-b89246877370@redhat.com>
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com> <CAMe9rOoErR0xLqf4wLzk13XwTQY9-+cRAxDWKW9HU+rB0GApzQ@mail.gmail.com> <a995c5bd-8f80-2118-4d4-86e5e062a77@redhat.com> <CAMe9rOpz5Uft3MKXneYd3VqW1CaSXFF_GLBqKEZFiZsidKA43A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 19 Apr 2024, H.J. Lu wrote:

> You should write your own memory copy function and compile it with
> -fzero-call-used-regs if possible.
> 
> -- 
> H.J.

This would work - but I looked at OpenSSL and it seems to suffer from the 
same problem as libdevmapper.

OpenSSL uses plain memcpy, it overwrites memory before freeing it, but it 
doesn't overwrite the YMM and ZMM registers.

So, it seems like overkill to add a special memcpy implementation to every 
library that manipulates sensitive data. It may be better to have some 
general solution. There's already "explicit_bzero", so maybe we could add 
"explicit_memcpy" or "secure_memcpy"?

Mikulas

