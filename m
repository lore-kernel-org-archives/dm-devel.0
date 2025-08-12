Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC14D2D061F
	for <dm-devel@lists.linux.dev>; Tue, 12 Aug 2025 20:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755029069; cv=none; b=kw8Qt60k6/5Plvii9EsC9KqSLqB4cytZeU5U+qFm5X+g9IMT/Pe8VRh354ab6nb9N4RoU+V4XaTmzUzRT2PARAoDRucFT4ZjsRhYKYbb4G2bOhN8SehL9wk2l23nxkWTkWzrV7C7729meBrufVeTOPT7XGHpItkS63+hl/qNsik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755029069; c=relaxed/simple;
	bh=6PZtM4+t1we1+tEbM/1MqdbDEK5pQRP+/jLTg0BnH+U=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=MkeRYm7jO3kP71w4B/UGWrbCa1Fwz1jnT6yJLJ2ZoZS38OdZ8LFJvWKEjNza5+1HLsXVS6R3BnApwKJ4wfvfwiKy//cbpfEpBTL60q/e8xHPH1LPGqp2uOivxoYgPEEIzdQN9+80rsJUYbu5tMDBvihIF8tCSH+FjAU3ZONoYvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ft3faTMf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ft3faTMf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755029066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=WWK+LOSpqCS346v6D/rDBcstJIXvBSC3FH1sp0DvLc8=;
	b=Ft3faTMf2C4QfDvj7KSt7tvOjDA1gUBv+cnp5Iru3ac26zJDMav95reLiOfBnk9SktZX39
	YILDyIC1KsOa48f1zzzvvu9yyEkhqxdA2bysBEKCScLO8Ad1s62Wb428cbCgdliekZd+Uy
	aa2Wab/jCk3roZZSJzaKwYAQUQuTmmg=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-XXbYmY18OVOigvEYQUjq_Q-1; Tue, 12 Aug 2025 16:04:25 -0400
X-MC-Unique: XXbYmY18OVOigvEYQUjq_Q-1
X-Mimecast-MFC-AGG-ID: XXbYmY18OVOigvEYQUjq_Q_1755029064
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-332326aa250so28331561fa.2
        for <dm-devel@lists.linux.dev>; Tue, 12 Aug 2025 13:04:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755029063; x=1755633863;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WWK+LOSpqCS346v6D/rDBcstJIXvBSC3FH1sp0DvLc8=;
        b=sjkk7bnlOslz1g2GM1ESsofR8x1ydMZYA6LoY6fB1VrUBd4qD9wzfA1/w0Mmfm+D/C
         v139JlivnjyYczzQyQep0iBLSm7JRVqbD+rEtkVxbiSxeH/3YHVUZeuLBHACPXw9QhWc
         b0B0JpnmZJNilwo4xaFG0je6HUgtLputFrHBQC10bYtF7P/+TOOAm+7S3mTcq6EEqeVx
         vbUsWqprqm/Arq7YfwnQM4GJHE50lT6TKUJl5bWfpkRkQY7R83HAhFSTTwRjAEEOoZ6p
         r4fJIvYjqKQDcXrql454yS2idrvbNzjl80Qc3HMJzIoS2rl1nJKMZZg5w9PrSVNZmE0D
         rVtg==
X-Gm-Message-State: AOJu0YxkkvRo/zE1C2s7upGM6dAPdSpQ85hphXD/HoP7D5TOX6MwYCZ4
	ZOwA0vzsteWdyJ7KZ2gjwYtLayVyeFeRWcXJWDMyBr1ZevDQ17hwr1Lb/YfzXj3heSlM6B9ULqz
	nYDaTkJUluVaow0lXNzquIs2LV/gWbBHtSeY1lBwnJQ8SBJuNlF5cPfV4b9ypwFqhZ3ptkdjrWE
	sIdYg3U4rw0uZ5B3uQHY/j5b0dzXZjMhPTELcaQffZCKKPkg==
