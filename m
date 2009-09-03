From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches
	from Ryo to track async bios.
Date: Wed, 2 Sep 2009 22:40:14 -0400
Message-ID: <20090903024014.GA8644@redhat.com>
References: <20090901141142.GA13709@redhat.com>
	<20090902.185251.193693849.ryov@valinux.co.jp>
	<20090902135821.GB5012@redhat.com>
	<20090903.112423.226782505.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090903.112423.226782505.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Thu, Sep 03, 2009 at 11:24:23AM +0900, Ryo Tsuruta wrote:
> Hi Vivek,
>=20
> Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > > > > - Somebody also gave an example where there is a memory hog=
ging process and
> > > > > > > =A0possibly pushes out some processes to swap. It does not =
sound fair to
> > > > > > > =A0charge those proccess for that swap writeout. These proc=
esses never
> > > > > > > =A0requested swap IO.
> > > > >=20
> > > > > I think that swap writeouts should be charged to the memory hog=
ging
> > > > > process, because the process consumes more resources and it sho=
uld get
> > > > > a penalty.
> > > > >=20
> > > >=20
> > > > A process requesting memory gets IO penalty? IMHO, swapping is a =
kernel=20
> > > > mechanism and kernel's way of providing extended RAM. If we want =
to solve
> > > > the issue of memory hogging by a process then right way to solve =
is to use
> > > > memory controller and not by charging the process for IO activity=
.
> > > > Instead, proabably a more suitable way is to charge swap activity=
 to root
> > > > group (where by default all the kernel related activity goes).  =20
> > >=20
> > > No. In the current blkio-cgroup, a process which uses a large amoun=
t
> > > of memory gets penalty, not a memory requester.
> > >=20
> >=20
> > At ioband level you just get to see bio and page. How do you decide w=
heter
> > this bio is being issued by a process which is a memory hog?
> >=20
> > In fact requester of memory could be anybody. It could be memory hog =
or a
> > different process. So are you saying that you got a mechanism where y=
ou=20
> > can detect that a process is memory hog and charge swap activity to i=
t.
> > IOW, if there are two processes A and B and assume A is the memory ho=
g and
> > then B requests for memory which triggers lot of swap IO, then you ca=
n
> > charge all that IO to memory hog A?
>=20
> When an annoymou page is allocated, blkio-cgroup sets an ID to the
> page. And then when the page is going to swap out, dm-ioband can know
> who the owner of the page is by retrieving ID from the page.
>=20
> In the above case, since the pages of the process A are swapped-out,=20
> dm-ioband charges swap IO to the process A.
>=20

But this does not mean that in all cases memory hog is being charged for
swap IO, as you have said. So if a process A has done some anonymous page
allocations and later a memory hog B comes in and forces swap out of A,=20
you will charge A for swap activity which does not seem fair as B is
memory hog here?

Thanks
Vivek

> > Can you please point me to the relevant code in dm-ioband?
> >=20
> > IMHO, to keep things simple, all swapping activity should be charged =
to
> > root group and be considered as kernel activity and user space not be
> > charged for that.
>=20
> Thanks,
> Ryo Tsuruta
