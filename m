Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7631724C675
	for <dm-devel@lists.linux.dev>; Mon, 10 Feb 2025 21:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739222710; cv=none; b=Ji9FOqafDVGrjYdHqu914PM/D0z0lE++n6f/YTT3vmj2Z8z0Xblv0M4BiEck8vWgbdvVooCM0os6InLB++zLvy3xMnkX3GZIUUMCdphxddRjaQLDeft05VeCh2SA4DbbwNX3paQ19jD7Q7CzFyz+MdA94Lh5TfQC+OS7lY3up+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739222710; c=relaxed/simple;
	bh=UuBoBid759grFY8mIdeZz2HJgUjWha4XCnYQUrjFSy0=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=paMHi37ZHZN2tvuL6Tds1bqtvivmuck0aiiPm2WpOMERZp6LzOhSKbUTmWVh/ywwlg7KjzBe6wa2NyQaFyzVFHm50rUdBvsRAuFqRBFjBQ7B3fBAtbSb6z+/wkpQ4etVIExj/uSe729rYrQ3eXorFeujSLmRzyjSMXoSLmg4s+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Qbxyb1aK; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Qbxyb1aK"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aaec61d0f65so1077607266b.1
        for <dm-devel@lists.linux.dev>; Mon, 10 Feb 2025 13:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739222706; x=1739827506; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:date:cc:to:from
         :subject:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UuBoBid759grFY8mIdeZz2HJgUjWha4XCnYQUrjFSy0=;
        b=Qbxyb1aKC35raz7Jpe8p5Z6U+XlbrGtIfB+JWKgduCc8q1KZLU82eDkA9P/mOrzOmn
         5nFIQ6bzggj2aC3byJx/FQL7rSFKIifnFa+fJ3FXf0rmNE5jczMADYlpNQX7PtfNzGZL
         tR562DtUhXta/uts8BWJX6Bsj7ZgqK8RWjCn33QKkiWA9pAC3ue+5y39O6NdbPaKZEO/
         DF0zC83zrbsVptIGmKxfj5koPaGNiECWLDftWJqTVB7k7w69EqwR2hyRhFdXD34v0eoF
         uLEEiMQTAwkX5dbZeOYHyuDIv7B+EoMXgzdmW+k4qJZRhnJBMw7u8HkaIosAaMLapnLC
         +cog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739222706; x=1739827506;
        h=mime-version:user-agent:content-transfer-encoding:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UuBoBid759grFY8mIdeZz2HJgUjWha4XCnYQUrjFSy0=;
        b=XD4bC+tzOzWk8tb4AO5jV1sB/T8TNo5y+Wuu2gdd8F3nMLyDtSY6W3CYwL5S3N/H+z
         CV6mOWGEg1bQN+W+VfPrcDnzVsedVqlismq+lwMhMt2J/xPwuuhoRq3AZGBaWUWWqoJx
         egVSdO2gfX4kio07l92ZL5/HwCWwyK4ln89QBCpSAumVXfDvh43VU+1RFH1nN/ahj0iJ
         /pom1ediULd9ks+JzIIzptSIKrEi/39ASTuy1iSsbnQepQCHzelK/lJK8ieygwh1SPRp
         siUHw6jX997U2wMbYZQknS43TjnwH9yRyFRQq+Wd3izyrpywoxs1enwGtEWFLWf7ynNp
         Ei5g==
X-Gm-Message-State: AOJu0YyliyoEgjzbW4/Ot3jPjdwvz7fDT1vDcVN+5C1kQBhuZdbYRXbR
	kcDP0COdmHu3U/OsvXul9LhGTmkCohj0QfGQoZiHGFuvKzFKT2k752dTsoojzjDn/bzra0C7bTP
	8
X-Gm-Gg: ASbGncssDgWHLHViz7TY94bWhF2YX2mjo91BYa/cALB+R4EKswzUAh+inZ5zsbCBXb2
	mT33HFOqCTb/ik+u1h2wFBIMA38Z+YIJ/WdAWLoH9Xvj3OFYvLlDUZCegMfDXoJUeqpF5YCraDd
	tQ/9LEzeXNF6uZC/Ien0EsW4W2XmNrRU903Ngj+mJqq7u7rIbQ9JdGVCpxFxi1TNicaCKr7eGzk
	TqJ84Bk1Qj8MNnjg/IaWqzLYBu1HHoQwIhrWMDhloqDIVvGKBmJcn6Sx0EHpCT5BSQ1nTxwgWqv
	aGMXt22XwRed0IOTx5qIeRI2wanE6WKDumBtFwVe5chM6I8xjvt+tQ==
X-Google-Smtp-Source: AGHT+IFb4NBwnaYKERXlyRwExAwCMfJDG9dMQ5s4Or9qy0u3NObPgcaJ1jNODsMB5+IetlQdHtjjkg==
X-Received: by 2002:a17:907:72cd:b0:ab7:a679:4b00 with SMTP id a640c23a62f3a-ab7a6795bcamr1064230666b.40.1739222705629;
        Mon, 10 Feb 2025 13:25:05 -0800 (PST)
Received: from apollon.fritz.box (p5ddd307c.dip0.t-ipconnect.de. [93.221.48.124])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7e0a6af6bsm2321066b.99.2025.02.10.13.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 13:25:05 -0800 (PST)
Message-ID: <df3d023177dca2006b5aab4b2c4ef78fe1acf8c5.camel@suse.com>
Subject: Announcement: "stable" branches for multipath-tools
From: Martin Wilck <martin.wilck@suse.com>
To: dm-devel@lists.linux.dev
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski	
 <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.com>, Xose Vazquez Perez	
 <xose.vazquez@gmail.com>, Chris Hofstaedtler <zeha@debian.org>, Christian
 Hesse	 <mail@eworm.de>
Date: Mon, 10 Feb 2025 22:25:04 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

All,

the multipath-tools maintainers have decided to start providing stable
branches that accumulate bug fix patches only. We currently provide two
branches, stable-0.10.y [1] and stable-0.11.y [2].=C2=A0

The stable branches are meant as a guideline for distribution
maintainers to pick bug fixes without major regression risk. Only small
patches that fix actual problems are eligible for inclusion in the
stable trees.

This is a best-effort endeavor that doesn't come with any guarantees.
The maintainers will provide maximum two stable branches at any point
in time. They will usually be based on the previous two .0 releases,
but this isn't set in stone.

The introduction of the stable branches goes along with a modified
versioning scheme for the "master" branch. The development tree is
still hosted at [3]. As before, this tree will be "released" to the
opensvc "master" branch [4] in roughly quaterly intervals, to become
the next 0.x.0 release (0.12.0 will be next).

Best regards
Martin

[1] https://github.com/opensvc/multipath-tools/tree/stable-0.10.y
[2] https://github.com/opensvc/multipath-tools/tree/stable-0.11.y
[3]=C2=A0https://github.com/openSUSE/multipath-tools/tree/queue
[4] https://github.com/opensvc/multipath-tools/
