Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518AC3DAACB
	for <dm-devel@lists.linux.dev>; Fri,  9 Oct 2026 10:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791540140; cv=none; b=bxSdhfh+F+RCQNAYA8wJErngbvtL4WeKSkDmKziNFmE5cXlOTvj7GXCR+rALD7ZGphF2DEyGWQbbGx8aGnOPDlLNcd99eoNBsgr6UBTUQWPihRpxU+i961RTHba+fmD/MmeiHB4qa7N55H/uYK72BoVoJEMBeirdU0JWe/bhdU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791540140; c=relaxed/simple;
	bh=ELo1xj4tv2NEsMSyG+rgox8vQqlqCYHY1+dFcKjyXTg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fO+jejPCQPko5D7ciNAY4VJfSeX2YuxDDSxiJ1wBMrWkPUCSFcLHBVcQXki3NYWRhSmN0vVRO2Ptag3NUAXXq2WFhzqtB5Qg87FZdAu65wQCNTCyX7W0qFTKEREO+ppKDMOhE4rEffMnKnccm504t3CF2q6EhcuDwId/ChBpUeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JjybgrBD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JjybgrBD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791540138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dbf/l4uU+bsLoxlmKw8Vt+syCnVEZ9WpjOMjHVGhgJo=;
	b=JjybgrBDP32OSvDjKpSNQWOyfbo6hqo/bnzf3NczXfRYzDkRzkdunqh/kCExodWGEeYrLV
	sGduNgbAbr1Ez7peZ44IfZ2bYL4bhZhgbJ6rEul6xF5K1q5ooj3P5ZrjB6Y7gXqZDmlAyV
	VUKd3O1JRTBjbPSvlRjceTu0/G3qCyo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-SQuKqYVdPI-F7G6R9q1fMQ-1; Fri,
 09 Oct 2026 06:02:15 -0400
X-MC-Unique: SQuKqYVdPI-F7G6R9q1fMQ-1
X-Mimecast-MFC-AGG-ID: SQuKqYVdPI-F7G6R9q1fMQ_1791540134
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8A8A1964CD1;
	Fri,  9 Oct 2026 10:02:13 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87BFD30000E3;
	Fri,  9 Oct 2026 10:02:12 +0000 (UTC)
Date: Fri, 9 Oct 2026 12:02:10 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Mike Snitzer <snitzer@kernel.org>, Alasdair Kergon <agk@redhat.com>, 
    dm-devel@lists.linux.dev
Subject: Re: [PATCH 0/3] dm-mpath: Miscellaneous HST path selector cleanups
In-Reply-To: <20261008202809.1976567-1-bmarzins@redhat.com>
Message-ID: <9ade9725-7a00-3702-6e3e-4afebef9f836@redhat.com>
References: <20261008202809.1976567-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lqKXgOHXFIKgmSOVnkK44Q2JUrmjVABSlLbxp0ZjeBM_1791540134
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 8 Oct 2026, Benjamin Marzinski wrote:

> These are just some minor cleanups for dm multipath's
> historical-service-time path selector.
> 
> Benjamin Marzinski (3):
>   dm-mpath: streamline setup work in the HST path selector
>   dm-mpath: standardize repeat_count handling in the HST path selector
>   dm-mpath: check values in hst_status while holding spinlock
> 
>  drivers/md/dm-ps-historical-service-time.c | 61 ++++++----------------
>  1 file changed, 16 insertions(+), 45 deletions(-)
> 
> -- 
> 2.53.0

Hi

I accepted all three patches, thanks.

Mikulas

