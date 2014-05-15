From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: an interesting note on LUN coalescing
Date: Thu, 15 May 2014 23:09:58 +0200
Message-ID: <CABr-Gne0rTksK2utYF65qT1Mf1vLGdck+TFsC0TG3ubq4pnwOw@mail.gmail.com>
References: <9E356404-6E9E-4271-A8DC-8A95DD66AC81@purestorage.com>
	<1400173675.19394.13.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<CDE8FB77-CD2E-4FF6-8485-C08FA3A7AE74@purestorage.com>
	<1400186442.19394.29.camel@ict-vth-stewarts01.ict.englab.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4161854571196469086=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1400186442.19394.29.camel@ict-vth-stewarts01.ict.englab.netapp.com>
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

--===============4161854571196469086==
Content-Type: multipart/alternative; boundary=089e0149beca3104ae04f976b860

--089e0149beca3104ae04f976b860
Content-Type: text/plain; charset=UTF-8

Hi,

you could also try to extend your observation to the timing of the udev
triggers.

You did not describe the scenario leading to this misbehaviour, but if it
involves paths remove-readd it's critical udev completed the /dev/ entries
janitoring ... unless multipathd might exec scsi_id on the wrong devices.

Latest distro versions implement a strict serialization, using the udevd
socket, thanks to Hannes work. You might try to reproduce the problem with
those to get a broader viewpoint, but it sure won't help with your
supporting your products on older distros.

Best regards,
Christophe Varoqui


On Thu, May 15, 2014 at 10:40 PM, Stewart, Sean <Sean.Stewart@netapp.com>wrote:

> On Thu, 2014-05-15 at 10:23 -0700, Brian Bunker wrote:
> > I will get both the page 0x83 and page 0x80 data of the path when the
> problem happens. In our case the page 0x83 and page 0x80 data are the same
> always. The page 0x83 data has the additional encoding and OUI information
> but the bytes after that 3624a9370 are exactly the same. I am wondering
> about how the path gets its wwid when it comes back.
>
> This is through the call to /lib/udev/scsi_id, which pulls it from page
> 0x83.  The function that does it is called get_uid().  It calls the
> external program, then strips trailing whitespace, replacing spaces with
> null characters.  You could try simply making the log message in that
> function a level 2 instead of a 3, so we'll know that get_uid completed
> for the path, and what it found for the uid.
>
> >
> > In our case we have a controller coming back online after doing
> something. All the LUNs are re-discovered by the initiator and an sd device
> gets created for each LUN path which came back. The serial of the sd device
> at that time I believe is known to the initiator. The multipathd gets that
> sd device and comes up with a wwid. I would expect that wwid would be just
> the serial number plus some bytes in the beginning but that is not what we
> see in the fail case. The path wwid and path serial are pointing to
> different volumes on the array. I expect that the sd device will show the
> same data for page 0x83 and page 0x80 pointing to the same volume on the
> array but I will verify that with more logging.
> >
> Similar to what I said above, you could change the log message in
> scsi_ioctl_pathinfo (after the get_serial call) from level 3 to level 2.
>
> Beyond that, I don't have many more ideas here..  Another wild guess, I
> suppose it's possible that the data from the 0x83 inquiry at the time of
> discovery could be incomplete?  Then, when you run the command later,
> manually, after it comes up, it appears just fine. I don't think I see
> the code zeroing the memory for the wwid in the newly allocated path
> struct before it tries to populate the buffer, but that seems kind of
> farfetched.
>
> > You can see from my previous posts on this issue. (They go back for some
> time). That the page 0x83 and page 0x80 from sg3_utils show that they point
> to same LUN but different from the dm device that they are coalesced under.
> >
> > Thanks,
> > Brian
>
> Hope this helps.
>
> Thanks,
> Sean
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--089e0149beca3104ae04f976b860
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>you could also try to extend your o=
bservation to the timing of the udev triggers.</div><div><br></div><div>You=
 did not describe the scenario leading to this misbehaviour, but if it invo=
lves paths remove-readd it&#39;s critical udev completed the /dev/ entries =
janitoring ... unless multipathd might exec scsi_id on the wrong devices.</=
div>
<div><br></div><div>Latest distro versions implement a strict serialization=
, using the udevd socket, thanks to Hannes work. You might try to reproduce=
 the problem with those to get a broader viewpoint, but it sure won&#39;t h=
elp with your supporting your products on older distros.</div>
<div><br></div><div>Best regards,</div><div>Christophe Varoqui</div></div><=
div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Thu, May 15=
, 2014 at 10:40 PM, Stewart, Sean <span dir=3D"ltr">&lt;<a href=3D"mailto:S=
ean.Stewart@netapp.com" target=3D"_blank">Sean.Stewart@netapp.com</a>&gt;</=
span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"">On Thu, 2014-05-15 at 10:23 =
-0700, Brian Bunker wrote:<br>
&gt; I will get both the page 0x83 and page 0x80 data of the path when the =
problem happens. In our case the page 0x83 and page 0x80 data are the same =
always. The page 0x83 data has the additional encoding and OUI information =
but the bytes after that 3624a9370 are exactly the same. I am wondering abo=
ut how the path gets its wwid when it comes back.<br>

<br>
</div>This is through the call to /lib/udev/scsi_id, which pulls it from pa=
ge<br>
0x83. =C2=A0The function that does it is called get_uid(). =C2=A0It calls t=
he<br>
external program, then strips trailing whitespace, replacing spaces with<br=
>
null characters. =C2=A0You could try simply making the log message in that<=
br>
function a level 2 instead of a 3, so we&#39;ll know that get_uid completed=
<br>
for the path, and what it found for the uid.<br>
<div class=3D""><br>
&gt;<br>
&gt; In our case we have a controller coming back online after doing someth=
ing. All the LUNs are re-discovered by the initiator and an sd device gets =
created for each LUN path which came back. The serial of the sd device at t=
hat time I believe is known to the initiator. The multipathd gets that sd d=
evice and comes up with a wwid. I would expect that wwid would be just the =
serial number plus some bytes in the beginning but that is not what we see =
in the fail case. The path wwid and path serial are pointing to different v=
olumes on the array. I expect that the sd device will show the same data fo=
r page 0x83 and page 0x80 pointing to the same volume on the array but I wi=
ll verify that with more logging.<br>

&gt;<br>
</div>Similar to what I said above, you could change the log message in<br>
scsi_ioctl_pathinfo (after the get_serial call) from level 3 to level 2.<br=
>
<br>
Beyond that, I don&#39;t have many more ideas here.. =C2=A0Another wild gue=
ss, I<br>
suppose it&#39;s possible that the data from the 0x83 inquiry at the time o=
f<br>
discovery could be incomplete? =C2=A0Then, when you run the command later,<=
br>
manually, after it comes up, it appears just fine. I don&#39;t think I see<=
br>
the code zeroing the memory for the wwid in the newly allocated path<br>
struct before it tries to populate the buffer, but that seems kind of<br>
farfetched.<br>
<div class=3D""><br>
&gt; You can see from my previous posts on this issue. (They go back for so=
me time). That the page 0x83 and page 0x80 from sg3_utils show that they po=
int to same LUN but different from the dm device that they are coalesced un=
der.<br>

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
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</div></div></blockquote></div><br></div>

--089e0149beca3104ae04f976b860--


--===============4161854571196469086==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4161854571196469086==--
