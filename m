From: Nauman Rafique <nauman@google.com>
Subject: Re: [dm-devel] Re: dm-ioband: Test results.
Date: Mon, 20 Apr 2009 02:07:44 -0700
Message-ID: <e98e18940904200207y62eca680t7cf938049375f4b3@mail.gmail.com>
References: <20090416.114750.226794985.ryov@valinux.co.jp>
	 <20090416141125.GB8896@redhat.com>
	 <e98e18940904161324p9833457vdf699d66bb323591@mail.gmail.com>
	 <20090420.172959.193682665.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754754AbZDTJII@vger.kernel.org>
In-Reply-To: <20090420.172959.193682665.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: vgoyal@redhat.com, fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Mon, Apr 20, 2009 at 1:29 AM, Ryo Tsuruta <ryov@valinux.co.jp> wrote=
:
> Hi Vivek and Nauman,
>
>> On Thu, Apr 16, 2009 at 7:11 AM, Vivek Goyal <vgoyal@redhat.com> wro=
te:
>> > On Thu, Apr 16, 2009 at 11:47:50AM +0900, Ryo Tsuruta wrote:
>> >> Hi Vivek,
>> >>
>> >> > General thoughts about dm-ioband
>> >> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> >> > - Implementing control at second level has the advantage tha on=
e does not
>> >> > =A0 have to muck with IO scheduler code. But then it also has t=
he
>> >> > =A0 disadvantage that there is no communication with IO schedul=
er.
>> >> >
>> >> > - dm-ioband is buffering bio at higher layer and then doing FIF=
O release
>> >> > =A0 of these bios. This FIFO release can lead to priority inver=
sion problems
>> >> > =A0 in certain cases where RT requests are way behind BE reques=
ts or
>> >> > =A0 reader starvation where reader bios are getting hidden behi=
nd writer
>> >> > =A0 bios etc. These are hard to notice issues in user space. I =
guess above
>> >> > =A0 RT results do highlight the RT task problems. I am still wo=
rking on
>> >> > =A0 other test cases and see if i can show the probelm.
>>
>> Ryo, I could not agree more with Vivek here. At Google, we have very
>> stringent requirement for latency of our RT requests. If RT requests
>> get queued in any higher layer (behind BE requests), all bets are of=
f.
>> I don't find doing IO control at two layer for this particular reaso=
n.
>> The upper layer (dm-ioband in this case) would have to make sure tha=
t
>> RT requests are released immediately, irrespective of the state (FIF=
O
>> queuing and tokens held). And the lower layer (IO scheduling layer)
>> has to do the same. This requirement is not specific to us. I have
>> seen similar comments from filesystem folks here previously, in the
>> context of metadata updates being submitted as RT. Basically, the
>> semantics of RT class has to be preserved by any solution that is
>> build on top of CFQ scheduler.
>
> I could see the priority inversion by running Vivek's script and I
> understand how RT requests has to be handled. I'll create a patch
> which makes dm-ioband cooperates with CFQ scheduler. However, do you
> think we need some kind of limitation on processes which belong to th=
e
> RT class to prevent the processes from depleting bandwidth?

If you are talking about starvation that could be caused by RT tasks,
you are right. We need some mechanism to introduce starvation
prevention, but I think that is an issue that can be tackled once we
decide where to do bandwidth control.

The real question is, once you create a version of dm-ioband that
co-operates with CFQ scheduler, how that solution would compare with
the patch set Vivek has posted? In my opinion, we need to converge to
one solution as soon as possible, so that we can work on it together
to refine and test it.

>
> Thanks,
> Ryo Tsuruta
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>
