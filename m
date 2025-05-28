Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C331C4A0A
	for <dm-devel@lists.linux.dev>; Wed, 28 May 2025 02:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748397682; cv=none; b=XrQU0dABjYaEJalIiEkMlVkTXiNUMGPrjcXl9Gk9OAPgdDLbqrLnmYNisFnEaMFanzWwjzRUQcqlxkU2Be8+M4NRNImRvokr9bxsUEcpYiE4p3MY1VfUq7XHCUmf86SsZHYO++a4WhQ2HHrCrGl2B+CT9pk9TX0L+z/Y1BA1d2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748397682; c=relaxed/simple;
	bh=LiEhLnLcjhOfpv7G4HYc5Uhcen0AF6vhvUb1MqWtuhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=MBYsPSSmxPsdxd3HqbaBnxF7S6194guEOXhcDXkeekYG2soVYVVQ1pVg5NFqK3f2vF9bLrB2FtoEIPnf9Y7F2zeicjBfVUFYPWtQ+7qM3ojh1vcC7E6m2W47pAhOyp6c5VjK5TvhqLgDE1/LI7DMhJ5O5neEExwABuWixd5yqn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FHXwEoFS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FHXwEoFS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748397679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ao6sTs8m2z97o8QNuHCaE0vaf3bzSI7A1sevarQzpr4=;
	b=FHXwEoFSS4qgZRFyqh5ejTYtO4yguAPbIhTcFX/lGTMJ6vjf0xBMYFic9ULo749ku76bwC
	f3YlTJYklMAByABE1HjZPkdljzTe4JVXPLz/O468AFYDCt+jpMgkbSmGTQogZKzIVZX/yP
	ZfLJdCxhsiRtDws/jdnt1Rt/+t/7eoA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-484-6pBdqZvmMVyj-Xbst1DtEw-1; Tue,
 27 May 2025 22:01:17 -0400
X-MC-Unique: 6pBdqZvmMVyj-Xbst1DtEw-1
X-Mimecast-MFC-AGG-ID: 6pBdqZvmMVyj-Xbst1DtEw_1748397677
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D92719560AA;
	Wed, 28 May 2025 02:01:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33A8819560AA;
	Wed, 28 May 2025 02:01:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 54S21EpJ930225
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 27 May 2025 22:01:14 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 54S21Enk930224;
	Tue, 27 May 2025 22:01:14 -0400
Date: Tue, 27 May 2025 22:01:14 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] multipathd: always reset checker interval for failed
 paths
Message-ID: <aDZuageAzJxJHCeC@redhat.com>
References: <20250522002623.611830-1-bmarzins@redhat.com>
 <baa4713be2b579189fd40d3a6e4b8aca897baef9.camel@suse.com>
 <4b4107e368e68588dd21d3d386b7f84babc5ed1f.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <4b4107e368e68588dd21d3d386b7f84babc5ed1f.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XUDOQHE-6Fbgc4EvnY93rzMy8nYEsTKjoYQQ1q-ZglQ_1748397677
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 23, 2025 at 01:04:15PM +0200, Martin Wilck wrote:
> On Fri, 2025-05-23 at 13:00 +0200, Martin Wilck wrote:
> > On Wed, 2025-05-21 at 20:26 -0400, Benjamin Marzinski wrote:
> > > The are multiple places in the code that can set pp->state to
> > > PATH_DOWN without resetting pp->checkint, most obviously when
> > > a path is failed by update_multipath(). When this happens the
> > > path will continue to be checked at its previous interval,
> > > instead of switching back to conf->checkint. Fix these cases
> > > by always resetting the pp->checkint to conf->checkint when
> > > updating the state of a failed path.
> > > 
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> Although this patch has no fixes: tag, I'll consider it for the stable
> branches. Objections?

Yeah. It makes sense for the stable branches.

-Ben

> 
> Martin

