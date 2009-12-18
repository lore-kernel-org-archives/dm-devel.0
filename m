From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Fri, 18 Dec 2009 13:31:50 +0000
Message-ID: <4B2B8446.4060401@draigBrady.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <200912171618.32882.bzolnier@gmail.com> <alpine.LFD.2.00.0912170726230.17868@localhost.localdomain> <200912171708.07899.bzolnier@gmail.com> <alpine.LFD.2.00.0912170816210.15740@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752354AbZLRNeK@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0912170816210.15740@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?ISO-8859-1?Q?Am=E9r?= =?ISO-8859-1?Q?ico_Wang?= <xiyou.wangcong@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 17/12/09 16:21, Linus Torvalds wrote:
> I'd be ok with changing the warning to 132 characters, which is anoth=
er
> perfectly fine historical limit. Or we can split the difference, and =
say
> "ok, 106 characters is too much". I don't care. But 80 characters is
> causing too many idiotic changes.

I find smaller limits help when you want to do side-by-side diffs,
or `git blame` for example, but I agree there needs to be taste applied=
,
so as to not mangle the code.

cheers,
P=E1draig.
