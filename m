Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26616395AC7
	for <dm-devel@lists.linux.dev>; Tue,  2 Jun 2026 05:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780379633; cv=none; b=AvZ2KVqSRkwIqMaA+4ovUnmXBpvX1qcjmBphe4GCt/d1h+6NMf+4F5aoJCucg3eGm7y7SmvP1zyU6QcNgEdzUryDFRWJ13bxBXqxn6cpk1hu+aVrMUXqnuyO58uT3OOxlROOPs+h8MmEpmXGlTbxHjjG36jZdG6MunPimxf+B5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780379633; c=relaxed/simple;
	bh=CMQu8Rmogc71E5dHsGV63U4d1OpuHBDlSemfZapAh30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=HbIVNtkeSpMymDWIVqaAWoGQkKBjACNTiUz3VfNHBd3EfN+NTETzm7j61OYCbj9wIclPMoWYvMg9g6iW/GyfXS+MyVKkzvq6J5YKS689NqJ9NGPgQjVHqrVaNoygreH18D11t3tyomCItFZlJZMql4VA35BjmHOqOlyMBaVwZcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i+v4W2Ec; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i+v4W2Ec"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780379631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xbiFkqSxxEYt6YBnPyUcFFZipzI4nDhd1jNKeeUK9k4=;
	b=i+v4W2EcYtZLSRTdMqReJkSQw+rK9oyQ4wMIjLqkfCIyMB+rNejfiqLSg4Q1ldULOUhtH7
	tiGp3cFg62osvgCLCRgg2747BQvha2YFegGPMopd+b38/OaHRb9y/QAs6fxiRor4om6Uc7
	e2/BoIWOX/BHDbDRiRdK7Xdc8BGSrCQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-211-Ow7apcvZOcGwJvCPLPMSAA-1; Tue,
 02 Jun 2026 01:53:45 -0400
X-MC-Unique: Ow7apcvZOcGwJvCPLPMSAA-1
X-Mimecast-MFC-AGG-ID: Ow7apcvZOcGwJvCPLPMSAA_1780379624
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F11151956080;
	Tue,  2 Jun 2026 05:53:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E21B1956095;
	Tue,  2 Jun 2026 05:53:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6525rgQW305543
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 2 Jun 2026 01:53:42 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6525rfud305542;
	Tue, 2 Jun 2026 01:53:41 -0400
Date: Tue, 2 Jun 2026 01:53:41 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 00/19] multipath-tools: asynchronous checker framework
Message-ID: <ah5v5cxuGay6J8zu@redhat.com>
References: <20260522164415.846589-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260522164415.846589-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _RfSBtRL-keK2TvYEwnNleF1TenYvJAAmFEZEhbdUJw_1780379624
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 22, 2026 at 06:43:56PM +0200, Martin Wilck wrote:
> Based on my previous patch set [1], which introduced the "runner" thread
> handling code as an abstract implementation of the asynchronous checker
> logic in the TUR checker, this set introduces a generic "async_checker"
> type and converts all existing checkers except directio to this framework.
> With this set applied, all checkers run asyncrhonously unless explicitly
> forbidden to do so with the "force_sync" option.
> 
> Patch 1-3 are minor preparations. Patch 4-8 introduce a general concept of a
> refcounted "shared" pointer and use it to replace multiple instances
> of hard-coded refcounts on objects. Patch 9 converts the current TUR code
> into a generic asynchronous checker type by separating the actual TUR
> code from the handling of the async runners. Patch 10 adds support for
> this async checker type in the checkers code by searching for
> "libcheck_async_func" with dlsym() in checker DSOs. Patch 11-15 convert
> all checkers except emc_clariion to the async_checker framework.
> emc_clariion is special because it needs extra context both for the checker
> itself and for multipath-related information. Patch 16 and 17 add the
> respective additional fields to the async_checker framework. The mpcontext
> handling is rewritten, because the current apporach of handling void **
> pointers would be disastrous in scenarious with truly asynchronous checker
> threads that may hang forever. Patch 18 finally converts emc_clariion,
> using the concepts from patch 16 and 17.
> 
> Comments and reviews welcome.
> 
> Regards,
> Martin
> 

Sorry for the late review. For the set:

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

