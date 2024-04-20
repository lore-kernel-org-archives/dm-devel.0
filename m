Received: from fhigh4-smtp.messagingengine.com (fhigh4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D9C205E12
	for <dm-devel@lists.linux.dev>; Sat, 20 Apr 2024 03:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713583797; cv=none; b=iuFLKkIMnkzDuNDdAHfM2HZVs/ewl9PimQudnRMG3Iq9jk94xeRLqW9yJjeHrq0pa57MR4ehb4DMX3ea90t1Pia1tv0JQuIlvrI0diwNOQNTd2hmwwQWgI1XUoXE8Bbm7c6LGMTJfeAD1bn6f0tnq6e/E2UVbj+ek9vxnpKvmZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713583797; c=relaxed/simple;
	bh=n61BEReyQa5DNeFH304oA8AXLQ9Ze3ACB5Do5s50l4Y=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=AW7AoYCnxBbCwudDJ0gtMgMYsQhRlrqDHmDTFs6nIxJuFv1OWD7p17rcvop7/+BiIAEAzUAIfnbQB8SaZTROd5qAd81CDXwypSce2A/szPR8fkLGhaGeU71h7fDv/vsCUC0lMUMPNCOSJabP6pU+qrDhulu00Z4tTNEzobe2MA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=owlfolio.org; spf=pass smtp.mailfrom=owlfolio.org; dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b=U/a+2WgR; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jcRFx9NO; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b="U/a+2WgR";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jcRFx9NO"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id DFBE31140130;
	Fri, 19 Apr 2024 23:29:53 -0400 (EDT)
Received: from imap45 ([10.202.2.95])
  by compute5.internal (MEProxy); Fri, 19 Apr 2024 23:29:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=owlfolio.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1713583793;
	 x=1713670193; bh=S3P89661a/vQLOF21RrX8vbn8zuamqYrMPR4h7quqcM=; b=
	U/a+2WgR7Gx3PK3WfWDOkOtl1qpMtEEhGtHtOyabtPuLH/F7AkLVl+rmlvrkM5T0
	KEVBeUtjNmSOY8P6gqwdfPToUeTzZv7avq8VVG5k9CEcGNqEPHg8pVBCCdsvY0SS
	NZF/bgkZ2tOAQIodSf/GBk5+QNPWzSyudYR3Bx7mF4Eepq71rqvQLBUJnokjrcf8
	FId6wyB+DD3rVP0D9FghT9LicbQOCSvbDzpVvj5stAeyTwvG9MUpEJs94xAaCaK8
	d2S9emRRamE+uMuEX/Y6yMjUtUmMWFbdZKR6pOOxgURNIyU83buzLsiivnTsAqqO
	6LqcsNchzgpQt0lSOYvspA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1713583793; x=
	1713670193; bh=S3P89661a/vQLOF21RrX8vbn8zuamqYrMPR4h7quqcM=; b=j
	cRFx9NOgzAQ3r1NHl7QyZR89KgV/qw7aMCtJIVxMOG4Stu8PzabH9tZT2plAyeHU
	dJIEYmUuZEfPZ3IKWqZqkfzr8Ukw49bOcZSfBY6uhz5G2i1d7K6cG8gr6gp+L1DR
	+V40vSpNPVPAnwO61CpNspz4r+fV1fjDVTyiYnglf2/IZjTi+c6Opz7Gb1rH19Bt
	sWWL7fO3t20kbzH+oCsn1JVOzFiBBD5mmKVXk8Thipubst7Lfb9m3OMhOgGFXh8z
	HqQ+/FiLEBnA+O1+jZDxjkV7qURTTb+z8QfLPQma7Xy1xrpbJH3vGPhApWb6Y4+X
	8YBEVcfKJYXjmRK+4Mh0w==
X-ME-Sender: <xms:sTYjZuvIYnIXP3-D6qFAs_9stzAgUv3EhZMGnBmfMv9X3wAXYq8fvg>
    <xme:sTYjZjfKLL-nQaxP7FF6tZZAnWVPp8SVLl4H2bqBsaJUYG8qPy8VPPxk79acwuw1J
    Y-RRXLVXl6Xa5nSmcs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudekfedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtgfesthhqredtreerjeenucfhrhhomhepfdgk
    rggtkhcuhggvihhnsggvrhhgfdcuoeiirggtkhesohiflhhfohhlihhordhorhhgqeenuc
    ggtffrrghtthgvrhhnpeduueeigeehffekiefhtdehiedvueffteevtefhudfguedtueei
    tdetgfetieeiieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpeiirggtkhesohiflhhfohhlihhordhorhhg
X-ME-Proxy: <xmx:sTYjZpzb07dc_kR5d5Bnvug5fubYxBhXKwhOw5xIg93fjv1UKnWgVQ>
    <xmx:sTYjZpMVNp0OGyJGqCxsYj9L4owhG6p9fv9GpY5yOE50FD3RrVFcrA>
    <xmx:sTYjZu8FMSEAy8Huy-PfbH7sNv2DIAF7uschdYIt4DZ25vcwdyIAOQ>
    <xmx:sTYjZhXdbmhYyabrEzo1KzyHSm0Ts0FTRmgCJh1mTUirKCj0niT3Cw>
    <xmx:sTYjZhbBl1qeYBjSKaa-cqNKiCtUpmlX65cRYwKBRMalYhIvJhsMsQcr>
Feedback-ID: i876146a2:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 4B4CB272007C; Fri, 19 Apr 2024 23:29:53 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-379-gabd37849b7-fm-20240408.001-gabd37849
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <64eab296-05c3-4576-b4e2-526396e1524f@app.fastmail.com>
In-Reply-To: <878r196igy.fsf@oldenburg.str.redhat.com>
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
 <CAMe9rOoErR0xLqf4wLzk13XwTQY9-+cRAxDWKW9HU+rB0GApzQ@mail.gmail.com>
 <a995c5bd-8f80-2118-4d4-86e5e062a77@redhat.com>
 <CAMe9rOpz5Uft3MKXneYd3VqW1CaSXFF_GLBqKEZFiZsidKA43A@mail.gmail.com>
 <e35dccca-a1e7-93c4-f797-b89246877370@redhat.com>
 <9cefd07d-2940-4865-bd77-3dd0899a539f@cs.ucla.edu>
 <d387436c-8c35-4f51-bf49-dc02d829c73a@app.fastmail.com>
 <ae79e84e-5a69-dc3a-08da-ef03f6d17c34@ispras.ru>
 <a2369edc-7159-4f0d-8f89-9d41a79d7f7e@app.fastmail.com>
 <4f9517c-46e-367c-8891-e452d7983b67@redhat.com>
 <df151cf3-fb22-4465-81dc-34e0172a4fcb@app.fastmail.com>
 <c5ac58cf-3e2e-3cc4-5a18-32c9acdef82d@redhat.com>
 <878r196igy.fsf@oldenburg.str.redhat.com>
Date: Fri, 19 Apr 2024 23:29:32 -0400
From: "Zack Weinberg" <zack@owlfolio.org>
To: "Florian Weimer" <fweimer@redhat.com>,
 "Mikulas Patocka" <mpatocka@redhat.com>
Cc: "Alexander Monakov" <amonakov@ispras.ru>,
 "Paul Eggert" <eggert@cs.ucla.edu>, "H . J . Lu" <hjl.tools@gmail.com>,
 "GNU libc development" <libc-alpha@sourceware.org>,
 "Zdenek Kabelac" <zkabelac@redhat.com>, "Ondrej Kozina" <okozina@redhat.com>,
 "Milan Broz" <gmazyland@gmail.com>, dm-devel@lists.linux.dev
Subject: Re: memcpy is leaking secret data through ZMM vector registers
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Fri, Apr 19, 2024, at 7:27 PM, Florian Weimer wrote:
> * Mikulas Patocka:
>
>> On Fri, 19 Apr 2024, Zack Weinberg wrote:
>>
>>> On Fri, Apr 19, 2024, at 4:15 PM, Mikulas Patocka wrote:
>>> > On Fri, 19 Apr 2024, Zack Weinberg wrote:
>>> >> ... the copy
>>> >> of round_keys in the vector registers *won't* get erased -- the e=
xact
>>> >> problem being discussed in this thread.
>>> >
>>> > On the SYSV ABI, all the vector registers are volatile, so you can=
 erase=20
>>> > them in explicit_bzero.
>>> >
>>> > On Windows 64-bit ABI, it is more problematic, because some of the=
 vector=20
>>> > registers must be preserved.
>>>=20
>>> Oh, huh. Yes, that would work.
>>
>> I've just realized that this wouldn't work - if the function=20
>> explicit_bzero is lazily resolved, the dynamic linker would spill the=20
>> vector registers to the stack prior to calling explicit_bzero.
>
> No, the dynamic linker makes a tail call to explicit_bzero.  There's no
> register restore on the return path, all that happens before the tail
> call.

Doesn't help =E2=80=94 if the vector registers get spilled at all, we lo=
se.

zw
