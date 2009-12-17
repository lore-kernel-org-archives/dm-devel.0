From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Thu, 17 Dec 2009 16:18:32 +0100
Message-ID: <200912171618.32882.bzolnier@gmail.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<2375c9f90912170131g3144ca2eydfa067c85f6ced44@mail.gmail.com>
	<alpine.LFD.2.00.0912170713390.17868@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0912170713390.17868@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?utf-8?q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thursday 17 December 2009 04:14:37 pm Linus Torvalds wrote:
>=20
> On Thu, 17 Dec 2009, Am=C3=A9rico Wang wrote:
> >=20
> > I like this patch, this is actually what I wanted to do.
>=20
> I have nothing against a switch, but it had better default to off.
>=20
> The whole 80-char limit is insane. It results in insane "fixes". Just=20
> about every time somebody "improves" a patch due to the warning, the=20
> result is worse than the original patch.

Examples? :)

--
Bartlomiej Zolnierkiewicz
