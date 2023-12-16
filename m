Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5710ADDB0
	for <dm-devel@lists.linux.dev>; Sat, 16 Dec 2023 02:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="izWmW4oF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702695216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z4YnplCj279q5OXGhjE7tzYGeYQmw4bJdUqjdsD0nrc=;
	b=izWmW4oF8yY7ujTkBZw9lU2OghJnfTsFPOucDD1q9Zu8VE3Jf+Uwo8PfHZdH0SW7JxJodB
	c8/W293i8dnRm80F5l6Gf1ht1A/xxK7lD3AZU3Qel/Y1AlKie52yKMQTdQPsx6yihQoFve
	1AuG/a+C1RvLN9gqdZkuztVDlrkDcDI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-dGoKUsWyNCuJGP309mmHmg-1; Fri, 15 Dec 2023 21:53:34 -0500
X-MC-Unique: dGoKUsWyNCuJGP309mmHmg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 328FF832D1C;
	Sat, 16 Dec 2023 02:53:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B9E23C25;
	Sat, 16 Dec 2023 02:53:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BG2rX4s677641
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 21:53:34 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BG2rXML677640;
	Fri, 15 Dec 2023 21:53:33 -0500
Date: Fri, 15 Dec 2023 21:53:33 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 2/5] multipathd: don't modify the multipath device on
 show commands
Message-ID: <ZX0RLeZM1w14Y1Jn@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231205235704.355125-1-bmarzins@redhat.com>
 <20231205235704.355125-3-bmarzins@redhat.com>
 <a365676f9d92a1deea8399958de4f94dac0b1d81.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a365676f9d92a1deea8399958de4f94dac0b1d81.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 14, 2023 at 05:15:39PM +0100, Martin Wilck wrote:
> On Tue, 2023-12-05 at 18:57 -0500, Benjamin Marzinski wrote:
> > The commands to show a multipath device are supposed to return its
> > current state without updating it. Even when reset is 0,
> > update_multipath() still can update the device. Call,
> > __setup_multipath() instead to just fetch the current state.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> __setup_multipath() can still call remove_map_and_stop_waiter(), do we
> want to avoid that, too, maybe?

If there really is no multipath device anymore, I don't see a benefit in
keeping it around in multipathd until the next path check, do you?

-Ben

> 
> Martin

