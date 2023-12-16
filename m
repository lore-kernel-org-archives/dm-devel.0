Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B44023D4
	for <dm-devel@lists.linux.dev>; Sat, 16 Dec 2023 03:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g6sT4IyB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702697207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H6Gn/YXJSMUD3MjA7AcgYRxiTuQ22ugJ4L4GjWSZe3U=;
	b=g6sT4IyBV0JznVkYtzQC9T4R6/7Z2dQFjCQGqPenjjAM4ikz+OsijkyKK0Ph52uBEQPUGt
	jp1x6BGrhg0df/QKm8Tdagp+bAZdaIblSN8t2FY3f0v8xR+6/+nw5xUHmvS7lykqGUWvDd
	OqFPYAESqXNmcY68bxgRj7IFS+9MgHo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-247-UlCKRbQRMkqGzjh11soLrQ-1; Fri,
 15 Dec 2023 22:26:46 -0500
X-MC-Unique: UlCKRbQRMkqGzjh11soLrQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA4E3282FA1A;
	Sat, 16 Dec 2023 03:26:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A26D23C25;
	Sat, 16 Dec 2023 03:26:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BG3Qjmr677913
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 22:26:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BG3Qjso677912;
	Fri, 15 Dec 2023 22:26:45 -0500
Date: Fri, 15 Dec 2023 22:26:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 14/16] libdmmp: handle failures in _process_cmd
Message-ID: <ZX0Y9RAYS75s762T@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231212235320.440336-1-bmarzins@redhat.com>
 <20231212235320.440336-15-bmarzins@redhat.com>
 <24f65fc3c37e27a859d9c9447494ccabd1f926ea.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <24f65fc3c37e27a859d9c9447494ccabd1f926ea.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 14, 2023 at 06:23:19PM +0100, Martin Wilck wrote:
> On Tue, 2023-12-12 at 18:53 -0500, Benjamin Marzinski wrote:
> > currently, most of the callers of _process_cmd() do not gracefully
> > handle the case where multipathd returns "fail\n". dmmp_flush_mpath()
> > does, but it does extra work to try to figure out after the fact why
> > the
> > flush command failed. Instead, handle fail replies in _process_cmd()
> > using the appropriate DMMP error codes.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> (should Gris Ge have been cc'd on this perhaps? Is he still at Red
> Hat?)

Yeah. He's still at Red Hat, just working on other things now.

-Ben

