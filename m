Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D2729408
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 00:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778632816; cv=none; b=degjhpXcF2hEKxavwpGsVGU7OA4Dugu5g6FChG/Z6lCWYbnhrMHo25T32mYs9b6b58l6XH3pyelRBmxdpKnB6ngOrPjnoDKGvCqFy05CZv46/7GzTHV2E4fO6jDHZFtQaSYee71X0TDnKNn2ABjZiMmxBbBIhBKWK7kEpWHWubc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778632816; c=relaxed/simple;
	bh=4lOL8kFmGDIRHikk1X95O6Wlu73GzuQ6cmP5l68hm8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ABX/eXTjWg50sTnxXMwXwZB8FmiXlmxGk9O6MQmrkY6USsuaNuOr3e0ADsOkDW7eWg9D/7y3XRSEstFuVhTRRP5V8uMyHzuDaKKkb+HWSoxkqOCg3yEd10nQNLqpPV40S0PlhzQa0jcbo670IIWZ3W6Ct//pFdmGGXnqGHbQCyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=izhD80Wd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="izhD80Wd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778632814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KSj2UIqZiW/x3R+u+jm+iKt+wJLCv4FZ+3jvCzFwnos=;
	b=izhD80Wdv0XpzRxfNeABJf/pvipyPAz47RZ73+90fSYmvU8TG4XsACSOMa31mEaKICERyu
	yEp/EvO2burURC6+X0BN5bYBXI5KSdKzOTVGXU7mTpjicFfrtvVSSDv6nhb/zlAm3tjVZd
	WI6jqlG5MAgVBEId4K9PfkOQ8/P+8XI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612-blAawHSePIWIMnwd6HBOvw-1; Tue,
 12 May 2026 20:40:11 -0400
X-MC-Unique: blAawHSePIWIMnwd6HBOvw-1
X-Mimecast-MFC-AGG-ID: blAawHSePIWIMnwd6HBOvw_1778632810
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA92E195609D;
	Wed, 13 May 2026 00:40:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5DD21800357;
	Wed, 13 May 2026 00:40:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D0e8Ap3331564
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 20:40:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D0e8Eu3331563;
	Tue, 12 May 2026 20:40:08 -0400
Date: Tue, 12 May 2026 20:40:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 03/18] libmultipath: checkers: move checker_class
 definition to checkers.h
Message-ID: <agPIaCBtutBe8SsJ@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-4-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-4-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -DHDs4fwW44gRwENZ8ke6sfIxnJrJKwqd20OmoMKHgU_1778632810
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:17PM +0200, Martin Wilck wrote:
> Make the contents of struct checker_class accessible to other code.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

