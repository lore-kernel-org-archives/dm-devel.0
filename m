Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795116041;
	b=ogsZxYWkQzvO3ueNRSP0ZlaF91zvElKv6UnRrZVogt5weeB/3Zw5RJ74rjgqPenZWDv1
	 jOpHwxhN5W9dR46lDvDhDhUW9fPCJtwStcs1w0zrq1MNqcoIDucQv8Syf3pMVI9Ml0Cz3
	 sRHM4sDzVibkct397ondgGP9CoBytTyRH1MKuz9H1jOhS2PezPozWNCYB3QqYsuztNyND
	 he/6DnUvNMyvfWOLb1EJn8USM7i3wXkEsFRIs/Emqx7bRERiDT/c06oZdX5pMvn6pQpMp
	 TAd5UkvDKZIlKFdnRhBU3v+QzIntOfm5+hZxhVNEA0pe3XTOnQ1KgUFjAcdzPvhDBVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795116041;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type:Content-Disposition;
	bh=Um8gYE7Wj8DQXgc39oieKwxLwzqQdcu6AkEqQLyOQo8=;
	b=bx6znAknB4wO9D/5rsyw/2kBuDE9gN671EimTu8QhYoEh5p32HPMnOUqyDK85/q8r/uS
	 MwMkhwtdACCPimiLwhJUqfTy+Nii1Oz6Z61YLPNdARKwglrHjujrUnO3wQ1c8Zj0tpIvm
	 3lh7bCKxcXftlxTPUAZfIX8IjhGUQzrSFHZr7DlER9FtntYMwpaF069VI9fr+A7ImdCEX
	 OkWyK+JYlTyOR8aecXxjxjw8tZ6rO4D494M791X8NcZ+mAtiRnN15ojPMgbtruCv5ipVj
	 lFbJk3okuerKjOBWnI7jlJN+1g9X+NcpmdZkch5YwywF8r1YV1S3TRtVHAhW91Mhn3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="anOxiQ/A";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF4E606A32F
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 19:20:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FF4E606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=anOxiQ/A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795116040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Um8gYE7Wj8DQXgc39oieKwxLwzqQdcu6AkEqQLyOQo8=;
	b=anOxiQ/AkS1OJtmw3ItFyLMPAqWaB/2mWC7aLfRd808gprc+vi5oJaA2zS9qsAMXulg3RU
	7PKxR2PoQzUMq+ud/gQgGe5v/ABUk5El3rul+rEVS1/PvpyeUyAbKxUCgcmDrg0XmUXFDL
	4vOPL3dqWWhRUrUOM2B25yVK1opRj+o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-c-SbkB-PO0mboB-jT0S00A-1; Thu,
 19 Nov 2026 14:20:36 -0500
X-MC-Unique: c-SbkB-PO0mboB-jT0S00A-1
X-Mimecast-MFC-AGG-ID: c-SbkB-PO0mboB-jT0S00A_1795116035
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BF8C1955DC4;
	Thu, 19 Nov 2026 19:20:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA97A346;
	Thu, 19 Nov 2026 19:20:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AJJKXBk880853
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:20:33 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AJJKXSj880852;
	Thu, 19 Nov 2026 14:20:33 -0500
Date: Thu, 19 Nov 2026 14:20:33 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Qiliang Yuan <qiliang.yuan@linux.dev>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] dm thin: free thins with kfree_rcu() instead of
 waiting in thin_dtr()
Message-ID: <av9MAYLH-bcaKzUw@redhat.com>
References: <20261119-bug-dm-thin-rcu-gp-v3-0-c80ecc475e1e@linux.dev>
 <20261119-bug-dm-thin-rcu-gp-v3-3-c80ecc475e1e@linux.dev>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261119-bug-dm-thin-rcu-gp-v3-3-c80ecc475e1e@linux.dev>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: H-yST5OtXdwMrE78QZqLTkGj0-7M69Cw9fW8idS6zR4_1795116035
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 19, 2026 at 06:05:08AM -0500, Qiliang Yuan wrote:
> thin_dtr() takes the thin off pool->active_thins once its last
> reference is dropped and then waits for a grace period, so that
> requeue_bios() and error_retry_list_with_code(), which walk the list
> under rcu_read_lock(), are done with the thin before it is freed.
> 
> Removing a thin device thus waits for a full grace period in thin_dtr(),
> although those readers only need the memory of the thin to stay around.
> 
> Free the thin with kfree_rcu() instead of waiting for the grace period.
> 
> Removing 100 thin devices of an idle pool with dmsetup remove takes per
> device (mean of five rounds, min-max of the rounds in parentheses). The
> queue freeze in del_gendisk() waits for a grace period of its own, which
> the one in thin_dtr() used to overlap, so only part of it is saved:
> 
>   before (ms)        after (ms)         change
>   17.2 (17.0-17.4)   13.7 (13.2-14.4)     -20%
> 
> Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

