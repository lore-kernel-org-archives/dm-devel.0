From: David Zeuthen <zeuthen@gmail.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm resume
	ioctl.
Date: Fri, 19 Mar 2010 12:01:23 -0400
Message-ID: <7b13a0f81003190901o225df427o4468700888501177@mail.gmail.com>
References: <ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
	<20100319090656.GR6379@soda.linbit>
	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>
	<4BA37B06.1040107@redhat.com>
	<ac3eb2511003190643u32a8e702l4e7774e7ec924a12@mail.gmail.com>
	<7b13a0f81003190658i78664328ocb94aa0048054a17@mail.gmail.com>
	<20100319143412.GE919@agk-dp.fab.redhat.com>
	<7b13a0f81003190759w4de7be34pfa1a0454ac311ad8@mail.gmail.com>
	<20100319152409.GG919@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0051399865811238382=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100319152409.GG919@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Zeuthen <zeuthen@gmail.com>, device-mapper development <dm-devel@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

--===============0051399865811238382==
Content-Type: multipart/alternative; boundary=00148530ad837af5a904822975af

--00148530ad837af5a904822975af
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Mar 19, 2010 at 11:24 AM, Alasdair G Kergon <agk@redhat.com> wrote:

> On Fri, Mar 19, 2010 at 10:59:12AM -0400, David Zeuthen wrote:
> > I'd like to reiterate that it's actually not a problem that the sequence
> is
> >  - "add" uevent
> >  - device is not usable, access to the device fails gracefully
> >  - "change" uevent
> >  - device usable, blkid on the device etc. works
> > the point really is that you have to accept that there will exist
> > user space programs that does things on the device between
> > "add" and the initial "change" uevent.
>
> It is a problem if both:
>    1) something attempts to open the devices in that window
> AND 2) we have no mechanism to wait for it to finish
>
> Also note that if it is permitted to run 'udevadm trigger' at
> any time that also causes a synchonisation problem here: our
> application code doesn't even know there is something conflicting
> that it needs to wait for.  [Even though we want to ignore ADD,
> we may still need to synchronise against it.]
>
> So again, the 'don't issue ADD until device is usable' offers a simple
> way of avoiding this class of problems.


But as Kay said it's a horrible horrible hack.

If you wanted to solve the problem kernel-side I'd expect you to
create a new subsytem for device-mapper (let's call it 'kdm') that
libdevmapper would talk to. Then you'd only present block device
objects exactly when the device-mapper side has been configured.

Then the flow of events could be something like this

 - add device kdm-0  (subsys 'kdm')
 - libdevmapper configures kdm-0
 - add device dm-0 (subsys 'block')

but I don't know if this is better.


> The 'private device
> attribute' we suggested offers another - all would be expected
> to respect a 'private' sysfs attribute.
>

Sorry, but this is an even worse hack. Mandating that all of user
space (that is: past, present and future) needs to read some
random 'private' attribute in sysfs because of weird life-cycle
issues in the device-mapper implementation... that's not really
workable.

Anyway, I really don't think you can expect user space to behave
sanely so it's not really worth trying.

(I don't think you ever could expect user space to behave sanely,
but I'll note that it's an even bigger problem now that we have
powerful frameworks (such as udev) allowing people to run code
at device discovery time.... I mean, device-mapper have probably
been suffering from these issues from day 1 - it just wasn't visible
earlier on because we didn't have uevents...)

Thanks,
David

--00148530ad837af5a904822975af
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 19, 2010 at 11:24 AM, Alasdair G Kergon <span dir=3D"ltr">&lt;<=
a href=3D"mailto:agk@redhat.com">agk@redhat.com</a>&gt;</span> wrote:<br><d=
iv class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
<div class=3D"im">On Fri, Mar 19, 2010 at 10:59:12AM -0400, David Zeuthen w=
rote:<br>
&gt; I&#39;d like to reiterate that it&#39;s actually not a problem that th=
e sequence is<br>
&gt; =A0- &quot;add&quot; uevent<br>
&gt; =A0- device is not usable, access to the device fails gracefully<br>
&gt; =A0- &quot;change&quot; uevent<br>
&gt; =A0- device usable, blkid on the device etc. works<br>
&gt; the point really is that you have to accept that there will exist<br>
&gt; user space programs that does things on the device between<br>
&gt; &quot;add&quot; and the initial &quot;change&quot; uevent.<br>
<br>
</div>It is a problem if both:<br>
 =A0 =A01) something attempts to open the devices in that window<br>
AND 2) we have no mechanism to wait for it to finish<br>
<br>
Also note that if it is permitted to run &#39;udevadm trigger&#39; at<br>
any time that also causes a synchonisation problem here: our<br>
application code doesn&#39;t even know there is something conflicting<br>
that it needs to wait for. =A0[Even though we want to ignore ADD,<br>
we may still need to synchronise against it.]<br>
<br>
So again, the &#39;don&#39;t issue ADD until device is usable&#39; offers a=
 simple<br>
way of avoiding this class of problems. =A0</blockquote><div><br></div><div=
><div>But as Kay said it&#39;s a horrible horrible hack.</div><div><br></di=
v><div><div>If you wanted to solve the=A0problem kernel-side I&#39;d expect=
 you to</div>
<div>create a new subsytem=A0for device-mapper (let&#39;s call it &#39;kdm&=
#39;) that</div><div>libdevmapper would talk to. Then you&#39;d only=A0pres=
ent block device</div><div>objects exactly when the device-mapper=A0side ha=
s been configured.</div>
<div><br></div><div>Then the flow of events could be something like this</d=
iv><div><br></div><div>=A0- add device kdm-0 =A0(subsys &#39;kdm&#39;)</div=
><div>=A0- libdevmapper configures kdm-0</div><div>=A0- add device dm-0 (su=
bsys &#39;block&#39;)</div>
<div><br></div><div>but I don&#39;t know if this is better.</div></div></di=
v><div>=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8e=
x;border-left:1px #ccc solid;padding-left:1ex;">The &#39;private device<br>
attribute&#39; we suggested offers another - all would be expected<br>
to respect a &#39;private&#39; sysfs attribute.<br></blockquote><div><br></=
div><div>Sorry, but this is an even worse hack.=A0Mandating=A0that all of u=
ser</div><div>space (that is: past, present and future) needs to read some<=
/div>
<div>random &#39;private&#39;=A0attribute in sysfs because of weird life-cy=
cle</div><div>issues in the device-mapper implementation... that&#39;s not =
really</div><div>workable.</div><div><br></div><div>Anyway, I really don&#3=
9;t think you can expect user space to behave</div>
<div>sanely so it&#39;s not really worth trying.</div><div><br></div><div>(=
I don&#39;t think you ever could expect user space to behave sanely,</div><=
div>but I&#39;ll note that it&#39;s=A0an even bigger problem now that we ha=
ve</div>
<div>powerful frameworks=A0(such as udev) allowing people to run code</div>=
<div>at device discovery=A0time.... I mean, device-mapper have probably</di=
v><div>been suffering=A0from these issues from day 1 - it just wasn&#39;t v=
isible</div>
<div>earlier=A0on because we didn&#39;t have uevents...)</div><div><br></di=
v><div>Thanks,</div><div>David</div><div><br></div></div>

--00148530ad837af5a904822975af--


--===============0051399865811238382==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0051399865811238382==--