X-Gm-Gg: ASbGncsn2yoYEhJNEPAGvIndc1Nup16Md7Oj1pLF4i1bGjsSKqr522b913DzwAgVozB
	ryC/SEMGCtOc7WAIoWmk0rgUhVAQn4CBJY8As0RvvbfPEbGcucayRVS2evmx19oBvX2pyjcSXJE
	A8zHn+DnoykuEXAzXhyHDMIduo/WoD7AA6fguyd5okZ1uoYfHrBDKG3Q==
X-Received: by 2002:a05:651c:420d:b0:32c:a771:9899 with SMTP id 38308e7fff4ca-333e9874850mr655921fa.9.1755029063317;
        Tue, 12 Aug 2025 13:04:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEET7vMPuZbAFeKAgtBGk8LzwEu4Fvsndo1zz6zTuRToeXrT4OANWKzqeZUBsVhHvCYSQazD2rm2nKVXJfiWBY=
X-Received: by 2002:a05:651c:420d:b0:32c:a771:9899 with SMTP id
 38308e7fff4ca-333e9874850mr655861fa.9.1755029062882; Tue, 12 Aug 2025
 13:04:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Jonathan Brassow <jbrassow@redhat.com>
Date: Tue, 12 Aug 2025 15:04:11 -0500
X-Gm-Features: Ac12FXzTRKHu51huARjz0-z0DdBNNqcbkF5bKNcfxNLnQL1P_Twk7-X1Z-RfSZI
Message-ID: <CAOP-y9He_CWP0khLkRGjw=6n3bgxULT=xR4G+tZOBAmD3VLY+Q@mail.gmail.com>
Subject: [Job Posting] There is a position open in Red Hat for device-mapper
To: dm-devel@lists.linux.dev, Jonathan Brassow <jbrassow@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XrqLGny84pKBlD-TVCGg4osoVgg5cmiNcz7_T0Ghx90_1755029064
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Hi,

Red Hat has an opening for a Senior Software Engineer on the
device-mapper team.  We are currently looking for candidates in the
Czech Republic and India, but I am open to looking at resumes from
other locations also.

We are looking for someone with kernel and storage experience -
ideally, folks who have contributed on this mailing list.  Please
contact me off-list and I will connect you with the hiring manager.

Thank-you!
 brassow

Job Description:
Red Hat Engineering is looking for a Senior Software Engineer to join
our global Platform Storage team. In this role, you will work as part
of a team to design, improve, and maintain our storage offerings -
specifically, device-mapper related technologies with an emphasis on
kernel work.  It is a challenging environment that requires skill in
algorithms and data structures, advanced kernel knowledge, and the
ability to adapt to advancing hardware capabilities.

What You Will Do
* Design, develop, and implement Device Mapper technologies within the
Linux kernel using the C language.
* Become responsible for the quality of our offerings, participate in
peer code reviews.
* Develop and maintain Python code for testing and automation related
to Device Mapper functionality.
* Actively participate in, lead, and contribute to upstream open
source Device Mapper project communities, including developing new
features and providing fixes.
* Collaborate with customers to understand their storage challenges
and provide expert guidance and solutions related to Device Mapper.

What You Will Bring
* Strong C language programming skills, with a proven ability to write
robust, high-performance code.
* Expertise in debugging complex issues within kernel-level code and
distributed systems.
* A deep understanding of how open source communities work, with a
track record of effective collaboration and contribution.
* Solid knowledge of the Linux kernel, particularly its storage subsystems.
* Excellent understanding of storage technologies, including the block
layer and the mechanisms for ensuring data guarantees (e.g.,
atomicity, durability).
* Motivated with a proactive attitude, willingness to tackle new problems
* Ability to work well as part of a team in a highly collaborative,
distributed environment with a diverse team.
* Good communication skills in English.

The following are considered a plus:
* Clear understanding of modern storage technologies like NVMe and
SSDs, as well as RAID configurations.
* Good understanding of other Device Mapper-related technologies such
as VDO (Virtual Data Optimizer), Thin Provisioning, Stratis, Crypt,
and other relevant modules.
* Previous contributions to open source projects or being an open
source contributor in the storage domain.

