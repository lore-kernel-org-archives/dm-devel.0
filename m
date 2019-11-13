From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH RT 2/2 v2] list_bl: avoid BUG when the list is not
 locked
Date: Wed, 13 Nov 2019 06:16:41 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1911130616240.20335@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1911121110430.12815@file01.intranet.prod.int.rdu2.redhat.com> <335dafcb-5e07-63ed-b288-196516170bde@arrikto.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <335dafcb-5e07-63ed-b288-196516170bde@arrikto.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: tglx@linutronix.de, linux-rt-users@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>, Scott Wood <swood@redhat.com>, Ilias Tsitsimpis <iliastsi@arrikto.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: dm-devel.ids



On Wed, 13 Nov 2019, Nikos Tsironis wrote:

> On 11/12/19 6:16 PM, Mikulas Patocka wrote:
> > list_bl would crash with BUG() if we used it without locking. dm-snapsh=
ot=20
> > uses its own locking on realtime kernels (it can't use list_bl because=
=20
> > list_bl uses raw spinlock and dm-snapshot takes other non-raw spinlocks=
=20
> > while holding bl_lock).
> >=20
> > To avoid this BUG, we must set LIST_BL_LOCKMASK =3D 0.
> >=20
> > This patch is intended only for the realtime kernel patchset, not for t=
he=20
> > upstream kernel.
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
>=20
> Hi Mikulas,
>=20
> I think removing __set_bit()/__clear_bit() breaks hlist_bl_is_locked(),
> which is used by the RCU variant of list_bl.
>=20
> Nikos

OK. so I can remove this part of the patch.

Mikulas

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
>=20
