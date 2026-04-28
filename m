Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F0427E049
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 17:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777398376; cv=none; b=IcJ09A9RolgjJpfT8vzks49vgoGoab3leisIpUzrT5Av6wVuebkDfmPO1QiUv37JnjqapFyeUnS5ocLEF0LXU5ZK1Cxt70f/TEPmRDY0Bv5zWEuXlij99dQMuk34iBbfYlmYPGct+RNAp1NJywcr2XCbUrqG1eV+Li8X82+JxNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777398376; c=relaxed/simple;
	bh=WQo9F7amEO1y0chXMivzpal/w39T4Sp9z+RCPfvjEaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Mzicm3ZEJ38Mpayab/G4Zh3r8wtGhIWi12W9icYedGHFrDm7EwoWh1NIhjeOfnbDPRxaXS4nBb0kwshGyC+K5GNAfoeqVtZyQNzqLctsh1xwrWgA4MPj92LsfjenD4vthpfEqEeC/bt2TWX4x49C/VkiYZe/i3jIoOXDGfyaFeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qn0STlYQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qn0STlYQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777398373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0zZVmJ7NaaNDtv51Vc1VayQ9fqWwfmkS6+rxjOFmkPs=;
	b=Qn0STlYQr0JxOXJb25V9vKqHunomJ/68elsACGLlpjCwB72bDzEHYaIjYgyU2uUxr6JNMo
	gM5zyfntTc+ZEt/h5o7s7u5oVAyDL/FuxyBryBS56RcQWhxR3Q1vuvt2Ok0Gk7/MKS56LI
	gGDY6xIFbG+ZSseiAnbA5lowXUN0CLI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-246-zpPIZtKUOhy5Q4S7uqm3JQ-1; Tue,
 28 Apr 2026 13:46:12 -0400
X-MC-Unique: zpPIZtKUOhy5Q4S7uqm3JQ-1
X-Mimecast-MFC-AGG-ID: zpPIZtKUOhy5Q4S7uqm3JQ_1777398371
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 312931956046;
	Tue, 28 Apr 2026 17:46:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF8C619560AB;
	Tue, 28 Apr 2026 17:46:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63SHk9BF2775581
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 28 Apr 2026 13:46:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63SHk9HX2775580;
	Tue, 28 Apr 2026 13:46:09 -0400
Date: Tue, 28 Apr 2026 13:46:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 2/5] libmpathutil: add generic implementation for
 checker thread runners
Message-ID: <afDyYXIY2nyuI7Ij@redhat.com>
References: <20260428114942.292307-1-mwilck@suse.com>
 <20260428114942.292307-3-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260428114942.292307-3-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: evm5TJoy3XYLBe6w3v3quMUCp3yZp23PQQTImuqGHio_1777398371
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 28, 2026 at 01:49:39PM +0200, Martin Wilck wrote:
> This code adds a generic, abstract implementation of the kind of threads we
> need for checkers: detached threads that may time out. The design is such
> that these threads never access any memory of the calling program,
> simplifying the management of lifetimes of objects.
> 
> See the documentation of the API in "runner.h".
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

