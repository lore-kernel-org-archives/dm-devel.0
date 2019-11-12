From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/2] realtime: avoid BUG when the list is not
 locked
Date: Tue, 12 Nov 2019 06:21:57 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1911120621030.17732@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1911110853100.30532@file01.intranet.prod.int.rdu2.redhat.com>
	<20191112091044.lf7okijocx2wajhk@beryllium.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191112091044.lf7okijocx2wajhk@beryllium.lan>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Daniel Wagner <dwagner@suse.de>
Cc: Mike Snitzer <msnitzer@redhat.com>, linux-rt-users@vger.kernel.org, bigeasy@linutronix.de, Ilias Tsitsimpis <iliastsi@arrikto.com>, dm-devel@redhat.com, tglx@linutronix.de, Scott Wood <swood@redhat.com>, Nikos Tsironis <ntsironis@arrikto.com>
List-Id: dm-devel.ids



On Tue, 12 Nov 2019, Daniel Wagner wrote:

> [cc: linux-user-rt, Thomas and Sebastian]
>=20
> On Mon, Nov 11, 2019 at 08:59:44AM -0500, Mikulas Patocka wrote:
> > list_bl.h would crash with BUG() if we used it without locking.=20
> > dm-snapshot uses its own locking on readltime kernels, so to avoid this=
=20
> > BUG, we must set LIST_BL_LOCKMASK =3D 0.
> >=20
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> >=20
> > Index: linux-rt-devel/include/linux/list_bl.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-rt-devel.orig/include/linux/list_bl.h=092019-11-07 14:01:51.0=
00000000 +0100
> > +++ linux-rt-devel/include/linux/list_bl.h=092019-11-08 10:12:49.000000=
000 +0100
> > @@ -19,7 +19,7 @@
> >   * some fast and compact auxiliary data.
> >   */
> > =20
> > -#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
> > +#if (defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)) && !define=
d(CONFIG_PREEMPT_RT_BASE)
>=20
> CONFIG_PREEMPT_RT_BASE is only available in the out of tree -rt patch
> set, therefore I assume it's not for mainline, right?

Yes - this is intended to be applied to the realtime patchset.

Mikulas

> >  #define LIST_BL_LOCKMASK=091UL
> >  #else
> >  #define LIST_BL_LOCKMASK=090UL
> > @@ -161,9 +161,6 @@ static inline void hlist_bl_lock(struct
> >  =09bit_spin_lock(0, (unsigned long *)b);
> >  #else
> >  =09raw_spin_lock(&b->lock);
> > -#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
> > -=09__set_bit(0, (unsigned long *)b);
> > -#endif
> >  #endif
> >  }
> > =20
> > @@ -172,9 +169,6 @@ static inline void hlist_bl_unlock(struc
> >  #ifndef CONFIG_PREEMPT_RT_BASE
> >  =09__bit_spin_unlock(0, (unsigned long *)b);
> >  #else
> > -#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
> > -=09__clear_bit(0, (unsigned long *)b);
> > -#endif
> >  =09raw_spin_unlock(&b->lock);
> >  #endif
> >  }
> >=20
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >=20
>=20
> Thanks,
> Daniel
>=20
