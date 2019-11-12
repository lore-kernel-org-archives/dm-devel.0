From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/2] dm-snapshot: fix crash with the realtime kernel
Date: Tue, 12 Nov 2019 02:50:42 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1911120240020.25757@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1911110811060.28408@file01.intranet.prod.int.rdu2.redhat.com> <c9a772e9-e305-cf0b-1155-fb19bdb84e55@arrikto.com> <20191112011444.GA32220@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191112011444.GA32220@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Nikos Tsironis <ntsironis@arrikto.com>, Scott Wood <swood@redhat.com>, Ilias Tsitsimpis <iliastsi@arrikto.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids



On Mon, 11 Nov 2019, Mike Snitzer wrote:

> On Mon, Nov 11 2019 at 11:37am -0500,
> Nikos Tsironis <ntsironis@arrikto.com> wrote:
>=20
> > On 11/11/19 3:59 PM, Mikulas Patocka wrote:
> > > Snapshot doesn't work with realtime kernels since the commit f79ae415=
b64c.
> > > hlist_bl is implemented as a raw spinlock and the code takes two non-=
raw
> > > spinlocks while holding hlist_bl (non-raw spinlocks are blocking mute=
xes
> > > in the realtime kernel, so they couldn't be taken inside a raw spinlo=
ck).
> > >=20
> > > This patch fixes the problem by using non-raw spinlock
> > > exception_table_lock instead of the hlist_bl lock.
> > >=20
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > Fixes: f79ae415b64c ("dm snapshot: Make exception tables scalable")
> > >=20
> >=20
> > Hi Mikulas,
> >=20
> > I wasn't aware that hlist_bl is implemented as a raw spinlock in the
> > real time kernel. I would expect it to be a standard non-raw spinlock,
> > so everything works as expected. But, after digging further in the real
> > time tree, I found commit ad7675b15fd87f1 ("list_bl: Make list head
> > locking RT safe") which suggests that such a conversion would break
> > other parts of the kernel.
>=20
> Right, the proper fix is to update list_bl to work on realtime (which I
> assume the referenced commit does).  I do not want to take this
> dm-snapshot specific workaround that open-codes what should be done
> within hlist_{bl_lock,unlock}, etc.

If we change list_bl to use non-raw spinlock, it fails in dentry lookup=20
code. The dentry code takes a seqlock (which is implemented as preempt=20
disable in the realtime kernel) and then takes a list_bl lock.

This is wrong from the real-time perspective (the chain in the hash could=
=20
be arbitrarily long, so using non-raw spinlock could cause unbounded=20
wait), however we can't do anything with it.

I think that fixing dm-snapshot is way easier than fixing the dentry code.=
=20
If you have an idea how to fix the dentry code, tell us.

> I'm not yet sure which realtime mailing list and/or maintainers should
> be cc'd to further the inclussion of commit ad7675b15fd87f1 -- Nikos do
> you?
>=20
> Thanks,
> Mike

Mikulas
