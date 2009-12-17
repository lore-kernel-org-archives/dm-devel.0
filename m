From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Thu, 17 Dec 2009 07:14:37 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0912170713390.17868@localhost.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<200912152326.34728.bzolnier@gmail.com>
	<2375c9f90912170131g3144ca2eydfa067c85f6ced44@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2375c9f90912170131g3144ca2eydfa067c85f6ced44@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
List-Id: dm-devel.ids



On Thu, 17 Dec 2009, Am=C3=A9rico Wang wrote:
>=20
> I like this patch, this is actually what I wanted to do.

I have nothing against a switch, but it had better default to off.

The whole 80-char limit is insane. It results in insane "fixes". Just=20
about every time somebody "improves" a patch due to the warning, the=20
result is worse than the original patch.

		Linus
