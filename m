From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Re: dm-ioband: Test results.
Date: Mon, 20 Apr 2009 17:29:59 +0900 (JST)
Message-ID: <20090420.172959.193682665.ryov@valinux.co.jp>
References: <20090416.114750.226794985.ryov@valinux.co.jp>
	<20090416141125.GB8896@redhat.com>
	<e98e18940904161324p9833457vdf699d66bb323591@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e98e18940904161324p9833457vdf699d66bb323591@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: nauman@google.com
Cc: fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, agk@redhat.com, jens.axboe@oracle.com, vgoyal@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi Vivek and Nauman,

> On Thu, Apr 16, 2009 at 7:11 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Apr 16, 2009 at 11:47:50AM +0900, Ryo Tsuruta wrote:
> >> Hi Vivek,
> >>
> >> > General thoughts about dm-ioband
> >> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> > - Implementing control at second level has the advantage tha one d=
oes not
> >> > =A0 have to muck with IO scheduler code. But then it also has the
> >> > =A0 disadvantage that there is no communication with IO scheduler.
> >> >
> >> > - dm-ioband is buffering bio at higher layer and then doing FIFO r=
elease
> >> > =A0 of these bios. This FIFO release can lead to priority inversio=
n problems
> >> > =A0 in certain cases where RT requests are way behind BE requests =
or
> >> > =A0 reader starvation where reader bios are getting hidden behind =
writer
> >> > =A0 bios etc. These are hard to notice issues in user space. I gue=
ss above
> >> > =A0 RT results do highlight the RT task problems. I am still worki=
ng on
> >> > =A0 other test cases and see if i can show the probelm.
>=20
> Ryo, I could not agree more with Vivek here. At Google, we have very
> stringent requirement for latency of our RT requests. If RT requests
> get queued in any higher layer (behind BE requests), all bets are off.
> I don't find doing IO control at two layer for this particular reason.
> The upper layer (dm-ioband in this case) would have to make sure that
> RT requests are released immediately, irrespective of the state (FIFO
> queuing and tokens held). And the lower layer (IO scheduling layer)
> has to do the same. This requirement is not specific to us. I have
> seen similar comments from filesystem folks here previously, in the
> context of metadata updates being submitted as RT. Basically, the
> semantics of RT class has to be preserved by any solution that is
> build on top of CFQ scheduler.

I could see the priority inversion by running Vivek's script and I
understand how RT requests has to be handled. I'll create a patch
which makes dm-ioband cooperates with CFQ scheduler. However, do you
think we need some kind of limitation on processes which belong to the
RT class to prevent the processes from depleting bandwidth?

Thanks,
Ryo Tsuruta
