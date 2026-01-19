Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4857F22B5A3
	for <dm-devel@lists.linux.dev>; Mon, 19 Jan 2026 17:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768844256; cv=none; b=j1+jgPHh/O4LLRrM9Em0i3P3JJ014IH8SrnPwKM+6vhMLMpJoQqoEog327dvv0d6eaBiklTnG69TELlneTcyd+5KHUIJccHLt7U6v5xMJtR0cOTt8cJOnsM6ZZZyulLhls3nsQi9sHyF5P1fxMPQ5oZl9OeZUnkmBeCDiPsl0b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768844256; c=relaxed/simple;
	bh=ToEW09c6cQJlBdwt6A1d8A3DIFtHzWizt6B/XFe0kzA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Y6hYpfDHkBcE9xYLumDu9Ryv7GbWLVuJeRiHHqY2pjckOtFWps9sfhKR+PJXXKbvqRrn+kdGPmSwEyoLZo1UANBAD+BysrUAWi+T4dso8sHeATukg31SFekuPLluNx+Z5CVxbXw4St8H8tQ8kJAdLnfRS0Mpjn+lnyohyLJeZ3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XXI7mMdr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XXI7mMdr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768844254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K+neMMrYsWh6q6pTFkn4Zo4FJQAjTmhJQQA275qwHYE=;
	b=XXI7mMdrF+lwvMj3tgYRXRl5vHhjh8u2sRE5HBN/RD3WJO+9Cb5SG1uBEtW4XjN9yufHJ2
	uM58vuViMA+ogksI2Mm5UQWai5/7WTK0wp1MzwVMkkGYP9Qm7DfdnToGcNFcJ/JS6OPm/I
	J5ITH5kpXxfVNV79M88I9Xqzu3TVcLk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-332-_Irxi0T8PUC3z8XBMLhPmA-1; Mon,
 19 Jan 2026 12:37:32 -0500
X-MC-Unique: _Irxi0T8PUC3z8XBMLhPmA-1
X-Mimecast-MFC-AGG-ID: _Irxi0T8PUC3z8XBMLhPmA_1768844251
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B4F419560A3;
	Mon, 19 Jan 2026 17:37:31 +0000 (UTC)
Received: from [10.44.34.158] (unknown [10.44.34.158])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE4101800665;
	Mon, 19 Jan 2026 17:37:29 +0000 (UTC)
Date: Mon, 19 Jan 2026 18:37:24 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Matt Whitlock <kernel@mattwhitlock.name>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev
Subject: Re: Patch for mapping bug in drivers/md/dm-unstripe.c
In-Reply-To: <88ac5d9b-bc4a-4c7f-bc06-c4bee4ad9b33@mattwhitlock.name>
Message-ID: <162b8aa9-507f-a8ea-ffac-805072982ba0@redhat.com>
References: <68f72c7d-7e4e-4182-87fc-78c138046cd3@mattwhitlock.name> <113951bf-b1f9-02ad-3e9b-9fc1e30a575b@redhat.com> <88ac5d9b-bc4a-4c7f-bc06-c4bee4ad9b33@mattwhitlock.name>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dJeIh3CJke1OCmn9_Hr3cD4WlDaWNi0vw91891gWDOs_1768844251
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 19 Jan 2026, Matt Whitlock wrote:

> On Monday, 19 January 2026 09:13:04 EST, Mikulas Patocka wrote:
> > The patch is OK. Please re-send it with the "Signed-off-by: Matt Whitlock 
> > <kernel@mattwhitlock.name>" line inserted - this line indicates that you 
> > have legal right to send the patch.
> 
> I'll never understand the obsession with this one redundant snippet of 
> text. It's not as though my hitting Copy+Paste on it changes anything. 
> Did I discover this bug? Did I write this one-liner to fix it? As it 
> happens, yes and yes, but suppose I didn't: would you then really be 
> legally barred from fixing this bug, forever doomed to preserve the 
> incorrect behavior in the kernel because someone who didn't have the 
> "right" to tell you how to fix it told you how to fix it? Good grief.

I think that this requirement was added after the SCO lawsuit where SCO 
made baseless claims that Linux contains code that was copied from Unix. 
So, the purpose is to just have a record of who-changed-what, so that it 
would be easier to defend in cases like that.

Mikulas

