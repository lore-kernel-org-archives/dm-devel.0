From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device-mapper patches for 2.6.29
Date: Mon, 5 Jan 2009 18:51:00 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901051843570.3057@localhost.localdomain>
References: <20081010125159.GK5098@agk.fab.redhat.com>
	<20090105191824.GP5098@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090105191824.GP5098@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Cheng Renquan <crquan@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Mon, 5 Jan 2009, Alasdair G Kergon wrote:
>
> Please pull from:
>=20
>   master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git
>=20
> to get the following device-mapper patches for 2.6.29:

Oh no, this is totally broken, and doesn't compile even with my fairly=20
minimal install:

  drivers/md/dm-target.c: In function =A1dm_unregister_target=A2:
  drivers/md/dm-target.c:106: error: implicit declaration of function =A1=
module_refcount=A2

Not pulled.

		Linus
