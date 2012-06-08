From: Frederick Grose <fgrose@gmail.com>
Subject: Re: access to snapshot deltas
Date: Fri, 8 Jun 2012 17:54:37 -0400
Message-ID: <CAEcBt+WXwZZrq0XLS1ZAQf9EhsZRehRCEqL6cvr-W4DxTEHEwA@mail.gmail.com>
References: <1339167366.25380.47.camel@pod.greynode.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5423397467973534675=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1339167366.25380.47.camel@pod.greynode.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5423397467973534675==
Content-Type: multipart/alternative; boundary=000e0ce0f1844c538704c1fd0ea2

--000e0ce0f1844c538704c1fd0ea2
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Jun 8, 2012 at 10:56 AM, Benjamin S. Scarlet
<scarlet@alum.mit.edu>wrote:

> Is there or could there be support for writing to a snapshot
> copy-on-write device from userspace? Are the bits contained therein
> portable between two snapshot instances with the same sizes of origin
> and copy-on-write devices?
>
> I tried a simple experiment and caused Very Bad Things to happen (a
> kernel error claiming "BUG: Bad page state in process ..."), but I may
> have done something bogus. Before I proceeded with further experiments,
> I thought I'd ask what, if anything, ought to work.
>
> My ultimate goal is to reduce downtime while migrating a virtual guest
> with its storage from one host to another. To that end what I'd like to
> do is:
> *) take a snapshot
> *) transfer the frozen view of the snapshot while the guest continues to
> run
> *) stop the guest on the original host
> *) transfer the deltas that have been written since the snapshot
> *) start the guest on the new host
> *) merge the deltas (assuming they weren't already merged during the
> transfer, depending on how that was done)
>
> So please consider the following experiment, expressed mostly in terms
> of lvm tools rather than dmsetup, just because this way I think I'm
> giving myself fewer chances to mess up:
>
> 1) create an LVM volume A to play the role of the original volume. Fill
> it up with some data.
> 2) create an LVM snapshot of A, A-snap.
> 3) create an LVM volume B to play the role of the destination volume,
> the same size as A.
> 4) copy (e.g. dd) from A into B, and simultaneously write some changes
> into A-snap.
> 5) create an LVM snapshot of B, B-snap.
> 5.5) cross your fingers 'cause here I'm heading into the unknown (for
> me)
> 6) dmsetup suspend something (if any variant would work, could someone
> tell me what?)
> 7) copy bits from A-snap-cow to B-snap-cow
> 8) dmsetup resume
> 9) diff A-snap and B-snap and observe they're the same! (or so I would
> like)
> 10) proceed to use lvm to merge B-snap into B
>

Would mirroring A to B work for this?

       --Fred

--000e0ce0f1844c538704c1fd0ea2
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">On Fri, Jun 8, 2012 at 10:56 AM, Benjamin S. Sca=
rlet <span dir=3D"ltr">&lt;<a href=3D"mailto:scarlet@alum.mit.edu" target=
=3D"_blank">scarlet@alum.mit.edu</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">

Is there or could there be support for writing to a snapshot<br>
copy-on-write device from userspace? Are the bits contained therein<br>
portable between two snapshot instances with the same sizes of origin<br>
and copy-on-write devices?<br>
<br>
I tried a simple experiment and caused Very Bad Things to happen (a<br>
kernel error claiming &quot;BUG: Bad page state in process ...&quot;), but =
I may<br>
have done something bogus. Before I proceeded with further experiments,<br>
I thought I&#39;d ask what, if anything, ought to work.<br>
<br>
My ultimate goal is to reduce downtime while migrating a virtual guest<br>
with its storage from one host to another. To that end what I&#39;d like to=
<br>
do is:<br>
*) take a snapshot<br>
*) transfer the frozen view of the snapshot while the guest continues to<br=
>
run<br>
*) stop the guest on the original host<br>
*) transfer the deltas that have been written since the snapshot<br>
*) start the guest on the new host<br>
*) merge the deltas (assuming they weren&#39;t already merged during the<br=
>
transfer, depending on how that was done)<br>
<br>
So please consider the following experiment, expressed mostly in terms<br>
of lvm tools rather than dmsetup, just because this way I think I&#39;m<br>
giving myself fewer chances to mess up:<br>
<br>
1) create an LVM volume A to play the role of the original volume. Fill<br>
it up with some data.<br>
2) create an LVM snapshot of A, A-snap.<br>
3) create an LVM volume B to play the role of the destination volume,<br>
the same size as A.<br>
4) copy (e.g. dd) from A into B, and simultaneously write some changes<br>
into A-snap.<br>
5) create an LVM snapshot of B, B-snap.<br>
5.5) cross your fingers &#39;cause here I&#39;m heading into the unknown (f=
or<br>
me)<br>
6) dmsetup suspend something (if any variant would work, could someone<br>
tell me what?)<br>
7) copy bits from A-snap-cow to B-snap-cow<br>
8) dmsetup resume<br>
9) diff A-snap and B-snap and observe they&#39;re the same! (or so I would<=
br>
like)<br>
10) proceed to use lvm to merge B-snap into B<br></blockquote><div><br></di=
v><div>Would mirroring A to B work for this?</div><div><br></div><div>=A0 =
=A0 =A0 =A0--Fred=A0</div></div><br>

--000e0ce0f1844c538704c1fd0ea2--


--===============5423397467973534675==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5423397467973534675==--
