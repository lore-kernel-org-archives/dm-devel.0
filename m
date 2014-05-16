From: Brian Bunker <brian@purestorage.com>
Subject: Re: an interesting note on LUN coalescing
Date: Thu, 15 May 2014 17:40:27 -0700
Message-ID: <5CC2707E-52B8-43B2-AC91-B220FE772D7A@purestorage.com>
References: <9E356404-6E9E-4271-A8DC-8A95DD66AC81@purestorage.com>
	<1400173675.19394.13.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<CDE8FB77-CD2E-4FF6-8485-C08FA3A7AE74@purestorage.com>
	<1400186442.19394.29.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<CABr-Gne0rTksK2utYF65qT1Mf1vLGdck+TFsC0TG3ubq4pnwOw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/mixed; boundary="===============7331049971578746454=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-Gne0rTksK2utYF65qT1Mf1vLGdck+TFsC0TG3ubq4pnwOw@mail.gmail.com>
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


--===============7331049971578746454==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_A7F91DB0-86A0-4469-BBC9-529549C497B2"


--Apple-Mail=_A7F91DB0-86A0-4469-BBC9-529549C497B2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

What I am going to do is this. I will do a page 0x83 EVPD page inquiry =
before entering the find_mp_by_wwid function. I will strncmp the NAA =
number from page 0x83 with the wwid. If I find a difference, I will log =
it. I expect that if I just step on the wwid with the NAA number that I =
get from page 0x83 that I get if the two are different then my problem =
will go away, but it would be interesting to see how the difference =
happens. I will update with my findings once it fires again.

Just as an aside, why not just use the NAA page 0x83 number instead of =
the callout to scsi_id? The inquiry plumbing is all there already in =
discovery to get the serial number and with a small addition could =
return the NAA value as a string to match the wwid expectation.

Thanks,
Brian

On May 15, 2014, at 2:09 PM, Christophe Varoqui =
<christophe.varoqui@opensvc.com> wrote:

> Hi,
>=20
> you could also try to extend your observation to the timing of the =
udev triggers.
>=20
> You did not describe the scenario leading to this misbehaviour, but if =
it involves paths remove-readd it's critical udev completed the /dev/ =
entries janitoring ... unless multipathd might exec scsi_id on the wrong =
devices.
>=20
> Latest distro versions implement a strict serialization, using the =
udevd socket, thanks to Hannes work. You might try to reproduce the =
problem with those to get a broader viewpoint, but it sure won't help =
with your supporting your products on older distros.
>=20
> Best regards,
> Christophe Varoqui
>=20
>=20
> On Thu, May 15, 2014 at 10:40 PM, Stewart, Sean =
<Sean.Stewart@netapp.com> wrote:
> On Thu, 2014-05-15 at 10:23 -0700, Brian Bunker wrote:
> > I will get both the page 0x83 and page 0x80 data of the path when =
the problem happens. In our case the page 0x83 and page 0x80 data are =
the same always. The page 0x83 data has the additional encoding and OUI =
information but the bytes after that 3624a9370 are exactly the same. I =
am wondering about how the path gets its wwid when it comes back.
>=20
> This is through the call to /lib/udev/scsi_id, which pulls it from =
page
> 0x83.  The function that does it is called get_uid().  It calls the
> external program, then strips trailing whitespace, replacing spaces =
with
> null characters.  You could try simply making the log message in that
> function a level 2 instead of a 3, so we'll know that get_uid =
completed
> for the path, and what it found for the uid.
>=20
> >
> > In our case we have a controller coming back online after doing =
something. All the LUNs are re-discovered by the initiator and an sd =
device gets created for each LUN path which came back. The serial of the =
sd device at that time I believe is known to the initiator. The =
multipathd gets that sd device and comes up with a wwid. I would expect =
that wwid would be just the serial number plus some bytes in the =
beginning but that is not what we see in the fail case. The path wwid =
and path serial are pointing to different volumes on the array. I expect =
that the sd device will show the same data for page 0x83 and page 0x80 =
pointing to the same volume on the array but I will verify that with =
more logging.
> >
> Similar to what I said above, you could change the log message in
> scsi_ioctl_pathinfo (after the get_serial call) from level 3 to level =
2.
>=20
> Beyond that, I don't have many more ideas here..  Another wild guess, =
I
> suppose it's possible that the data from the 0x83 inquiry at the time =
of
> discovery could be incomplete?  Then, when you run the command later,
> manually, after it comes up, it appears just fine. I don't think I see
> the code zeroing the memory for the wwid in the newly allocated path
> struct before it tries to populate the buffer, but that seems kind of
> farfetched.
>=20
> > You can see from my previous posts on this issue. (They go back for =
some time). That the page 0x83 and page 0x80 from sg3_utils show that =
they point to same LUN but different from the dm device that they are =
coalesced under.
> >
> > Thanks,
> > Brian
>=20
> Hope this helps.
>=20
> Thanks,
> Sean
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

Brian Bunker
brian@purestorage.com




