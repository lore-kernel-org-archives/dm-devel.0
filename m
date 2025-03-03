Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC97B1F0E34
	for <dm-devel@lists.linux.dev>; Mon,  3 Mar 2025 10:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740997323; cv=none; b=BrnaiCiSDeq4WhrwaDg2JnS8jXTGjnacoeXPU8z5nll1yB33mKmFjMZ2Pr7eiyPNu4w3KF4iRu9vsr3E4g0urGnii3WQcTxUgLAnQBj4LJDpxMoIA/vrJVUgWj/bId0f0JpuEezPuphgCXbryeACbI2r1Z038HLnUS+8fkZCo9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740997323; c=relaxed/simple;
	bh=RtvIrhiNHKaXaSmnFIMfUWDpr0+DmF1U/oiou9GGElM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Ec8W9PUQTPvz0we/04hz7M/mKBlf/TF031kwAxNlrgNn1Z+vowoMOc2oV8PV7L4BkEBEMBiOLpFuMGP0lzKZRspl0yqRldgGMe3Zf/OK3mjtn4kaAoGO4ca52+WvA9+Z0Eo56pA8jGqA0/pvtL5bL+OeWOqVZmjyRMY2tMzqIAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RrNuOmG4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RrNuOmG4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740997320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VXnQNNA7piQ3hw4C0AqbVV0Ymy22beYvtZAvK/osYJ8=;
	b=RrNuOmG4snRV3yf/NqokSbRqXFQHh3Q95XrnFZtjd0mR8DnIdLXvPKRFl/bIg2BfQyEhN2
	dvqGyiF1+oe3ufTaMnnqDwMdO3nYvsqpcl7AxW0W2PD0iiQADEuWKG/+xr/2eaZq/KDz56
	9qh412H1FKc5hDCEcRJUHDIeP60q4b8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-1a9-bE5mPnehTsBDWm2M5w-1; Mon,
 03 Mar 2025 05:21:54 -0500
X-MC-Unique: 1a9-bE5mPnehTsBDWm2M5w-1
X-Mimecast-MFC-AGG-ID: 1a9-bE5mPnehTsBDWm2M5w_1740997313
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 693C3180087E;
	Mon,  3 Mar 2025 10:21:53 +0000 (UTC)
Received: from [10.45.224.44] (unknown [10.45.224.44])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B17E1800371;
	Mon,  3 Mar 2025 10:21:51 +0000 (UTC)
Date: Mon, 3 Mar 2025 11:21:46 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jooyung Han <jooyung@google.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    zkabelac@redhat.com, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm: make it possible to open underlying devices in
 shareable mode
In-Reply-To: <CAO-8PLbbsn=6KQ19oi7WpW2PcVHLfy13RT2Ce-5ePp-0j0sYEA@mail.gmail.com>
Message-ID: <40160815-d4b4-668e-389c-134c75ac87f1@redhat.com>
References: <CAO-8PLb0azRAuu2yJ3=K1EwiSXASDJ8nVBttbuOUV77==Xd2ug@mail.gmail.com> <94c895e2-0a71-73b2-2692-af8bf62fb340@redhat.com> <CAO-8PLYMFd3YLvfue_an7mc-O19fixJY4ZKybvjehxcm2tRYvA@mail.gmail.com> <CAO-8PLa3Qxhy1M1C_ZDTpOyXrhQ=UQKeKoDOmy-bbShb4rV03A@mail.gmail.com>
 <dcaed20c-2132-d453-9c04-b22417ba4010@redhat.com> <CAO-8PLbTAMO867ifaHOdSWQrErV+vfsg2udWF27PK_VKmrMFgw@mail.gmail.com> <aa42a2ba-ae99-c209-1289-a2b22dd3b6e8@redhat.com> <CAO-8PLbbsn=6KQ19oi7WpW2PcVHLfy13RT2Ce-5ePp-0j0sYEA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: J7xnsdxfUKVzeDmZyZ612ZPwHjtqJz7F_zV2cKllIJg_1740997313
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 14 Nov 2024, Jooyung Han wrote:

> Thank you Mikulas and Alasdair for your thoughts and ideas about alternatives.
> 
> I'm aware of those alternatives. Android already uses DIO for loop
> devices for read performance for APEX mounts. Having an extra DM
> device was in fact our immediate fallback solution when I found this
> issue. Then, I thought that, if DM-device owned by another DM-device
> can be shared, why not share it with another read-only filesystem.
> 
> > confuse dependencies in udev,
> 
> What would it be like when a DM device is shared by two other DM
> devices like your suggestion #1 or #3? In #1 for example, a dm-verity
> device is shared by two dm-linear devices: one for /system filesystem
> mount and the other for APEX mount. I hope we can fix the issue around
> udev dependencies if there's any.
> 
> > Will there be some performance degradation due to the extra linear device?
> > Could you measure it?
> 
> I'll! There're two aspects: device creation and read performance. Both
> will affect syshealth. Fewer devices should definitely be a win.
> That's why I brought this to you ;-) If your patch can't make it, #1
> is most likely the only option I have so I hope there's not much
> degradation.
> 
> Thanks again.

Hi Jooyung

I revived the old dm-loop target (I'm sending it in the next email). It 
works as a regular loop driver, but it has better performance because it 
builds a map of the file in the constructor and then it just remaps bios. 
It doesn't bounce the bios through a workqueue like the existing loop 
driver.

It'd like to ask you to test if the dm-loop driver fits your needs of 
mounting the APEX images.

You can create a mapping of a file "/root/file" with this command:
dmsetup create loop --table '0 524288 loop /root/file 0'

The last number on the constructor line is the byte offset into the file 
where the mapping starts.

Mikulas

