Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43A026D4DD
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 00:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778633447; cv=none; b=W4BNnsRqfcxZiBEgLnIHqzj4Z5Rp58ri94tEY1nuipZk4i/bHMjZi6irWwz5pLTcTDv4vBVAtitudquEdB9wCYpMOspyoAfHHmVDm0KUZxHlPD0Vm7L1cT9m/UkPTEJo2FLP8PG5tqCQ2Xgs59y8ug/ylCFA+Zz70lmPUq4W16E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778633447; c=relaxed/simple;
	bh=vUq5V68u6XhQpMHEoiL7yaQl3+rxBLDjTUYEEK1EPZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=TX5EI+x82IwBIwjbZkxSwKFUNujAw0Hs26JeX/OvW1EbJWaq/IOzpofZiRQ17uv+fLMqFTi1J9Kr4zaQ5lzMBlmuk8mc6l5uILrBEfq7ePIGTIZDzaf+3j9erxcauUAzQvoBGtJVZ1ivaIIj/w25UXZHdrl99UmK24VuWY+O0Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DxDZbJB1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DxDZbJB1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778633445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zxoBvAO81L5TVjz4bvAVHO+GHpvKaFcaaLCdYnHug98=;
	b=DxDZbJB1F6Wyg+xdg+HDKMIoSimBLrTF7RsZC2nOZg++BJ08bNR4PFoF4yxlDSed6tP/6W
	xX5eK1yu7rHMWs9zdNNI6Up+xWz8amx9yYfk5T8H5iy+8JC/zXYvOf7bYQfRQoTAYxVkxh
	Nx6we1q4oZlPTt0mWYKO9M8wkEUHKgk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-471-a2vuikXLP8-YRAeE7do8Jw-1; Tue,
 12 May 2026 20:50:43 -0400
X-MC-Unique: a2vuikXLP8-YRAeE7do8Jw-1
X-Mimecast-MFC-AGG-ID: a2vuikXLP8-YRAeE7do8Jw_1778633441
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD3A01954225;
	Wed, 13 May 2026 00:50:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 78F2E1955D84;
	Wed, 13 May 2026 00:50:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D0oaNu3331840
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 20:50:36 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D0oaxj3331839;
	Tue, 12 May 2026 20:50:36 -0400
Date: Tue, 12 May 2026 20:50:36 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 07/18] libmultipath: use shared_ptr for prioritizers
Message-ID: <agPK3AmaCLuKw5pd@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-8-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-8-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Cq1cCir626ags6q-ZBG1id67Nkw5Q849WMLfGDpRySg_1778633441
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:21PM +0200, Martin Wilck wrote:
> Replace the hardcoded refcount handling in prio.c with shared_ptr.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