--Apple-Mail=_A7F91DB0-86A0-4469-BBC9-529549C497B2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;">What I =
am going to do is this. I will do a page 0x83 EVPD page inquiry before =
entering the find_mp_by_wwid function. I will strncmp the NAA number =
from page 0x83 with the wwid. If I find a difference, I will log it. I =
expect that if I just step on the wwid with the NAA number that I get =
from page 0x83 that I get if the two are different then my problem will =
go away, but it would be interesting to see how the difference happens. =
I will update with my findings once it fires =
again.<div><br></div><div>Just as an aside, why not just use the NAA =
page 0x83 number instead of the callout to scsi_id? The inquiry plumbing =
is all there already in discovery to get the serial number and with a =
small addition could return the NAA value as a string to match the wwid =
expectation.<br><div><br></div><div>Thanks,</div><div>Brian</div><div><br>=
<div><div>On May 15, 2014, at 2:09 PM, Christophe Varoqui &lt;<a =
href=3D"mailto:christophe.varoqui@opensvc.com">christophe.varoqui@opensvc.=
com</a>&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite"><div =
dir=3D"ltr">Hi,<div><br></div><div>you could also try to extend your =
observation to the timing of the udev =
triggers.</div><div><br></div><div>You did not describe the scenario =
leading to this misbehaviour, but if it involves paths remove-readd it's =
critical udev completed the /dev/ entries janitoring ... unless =
multipathd might exec scsi_id on the wrong devices.</div>
<div><br></div><div>Latest distro versions implement a strict =
serialization, using the udevd socket, thanks to Hannes work. You might =
try to reproduce the problem with those to get a broader viewpoint, but =
it sure won't help with your supporting your products on older =
distros.</div>
<div><br></div><div>Best regards,</div><div>Christophe =
Varoqui</div></div><div class=3D"gmail_extra"><br><br><div =
class=3D"gmail_quote">On Thu, May 15, 2014 at 10:40 PM, Stewart, Sean =
<span dir=3D"ltr">&lt;<a href=3D"mailto:Sean.Stewart@netapp.com" =
target=3D"_blank">Sean.Stewart@netapp.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><div class=3D"">On =
Thu, 2014-05-15 at 10:23 -0700, Brian Bunker wrote:<br>
&gt; I will get both the page 0x83 and page 0x80 data of the path when =
the problem happens. In our case the page 0x83 and page 0x80 data are =
the same always. The page 0x83 data has the additional encoding and OUI =
information but the bytes after that 3624a9370 are exactly the same. I =
am wondering about how the path gets its wwid when it comes back.<br>

<br>
</div>This is through the call to /lib/udev/scsi_id, which pulls it from =
page<br>
0x83. &nbsp;The function that does it is called get_uid(). &nbsp;It =
calls the<br>
external program, then strips trailing whitespace, replacing spaces =
with<br>
null characters. &nbsp;You could try simply making the log message in =
that<br>
function a level 2 instead of a 3, so we'll know that get_uid =
completed<br>
for the path, and what it found for the uid.<br>
<div class=3D""><br>
&gt;<br>
&gt; In our case we have a controller coming back online after doing =
something. All the LUNs are re-discovered by the initiator and an sd =
device gets created for each LUN path which came back. The serial of the =
sd device at that time I believe is known to the initiator. The =
multipathd gets that sd device and comes up with a wwid. I would expect =
that wwid would be just the serial number plus some bytes in the =
beginning but that is not what we see in the fail case. The path wwid =
and path serial are pointing to different volumes on the array. I expect =
that the sd device will show the same data for page 0x83 and page 0x80 =
pointing to the same volume on the array but I will verify that with =
more logging.<br>

&gt;<br>
</div>Similar to what I said above, you could change the log message =
in<br>
scsi_ioctl_pathinfo (after the get_serial call) from level 3 to level =
2.<br>
<br>
Beyond that, I don't have many more ideas here.. &nbsp;Another wild =
guess, I<br>
suppose it's possible that the data from the 0x83 inquiry at the time =
of<br>
discovery could be incomplete? &nbsp;Then, when you run the command =
later,<br>
manually, after it comes up, it appears just fine. I don't think I =
see<br>
the code zeroing the memory for the wwid in the newly allocated path<br>
struct before it tries to populate the buffer, but that seems kind =
of<br>
farfetched.<br>
<div class=3D""><br>
&gt; You can see from my previous posts on this issue. (They go back for =
some time). That the page 0x83 and page 0x80 from sg3_utils show that =
they point to same LUN but different from the dm device that they are =
coalesced under.<br>

&gt;<br>
&gt; Thanks,<br>
&gt; Brian<br>
<br>
</div>Hope this helps.<br>
<br>
Thanks,<br>
Sean<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" =
target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>=

</div></div></blockquote></div><br></div>
--<br>dm-devel mailing list<br><a =
href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>https://www=
.redhat.com/mailman/listinfo/dm-devel</blockquote></div><br><div =
apple-content-edited=3D"true">
<span class=3D"Apple-style-span" style=3D"border-collapse: separate; =
color: rgb(0, 0, 0); font-family: Helvetica; font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: 2; text-align: -webkit-auto; text-indent: =
0px; text-transform: none; white-space: normal; widows: 2; word-spacing: =
0px; -webkit-border-horizontal-spacing: 0px; =
-webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px;  "><div>Brian Bunker</div><div><a =
href=3D"mailto:brian@purestorage.com">brian@purestorage.com</a></div><div>=
<br></div></span><br class=3D"Apple-interchange-newline">

</div>
<br></div></div></body></html>=

--Apple-Mail=_A7F91DB0-86A0-4469-BBC9-529549C497B2--


--===============7331049971578746454==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7331049971578746454==--
