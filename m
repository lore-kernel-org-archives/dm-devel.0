Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5117F1B810
	for <dm-devel@lists.linux.dev>; Wed, 29 May 2024 15:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716995225; cv=none; b=ShfbEiYQQBgvuTvAICcGSR6X339NTjj5I7l0mye88tw7zXbVMTRnW2LhJk1+Y1F8fQ3FWZBFnJjFKQ1+qNV+Fi68mSuxdCbKGcdbRoCbi5oUzDNJQDk1CdkdwY4unHsepXDDcRFpu6QULuLyhmoW+g4feBHRcYGlPjWHX11vh6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716995225; c=relaxed/simple;
	bh=rYyjb2usmmFIwj6uki+mL3VyNsLAhqLnFUqsaZu790M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=YHg0wVh0qjd3O19i386yHAkZ868YV+03wike6dfOwme5LE+GI3jdTgxONCI+9mJNaChP4KZQJdjsYGyxRTuNH2rpFHIJ1nGGc1x2PLcTduNRyXU5AoOkuWvbNtjiPZspQDuCtCGa5SSmXtHFgu5fOHXuXsz+LZg21BUuBt5JQRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RcJ0/WFN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RcJ0/WFN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716995222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OnrqPiXsXVCftsb5BEGDlhM3G/h2kFIKc1YR4hXHF8s=;
	b=RcJ0/WFNHsljjecB7kJIUDnXgV2cQS9HArVhVcilm5aVvOksaom6x+mQKdqrzgAy04xr6J
	W5cqJDgzAJGxys/cpIUPDnQmDmZjnykmk5sfZu/aCoD19YmrLMfZG3I1nuiu4QzRk759vT
	TEfPCTe7KVVJ9Hwqk8YjvOxG0IsccfU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-sKrQtLWAPI6xEsH6K6EPmQ-1; Wed, 29 May 2024 11:06:58 -0400
X-MC-Unique: sKrQtLWAPI6xEsH6K6EPmQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23BB0857A81;
	Wed, 29 May 2024 15:06:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 189541C00A97;
	Wed, 29 May 2024 15:06:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44TF6vR0359345
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 May 2024 11:06:57 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44TF6vXR359344;
	Wed, 29 May 2024 11:06:57 -0400
Date: Wed, 29 May 2024 11:06:57 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>,
        Nitin Yewale <nyewale@redhat.com>
Subject: Re: [PATCH 7/7] multipath-tools man pages: Add format wildcard
 descriptions
Message-ID: <ZldEkY_3VroMhRU3@redhat.com>
References: <20240513173646.94424-1-bmarzins@redhat.com>
 <20240513173646.94424-8-bmarzins@redhat.com>
 <ZkJlywJBcXQku0a8@redhat.com>
 <ace7bf8989a401993ae517e9cb1ad0c100731652.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ace7bf8989a401993ae517e9cb1ad0c100731652.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 24, 2024 at 04:29:22PM +0200, Martin Wilck wrote:
> On Mon, 2024-05-13 at 15:11 -0400, Benjamin Marzinski wrote:
> > On Mon, May 13, 2024 at 01:36:46PM -0400, Benjamin Marzinski wrote:
> > > Suggested-by: Nitin Yewale <nyewale@redhat.com>
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > 
> > Oops. I forgot to update the man page date. Martin, either I can send
> > a
> > new patch or you can feel free to update the date when you apply this
> > one, whichever you'd prefer.
> 
> No problem, I can do this.
> Would you like to have this included in the 0.9.9 release?
> As all these changes are small and non-controversial, I tend to include
> them, unless Christophe merges 0.9.9 very quickly.

Sure, and I can update the date when I send a V2 set with your
suggestions.

> 
> Martin

