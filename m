Received: from fout2-smtp.messagingengine.com (fout2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32997494
	for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 18:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713552485; cv=none; b=hcCGz8tmNhCiBGm603lkQFZzKfhOK3STt/9TPAJ88pS1+rl4p+qiJ1g4zx07he06wdq3Y3p6E6/IgEPRu0Aa2qYhL6ygjMa729RCXbWOqwkIc6AV62V5snNtOcCWchlRgdyqzbvHouuDr4G72iaFRM4QrHQUJufRJck4pFGitPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713552485; c=relaxed/simple;
	bh=Xa6c56KK90Oa97wuQjMQPqqfqI66mgHxnchxnRxiSiM=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=TuXOwDmgnPRtDYGQiW76NEqFfsNCspKc3zAeD8nul13NzAlfTdzCxPdaJFdIgIOUjg0RFubk8TMeEHZH04tz9cygoqqM+J31cYRL313nnaeoZtTuWiX6CZYohtaxqdcHdC0T8J4+83Y56oRdOeRANYzWYgvcp8HXsnabvsHTvtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=owlfolio.org; spf=pass smtp.mailfrom=owlfolio.org; dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b=QK1KdtD+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KWcf4Y5l; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b="QK1KdtD+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KWcf4Y5l"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfout.nyi.internal (Postfix) with ESMTP id 9C9691380254;
	Fri, 19 Apr 2024 14:48:01 -0400 (EDT)
Received: from imap45 ([10.202.2.95])
  by compute5.internal (MEProxy); Fri, 19 Apr 2024 14:48:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=owlfolio.org; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1713552481; x=1713638881; bh=SUfhRo47ZC
	EfcPXp8xCNzrsSROlKQBKSEI8r8PaE3g8=; b=QK1KdtD+Iko1q7KSFvg+6E1ufn
	UHIMpuSbjEZctidVVuzdPyI0bI8PxwmOsMqSkKrEGL/DQMRRBhfiP6wYQZo5iF/H
	WTwB5XVve306buZe07bdf8AaaQ9V72smz5HSqQ07I8YzOlI7I5fGylgU7Ecrp3zH
	QRXDyoDK5vnShwKWJb6U/ardsvPXrM6e0wgbzLFa5TVivwLPXc6QVk1wd0cGmkXs
	Vct+lYyxEqdKsLe3VBovjSih9qeeDOwfbZKwH8G5CJlND89XYCrw/Mcsc7VKtVfQ
	PRCyi7BRIEaoMraOFhXiDnOaI+efYNG8TX/cutNVZ8D5BtKDSIBZQTy3mE3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1713552481; x=1713638881; bh=SUfhRo47ZCEfcPXp8xCNzrsSROlK
	QBKSEI8r8PaE3g8=; b=KWcf4Y5lAz+R/Ve4rTp9LSz1Hu1EJ8y7nLFBfZRKORK+
	Y74KYVtbmchcjyVxeCDx/dSoOEExxKQJAVcvRvaiakdDSMsClsjXY6g8t1DlTVVK
	x51F06uZSh8djC/eni9BQa/9nkhkVpZumxG6kKi3iNkvCQ46MH/nKqP/iK1TsteS
	0S880DGq+Hh3448JJUMDNze+/d82aygG2VDJIKbyxg1YuFAuTLZm2OtkBSr15YTZ
	VoN8AMVvotPROLxBV1BX3eGvvmB+i0wU4EE6wXdXzv5+8VtI81TvZ7S2/PH7pC89
	smcvkQdvpWCFGvV3r/1xDB1hHEZLksr8XzsUFWzcIQ==
X-ME-Sender: <xms:YbwiZj9fCR5TADeofZjh-UsTw2ybfaAr8eWhJjrWsM1YDKq7sLBugA>
    <xme:YbwiZvtDmu37RuK1OXltDBTkL-J3yKaqwgKZqqFJyDO1F6G4qPkrtOo9SEItASM7q
    D-TSGF1OeD5PaEtAGU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudekvddgudefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdgk
    rggtkhcuhggvihhnsggvrhhgfdcuoeiirggtkhesohiflhhfohhlihhordhorhhgqeenuc
    ggtffrrghtthgvrhhnpefhleefheduhfelgeehgeejveehueeihedvgfeuueetteelieei
    teehfefhleduieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpeiirggtkhesohiflhhfohhlihhordhorhhg
X-ME-Proxy: <xmx:YbwiZhDMhhARvF9v7UWW7himkvBSuBgpiP89on9cgj3l9_-FQGOjJg>
    <xmx:YbwiZveuXmhpL7Z9GKH2jjTlzR3X2oUHpmOveWpe4ojqiOZrf3ibMg>
    <xmx:YbwiZoMtejvDBaFqRx1LVSAqbh_z1MLWTdUwUUyhDcOPs5CFV-nlrw>
    <xmx:YbwiZhmvkycelV01TCtTS8TPgRXu4cnvowcr2BBPAhTMuHc6O223Jw>
    <xmx:YbwiZvfC2GibuYXu0uuMua3VNnPyQE-DL_uVqqo9gCXuJ0HQaNLM6Ouf>
Feedback-ID: i876146a2:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 3A025272007D; Fri, 19 Apr 2024 14:48:01 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-379-gabd37849b7-fm-20240408.001-gabd37849
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <d387436c-8c35-4f51-bf49-dc02d829c73a@app.fastmail.com>
In-Reply-To: <9cefd07d-2940-4865-bd77-3dd0899a539f@cs.ucla.edu>
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
 <CAMe9rOoErR0xLqf4wLzk13XwTQY9-+cRAxDWKW9HU+rB0GApzQ@mail.gmail.com>
 <a995c5bd-8f80-2118-4d4-86e5e062a77@redhat.com>
 <CAMe9rOpz5Uft3MKXneYd3VqW1CaSXFF_GLBqKEZFiZsidKA43A@mail.gmail.com>
 <e35dccca-a1e7-93c4-f797-b89246877370@redhat.com>
 <9cefd07d-2940-4865-bd77-3dd0899a539f@cs.ucla.edu>
Date: Fri, 19 Apr 2024 14:47:40 -0400
From: "Zack Weinberg" <zack@owlfolio.org>
To: "Paul Eggert" <eggert@cs.ucla.edu>,
 "Mikulas Patocka" <mpatocka@redhat.com>, "H . J . Lu" <hjl.tools@gmail.com>
Cc: "GNU libc development" <libc-alpha@sourceware.org>,
 "Zdenek Kabelac" <zkabelac@redhat.com>, "Ondrej Kozina" <okozina@redhat.com>,
 "Milan Broz" <gmazyland@gmail.com>, dm-devel@lists.linux.dev
Subject: Re: memcpy is leaking secret data through ZMM vector registers
Content-Type: text/plain

On Fri, Apr 19, 2024, at 2:45 PM, Paul Eggert wrote:
> On 4/19/24 11:04, Mikulas Patocka wrote:
>> There's already "explicit_bzero", so maybe we could add
>> "explicit_memcpy"
>
> Where would this stop? Wouldn't we also need explicit_memcmp, 
> explicit_memmove, explicit_mempcpy, etc.? Pretty much any function that 
> looks at memory could have the problem. Even C source code that doesn't 
> invoke any C library function could have the problem.

As I recall, one of the arguments for _not_ adding explicit_bzero to glibc
was that we couldn't guarantee copies of the secret data wouldn't hang
around in registers.

Is a hypothetical function __attribute__((clear_call_clobbered_regs_on_exit))
what we need here instead, maybe?

zw
