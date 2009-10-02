From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 2 Oct 2009 18:27:56 -0400
Message-ID: <20091002222756.GG4494@redhat.com>
References: <200910021255.27689.czoccolo@gmail.com>
	<20091002124921.GA4494@redhat.com>
	<4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com>
	<1254497520.10392.11.camel@marge.simson.net>
	<20091002154020.GC4494@redhat.com>
	<12774.1254502217@turing-police.cc.vt.edu>
	<20091002195815.GE4494@redhat.com>
	<4e5e476b0910021514i1b461229t667bed94fd67f140@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4e5e476b0910021514i1b461229t667bed94fd67f140@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, Jens Axboe <jens.axboe@oracle.com>, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, Valdis.Kletnieks@vt.edu, containers@lists.linux-foundation.org, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Sat, Oct 03, 2009 at 12:14:28AM +0200, Corrado Zoccolo wrote:
> On Fri, Oct 2, 2009 at 9:58 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Oct 02, 2009 at 12:50:17PM -0400, Valdis.Kletnieks@vt.edu wro=
te:
> >> On Fri, 02 Oct 2009 11:40:20 EDT, Vivek Goyal said:
> >>
> >> Umm... I got petabytes of hardware RAID across the hall that very de=
finitely
> >> *is* rotating. =A0Did you mean "SSD and disk systems with big honkin=
g caches
> >> that cover up the rotation"? =A0Because "RAID" and "big honking cach=
es" are
> >> not *quite* the same thing, and I can just see that corner case comi=
ng out
> >> to bite somebody on the ass...
> >>
> >
> > I guess both. The systems which have big caches and cover up for rota=
tion,
> > we probably need not idle for seeky process. An in case of big hardwa=
re
> > RAID, having multiple rotating disks, instead of idling and keeping r=
est
> > of the disks free, we probably are better off dispatching requests fr=
om
> > next queue (hoping it is going to a different disk altogether).
>=20
> In fact I think that the 'rotating' flag name is misleading.
> All the checks we are doing are actually checking if the device truly
> supports multiple parallel operations, and this feature is shared by
> hardware raids and NCQ enabled SSDs, but not by cheap SSDs or single
> NCQ-enabled SATA disk.
>=20

While we are at it, what happens to notion of priority of tasks on SSDs?
Without idling there is not continuous time slice and there is no
fairness. So ioprio is out of the window for SSDs?

On SSDs, will it make more sense to provide fairness in terms of number o=
r
IO or size of IO and not in terms of time slices.

Thanks
Vivek

> If we really wanted a "seek is cheap" flag, we could measure seek time
> in the io-scheduler itself, but in the current code base we don't have
> it used in this meaning anywhere.
>=20
> Thanks,
> Corrado
>=20
> >
> > Thanks
> > Vivek
> >
>=20
>=20
>=20
> --=20
> _______________________________________________________________________=
___
>=20
> dott. Corrado Zoccolo                          mailto:czoccolo@gmail.co=
m
> PhD - Department of Computer Science - University of Pisa, Italy
> -----------------------------------------------------------------------=
---
> The self-confidence of a warrior is not the self-confidence of the aver=
age
> man. The average man seeks certainty in the eyes of the onlooker and ca=
lls
> that self-confidence. The warrior seeks impeccability in his own eyes a=
nd
> calls that humbleness.
>                                Tales of Power - C. Castaneda
