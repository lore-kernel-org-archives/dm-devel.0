From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Re: dm-ioband: Test results.
Date: Mon, 20 Apr 2009 17:37:38 -0400
Message-ID: <20090420213738.GB9080@redhat.com>
References: <20090416.114750.226794985.ryov@valinux.co.jp>
	<20090416141125.GB8896@redhat.com>
	<e98e18940904161324p9833457vdf699d66bb323591@mail.gmail.com>
	<20090420.172959.193682665.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090420.172959.193682665.ryov@valinux.co.jp>
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
Cc: fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, Andrea Righi <righi.andrea@gmail.com>, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Mon, Apr 20, 2009 at 05:29:59PM +0900, Ryo Tsuruta wrote:
> Hi Vivek and Nauman,
>=20
> > On Thu, Apr 16, 2009 at 7:11 AM, Vivek Goyal <vgoyal@redhat.com> wrot=
e:
> > > On Thu, Apr 16, 2009 at 11:47:50AM +0900, Ryo Tsuruta wrote:
> > >> Hi Vivek,
> > >>
> > >> > General thoughts about dm-ioband
> > >> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >> > - Implementing control at second level has the advantage tha one=
 does not
> > >> > =A0 have to muck with IO scheduler code. But then it also has th=
e
> > >> > =A0 disadvantage that there is no communication with IO schedule=
r.
> > >> >
> > >> > - dm-ioband is buffering bio at higher layer and then doing FIFO=
 release
> > >> > =A0 of these bios. This FIFO release can lead to priority invers=
ion problems
> > >> > =A0 in certain cases where RT requests are way behind BE request=
s or
> > >> > =A0 reader starvation where reader bios are getting hidden behin=
d writer
> > >> > =A0 bios etc. These are hard to notice issues in user space. I g=
uess above
> > >> > =A0 RT results do highlight the RT task problems. I am still wor=
king on
> > >> > =A0 other test cases and see if i can show the probelm.
> >=20
> > Ryo, I could not agree more with Vivek here. At Google, we have very
> > stringent requirement for latency of our RT requests. If RT requests
> > get queued in any higher layer (behind BE requests), all bets are off=
.
> > I don't find doing IO control at two layer for this particular reason=
.
> > The upper layer (dm-ioband in this case) would have to make sure that
> > RT requests are released immediately, irrespective of the state (FIFO
> > queuing and tokens held). And the lower layer (IO scheduling layer)
> > has to do the same. This requirement is not specific to us. I have
> > seen similar comments from filesystem folks here previously, in the
> > context of metadata updates being submitted as RT. Basically, the
> > semantics of RT class has to be preserved by any solution that is
> > build on top of CFQ scheduler.
>=20
> I could see the priority inversion by running Vivek's script and I
> understand how RT requests has to be handled. I'll create a patch
> which makes dm-ioband cooperates with CFQ scheduler. However, do you
> think we need some kind of limitation on processes which belong to the
> RT class to prevent the processes from depleting bandwidth?

I think to begin with, we can keep the same behavior as CFQ. An RT task
can starve other tasks.

But we should provide two configurations and user can choose any one.
If RT task is in root group, it will starve other sibling tasks/groups. I=
f
it is with-in a cgroup, then it will starve its sibling only with-in that
cgroup and will not impact other cgroups.

What I mean is following.

			root
			/  \
		      RT   group1

In above configuration RT task will starve everybody else.

			root
		        /   \
		   group1   group2
		   /  \
	         RT   BE

In above configuration  RT task will starve only sibling in group1 but
will not starve the tasks in group2 or in root.

Thanks
Vivek
