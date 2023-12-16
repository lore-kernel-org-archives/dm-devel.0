Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BF7DF54
	for <dm-devel@lists.linux.dev>; Sat, 16 Dec 2023 02:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VKjmpViQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702695236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ComBylfrTr2T+9+3vCEFoWF7eFx1OA++zH7GbC7yNEY=;
	b=VKjmpViQE6DZOPafCJEar1U7mEs8GZAp0R16lDg1/YXmPuxpIIZflQPJEHH8LX74tN8ZVu
	L7hV0HqA3sm3mLXrT4Wwj2cZmQsh97b4XjmiR5KlP2PtHYx02mfp3ucNlApChJ134pk9Cf
	//0ip6CMtsBoyy/8zsaAtKHAe1dWBdE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-0kjgTOGvOZecWhehi6EmhQ-1; Fri,
 15 Dec 2023 21:53:52 -0500
X-MC-Unique: 0kjgTOGvOZecWhehi6EmhQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D9E71C06502;
	Sat, 16 Dec 2023 02:53:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 778871C060B1;
	Sat, 16 Dec 2023 02:53:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BG2rq2C677650
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 21:53:52 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BG2rqEp677649;
	Fri, 15 Dec 2023 21:53:52 -0500
Date: Fri, 15 Dec 2023 21:53:52 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 4/5] multipathd: cleanup __setup_multipath
Message-ID: <ZX0RQI0+LaXdVkc3@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231205235704.355125-1-bmarzins@redhat.com>
 <20231205235704.355125-5-bmarzins@redhat.com>
 <3f49c7b1b2ee1221644f01afc98437aa63a3fc26.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <3f49c7b1b2ee1221644f01afc98437aa63a3fc26.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 14, 2023 at 05:15:44PM +0100, Martin Wilck wrote:
> On Tue, 2023-12-05 at 18:57 -0500, Benjamin Marzinski wrote:
> > split __setup_multipath() into two functions: refresh_multipath(),
> > that
> > updates the table and status, and setup_multipath(), which works as
> > before, but now calls refresh_multipath().
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> If this set goes through a v3, please merge this patch with 2/5.

Sure

-Ben
> 
> Martin

