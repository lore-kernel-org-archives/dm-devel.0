From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs
Date: Mon, 31 May 2010 18:34:55 +0200
Message-ID: <1275323695.3291.122.camel@edumazet-laptop>
References: <20100531160425.GA20344@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100531160425.GA20344@basil.fritz.box>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: herbert@gondor.apana.org.au, dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
List-Id: dm-devel.ids

Le lundi 31 mai 2010 =C3=A0 18:04 +0200, Andi Kleen a =C3=A9crit :
> DM-CRYPT: Scale to multiple CPUs
>=20
> Currently dm-crypt does all encryption work per dmcrypt mapping in a
> single workqueue. This does not scale well when multiple CPUs
> are submitting IO at a high rate. The single CPU running the single
> thread cannot keep up with the encryption and encrypted IO performanc=
e
> tanks.
>=20
> This patch changes the crypto workqueue to be per CPU. This means
> that as long as the IO submitter (or the interrupt target CPUs
> for reads) runs on different CPUs the encryption work will be also
> parallel.
>=20
> To avoid a bottleneck on the IO worker I also changed those to be
> per CPU threads.
>=20
> There is still some shared data, so I suspect some bouncing
> cache lines. But I haven't done a detailed study on that yet.
>=20
> All the threads are global, not per CPU. That is to avoid a thread
> explosion on systems with a large number of CPUs and a larger
> number of dm-crypt mappings. The code takes care to avoid problems
> with nested mappings.
>    =20
> Signed-off-by: Andi Kleen <ak@linux.intel.com>


>  	/*
> +	 * Duplicated per cpu state. Access through
> +	 * per_cpu_ptr() only.
> +	 */
> +	struct crypt_cpu *cpu;
> +
> +	/*
>  	 * Layout of each crypto request:
>  	 *

Since commit e0fdb0e050eae331, we have a __percpu annotation so that
sparse can be augmented. This would also make the comment unnecessary..=
=2E


We also have this_cpu_ accessors

> +       return per_cpu_ptr(cc->cpu, smp_processor_id());

	this_cpu_ptr(cc->cpu)

and __thic_cpu_ptr() for the 'raw' version


> +       __get_cpu_var(io_wq_cpu) =3D current;

	this_cpu_write(io_wq_cpu, current)
