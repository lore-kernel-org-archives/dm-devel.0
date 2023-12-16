Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF071868
	for <dm-devel@lists.linux.dev>; Sat, 16 Dec 2023 03:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i610qi+9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702696656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1xQZil5XQpcZaIG4iF+xJHXxkQBvjNQ/7+uSPmn2tCU=;
	b=i610qi+97bx1BpKQwMBqCQWQ14Ynlv6sgrgjx6tnOmyOMuRzvk665J2BG/lvzOtxdNI0gZ
	kEUZ9RPFpjsGnJQPfLJgg4OSfA1gZQKSVwnMKUJ4Wd+KCvkJFEl/8lPyF5LcQWNQ/fRtxB
	m5T9orNwJ88izRMqTcBhzRPdsZmW04k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-RCYqDelCMa6of8Pj-tiy5Q-1; Fri, 15 Dec 2023 22:17:34 -0500
X-MC-Unique: RCYqDelCMa6of8Pj-tiy5Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D13D9185A780;
	Sat, 16 Dec 2023 03:17:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBCBF40C6EB9;
	Sat, 16 Dec 2023 03:17:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BG3HXPE677823
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 22:17:33 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BG3HXlS677822;
	Fri, 15 Dec 2023 22:17:33 -0500
Date: Fri, 15 Dec 2023 22:17:33 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 10/16] libmultipath: print error when find_mp_by_str()
 fails.
Message-ID: <ZX0WzSZR4gkyemXx@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231212235320.440336-1-bmarzins@redhat.com>
 <20231212235320.440336-11-bmarzins@redhat.com>
 <d21b9aabf9971dd32f9f6d7fa7b1b53d70912bd3.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <d21b9aabf9971dd32f9f6d7fa7b1b53d70912bd3.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 14, 2023 at 06:08:23PM +0100, Martin Wilck wrote:
> On Tue, 2023-12-12 at 18:53 -0500, Benjamin Marzinski wrote:
> > None of the callers of find_mp_by_str() print any message if they
> > fail
> > because the map name is invalid. Print one in find_mp_by_str() to
> > save
> > the effort of adding it to all the callers.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> This will be printed to the journal; clients won't see the message
> unless they check the journal, too. It's ok to add the message, but I
> don't think it' a condlog(0), which is normally reserved to fatal
> multipathd errors. I'd make it a 2; after all, it's most likely just a
> typo by the user.

Sure.

-Ben

> 
> Martin

