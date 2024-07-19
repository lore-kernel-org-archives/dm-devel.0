Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCAD2BB0D
	for <dm-devel@lists.linux.dev>; Fri, 19 Jul 2024 17:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721410011; cv=none; b=AnqQoUsj0p1/S380bupQsNr+mcL2Ku36QZGzeGg/FlmOiE+218F2IWrXneirgcMHk+Fl2PHGfiQzdj3bgWxZyKQs5weL/2EwZUapbOeWnlJ7ZtXsGcHyA0k55qUwpc2OwuVJuk6zgqL85OpvgOu0+xkXI64fWCx2GryopDLMZNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721410011; c=relaxed/simple;
	bh=0HhjhMuJ75ubHKDHl1NRclB8Tpt56JJnim2tEbheNcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=syNkmM/1K6b7vbtXm7Rfsx6fX0Ps9uZGxORid3qbFE6hIIbBpya7Pe1A9pRWj2lIBwp4FvLV8tEGjMWIySTXJ/QSWRiGoiCzON5DCWNnZ43VRDj1uRh3y8kStXkyx9Umd8NMBnFnBryzBr8vnUfoX0KQXt89/NJhprd1tu9YcXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FbTTKJak; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FbTTKJak"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721410008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YUDZUXF04CdwHs6AcmwY2lt4IIqpr5UgvT+QpvfgtSo=;
	b=FbTTKJakkHZzV4YkNxbrFoI8ZYoDAUC/HFugjBVDuctX8m9hropsbz4zpDCUJspn/8rx+N
	ZcdMg5B3FHlpHCYIqEeKqsGD6dL7HtYCAsqLuZmlmGPxCTFwA+MajghHTpQR+AZImUequm
	wTFEtJzbF8SvB9o0BTRtlxekcdWcGLs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-M9FRCqbRPZqbxzcvhxMyew-1; Fri,
 19 Jul 2024 13:26:45 -0400
X-MC-Unique: M9FRCqbRPZqbxzcvhxMyew-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E56D41955D58;
	Fri, 19 Jul 2024 17:26:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A7893000188;
	Fri, 19 Jul 2024 17:26:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46JHQfJS2367733
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 19 Jul 2024 13:26:41 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46JHQfDM2367732;
	Fri, 19 Jul 2024 13:26:41 -0400
Date: Fri, 19 Jul 2024 13:26:41 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 0/4] multipath-tools: coverity fixes
Message-ID: <Zpqh0Z2zKAr7DzUH@redhat.com>
References: <20240718191421.110487-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240718191421.110487-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 18, 2024 at 09:14:17PM +0200, Martin Wilck wrote:

For the set:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Martin Wilck (4):
>   libmpathcmd: check len parameter in mpath_recv_reply_data()
>   multipath-tools: use signed loop variable in vector_foreach_slot
>   libmpathutil: avoid size_t underflow in strchop()
>   fixup "libmultipath: use libmp_pathinfo() in update_multipath_table()"
> 
>  libmpathcmd/mpath_cmd.c    |  2 ++
>  libmpathutil/util.c        |  4 ++--
>  libmultipath/structs_vec.c |  3 ++-
>  multipathd/main.c          | 10 +++++-----
>  4 files changed, 11 insertions(+), 8 deletions(-)
> 
> -- 
> 2.45.2

