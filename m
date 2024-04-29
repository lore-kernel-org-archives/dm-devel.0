Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838668595F
	for <dm-devel@lists.linux.dev>; Mon, 29 Apr 2024 17:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410115; cv=none; b=Qz5mLwrpiU/TcwJMxYCn8DWOh2fUe/ldXVu8W8Ow27GATmt8jT8sNs2s3FS6Up/68+uY7ah+gM/d3/hnXTprBLfqhdYLD638vmcJVVFE4Ty2bdzGgTXntI5wWrLNARXktLQZyUt91qYc4sq+uPet3YxBcM7FoK9YmTvLx8bdHUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410115; c=relaxed/simple;
	bh=EOEG7OzEK3PSMAW77EECf82sna2FcmAfKrYLJw190YE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=E7Ywa60+wz6YHbcfVSlm3uHlY4D/kAT02/B5K67rVHhvyXY49OkAmetXReBnyfKuv4sxk5/3aHTU08tnHjdXBSOaJjXkwqeIowEraAy5BYC8iHf9xSe4qIS5GuTHTCCKrB3onj+KrYIZQVhnR43VaB3ZA0IKICEHUVmk/SN6Y+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DCXkcA7s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DCXkcA7s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714410112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P3VBSxva+pUZdw/HWFh7qQECYWwsz+D9lE6+jQ2RAv8=;
	b=DCXkcA7s9KY9kk6A83HdoMMSYA5OET0HRAot1vfbgI8FIJjtvTXdi6I+qgxqLzjxOvjYAC
	zo5VWaboukuU0qPpjaGX8y6XSubZwm5xuMKU89UJZ1aSFvecaVUuZvJqjjAGQRXwZxvwMz
	bnoWLWVPxPxfT4tzvyDx72eWUw+k9R8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-9etwI22cOlqwzFzc1IqOhg-1; Mon,
 29 Apr 2024 13:01:47 -0400
X-MC-Unique: 9etwI22cOlqwzFzc1IqOhg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E3923C0008A;
	Mon, 29 Apr 2024 17:01:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F84B492BC7;
	Mon, 29 Apr 2024 17:01:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43TH1kSf2168061
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 13:01:46 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43TH1kIq2168060;
	Mon, 29 Apr 2024 13:01:46 -0400
Date: Mon, 29 Apr 2024 13:01:46 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 0/3] multipath-tools: docs housekeeping
Message-ID: <Zi_SerdacP7bg71R@redhat.com>
References: <20240427235009.8751-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240427235009.8751-1-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 28, 2024 at 01:50:08AM +0200, Xose Vazquez Perez wrote:

For the set:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Xose Vazquez Perez (3):
>   multipath-tools: simplify comment in hwtable
>   multipath-tools: unify text in multipath.conf.5
>   multipath-tools: update man pages dates
> 
>  libmpathpersist/mpath_persistent_reserve_in.3  |  2 +-
>  libmpathpersist/mpath_persistent_reserve_out.3 |  2 +-
>  libmultipath/hwtable.c                         |  4 ++--
>  multipath/multipath.8.in                       |  2 +-
>  multipath/multipath.conf.5.in                  | 14 +++++++-------
>  multipathd/multipathd.8.in                     |  2 +-
>  6 files changed, 13 insertions(+), 13 deletions(-)
> 
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> -- 
> 2.44.0

