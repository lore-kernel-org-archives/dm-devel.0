Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A849384A3E
	for <dm-devel@lists.linux.dev>; Mon,  3 Mar 2025 17:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741021609; cv=none; b=g/75dxhUkzePJWv6MNcMcuj+lwuJ/BvFXzIwC+zy2dEm4O02lgTY7w4XW/hIcJv62etaUcoDiutXgkRWOX+oB2RMHgTfamMokTqagLuLTdu4DyGVBY0QyteNDAd222WWDZXnexTlFctqOnti4C5jt1PYOEp2Kju3HL51oH80z8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741021609; c=relaxed/simple;
	bh=72YyS2OAf6NLu0KHgYnmBut4F0v6p6K25KPVIuiiyFk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cpr16IDJ8+bICpT6Rd+VIfvx2Czw84XxvH4skXiFqRvE9Lob4IjTWp/Zs+Fhk5cCBnNsmcUSV0KT3PKcIQnuTqFeD/3kA23b4f86+zLmlTiu0iwe4HlFGfY+1MGOw4cpPIb6Y298+DvQH7SfTjaXyqHLkdHEsuGcg+8PlB/rb0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TZXvURnm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TZXvURnm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741021606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y+WdRNe3uYjKyeloc7G7vtyVlx46YrXe5KrCFL9hSR0=;
	b=TZXvURnmBJxtW+/+eGLa+ECfpRIUoJRsYoXmf1uiQhOc1j6lnAa631JxlyVeq/BH9ci+ZJ
	o/yQI/5RnhJQHvTjcWKbBl/T6QQBDCDX336ecVEwRa2uV+CN7x6KYpcYKwuEQi2kMOHOIu
	43D5GkY5bG0ba9CWr2R1XIsf1HLi4S0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-512-dOnRwxLUNJyvAHFY-CyoNQ-1; Mon,
 03 Mar 2025 12:06:45 -0500
X-MC-Unique: dOnRwxLUNJyvAHFY-CyoNQ-1
X-Mimecast-MFC-AGG-ID: dOnRwxLUNJyvAHFY-CyoNQ_1741021604
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3CF891800986;
	Mon,  3 Mar 2025 17:06:44 +0000 (UTC)
Received: from [10.45.224.44] (unknown [10.45.224.44])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E1EC1954B00;
	Mon,  3 Mar 2025 17:06:41 +0000 (UTC)
Date: Mon, 3 Mar 2025 18:06:36 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "Bryn M. Reeves" <breeves@redhat.com>
cc: Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, zkabelac@redhat.com, 
    dm-devel@lists.linux.dev
Subject: Re: [PATCH] the dm-loop target
In-Reply-To: <Z8Xe9bJQYs9TiUrO@redhat.com>
Message-ID: <0690d480-1bb9-a586-6b3b-976b9bf2ec1d@redhat.com>
References: <7d6ae2c9-df8e-50d0-7ad6-b787cb3cfab4@redhat.com> <Z8Xe9bJQYs9TiUrO@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ynFBQtxJQ0qtdDbw7LrYYCM2Ry5bhH_D4sEOTyZFB8M_1741021604
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 3 Mar 2025, Bryn M. Reeves wrote:

> On Mon, Mar 03, 2025 at 11:24:27AM +0100, Mikulas Patocka wrote:
> > This is the dm-loop target - a replacement for the regular loop driver 
> > with better performance. The dm-loop target builds a map of the file in 
> > the constructor and it just remaps bios according to this map.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> This looks like it is based on my dm-loop patch from almost 20 years
> ago.

Yes, it is. I copied some of the code from it.

> Afaik the locking problems that hch pointed out back then are still
> valid now - stashing the bmap lookup in memory lead to weird and hard to
> debug problems back then and I don't think this has changed.

The dm-loop driver does the same thing as swapfile activation - so I 
presume that if swapfile activation is correct, then dm-loop is also 
correct.

The S_SWAPFILE flag prevents the kernel from truncating, extending or 
deleting the file - it just returns "Text file busy".

Mikulas

