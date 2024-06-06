Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA818821
	for <dm-devel@lists.linux.dev>; Thu,  6 Jun 2024 19:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717702912; cv=none; b=JI0VleZvSQz+BXy/6kNlQVnylqtMn/zjLs2W42f/LWLT0zp+ikPOrWU8pU2bBRyWSfdTGQWJeCPAY2rlqRosd9lsgSwvclFu3MjxFdm5+GKoMjcevmPmpB0JRmxa3r/6YqzIgx3j9U7HfZSuE34B2nVQWmccNRTWtEV3fYqg/wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717702912; c=relaxed/simple;
	bh=vdDPgOETrlIUEHKIjDm7sqX4QOdjEmevinvwmI0xP0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ByeRh+WEErb5PCS12/antptp7xn0c8I4ZZwwvhXi7VS20NQW2MC5urr2wEbhlHyUz56vHV8qobtkaaXJSjRu1Rwz5kPFJ8k6wDhF5VlWbRaagAoFNGX3Et0Vm4/kyCF7KUB1k2n52x65AoqSnu++Uylz+IZKOvB2eNmX6OuDM0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hd9Nvgf4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hd9Nvgf4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717702910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vdDPgOETrlIUEHKIjDm7sqX4QOdjEmevinvwmI0xP0U=;
	b=hd9Nvgf4ukqX25H3gd72mwC/NiuX4Gf1BDR2IdvbIX2lvDrCARpq1Vz4jdHieIyRs5Dou7
	3y4QYU27h+3JndCUvd1tu+ByF9sLg1AcvTGfmsUOplESy3V9VDHvTu0c+E4dyiI28FbAYI
	CHQGWmrklDGDdGgtZ9Z0rf3i1mDSlLQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-167-2t8NMh8-PE-EZGvgerM8TA-1; Thu,
 06 Jun 2024 15:41:46 -0400
X-MC-Unique: 2t8NMh8-PE-EZGvgerM8TA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3EDB3806700;
	Thu,  6 Jun 2024 19:41:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AABC010139;
	Thu,  6 Jun 2024 19:41:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 456JfjkY653112
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 6 Jun 2024 15:41:45 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 456Jfj7v653111;
	Thu, 6 Jun 2024 15:41:45 -0400
Date: Thu, 6 Jun 2024 15:41:45 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 3/4] dm: Improve zone resource limits handling
Message-ID: <ZmIQ-eg7BPOt1HQI@redhat.com>
References: <20240606082147.96422-1-dlemoal@kernel.org>
 <20240606082147.96422-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606082147.96422-4-dlemoal@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

