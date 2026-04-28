Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BEE13D53C
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 04:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777349115; cv=none; b=noi/yEMagkPj4WWbUuapnqpPdnxgZFguTDSYI4W89ubDEtCj3qmzVm1/RcjaFUEK3hG1OPs4YlUd8DT7Khl7WrP/vCMdT22fEYtQlYgQjlRie0Iu6TQaY9Y78Kg4s2nDwH1MAtX61uKdebe4OzKHqKxx+HIk15EcGwvNTXA2KRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777349115; c=relaxed/simple;
	bh=8/m7rhIqeX77MYAN/ikkXeyOG3ztVfqpjPxJP8gOG7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=TNf10q+i7emfntSh9zeWEI7KWFOtJFfxjHcbjiJ5Plk4peLPhvzNToWkdgv3plC4295u5pz/oKIygomHT/A3BKA+mYr/lLU/7r0umTT6cxA1REOcvGcbWKbLEuSg2T5wBUqNipTsDrfJp2NgS5sZrVqWxZEzkQZZpv8I3R+laoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RFLC/IcA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RFLC/IcA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777349113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Li7LV8FRZGMZua6FgupLxptsOP9pgPwWpIdZNRaWUzs=;
	b=RFLC/IcAKzdwH3EqXWz15Q8bZhWKWeb1o79CezFTBaBhJhjWy3WXh7vysIagSRmkSdSysu
	+LsoUd/ceLuiqyYigx+kKA2bo+Ik0gUUUiAjveEvo3TgvXlGphxDCQw/ZJU4X/5gIE0PUI
	t7UKz7mHNxlp3aakswqa3/kA6gVebHw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-145-HaA9j7uYMZyCmNj6ShICfQ-1; Tue,
 28 Apr 2026 00:05:11 -0400
X-MC-Unique: HaA9j7uYMZyCmNj6ShICfQ-1
X-Mimecast-MFC-AGG-ID: HaA9j7uYMZyCmNj6ShICfQ_1777349110
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 969DE1800366;
	Tue, 28 Apr 2026 04:05:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 360433000C22;
	Tue, 28 Apr 2026 04:05:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63S458Hg2754072
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 28 Apr 2026 00:05:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63S4589U2754071;
	Tue, 28 Apr 2026 00:05:08 -0400
Date: Tue, 28 Apr 2026 00:05:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 5/5] libmultipath: tur checker: improve
 tur_deep_sleep() test
Message-ID: <afAx887CMIrvdH6x@redhat.com>
References: <20260423204446.472642-1-mwilck@suse.com>
 <20260423204446.472642-6-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260423204446.472642-6-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tgmoOWolMLkrvbennO441i6u26WvttbLFv49c4ASbQM_1777349110
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 23, 2026 at 10:44:46PM +0200, Martin Wilck wrote:
> The tur_deep_sleep() test serves to test the behavior of the tur checker
> when checkers time out and cannot be cancelled.
> 
> Up to now the checker timed out on every TUR_SLEEP_INTERVALth
> invocation. That made it impossible to test the MAX_TIMEOUTS logic, which
> requires multiple consecutive timeouts. To fix it, invert the logic, so
> that the checker just succeeds on every TUR_SLEEP_INTERVALth call.
> 
> Also, decrease loglevel of the messages from tur_deep_sleep().
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

