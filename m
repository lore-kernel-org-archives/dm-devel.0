Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AFE5DF3D
	for <dm-devel@lists.linux.dev>; Wed, 29 Nov 2023 19:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id 23B7884;
	Wed, 29 Nov 2023 11:51:40 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id JELnIWNnQHK4; Wed, 29 Nov 2023 11:51:39 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id 3300240;
	Wed, 29 Nov 2023 11:51:39 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 3300240
Date: Wed, 29 Nov 2023 11:51:39 -0800 (PST)
From: Eric Wheeler <dm-devel@lists.ewheeler.net>
To: Joe Thornber <thornber@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: Re: Stuck IOs with dm-integrity + md raid1 + dm-thin
In-Reply-To: <CAJ0trDbP4BFjb0KQ+t4Lh1JdVjP9sbMiwJEOXPkGEV_R95rFoQ@mail.gmail.com>
Message-ID: <12d141ed-84d2-411f-3e61-7a8d5bc7f0dc@ewheeler.net>
References: <fb4ae62-522-e262-df25-c82e8acf8baf@ewheeler.net> <CAJ0trDaipa_80xqVpDkJdm-SSCaN7g_O-m9-StG10P_DUxmtEA@mail.gmail.com> <CAJ0trDbP4BFjb0KQ+t4Lh1JdVjP9sbMiwJEOXPkGEV_R95rFoQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-527284786-1701287114=:29635"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-527284786-1701287114=:29635
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 29 Nov 2023, Joe Thornber wrote:
> On Wed, Nov 29, 2023 at 8:24 AM Joe Thornber <thornber@redhat.com> wrote:
>       Hi Eric,
>
> Since integrity is below thin I would say this is likely a real issue 
> with your hardware; probably causing thinp to head down the rarely used 
> error path.

While I suppose this is possible, the problem presented itself on two 
completely different NVMe mirror pairs, two NVMes of which are brand new. 
The system survived a 24 hour memory test and we have not seen any machine 
check exceptions or ECC errors, so is far as I can tell the hardware is 
working as expected.

> It looks like something is holding the rw_semaphore that protects 
> accesses to the thin_metadata. This could either be a process that is 
> blocked holding it (in which case you should be able to see it).  Or a 
> rarely used error path has omitted to release it.

Is any kernel tooling around finding what is holding the lock, or some 
kind of tracing mechanism that I could trigger while rw_semaphore is 
locked?

--
Eric Wheeler



> 
> 
> Looking at the code I think it's really unlikely that we've accidentally left it unlocked.  So could you check
> all processes to see if any are holding it please, and check
> the kernel logs to see if any processes were killed for some reason.
> 
> - Joe
> 
> 
> 
--8323328-527284786-1701287114=:29635--
