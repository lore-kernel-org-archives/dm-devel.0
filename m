Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947DC171D0
	for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 20:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706733275; cv=none; b=u9QW5ClQe85jd3iFmXNpvcwfpMO/R+9JCyhoQxa85zKsJrYCk9TUf9E3bcnmp7y6RAgBC4RYfBd30MHW4XmFlQTG9T/HMf0AvX/MPARESX7I7c6zvMqCaUbBy3RRh5FIkHpfRdjpoI3xT2yIq/wSASUnyrmKR3JhtaadpcRw21o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706733275; c=relaxed/simple;
	bh=TBFq7X8o5crVC2o5ncnE+hrP2Ca9UuqR84hoahVhpww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=KLJ1aPtcOhcOSZKkr1diFmZvMZtLSUjaQn9GxCgwWod5CL+V3jceYjXy1mHH/jHo9L2ZPb9nda09dxRhAYv8AqN+wQPR03Dqz+rFSqO7AOV29nZpCcHwF+AQ/QtGCZJIgUxQrZVpwpRh/wxkSdl+18KxI1iKEfMTEZxfThLxuNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BKRpj4FB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BKRpj4FB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706733272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LM9q8at7xBCl1WQCAL5CVCyTbn4iWTLc7efumNkNUMw=;
	b=BKRpj4FBS9pFqcNnOvzAGDYToZWhIeJThckmN0Y8IKRjKQ6eRiFF3FCOi5nLh9XbCft6WY
	E4+P6J+YboilFLXlaqgYk7g4YseFCn4PA3ZhSsL44eqgjt0F5Eye6de9boObTDVweCLSNw
	SaV6BUFVRB6BZPzVK3I6SW+rfBhuQ38=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-vt9NESM1NbeluHb99Dv9Mg-1; Wed,
 31 Jan 2024 15:34:26 -0500
X-MC-Unique: vt9NESM1NbeluHb99Dv9Mg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFE3B29AA2CD;
	Wed, 31 Jan 2024 20:34:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D59932026D66;
	Wed, 31 Jan 2024 20:34:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 40VKYP7U274151
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 15:34:25 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 40VKYPhu274150;
	Wed, 31 Jan 2024 15:34:25 -0500
Date: Wed, 31 Jan 2024 15:34:25 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Seamus Connor <sconnor@purestorage.com>
Subject: Re: [PATCH] multipathd: the sysfs prioritizer can return stale data
Message-ID: <Zbqu0W4c7tZbFNIS@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240124020007.25259-1-brian@purestorage.com>
 <ZbkmuqWetsaOPMkC@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
 <4dd466445f477e1991267edf30b16364af021f53.camel@suse.com>
 <22BFA8ED-7AA4-41C4-9253-3B2846301BFF@purestorage.com>
 <2f0e15e5672f3d9f665491b40cfdada4cd9c36c2.camel@suse.com>
 <9F411A14-251E-42B3-BF1B-7EAFE860B6CF@purestorage.com>
 <cae20ba154c77d7ba99f8eab0b47b93d76a9c953.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <cae20ba154c77d7ba99f8eab0b47b93d76a9c953.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jan 31, 2024 at 09:12:23PM +0100, Martin Wilck wrote:
> Hi Brian,
> > This is what we are doing now in our recommended configuration. I
> > will
> > probably add a patch for our hw table entry soon. It is a bit strange
> > to
> > me still that detect_prio would mean replace the one that I am
> > explicitly
> > stating in the device section. To me detect_prio would be if I didn’t
> > provide one and wanted multipath to choose for me.
> 
> True. The design of the "detect_prio" option is awkward and confusing.
> It happens all the time that people set "prio" and wonder why the
> setting isn't applied. Or worse, they think it is applied but it's not.
> I think the original idea was to use ALUA whenever supported, even if
> historically the hwtable contained something else for a given storage.
> It has been this way for a long time, I don't think we can change the
> semantics easily.
> 

It's so that you can select the failback prioritizer if multipath can't
autodetect one. This made more sense when detect_prio defaulted to "no",
so autodetection was only used by devices that specifically enabled it.
Now it just is what it is.

-Ben

