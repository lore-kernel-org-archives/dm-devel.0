Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0764E1E5217
	for <dm-devel@lists.linux.dev>; Tue, 18 Mar 2025 19:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742325806; cv=none; b=C7KB6lhjrUE2ekf/dE2MPi4nLhuACtjQtoQh+gIP2gAPq1zoVRym2l/KEGruSoim2t6FqK9+g3lbArEZzwc+Xj24eOxQraXgVDEYW3URQcEv8MeFDFOOhzpwzty++hQHX2jNbMmqbVICovdILe5Oopct3Q03ty/m1+F6M5rPZPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742325806; c=relaxed/simple;
	bh=9fP/oVApgYxqLB5RoTE3zsrBbobI0PwQCGh87u39l7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYJKxoWVJerGwA9bfSOyQN+7xsrS5xF+GFbx3hQK0Krc32W9LIRq08C8DIBoluE4/ir98UkmtG9z4Mkw1N2iWCCJc47gqTh1oYwjFTRrRMPuiLJo9c7ynKuWuJJthF41Olb1V9s9J2a/87lcfjfR1IgvkUWjx09DJwwsAD5vn6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jNF4kNqL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jNF4kNqL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742325804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/RLMYBwpSIvoET5BlljHVmD0m4DanHXp8UZ3TP9Ci7Y=;
	b=jNF4kNqL5AlV8q77vyjP71J0q4q5kXqkacqOX42eSxrRimd3/jnLv8umqqjg5jTWlndC21
	0KiML3XgiLGE14yCKKdFgvQOnKH2R8tXD8BWbl6gS/OCVni14qBx3fcC2TcyzPLwTTZK+F
	dk3c2dWrLcgZyRiGIfCbeCp6wQ0obqo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-146-UCe7ESZ6PvaTykmhMlDOkA-1; Tue,
 18 Mar 2025 15:23:20 -0400
X-MC-Unique: UCe7ESZ6PvaTykmhMlDOkA-1
X-Mimecast-MFC-AGG-ID: UCe7ESZ6PvaTykmhMlDOkA_1742325799
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D0061955DC6;
	Tue, 18 Mar 2025 19:23:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28F001956094;
	Tue, 18 Mar 2025 19:23:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52IJNGBK2267855
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 18 Mar 2025 15:23:16 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52IJNFU32267854;
	Tue, 18 Mar 2025 15:23:15 -0400
Date: Tue, 18 Mar 2025 15:23:15 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v2 3/6] block: make queue_limits_set() optionally return
 old limits
Message-ID: <Z9nIIydd_hZhzTss@redhat.com>
References: <20250317044510.2200856-1-bmarzins@redhat.com>
 <20250317044510.2200856-4-bmarzins@redhat.com>
 <20250318065603.GA16259@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318065603.GA16259@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Tue, Mar 18, 2025 at 07:56:03AM +0100, Christoph Hellwig wrote:
> On Mon, Mar 17, 2025 at 12:45:07AM -0400, Benjamin Marzinski wrote:
> > A future device-mapper patch will make use of this new argument. No
> > functional changes intended in this patch.
> 
> If you care about the old limits just use a queue_limits_start_update +
> queue_limits_commit_update{,frozen} pair.

Yep. I'll change that.

-Ben

