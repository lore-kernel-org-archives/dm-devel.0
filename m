Received: from mail.cs.ucla.edu (mail.cs.ucla.edu [131.179.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C4F22071
	for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 18:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=131.179.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713552817; cv=none; b=JBVQ9nN13tvmF8hyqK0pzJoGmAnnl/jnfV1SD38dR0XV9XzEdTjX1orMQ08G/ZmMJWmXREjSxqLWN+kluY9/eVzQF6+52YqLNS8Muhu168Z857+xME7LBCVZBJH0YXVqbmJYwD/UGXmLuTmcu9DKTI6imfqGa88/ZmOcveU3kNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713552817; c=relaxed/simple;
	bh=3K8AXI749vtf1mwQkSDwDq9kQY/LG/G3gOsW4LnJTBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yph+D1upPyf/ZWt7DQwSZsiPKf+YAkJs67IY9bVsZnTXh0PuHPOgK+4LfOlXUh7JOtTDqfE8HDJS+YcNoTAamJUBjeX5PTgfbhLR/cyN8oO8WaL3KCG/VhSNdc4qyPlesxQlNKPa4VSWvM85jiFidaymfgB0xFGWCxGjeNBibmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.ucla.edu; spf=pass smtp.mailfrom=cs.ucla.edu; dkim=pass (2048-bit key) header.d=cs.ucla.edu header.i=@cs.ucla.edu header.b=ZctGS+P/; arc=none smtp.client-ip=131.179.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.ucla.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.ucla.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.ucla.edu header.i=@cs.ucla.edu header.b="ZctGS+P/"
Received: from localhost (localhost [127.0.0.1])
	by mail.cs.ucla.edu (Postfix) with ESMTP id 928EA3C0140A0;
	Fri, 19 Apr 2024 11:45:07 -0700 (PDT)
Received: from mail.cs.ucla.edu ([127.0.0.1])
 by localhost (mail.cs.ucla.edu [127.0.0.1]) (amavis, port 10032) with ESMTP
 id 1YvYHLuaDEvH; Fri, 19 Apr 2024 11:45:07 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.cs.ucla.edu (Postfix) with ESMTP id 400613C0140A4;
	Fri, 19 Apr 2024 11:45:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.cs.ucla.edu 400613C0140A4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.ucla.edu;
	s=9D0B346E-2AEB-11ED-9476-E14B719DCE6C; t=1713552307;
	bh=DmS2Dht9EfdvU+y+mJW+nZY/Qysvxp5iTTgud8gQY5A=;
	h=Message-ID:Date:MIME-Version:To:From;
	b=ZctGS+P/+OlQzT05xM9zQetqyGz35YRrSJMtOGocA38zj/+2YW1XhJEh6MpQIzEKG
	 mxYzbUVn2d0yrwkwGKlgIeZXmhVIomLi9cf8otj41xbIIofGa2COgvZrxqBkqn3j8y
	 u0buC4oyQ743jLO4x8wsaZQC8r5dl4tDBrfwga34OJmk38wS9RaRd9ExYxte4Uo0kc
	 is/DyUDX1kWfPdOpVO9uZn2dBkLjir6b/ulvspb+zwGx9gxb2VkVeZYN+m4dJ2U328
	 5zTetlUpNN1uyMI/dmCZ9NFq8WZZoSNFUkFx80hyXgQMHuJYbIlh78hyepu1BPczyA
	 T5q4dsch1Wbxg==
X-Virus-Scanned: amavis at mail.cs.ucla.edu
Received: from mail.cs.ucla.edu ([127.0.0.1])
 by localhost (mail.cs.ucla.edu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id hPZ0eeWOOLhY; Fri, 19 Apr 2024 11:45:07 -0700 (PDT)
Received: from [131.179.64.200] (Penguin.CS.UCLA.EDU [131.179.64.200])
	by mail.cs.ucla.edu (Postfix) with ESMTPSA id 1281A3C0140A0;
	Fri, 19 Apr 2024 11:45:07 -0700 (PDT)
Message-ID: <9cefd07d-2940-4865-bd77-3dd0899a539f@cs.ucla.edu>
Date: Fri, 19 Apr 2024 11:45:05 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: memcpy is leaking secret data through ZMM vector registers
To: Mikulas Patocka <mpatocka@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>
Cc: libc-alpha@sourceware.org, Zdenek Kabelac <zkabelac@redhat.com>,
 Ondrej Kozina <okozina@redhat.com>, Milan Broz <gmazyland@gmail.com>,
 dm-devel@lists.linux.dev
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
 <CAMe9rOoErR0xLqf4wLzk13XwTQY9-+cRAxDWKW9HU+rB0GApzQ@mail.gmail.com>
 <a995c5bd-8f80-2118-4d4-86e5e062a77@redhat.com>
 <CAMe9rOpz5Uft3MKXneYd3VqW1CaSXFF_GLBqKEZFiZsidKA43A@mail.gmail.com>
 <e35dccca-a1e7-93c4-f797-b89246877370@redhat.com>
Content-Language: en-US
From: Paul Eggert <eggert@cs.ucla.edu>
Organization: UCLA Computer Science Department
In-Reply-To: <e35dccca-a1e7-93c4-f797-b89246877370@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/19/24 11:04, Mikulas Patocka wrote:
> There's already "explicit_bzero", so maybe we could add
> "explicit_memcpy"

Where would this stop? Wouldn't we also need explicit_memcmp, 
explicit_memmove, explicit_mempcpy, etc.? Pretty much any function that 
looks at memory could have the problem. Even C source code that doesn't 
invoke any C library function could have the problem.

On the library side, shouldn't this sort of thing be handled by 
_FORTIFY_SOURCE or something similar? And don't we need a compiler 
option saying "don't cache anything in registers"?
