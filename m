From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: RFC: I/O bandwidth controller
Date: Thu, 07 Aug 2008 17:30:52 +0900 (JST)
Message-ID: <20080807.173052.13120905.taka@valinux.co.jp>
References: <1217870433.20260.101.camel@nimitz>
	<1217985189.3154.57.camel@sebastian.kern.oss.ntt.co.jp>
	<2846be6b0808061237o6667c609l21bdb5a765469e95@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <2846be6b0808061237o6667c609l21bdb5a765469e95@mail.gmail.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: ngupta@google.com
Cc: xen-devel@lists.xensource.com, uchida@ap.jp.nec.com, fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com, yoshikawa.takuya@oss.ntt.co.jp, dm-devel@redhat.com, agk@sourceware.org, ryov@valinux.co.jp, virtualization@lists.linux-foundation.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com
List-Id: dm-devel.ids

Hi, Naveen,

> > If we are pursuing a I/O prioritization model =E0 la CFQ the tempta=
tion is
> > to implement it at the elevator layer or extend any of the existing=
 I/O
> > schedulers.
> >
> > There have been several proposals that extend either the CFQ schedu=
ler
> > (see (1), (2) below) or the AS scheduler (see (3) below). The probl=
em
> > with these controllers is that they are scheduler dependent, which =
means
> > that they become unusable when we change the scheduler or when we w=
ant
> > to control stacking devices which define their own make_request_fn
> > function (md and dm come to mind). It could be argued that the phys=
ical
> > devices controlled by a dm or md driver are likely to be fed by
> > traditional I/O schedulers such as CFQ, but these I/O schedulers wo=
uld
> > be running independently from each other, each one controlling its =
own
> > device ignoring the fact that they part of a stacking device. This =
lack
> > of information at the elevator layer makes it pretty difficult to o=
btain
> > accurate results when using stacking devices. It seems that unless =
we
> > can make the elevator layer aware of the topology of stacking devic=
es
> > (possibly by extending the elevator API?) evelator-based approaches=
 do
> > not constitute a generic solution. Here onwards, for discussion
> > purposes, I will refer to this type of I/O bandwidth controllers as=

> > elevator-based I/O controllers.
> =

> It can be argued that any scheduling decision wrt to i/o belongs to
> elevators. Till now they have been used to improve performance. But
> with new requirements to isolate i/o based on process or cgroup, we
> need to change the elevators.
> =

> If we add another layer of i/o scheduling (block layer I/O controller=
)
> above elevators
> 1) It builds another layer of i/o scheduling (bandwidth or priority)
> 2) This new layer can have decisions for i/o scheduling which conflic=
t
> with underlying elevator. e.g. If we decide to do b/w scheduling in
> this new layer, there is no way a priority based elevator could work
> underneath it.

I seems like the same goes for the current Linux kernel implementation
that if processes issued a lot of I/O requests and the io-request queue=

of a disk is overflowed, all the I/O requests after will be blocked
and the priorities of them are meaningless.
In other word, it won't work if it receives lots of requests more than
the ability/bandwidth of a disk.

It doesn't seem so weird if it won't work if a cgroup issues lots of
I/O requests more than the bandwidth which is assigned to the cgroup.

> If a custom make_request_fn is defined (which means the said device i=
s
> not using existing elevator), it could build it's own scheduling
> rather than asking kernel to add another layer at the time of i/o
> submission. Since it has complete control of i/o.

Thanks,
Hirokazu Takahashi
