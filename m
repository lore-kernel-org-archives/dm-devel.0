From: Cyril Chaboisseau <cyril.chaboisseau@free.fr>
Subject: Re: Fw: dm-mirror/kmirrord oops
Date: Thu, 30 Jun 2005 08:25:32 +0200
Message-ID: <20050630062532.GA11851@adren.mine.nu>
References: <20050627004827.12a389e0.akpm@osdl.org>
	<20050629223233.GD27078@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050629223233.GD27078@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Andrew Morton <akpm@osdl.org>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

 Le 29 juin vers 23:32, Alasdair G Kergon =E9crivait:
> On Mon, Jun 27, 2005 at 12:48:27AM -0700, Andrew Morton wrote:
> > Unable to handle kernel paging request at ffffc2000015c128 RIP:=20
> > <ffffffff802964a8>{core_in_sync+8}
>=20
> Do the following patches help?
>=20
>   ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/=
00011.patch
>   ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/=
00012.patch
>   ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/=
00013.patch
>=20
> [12 and 13 are already included in -mm; Jon Brassow is working on a cle=
aner fix]

unfortunately, I'm not able to test it anymore as the problem is
resolved (I just let pvmove finish it's work without doing any I/O on
the partitions)

sorry

--=20
	Cyril Chaboisseau
