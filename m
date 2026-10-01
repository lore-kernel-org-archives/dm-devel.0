Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E7F1DA62E
	for <dm-devel@lists.linux.dev>; Thu,  1 Oct 2026 00:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790813121; cv=none; b=pKQwRs2DizTZVjl2w0KKV2HmzfZ7QEZSLzxxj8n0aH/2eDNx/IgF4SNh/MRE4DzY2K7l4/kfD/eIK/bySiNH2WSfhUmoCAaTGX8zdhRqrvxFGS6CIZelZ89zKXrdaSeMY6bAuO3nwIZt34IvfMQXxaKaTagH0YySHHMYdzTO3aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790813121; c=relaxed/simple;
	bh=aY60Bpf25TmiCoysTa/J1WgtOI+aH9YyTN9FGBlNnhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=juoVE4blhw+hy21AXiuv8PwwixLOarRD+QQ+4qFz5ry3dLhoBigKe4EpiELRujZ77HxHQx3RKqr0kTftgINPS22l57j9gTP0awW075StkreuA1+ffCKwWJSSyZEvE1xdMNaBN5mrcbFucjUWcdY9XmxdMRWBa1J1eAvyR/OqI1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eZVOQQcK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eZVOQQcK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790813115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nRLn7JgPpDgLzrSNbWf+GQmPa46FDS8Uk+aZcdZn/EU=;
	b=eZVOQQcKH7np79CU4sUhL09FvGsKJVhEsN3h4ZDGqAVkhsvSyxUWRQNuHWlR7nRCdSmR9O
	M1peDizuHT6MEXz3r7kCwXn38DMMRpl9lmE8KklkBdb33QnDeoGI96ZCcYZHHj6RHypN9m
	Q2iSTnVnEAv+drFZ/2gCObPnhh9scTs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-nqAqSMqdN7OJYTsK7bGN6w-1; Wed,
 30 Sep 2026 20:05:11 -0400
X-MC-Unique: nqAqSMqdN7OJYTsK7bGN6w-1
X-Mimecast-MFC-AGG-ID: nqAqSMqdN7OJYTsK7bGN6w_1790813110
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C8D4B1955DDF;
	Thu,  1 Oct 2026 00:05:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A982195604C;
	Thu,  1 Oct 2026 00:05:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6910586h873447
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 20:05:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 691058Yu873446;
	Wed, 30 Sep 2026 20:05:08 -0400
Date: Wed, 30 Sep 2026 20:05:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.de
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 3/4] multipath-tools tests: add test for WWID unmangling
Message-ID: <ar2jtGS2VBCUFY4Y@redhat.com>
References: <20260925214014.2464499-1-mwilck@suse.de>
 <20260925214014.2464499-4-mwilck@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260925214014.2464499-4-mwilck@suse.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: T5YPmtB4qywuBzw991ALTEK7HH4BYERsQYQDNE55Y0g_1790813110
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 25, 2026 at 11:40:08PM +0200, mwilck@suse.de wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Add tests for the logic of the code added in the previous commit.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

