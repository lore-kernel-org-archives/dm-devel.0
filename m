Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3C3295DA8
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 17:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747069928; cv=none; b=NZh+qZ4lZ4HFF2u9xVrw9NNMylaInLI7gvR18BRdhGFSOhMvHCGcKo9gDyuSHaJTLRKRQiXwGE8DapRjrVaf4cCoKjbAU/1sx1BATcYaPt6W3SC6IdMMj779p7c4SnXcR2LOXlMBu7ssjKOl34orhoLraXOO32B5A0i4z3Dgslo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747069928; c=relaxed/simple;
	bh=Po4ynMhPY+/HI3i3Y/8+BgdApJzzRcQlovAzEJDM8+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=hU+K0bpSdVi2q3AwBvPQolO3bVvGpk6VGM153R/OJlxQQhhi7urpCcxFsoEP3/I/u5/fV/NkaD3hcDR9lc0ZJetk15fn0LVMOyvjQmRnx+fGgnXdd0OBcACImzyj/A0NuVkKhk+Av3tDl+JX4I522GRPUccVyka4sWJfb8z9IYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IzFN6he9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IzFN6he9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747069925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VjiLOimdc8Ju6A0H0gIQPH3Us1QNo7y2qJAtgkSs9b8=;
	b=IzFN6he91aSUF+TXQm6jodPhmMexz1jIaDRcN95+YFlWZ7DhNYupkKrPr1CoqyLWDlAaT0
	v6PXYugsC5a5JvImdGCAlgfjuLbfGNs4hYMIUq0MWnpJOcUwxZpTAGAoLX+hmA2k4C9gKa
	3m3uCmizjeZDGmUk1/UfJ7DTiFv+4Cs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-307-vv25Kn3SPjuTym8Dj6jiUQ-1; Mon,
 12 May 2025 13:12:02 -0400
X-MC-Unique: vv25Kn3SPjuTym8Dj6jiUQ-1
X-Mimecast-MFC-AGG-ID: vv25Kn3SPjuTym8Dj6jiUQ_1747069921
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB8161800366;
	Mon, 12 May 2025 17:12:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 584FE1955EA0;
	Mon, 12 May 2025 17:12:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 54CHBxuE3564379
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 13:11:59 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 54CHBwDM3564378;
	Mon, 12 May 2025 13:11:58 -0400
Date: Mon, 12 May 2025 13:11:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM-DEVEL ML <dm-devel@lists.linux.dev>,
        John Meneghini <jmeneghi@redhat.com>
Subject: Re: [PATCH] multipath-tools: replace round-robin path selector with
 the default for NFINIDAT/InfiniBox
Message-ID: <aCIr3r6KqyumN4Pt@redhat.com>
References: <20250509134459.226640-1-xose.vazquez@gmail.com>
 <085c156c31fcd2fc5da4e889642bd6186c677a7c.camel@suse.com>
 <01c09aff033bdc1ba06c7a3265c1a1a477be1a04.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <01c09aff033bdc1ba06c7a3265c1a1a477be1a04.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hwajE52X64-SeYgrl0XKmDny7Tdzg5bCUAABcO_fOto_1747069921
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, May 09, 2025 at 04:22:40PM +0200, Martin Wilck wrote:
> On Fri, 2025-05-09 at 16:08 +0200, Martin Wilck wrote:
> > 
> > This code is from 55da608 ("libmultipath: update INFINIDAT builtin
> > config"), signed-off by arnony@infinidat.com. We usually don't change
> > defaults from explicit vendor recommendations without consent from
> > the
> > vendor. I've added Arnon to cc, maybe he wants to comment on your
> > suggestion.
> 
> Arnon's email address bounces. Unless we find someone else from
> Infinidat to comment, I think we should keep the current default. Users
> are free to override the defaults if the aren't happy with the
> performance.

I agree. This device config was set to round-robin after we switched the
default to service-time, so I think it's reasonable to assume that this
was intentional. Barring an email or updated documentation from
INFINIDAT that shows it's no longer the recommended config, I feel like
we should leave it as is. 

-Ben

> 
> Thanks
> Martin

