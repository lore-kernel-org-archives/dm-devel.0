From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches from Ryo to
 track async bios.
Date: Thu, 03 Sep 2009 11:24:23 +0900 (JST)
Message-ID: <20090903.112423.226782505.ryov@valinux.co.jp>
References: <20090901141142.GA13709@redhat.com>
	<20090902.185251.193693849.ryov@valinux.co.jp>
	<20090902135821.GB5012@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754094AbZICCYW@vger.kernel.org>
In-Reply-To: <20090902135821.GB5012@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vgoyal@redhat.com
Cc: nauman@google.com, riel@redhat.com, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, containers@lists.linux-foundation.org, dm-devel@redhat.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu
List-Id: dm-devel.ids

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > > > - Somebody also gave an example where there is a memory hog=
ging process and
> > > > > > =A0possibly pushes out some processes to swap. It does not =
sound fair to
> > > > > > =A0charge those proccess for that swap writeout. These proc=
esses never
> > > > > > =A0requested swap IO.
> > > >=20
> > > > I think that swap writeouts should be charged to the memory hog=
ging
> > > > process, because the process consumes more resources and it sho=
uld get
> > > > a penalty.
> > > >=20
> > >=20
> > > A process requesting memory gets IO penalty? IMHO, swapping is a =
kernel=20
> > > mechanism and kernel's way of providing extended RAM. If we want =
to solve
> > > the issue of memory hogging by a process then right way to solve =
is to use
> > > memory controller and not by charging the process for IO activity=
=2E
> > > Instead, proabably a more suitable way is to charge swap activity=
 to root
> > > group (where by default all the kernel related activity goes).  =20
> >=20
> > No. In the current blkio-cgroup, a process which uses a large amoun=
t
> > of memory gets penalty, not a memory requester.
> >=20
>=20
> At ioband level you just get to see bio and page. How do you decide w=
heter
> this bio is being issued by a process which is a memory hog?
>=20
> In fact requester of memory could be anybody. It could be memory hog =
or a
> different process. So are you saying that you got a mechanism where y=
ou=20
> can detect that a process is memory hog and charge swap activity to i=
t.
> IOW, if there are two processes A and B and assume A is the memory ho=
g and
> then B requests for memory which triggers lot of swap IO, then you ca=
n
> charge all that IO to memory hog A?

When an annoymou page is allocated, blkio-cgroup sets an ID to the
page. And then when the page is going to swap out, dm-ioband can know
who the owner of the page is by retrieving ID from the page.

In the above case, since the pages of the process A are swapped-out,=20
dm-ioband charges swap IO to the process A.

> Can you please point me to the relevant code in dm-ioband?
>=20
> IMHO, to keep things simple, all swapping activity should be charged =
to
> root group and be considered as kernel activity and user space not be
> charged for that.

Thanks,
Ryo Tsuruta
