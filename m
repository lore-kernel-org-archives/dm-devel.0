From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] dm-snapshot: fix crash with the realtime
	kernel
Date: Mon, 11 Nov 2019 20:14:44 -0500
Message-ID: <20191112011444.GA32220@redhat.com>
References: <alpine.LRH.2.02.1911110811060.28408@file01.intranet.prod.int.rdu2.redhat.com>
	<c9a772e9-e305-cf0b-1155-fb19bdb84e55@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c9a772e9-e305-cf0b-1155-fb19bdb84e55@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Scott Wood <swood@redhat.com>, Ilias Tsitsimpis <iliastsi@arrikto.com>
List-Id: dm-devel.ids

On Mon, Nov 11 2019 at 11:37am -0500,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> On 11/11/19 3:59 PM, Mikulas Patocka wrote:
> > Snapshot doesn't work with realtime kernels since the commit f79ae415b6=
4c.
> > hlist_bl is implemented as a raw spinlock and the code takes two non-ra=
w
> > spinlocks while holding hlist_bl (non-raw spinlocks are blocking mutexe=
s
> > in the realtime kernel, so they couldn't be taken inside a raw spinlock=
).
> >=20
> > This patch fixes the problem by using non-raw spinlock
> > exception_table_lock instead of the hlist_bl lock.
> >=20
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Fixes: f79ae415b64c ("dm snapshot: Make exception tables scalable")
> >=20
>=20
> Hi Mikulas,
>=20
> I wasn't aware that hlist_bl is implemented as a raw spinlock in the
> real time kernel. I would expect it to be a standard non-raw spinlock,
> so everything works as expected. But, after digging further in the real
> time tree, I found commit ad7675b15fd87f1 ("list_bl: Make list head
> locking RT safe") which suggests that such a conversion would break
> other parts of the kernel.

Right, the proper fix is to update list_bl to work on realtime (which I
assume the referenced commit does).  I do not want to take this
dm-snapshot specific workaround that open-codes what should be done
within hlist_{bl_lock,unlock}, etc.

I'm not yet sure which realtime mailing list and/or maintainers should
be cc'd to further the inclussion of commit ad7675b15fd87f1 -- Nikos do
you?

Thanks,
Mike
