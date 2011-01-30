From: nishant mungse <nishantmungse@gmail.com>
Subject: Re: How to test the read/write flow of dm-target.
Date: Sun, 30 Jan 2011 13:37:40 -0500
Message-ID: <AANLkTikhUWPRSX87+o6BcTa8iEmh6Db0qD821ocDLV+A@mail.gmail.com>
References: <AANLkTimQjYdRqLFpuystxuN5hM=rGirj9XBiA_zDkG7+@mail.gmail.com>
	<20110128194241.GB4616@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4113838737418416374=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110128194241.GB4616@us.ibm.com>
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

--===============4113838737418416374==
Content-Type: multipart/alternative; boundary=e0cb4e43cee91714f7049b14988e

--e0cb4e43cee91714f7049b14988e
Content-Type: text/plain; charset=ISO-8859-1

Hi Malahal

Is there any way to find the last sector of bio.
Is this a correct way to find last sector of bio

"bio->bi_sector=bio->bi_sector + (bio->bi_size >> 9)-1"

or

bio_for_each_segment(bvec,bio,
idx)
{
 bio->bi_sector=bio->bi_sector + (bvec->bv_len >> 9) -1;
}
Actually what i think both are same thing but in different way. Will this
bio->bi_sector point to last sector of bio if bio->bi_vcnt is greater than
1.
What is correct way to find/get last sector from bio?
Regards,
Nishant.


On Fri, Jan 28, 2011 at 2:42 PM, Malahal Naineni <malahal@us.ibm.com> wrote:

> nishant mungse [nishantmungse@gmail.com] wrote:
> > Hi,
> >
> > I've created a device mapper target and I wanna test its read and
> > write mechanisms. I created a device using this target and tried to
> > write a filesystem on to the device.
> >
> > My target is creating roughly two outgoing bios per incoming bio.
> > Which is maybe why I'm not able to get a proper log after running the
> > mke2fs command as while writing the filesystem, there are massive
> > amounts of writes performed on the device.
> >
> > So, I tried to use the cat command to directly write to the device
> > file. The write is being performed for sure because I'm able to view
> > the data written to the underlying device.
> >
> > But there is no output when I try to read the device file contents using
> cat.
> >
> > Is there any other way to test the read/write workflows of a dm target
> > that can give out a proper log ?
>
> I am not sure what you mean by 'proper log'. I would use 'dd' with
> direct I/O to avoid cache so that every read and write directly go to the
> device. I don't think you can do that with 'cat' command.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--e0cb4e43cee91714f7049b14988e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Malahal<br>
<br>
Is there any way to find the last sector of bio. <br>
Is this a correct way to find last sector of bio <br><br>&quot;bio-&gt;bi_s=
ector=3Dbio-&gt;bi_sector + (bio-&gt;bi_size &gt;&gt; 9)-1&quot;<br>
<br>or<br>
<br>bio_for_each_segment(bvec,bio,<div id=3D":1ae">idx)<br>
{<br>
=A0bio-&gt;bi_sector=3Dbio-&gt;bi_sector + (bvec-&gt;bv_len &gt;&gt; 9) -1;=
<br>
}<br>
Actually what i think both are same thing but in different way. Will this b=
io-&gt;bi_sector point to last sector of bio if bio-&gt;bi_vcnt is greater =
than 1.<br>
What is correct way to find/get last sector from bio?<br>
Regards,<br><font color=3D"#888888">
Nishant.</font></div><br><br><div class=3D"gmail_quote">On Fri, Jan 28, 201=
1 at 2:42 PM, Malahal Naineni <span dir=3D"ltr">&lt;<a href=3D"mailto:malah=
al@us.ibm.com">malahal@us.ibm.com</a>&gt;</span> wrote:<br><blockquote clas=
s=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margi=
n: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div><div></div><div class=3D"h5">nishant mungse [<a href=3D"mailto:nishant=
mungse@gmail.com">nishantmungse@gmail.com</a>] wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; I&#39;ve created a device mapper target and I wanna test its read and<=
br>
&gt; write mechanisms. I created a device using this target and tried to<br=
>
&gt; write a filesystem on to the device.<br>
&gt;<br>
&gt; My target is creating roughly two outgoing bios per incoming bio.<br>
&gt; Which is maybe why I&#39;m not able to get a proper log after running =
the<br>
&gt; mke2fs command as while writing the filesystem, there are massive<br>
&gt; amounts of writes performed on the device.<br>
&gt;<br>
&gt; So, I tried to use the cat command to directly write to the device<br>
&gt; file. The write is being performed for sure because I&#39;m able to vi=
ew<br>
&gt; the data written to the underlying device.<br>
&gt;<br>
&gt; But there is no output when I try to read the device file contents usi=
ng cat.<br>
&gt;<br>
&gt; Is there any other way to test the read/write workflows of a dm target=
<br>
&gt; that can give out a proper log ?<br>
<br>
</div></div>I am not sure what you mean by &#39;proper log&#39;. I would us=
e &#39;dd&#39; with<br>
direct I/O to avoid cache so that every read and write directly go to the<b=
r>
device. I don&#39;t think you can do that with &#39;cat&#39; command.<br>
<font color=3D"#888888"><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</font></blockquote></div><br>

--e0cb4e43cee91714f7049b14988e--


--===============4113838737418416374==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4113838737418416374==--
