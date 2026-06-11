Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE2A33A71B
	for <dm-devel@lists.linux.dev>; Thu, 11 Jun 2026 05:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781156034; cv=none; b=YasRdQOUyPsY3BsQ3Dbpze1UU6aIITptrf7vqD54vacASJPgUZnRLHsrHIM+X0IBJgQiZ/nflEhHRDHSdoYTWtLNGn5fDffl/VpsAi29MqCcyNhFSS2j7RRoYJBG3M6GLM7WAwpVDH9kYn6jilD1UQgq4l/VojtzP1S4E5/3C1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781156034; c=relaxed/simple;
	bh=F5U58Q+TlC8jAdccS7G+VZQOPyL9LzR95X7Vhw0XclU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EpzMqStpuXdMOMrETWKq/1CPMHr/1tAntS2DbvDEV2kNbBaQC8YZBALgkdCDDh48kiutYupisMhPd0D9rzVeMsR8nP5AN9q+WGmAynNx/ympy/N4/oLgJrIi7upXL0rGOE5RwIJtSA6L8nwFISfwnOk28c0bzUh062zzZ9siKfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=ADr/ILkl; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="ADr/ILkl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1781156015; x=1781760815; i=markus.elfring@web.de;
	bh=F5U58Q+TlC8jAdccS7G+VZQOPyL9LzR95X7Vhw0XclU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ADr/ILklFSXNR0qoSR2q+MoHHoKZFxmwYpSVm5HXgXlj8MDXlTuL8EMUwBsQa2w+
	 0JNoQjC3EZge7scU+JzmMbQrqvv7D0dAuNEMdY5HZ/Kh5wj5f96BqShRiD89PrX6/
	 Dh89spsxXnpaiHaXmuoKA0fRfeY4RTvXQEQcRWC4Lj5bviTWeHOnSvK5xAdSkkoy3
	 CNi3M4phMLz5ZvXdx3LwK9/R0uFqOhYyecYbZAF1QIPfJJMgE+jZzCqkHIpD/Adat
	 4IKBtErddDMKMf+tbWZM24d0CwSqKh41VHl3n0SeHoKe/1yvK8ucTQ4K00UYS6DAN
	 4T7CXEsuqeTMLr7L1w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mmhjm-1wyfqi3VkU-00ZGYD; Thu, 11
 Jun 2026 07:33:34 +0200
Message-ID: <3b8e5056-0611-43eb-9fc3-c82f0511d466@web.de>
Date: Thu, 11 Jun 2026 07:33:25 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: dm: Use common error handling code in three functions
To: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
Cc: Alasdair Kergon <agk@redhat.com>, Benjamin Marzinski
 <bmarzins@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <be375668-6d07-4070-9b08-d6445afa324f@web.de>
 <d802f7e7-9ed7-e7f9-89c5-19cdc9806367@redhat.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <d802f7e7-9ed7-e7f9-89c5-19cdc9806367@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:j5FK80TwxozBZYOg+KtPI33s1NuB0oltfPwknO2k1ku/FUkjf93
 1QJig1kMkjq3FN3Q5QnaYJHMKPW8aOMioEk2wi9eYwY+s08TbND2yLgmInDaBiWdmHced4+
 rTwQV81gE8GWls+/UrDrSx7FE0A7eODyrZx3SEeAb0/3VI7UAe74gjzpD016UiFS5YQBRsU
 cdBbFGmpbL7U9qmmPpRWg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:HzjRugHBduI=;y2ZPWX9F0As5KcjY5EIqoiRZjnH
 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

>> Use additional labels so that a bit of exception handling can be better
>> reused at the end of three if branches.
>>
>> This issue was detected by using the Coccinelle software.
>=20
> Hi
>=20
> I think that jumping into a nested block isn't good practice and it make=
s=20
> the code harder to read and maintain. I would redo the patches so that=
=20
> they jump to the end of the topmost function block, for example:
Thanks for your constructive feedback.

Can any further adjustments become feasible for the design goal =E2=80=9CC=
entralized exiting of functions=E2=80=9D?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv7.1-rc7#n526

Would you find goto chains applicable for another while?
https://cmu-sei.github.io/secure-coding-standards/sei-cert-c-coding-standa=
rd/recommendations/memory-management-mem/mem12-c/

How do you think about to increase the application of scope-based resource=
 management?
https://elixir.bootlin.com/linux/v7.1-rc7/source/include/linux/cleanup.h

Regards,
Markus
