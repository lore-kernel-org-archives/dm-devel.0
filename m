Received: from fout3-smtp.messagingengine.com (fout3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F1B946C
	for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 20:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713558721; cv=none; b=hXmpjkf5go8MkJQZt6Zw7CiRTldkVlkYknARXqQSTbkF1Cmzfl+OlDpzhFiXwvoCMkp/lPAhkRW2jKq60fOknUQbDk0ILQ2EiWGpWezbqRKW03HGlxueUfVeuQLG+R8w7p6r1zYjtdMQQxgvdKHdDRrHPN7HsraWgILyQj9iamY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713558721; c=relaxed/simple;
	bh=ifV9yy5qU3ymJdp/dq64Zan6osQvv4r6CajpJuvFamQ=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=ZAXKFD0LM/vKnRBoh6JBVL7npRu5Hi8u2+D/EyJbUrZBfi4ktvADy3RQq/vbwLrsmRsk5NUx/Qnm7KN1KmiPyIPuSJsb0JtQV2RZgFjhR5lqQQWohjloJxnZYnvvokOeX60mNL+qmQLKya3WY7eZ5556cs0bSTAuDj/WPejS0+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=owlfolio.org; spf=pass smtp.mailfrom=owlfolio.org; dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b=KXGtFyYv; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LrDLGfHJ; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b="KXGtFyYv";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LrDLGfHJ"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfout.nyi.internal (Postfix) with ESMTP id 2AE0F13800C6;
	Fri, 19 Apr 2024 16:31:58 -0400 (EDT)
Received: from imap45 ([10.202.2.95])
  by compute5.internal (MEProxy); Fri, 19 Apr 2024 16:31:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=owlfolio.org; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1713558718; x=1713645118; bh=7pX3xh/wJS
	R4VjrpBA+dyTy/mw8XrQTy3HTNpeAJftE=; b=KXGtFyYvGbguBpfUVyu4YtJomf
	9wr/2BVpeopYwdzkvk3guhjlWMupiaTV8dwPqLBDXLkWIjHF2PGk98ZveOD15ZqU
	HYFK9Gb6MiolAXSHysU54opsuSdGtiFAgDSth0kpurKApf9IHbRTfVH4UheYfRd6
	Gt8wmvoeQ+y0pGaGd8j6qA+6lHyU8hZo8m4VTHAGXuQ4LOKsZEG/2cRKUYSFldcq
	sMBq2Z+fheHJUmoi7NLWil2UTehyLqtpSImHbfzZAFbRGwnBkMQSnepwztfBH4zs
	/XH4hP7PzDri1yem0r1svMdFG89id8ake8E6K8/6gX3z1DgkYQbpr+N8P8zQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1713558718; x=1713645118; bh=7pX3xh/wJSR4VjrpBA+dyTy/mw8X
	rQTy3HTNpeAJftE=; b=LrDLGfHJMyuWDeNG36XCsBeEm540motJa/po47xlV5hi
	b0dVRb4H2By8WzT5xUpnEqCMc/9aXx8MTtpU3eD93w6pucIJYL+pDE5x5qBUzRWo
	ihLmdZAZJ5JpMjtNuzveydqE97d6CoDlSCluSvvlzMd4F8FfPFOwVawjq7pJtafR
	Wm4OETR44nI4P0W9ORkbRagYFSkn1KhpeCulZUbX6hMgc10Q4GD4Vmslb2cJObSA
	k9Ec9bqSEF/IWMldeQzirMfprpC0OhEr+ub90fzk4SMhjr1Wk1s+VR93vOHIWaya
	yZSl9Ok35/KhXDC7FTvSZFVcEHsn/mpKeaNCg7otTQ==
X-ME-Sender: <xms:vdQiZhIbkm0Hj7uNPlbR3tFR2kaGrIY-_sDnnGW6pebSM7eMvg8Iaw>
    <xme:vdQiZtLOFcRBXPCpEFZHamF2i72R_nS5InsK9oBBSWMpdGK81OVI2z6HTD7hcFJzh
    Jej6O_bQiZmjyCSR0M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudekvddgudehfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdgk
    rggtkhcuhggvihhnsggvrhhgfdcuoeiirggtkhesohiflhhfohhlihhordhorhhgqeenuc
    ggtffrrghtthgvrhhnpefhleefheduhfelgeehgeejveehueeihedvgfeuueetteelieei
    teehfefhleduieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpeiirggtkhesohiflhhfohhlihhordhorhhg
X-ME-Proxy: <xmx:vdQiZpsTEtKnG6jhzvL1Ezt1eJzDWtKDBZ2cq38NGTt51bRzmxr4FA>
    <xmx:vdQiZiYHF3EWUjFPJKY_sRHZOOzkTZrvOBpM515tElrwO1nexRCGhQ>
    <xmx:vdQiZobzhZ5L0Op_mhRK04NCuMwvdKioqA1ivn25uZLLwD_fmMov5Q>
    <xmx:vdQiZmCwQQx7fFFwuuhf7gG0l9uNxaWecC8A6XfcLXHHFvwjxEnffg>
    <xmx:vtQiZuMYqbRxJEwzHOpKAKPmFvjqyMxPA8bOq3MnyxfV-BKBBnvRVcPJ>
Feedback-ID: i876146a2:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 5DDA1272007E; Fri, 19 Apr 2024 16:31:57 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-379-gabd37849b7-fm-20240408.001-gabd37849
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <df151cf3-fb22-4465-81dc-34e0172a4fcb@app.fastmail.com>
In-Reply-To: <4f9517c-46e-367c-8891-e452d7983b67@redhat.com>
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
Date: Fri, 19 Apr 2024 16:31:40 -0400
From: "Zack Weinberg" <zack@owlfolio.org>
To: "Mikulas Patocka" <mpatocka@redhat.com>
Cc: "Alexander Monakov" <amonakov@ispras.ru>,
 "Paul Eggert" <eggert@cs.ucla.edu>, "H . J . Lu" <hjl.tools@gmail.com>,
 "GNU libc development" <libc-alpha@sourceware.org>,
 "Zdenek Kabelac" <zkabelac@redhat.com>, "Ondrej Kozina" <okozina@redhat.com>,
 "Milan Broz" <gmazyland@gmail.com>, dm-devel@lists.linux.dev
Subject: Re: memcpy is leaking secret data through ZMM vector registers
Content-Type: text/plain

On Fri, Apr 19, 2024, at 4:15 PM, Mikulas Patocka wrote:
> On Fri, 19 Apr 2024, Zack Weinberg wrote:
>> ... the copy
>> of round_keys in the vector registers *won't* get erased -- the exact
>> problem being discussed in this thread.
>
> On the SYSV ABI, all the vector registers are volatile, so you can erase 
> them in explicit_bzero.
>
> On Windows 64-bit ABI, it is more problematic, because some of the vector 
> registers must be preserved.

Oh, huh. Yes, that would work. Call-preserved registers are not a problem, because any function that puts secret data in a call-preserved register in the first place, must erase it again (by restoring the old value) before returning. Therefore, if we made explicit_bzero wipe *all* the call-clobbered registers before returning, my example function would be safe.

There's still a place secrets could leak to and not get erased, though: register spill slots on the stack. Only the compiler could plug this leak. Long term, I think what we want is something like __attribute__((sensitive)), which can only be applied to variables with automatic storage duration, and which means "erase all copies of this variable's value, wherever they wound up, at the end of its lifetime." Note that such variables must not be put in call-preserved registers in non-leaf functions, because then they might get spilled to the stack by a callee, which has no way of knowing that it's just leaked a secret. And I suppose we might also want to worry about signal frames. Nobody said this was gonna be easy ;-)

zw
