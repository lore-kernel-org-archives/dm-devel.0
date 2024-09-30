Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD61B65C
	for <dm-devel@lists.linux.dev>; Mon, 30 Sep 2024 10:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727693983; cv=none; b=DeJVlWXcFEmQsSG8no9xZcV4aHUnpWJFDmtMbYcFr6EfRsBwqO8AigiHnMfbrZzg1/yhsrmlodQqg3bOkgah2qvwDzh5UPwXx4RbdB/fbkB6Dn61jQglTO9dMFwWlO3CDucdTQddgxZmdEkloeG+MRzexWy4L7Tf/C0rIT1pIjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727693983; c=relaxed/simple;
	bh=OKPgpPO5GBNwpsx0L7EtzzwbMXtikEqviutcsynA1FA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=qq9xgKyk0KnMC9XAOKBo+lboWpTeNRJvga8kz8aqBIqA57sIbKN0x8jbLb6c8gj8djLNtrj6CZ4dnnUNROdfx24neclFCE9qzjLk2KFLPUbgQSk2e9Mta2wqoScbTILPU72IqL4BLlq42CFMih8C53jsR1nfe+PB0w9IuOtZKrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aHoyPPAB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aHoyPPAB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727693981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f5AEF1CLZn0QeyKiB61KaWdG3tHxJhWwlbG2yidmO4E=;
	b=aHoyPPABwt9anFtDXUmsr8nuqw7vYtdZ02JaNSuaUe74Ad+FSr9a6MbrQYx8rFPuMqtjQ5
	GuPgHJSHj/54PjTQfq1e/xwqQ5jILdzkk3aSt1dAaOB+zjkS5A8G9UENhsen0CrLIdHLiK
	KbK/ZWrAAk12DjfIf/VKrx04IJLqKo0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-oEg7Fw8UOUayOaCuB6c-wQ-1; Mon,
 30 Sep 2024 06:59:38 -0400
X-MC-Unique: oEg7Fw8UOUayOaCuB6c-wQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D82951955F25;
	Mon, 30 Sep 2024 10:59:36 +0000 (UTC)
Received: from [10.45.225.58] (unknown [10.45.225.58])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2441D3003E4D;
	Mon, 30 Sep 2024 10:59:33 +0000 (UTC)
Date: Mon, 30 Sep 2024 12:59:30 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Sami Tolvanen <samitolvanen@google.com>
cc: Milan Broz <gmazyland@gmail.com>, Maxim Suhanov <dfirblog@gmail.com>, 
    Akilesh Kailash <akailash@google.com>, Alasdair G Kergon <agk@redhat.com>, 
    Greg KH <gregkh@linuxfoundation.org>, Mike Snitzer <snitzer@kernel.org>, 
    security@kernel.org, dm-devel@lists.linux.dev, 
    Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
In-Reply-To: <CABCJKudUHS_vzW1G08_24JxLbSmZwKUUUtaWkFSjv6gFz6+GXw@mail.gmail.com>
Message-ID: <4c6ef1cd-9eab-c8d2-a641-50a7d6994632@redhat.com>
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com> <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com> <CABSDvDLu9-uzbd9z-avUu-iLV9rgyy=LKzaOwdWnD0f7ruBizg@mail.gmail.com> <9dee84e8-6c94-7450-a0c4-a95cab8f66d4@redhat.com>
 <b65d67cf-9904-4182-a113-2d9a241dd668@gmail.com> <CAKeu6dUEC-j5G+KOTFUdfinMe+HTBSm6idxhHQzwVr8Sp_MfMg@mail.gmail.com> <3d31625f-3b26-47d7-b933-0bd6a89b748b@gmail.com> <CABCJKuf3bkJXS2dzud5w7MrfEcYa21mbKa=ssEOQxPzfDtzE2g@mail.gmail.com>
 <1229c48a-a225-e426-7f39-465146754975@redhat.com> <CABCJKudUHS_vzW1G08_24JxLbSmZwKUUUtaWkFSjv6gFz6+GXw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 27 Sep 2024, Sami Tolvanen wrote:

> > See for example openssh, the function read_config_file_depth. There is:
> >
> > while (getline(&line, &linesize, f) != -1) {
> >         ... process_config_line_depth
> > }
> > free(line);
> > fclose(f)
> > if (bad_options > 0)
> >         fatal("%s: terminating, %d bad configuration options",
> >                 filename, bad_options);A
> > return 1;
> >
> > So, the function doesn't distinguish between error and eof. If reading the
> > config file returns -EIO, the function exits with 1 as if the file was
> > empty.
> 
> Sounds like OpenSSH's threat model doesn't include an attacker who can
> trigger arbitrary I/O errors. If you want dm-verity to protect against
> this, why not add a new restart_on_errors flag instead of changing the
> semantics of the restart_on_corruption flag and risk breaking existing
> users?
> 
> Sami

The dm-verity behavior was reported as a security bug, so by default, it 
should behave in the secure way - i.e. restart or panic on I/O error.

Do you intend to use dm-verity in Android and ChromeOS in the less-secure 
way where it returns -EIO? Have you audited the Android and ChromeOS 
codebase so that -EIO can't cause security breach? If yes, I can make a 
configuration switch for you that will enable the old behavior.

Mikulas

