Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0D2155757
	for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 20:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782418172; cv=none; b=PiPZVWcS7WnJKuXaz5Cd0JlHGhux93m85pFVpIpk83Zlgs6DgRbY6RSDAkePihhia3zLSK3bXrWQNoKxob7yQubXZ59VO5xlC/20GdJgYsb8w9CtR/WKbfVioN9ur4Ly31h/rVTfBfKTSpdewhFDqcp/jyGPKmJjYpJmpqoEFXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782418172; c=relaxed/simple;
	bh=njIkq00HAe2qMJ83ES4g5qvV7yaOahp5Lp2BTv7Mizs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=OG7nOndHkyYITcJ0VGLjTy1vfQBOIBBRcfgpQszMiuHVdfpwrtXs8CVNUoAxKBa053jIQ56Yu3tmkTYo3H5GEBSXuYF4shR1GZehLZ/P1f9Adq5ANesnxe0rwl0Q6rBnW1L3WmDUFxUlOeQUbB9R7hKK8Ty77XrDSa3ak0L7z5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fcV6NRoi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fcV6NRoi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782418170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=njIkq00HAe2qMJ83ES4g5qvV7yaOahp5Lp2BTv7Mizs=;
	b=fcV6NRoidI/id+I5001ei6wHF17CUlzYIeGBQ7rwB6pw0ttITdRZLQ/EiLI8QKd7k6dV58
	24RkN8xgzzmX/72Rl8AObTUR3acF08jm1mMf/aRKqO3yUbYa+T3WKDbIAol33an2kIimHO
	rr+71Jy8aze1xxLM9cOXkN3N4PJnu+4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-446-lL8G_8TvNkSKo-73b8ZZWw-1; Thu,
 25 Jun 2026 16:09:26 -0400
X-MC-Unique: lL8G_8TvNkSKo-73b8ZZWw-1
X-Mimecast-MFC-AGG-ID: lL8G_8TvNkSKo-73b8ZZWw_1782418165
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30F981956067;
	Thu, 25 Jun 2026 20:09:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3A541800370;
	Thu, 25 Jun 2026 20:09:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 65PK9NgG1551021
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 25 Jun 2026 16:09:23 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 65PK9MCA1551020;
	Thu, 25 Jun 2026 16:09:22 -0400
Date: Thu, 25 Jun 2026 16:09:22 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 0/4] multipath-tools: unit test fixes
Message-ID: <aj2K8s80ISSv0CY2@redhat.com>
References: <20260625160200.3318088-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260625160200.3318088-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0vYtXTbzGDHh2XC4vLopD4KCULsitPF4gsefd4JGZGA_1782418165
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 25, 2026 at 06:01:56PM +0200, Martin Wilck wrote:
> This series contains a few fixes for issues recently encountered
> in the multipath-tools GitHub CI.

For the set:

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

