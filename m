Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA471868
	for <dm-devel@lists.linux.dev>; Sat, 16 Dec 2023 03:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jD7dqKzP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702696602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D+lRn6XYWwyZ7zKtB8ZAjcPIz4U23Li5eQ1Po2JwBeQ=;
	b=jD7dqKzPfmqoh6oNQxE+sHaIGw2yPjeS6MRsTJ3PyKwEpMA75eRaAdPMptpeQ+W2b9AWJK
	bSaNpb1OCZojBl5A5QsE3Tc7HzvQ5hQcTuY8Qe8b4pvnhpwj6wk7NPfGE3p6iK9fysTGot
	y2CEnKNFWn0vGkeXxKjXby8ee8IjUlU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-n-mBVQQEPAamVMwSURxCmg-1; Fri, 15 Dec 2023 22:16:39 -0500
X-MC-Unique: n-mBVQQEPAamVMwSURxCmg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B389F85A58A;
	Sat, 16 Dec 2023 03:16:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ADAD22166B31;
	Sat, 16 Dec 2023 03:16:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BG3Gcna677811
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 22:16:38 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BG3Gchf677810;
	Fri, 15 Dec 2023 22:16:38 -0500
Date: Fri, 15 Dec 2023 22:16:38 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 03/16] multipathd: disable queueing when removing unknown
 maps
Message-ID: <ZX0Wlt1gOdi/C16z@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231212235320.440336-1-bmarzins@redhat.com>
 <20231212235320.440336-4-bmarzins@redhat.com>
 <ad34d00c0e6ad4f8f4e3cafaedd96f9396c208a2.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ad34d00c0e6ad4f8f4e3cafaedd96f9396c208a2.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 14, 2023 at 05:41:12PM +0100, Martin Wilck wrote:
> On Tue, 2023-12-12 at 18:53 -0500, Benjamin Marzinski wrote:
> > Make cli_del_maps() call dm_suspend_and_flush_map() for the unknown
> > multipath devices as well.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> dm_flush_maps() is now always called with need_suspend=1. We can
> simplify it.

Yep. I can add that.

-Ben

> 
> Regards
> Martin

