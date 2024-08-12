Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BA874BE1
	for <dm-devel@lists.linux.dev>; Mon, 12 Aug 2024 22:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723500404; cv=none; b=NLrO9alt7wZYDRFYb3ffMv63HBB8w1V5VOe2dVNpLGwK+NEsTjhB5nVUujP2uhVvHFdtV6wMhXQWkE7cfH3k1u88PRdIhwTuya6WnXBV3Byb+mC/V4nlb+0msf+L/8yiXOGlwhlivhPUEhkHGVhc6odJgjzf7HRrDBGS1ycC3YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723500404; c=relaxed/simple;
	bh=WYzThn+vv3XvBxUURNVNnLGK1qAs4dpwiouD4J/h7ZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=K+iDQuAbJ/mmYqBeayKRgM1c94l027LkY+kswq9PLC3rG+hzqPUYEEXtHs4FJ2LdpgoX6AYxDNU9Xyp0GMgL3oIp8OZy0NhQ+o5vbRzVEnXg2u6+xpegFySna0rc+sbUEX4QoeeP5gaH7OSdryWN4Ydy8ZsDhoxTPv5sBgitJ8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NsEsaHBk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NsEsaHBk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723500400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A01V0R6g3TcPXgAfebx4DHyesbgnRi9t5nzrSsGP5ps=;
	b=NsEsaHBkvBdZYPCCFmWMziVUzf7LcAoeemELPHt4DqDynvRI3YKwnT5RleN/NYG8PbvMdJ
	dXknkVcqfiritppYy1o4hWDNGXWZAl3Z4mQqU98AWHk/aD10GSHZzLSoLgoiCQHOmWdjQt
	vEU1GQ7Z+etZHcjG6uYx+6Ir1gJnA8Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-250-MQd4KWsdOL69_948Pca3LQ-1; Mon,
 12 Aug 2024 18:06:34 -0400
X-MC-Unique: MQd4KWsdOL69_948Pca3LQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BBC8F1954B0F;
	Mon, 12 Aug 2024 22:06:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4EB0419560AA;
	Mon, 12 Aug 2024 22:06:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 47CM6Smr3457818
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 12 Aug 2024 18:06:28 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 47CM6SOo3457817;
	Mon, 12 Aug 2024 18:06:28 -0400
Date: Mon, 12 Aug 2024 18:06:28 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 00/41] multipath-tools: comply with C library reserved
 names
Message-ID: <ZrqHZDgAZ6C7pokR@redhat.com>
References: <20240808152620.93965-1-mwilck@suse.com>
 <ZrZcgEz8dHRvyXk-@redhat.com>
 <89cc73933e550cb26a380296f2f84d81cb062ba0.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <89cc73933e550cb26a380296f2f84d81cb062ba0.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 12, 2024 at 06:44:54PM +0200, Martin Wilck wrote:
> On Fri, 2024-08-09 at 14:14 -0400, Benjamin Marzinski wrote:
> > 
> > Despite some small misgivings about renaming symbols (which quite
> > possibly aren't being used by anyone) in our user-facing libraries,
> > libpmathpersist and libmpathcmd, for the set:
> 
> As the functions are only renamed, we could use (weak) aliases here to
> still provide the old function names if some caller requires them.
> Would you prefer that?
> 
> We'd still be violating the glibc standards somewhat, but the
> probability for an actual symbol name clash is very low, so I guess it
> would be acceptable to do this in the name of backward compatibility.

While it's not that big of a deal, I do think we should prioritize
backwards compatibility over this level of standards compliance.

-Ben

> 
> Martin

