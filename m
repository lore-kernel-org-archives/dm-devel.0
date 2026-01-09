Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538281F03D2
	for <dm-devel@lists.linux.dev>; Fri,  9 Jan 2026 04:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767931653; cv=none; b=gwAcufv7LlhU24JOYGXx24h8vlvGR8t50dmdLyngbEjMFUy4ffsFimWR+9aRYomPs2UDbnFZfafyhwRmj5Tlru38ziIfcvIOOCa22/1eWZSt8ump2kgrpirbUMCstPZiIiCSYyGDyc8L/FVJwelGk3LjIE28VqTXSDb99CNYs8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767931653; c=relaxed/simple;
	bh=YFsi/OCipb9s819FR6nDBLbsBmZbOYXwNO0iwDzqKaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=e1S2RFu0Lulb3LWBChku2fnq44jWF1jz7rCGa+fcN5XSUoqtdp//Mz+cgQJrlS9XM7dO5Om10TK6tg+aUTMg3hmwYJjIQzq/VcpDjjmguPJ2P7cD0yrKVt3aPUgmvBMMWOA+JJki6CkbNGU3JM7NCnx5i8acQZfUAcB537/BnTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L2JmPmq4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L2JmPmq4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767931651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vlZcMX/RO/lNDwGRKp/jw8ThikeeOTaBS/kne7+5Wpw=;
	b=L2JmPmq4yC+K41HkCpQKKG84PGMjlHXp7h/maU+EXK2jeHw4f1IdZzKv4KvmhPc+Fnpf3s
	g6RjBqIfzw+CnaGrduaqEehqixjNIssEW0bUa47B9I/u9waMmKxAeeOACmY35c/i8ty/qE
	2riRiS1WPJ/M1lZkIYahv+uXbrP59nA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-388-4lv8OTYyOuOni7jjPG59WQ-1; Thu,
 08 Jan 2026 23:07:29 -0500
X-MC-Unique: 4lv8OTYyOuOni7jjPG59WQ-1
X-Mimecast-MFC-AGG-ID: 4lv8OTYyOuOni7jjPG59WQ_1767931649
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A399118005B2;
	Fri,  9 Jan 2026 04:07:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4CE341800240;
	Fri,  9 Jan 2026 04:07:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60947RxY3092078
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Jan 2026 23:07:27 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60947QI93092077;
	Thu, 8 Jan 2026 23:07:26 -0500
Date: Thu, 8 Jan 2026 23:07:26 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v3 00/26] Multipath-tools: various bug fixes
Message-ID: <aWB-_jvJ8EnijrRt@redhat.com>
References: <20260107201826.323977-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2aCycXc1D-Ne9EqWvYsmjo8_fA_LP7SNJiYKRMwYdGk_1767931649
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 07, 2026 at 09:18:00PM +0100, Martin Wilck wrote:
> Changes v2 -> v3
> 
> - 05/26: dropped, orphan_paths doesn't need to be exported in v3
>   subsequent numbering changes accordingly.
> - 12/26: do make sure in free_multipath() that this mpp isn't referenced any more
> - 13/26: new, another cleanup for the multipath freeing code
> - 14/26: to avoid the UAF pointed out by Ben in [4], change the order of definitions
> - 15/26: orphaning is now done in free_multipath() (see 12/26)
> 
> [4] https://lore.kernel.org/dm-devel/aUYpC_LaTHXIUkVU@redhat.com/T/#mbb46f26895f6626f6d965269691133f85875cc77

For the set:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

