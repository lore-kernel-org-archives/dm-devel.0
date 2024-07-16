Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9EE19AA4D
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 14:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721139829; cv=none; b=nD8jIMlvNFYmxaAg3FJYPxpg5ow1FKt2CkFrnNr+qXz0z/kWuIaGxYgy4MpigXc1wKlaGw1/0Qn80gXEX6abatdeybL0Q9OBovIZGlxaJKbEK0vz+AP8TNP8LYgCWBDe9MR71jlM+iASJVJRNd3ZnLYBQWm4DI5taDr3Cd6c+lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721139829; c=relaxed/simple;
	bh=Zl3nZOTOCSgmvhe8O69IPmE+yiCbllnjMvgxOzJuZhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=SoaMo4edCS4Gi1mvSR87Ejkrw1Tfq6VvUU1ZxQFZ0B/heYgNuaB+HkiEW+LjPl40Fk1Q2KzXb7iYuEFJ5LXZvUAtT2qw3ot94fVgLKFSI5Xj+FvsnZ8OegAIFKo+DJQ+YBCEW5kLWZPbeQw0i20wWV5fLDAykUL8pUKYYQ7ROus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AInQu2Oh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AInQu2Oh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721139826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3M1SXbTDoG/fpNpx5cO7Tt863VHOi+ZQJC4LrquEsuo=;
	b=AInQu2OhqC1XRT48G6kkvu4bgRrE7LoeBiEunNobW/bBZlzLY3pb4HgAqQaAskJQcJOk69
	5+FzUi3fjuTZDoX1NtMVjNz5pxyV/nsWKHTRunDzjlFdFQqSJZq/jJ2JHtuKCNUUrZgo/+
	8T/2JM2NJ55QHQaJUtkiEFRjQGXc84o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-408-Dm-dR079P8GmjnuyanRNEg-1; Tue,
 16 Jul 2024 10:23:45 -0400
X-MC-Unique: Dm-dR079P8GmjnuyanRNEg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 38556195609E;
	Tue, 16 Jul 2024 14:23:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA8A619560B2;
	Tue, 16 Jul 2024 14:23:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46GENgH02120357
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 10:23:42 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46GENgp42120356;
	Tue, 16 Jul 2024 10:23:42 -0400
Date: Tue, 16 Jul 2024 10:23:42 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 05/22] multipathd: handle uninitialized paths in new
 function
Message-ID: <ZpaCbnwuD3KTLfj5@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
 <20240713060506.2015463-6-bmarzins@redhat.com>
 <1eb0cdfbfd0f6cef110fa01802fa07c946011bc4.camel@suse.com>
 <33d9dff6f222a2831efdf34bab9d90c76351475a.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <33d9dff6f222a2831efdf34bab9d90c76351475a.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jul 15, 2024 at 05:36:54PM +0200, Martin Wilck wrote:
> On Mon, 2024-07-15 at 17:34 +0200, Martin Wilck wrote:
> > On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> > > Pull the code to handle uninitialized paths out of check_path() and
> > > into
> > > a new function called handle_uninitialized_paths(). This should
> > > cause
> > > no functional changes.
> > > 
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > >  multipathd/main.c | 171 ++++++++++++++++++++++++++++--------------
> > > --
> > > --
> > >  1 file changed, 105 insertions(+), 66 deletions(-)
> > 
> > !pp->mpp always holds if this function is called, so we can skip this
> > part of the test.
> > 
> 
> Just realized that you did this in patch 7.
> 
> LGTM, then, but if you resubmit, I suggest you just squash these two.

Sure.

> 
> Martin

