Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BC4357CEA
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 01:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778634350; cv=none; b=Las/bdH+QVJgu8diy51+88Qy6APRGY8hBWf6RB2ZwXQzK74eBuYHCyR7be/Z2ozuRZDL0LK8s2/o83zQCblqbKJmLZHv/laPvITEvW60NKEMdxnaGu7zkqdvEL3FNA68SBoWygneXwBuyBjrEF1ByKB/92a3t+MUkABTbExVw1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778634350; c=relaxed/simple;
	bh=tjLf03LV5Kmsrk3RE/NtsJqmjackCDDrKR5wGcw6Zxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=njZRM0YqDkKTKngsB4a3qcIVkUFaf/OVeZBkyjF6eM/lxKjAcntioey0nZ4reaf+DDa0IkOEmhf4hiEMrgyAXoeQxJ7OrNDWQzvJwl8mkLKwnRg/VfJAn345UU73wYYuFZY4bbXhHWXcEoD7pYNgw5BbUhGnwYCsOyWUTTDQZjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OcZKNMOy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OcZKNMOy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778634344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=npKQ0PvLoB+2KFqp9n1NIB66gtNGHqxl9jNkcqKnB8U=;
	b=OcZKNMOylNPENTCLYgqX2fXBypFrU7uXS621lgrRVnqP5bdJ8o5+UAsvkXdbMWRppdhQ7o
	VrC517YDGqB3A2o8ssfmDJVEaPrZPNwtS9MSQmbgsLyOVPTDiMdcM90yaXT5MSBVHetI7c
	RLIiQtMo/Ymfoc3cBaDZovlaaZGpKMY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-532--17vR3kDNsGV5p8Xq4lh0g-1; Tue,
 12 May 2026 21:05:39 -0400
X-MC-Unique: -17vR3kDNsGV5p8Xq4lh0g-1
X-Mimecast-MFC-AGG-ID: -17vR3kDNsGV5p8Xq4lh0g_1778634338
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7BFA51956094;
	Wed, 13 May 2026 01:05:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4826A1800347;
	Wed, 13 May 2026 01:05:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D15b683332345
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 21:05:37 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D15bRh3332344;
	Tue, 12 May 2026 21:05:37 -0400
Date: Tue, 12 May 2026 21:05:37 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 14/18] libmultipath: convert readsector0 checker to async
 checker
Message-ID: <agPOYe-JfNLVG3-X@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-15-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-15-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Zj5B29HDtB3wK6sfGjBT7g6_AQqzRCrCiCd5DgMnpkE_1778634338
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:28PM +0200, Martin Wilck wrote:
> Make the readsector0 checker use the async checker framework.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

