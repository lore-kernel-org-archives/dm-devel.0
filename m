Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594E75FF0A
	for <dm-devel@lists.linux.dev>; Thu, 30 Nov 2023 21:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id 1ED8A49;
	Thu, 30 Nov 2023 13:08:29 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Bu9fz-C51j9X; Thu, 30 Nov 2023 13:08:24 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id AB73B40;
	Thu, 30 Nov 2023 13:08:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net AB73B40
Date: Thu, 30 Nov 2023 13:08:24 -0800 (PST)
From: Eric Wheeler <dm-devel@lists.ewheeler.net>
To: Joe Thornber <thornber@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: Re: Stuck IOs with dm-integrity + md raid1 + dm-thin
In-Reply-To: <cb3f4665-fcfc-c08-2dce-99c071c2a569@ewheeler.net>
Message-ID: <bb6deb36-dd80-1649-11b6-bdcf24cb4e4@ewheeler.net>
References: <fb4ae62-522-e262-df25-c82e8acf8baf@ewheeler.net> <CAJ0trDaipa_80xqVpDkJdm-SSCaN7g_O-m9-StG10P_DUxmtEA@mail.gmail.com> <CAJ0trDbP4BFjb0KQ+t4Lh1JdVjP9sbMiwJEOXPkGEV_R95rFoQ@mail.gmail.com> <12d141ed-84d2-411f-3e61-7a8d5bc7f0dc@ewheeler.net>
 <CAJ0trDaRQaDicO9ho8Hokj68vEopaJwM8YKwPEjzYkWBXE0dWg@mail.gmail.com> <cb3f4665-fcfc-c08-2dce-99c071c2a569@ewheeler.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1778824679-1701378504=:29635"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1778824679-1701378504=:29635
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 30 Nov 2023, Eric Wheeler wrote:
> On Thu, 30 Nov 2023, Joe Thornber wrote:
> > On Wed, Nov 29, 2023 at 7:51 PM Eric Wheeler <dm-devel@lists.ewheeler.net> wrote:
> >       On Wed, 29 Nov 2023, Joe Thornber wrote:
> >       > On Wed, Nov 29, 2023 at 8:24 AM Joe Thornber <thornber@redhat.com> wrote:
> >       >       Hi Eric,
> >       >
> >       > Since integrity is below thin I would say this is likely a real issue
> >       > with your hardware; probably causing thinp to head down the rarely used
> >       > error path.
> > 
> >       While I suppose this is possible, the problem presented itself on two
> >       completely different NVMe mirror pairs, two NVMes of which are brand new.
> >       The system survived a 24 hour memory test and we have not seen any machine
> >       check exceptions or ECC errors, so is far as I can tell the hardware is
> >       working as expected.
> > 
> > 
> > Have you performed any long running tests with just dm-integrity and not dm-thin?
> 
> It ran fine for about 12 hours and then IOs hung shortly after we did a 
> reserve_metadata_snap.

More info:

Not only did it run for 12 hours just fine before IOs hung at 3:30am when 
we do metadata dumps, but this happened twice, on consecutive days at the 
same time of day (~3:30am), when cron does a reserve_metadata_snap for
metadata thin_dumps of inactive snapshots.

In each case we reformated dm-integrity the afternoon before, and ran an 
`integritysetup --integrity-recalculate-reset` to make sure it was clean. 
The first day we tried was on an older set of NVMe disks, but the second 
day we tried with brand new NVMe's that had never been used.

--
Eric Wheeler
--8323328-1778824679-1701378504=:29635--
