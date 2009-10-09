From: "j.Lucas" <lukasz.jurewicz@gmail.com>
Subject: Re: Help with MPIO assigning / blacklisting
Date: Fri, 9 Oct 2009 14:59:46 +0200
Message-ID: <8f3e95600910090559g10d267e3l3ba2c398d57aa7b4@mail.gmail.com>
References: <8f3e95600910081515x1257d9fbud365667c7e55c713@mail.gmail.com>
	<1255042244.10144.2.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1034221298=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1255042244.10144.2.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1034221298==
Content-Type: multipart/alternative; boundary=0015175df46eb602b80475802863

--0015175df46eb602b80475802863
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

According to SLES partitions do work and uses the kpratx tool  (partition
seem to work fine in MPIO when I manually set them up)=85 the issue isn=92t=
 them
working it is trying to limit mpio to only addressing the partitions by
using the blacklist option  (which seems to suggest it is very possible)



On Fri, Oct 9, 2009 at 12:50 AM, Chandra Seetharaman <sekharan@us.ibm.com>w=
rote:

> Hi Lucas,
>
> You can setup multipath only for block devices and not "partitions". You
> will be able to setup multipathing to sdb and use the multipathed
> partition corresponding to sdb1 for your purposes.
>
> You will not be able to setup multipathing to sdb1 and not sdb2.
>
> chandra
> On Fri, 2009-10-09 at 00:15 +0200, j.Lucas wrote:
> > I apologize if this is a simple question but I have tried in every
> > place I can google to resolve this before posting this.  The problem I
> > have (and hoping someone will help resolve) is:
> >
> > Setting up a MPIO SAS configuration it is important to me that I have
> > multiple paths to a partition on each drive.. each drive has two
> > partitions, but only one is of interest.  So we normal have eg sdb,
> > sdb1 and sdb2.  However we only want to MPIO to sdb1.
> >
> > Manually this would maybe seem easy, but there is likely to be many
> > many drives and hot-plugged in and out etc=85 so it seems sensible to
> > use the option of black listing and exclusions from black lists so
> > that DM only addresses sdx1=85.. but this is where my problems start an=
d
> > my hair fails out.
> >
> > I have tried reading everything I can find on this, and tried all
> > options I can think of=85 but I cannot get it work like this.  In fact =
I
> > cannot seem to get it to by default see any of the partitions (without
> > having to manually run something).
> >
> > I have even tried to blacklist ALL sd[a-z]  (which seems to work) but
> > exclude i.e. sdb1 which doesn=92t seem to work.
> >
> > I really would appreciate any advice as I am sure that to someone who
> > has the experience here will probably be able to resolve this in a
> > couple of lines as opposed to my couple of years!
> >
> > Thank you
> >
> > --
> > Lucas
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



--=20
Lucas

--0015175df46eb602b80475802863
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

According to SLES partitions do work and uses the kpratx tool=A0 (partition=
 seem to work fine in MPIO when I manually set them up)=85 the issue isn=92=
t them working it is trying to limit mpio to only addressing the partitions=
 by using the blacklist option=A0 (which seems to suggest it is very possib=
le)<br>

<br><br><br><div class=3D"gmail_quote">On Fri, Oct 9, 2009 at 12:50 AM, Cha=
ndra Seetharaman <span dir=3D"ltr">&lt;<a href=3D"mailto:sekharan@us.ibm.co=
m">sekharan@us.ibm.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_=
quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt =
0pt 0.8ex; padding-left: 1ex;">

Hi Lucas,<br>
<br>
You can setup multipath only for block devices and not &quot;partitions&quo=
t;. You<br>
will be able to setup multipathing to sdb and use the multipathed<br>
partition corresponding to sdb1 for your purposes.<br>
<br>
You will not be able to setup multipathing to sdb1 and not sdb2.<br>
<br>
chandra<br>
<div><div></div><div class=3D"h5">On Fri, 2009-10-09 at 00:15 +0200, j.Luca=
s wrote:<br>
&gt; I apologize if this is a simple question but I have tried in every<br>
&gt; place I can google to resolve this before posting this. =A0The problem=
 I<br>
&gt; have (and hoping someone will help resolve) is:<br>
&gt;<br>
&gt; Setting up a MPIO SAS configuration it is important to me that I have<=
br>
&gt; multiple paths to a partition on each drive.. each drive has two<br>
&gt; partitions, but only one is of interest. =A0So we normal have eg sdb,<=
br>
&gt; sdb1 and sdb2. =A0However we only want to MPIO to sdb1.<br>
&gt;<br>
&gt; Manually this would maybe seem easy, but there is likely to be many<br=
>
&gt; many drives and hot-plugged in and out etc=85 so it seems sensible to<=
br>
&gt; use the option of black listing and exclusions from black lists so<br>
&gt; that DM only addresses sdx1=85.. but this is where my problems start a=
nd<br>
&gt; my hair fails out.<br>
&gt;<br>
&gt; I have tried reading everything I can find on this, and tried all<br>
&gt; options I can think of=85 but I cannot get it work like this. =A0In fa=
ct I<br>
&gt; cannot seem to get it to by default see any of the partitions (without=
<br>
&gt; having to manually run something).<br>
&gt;<br>
&gt; I have even tried to blacklist ALL sd[a-z] =A0(which seems to work) bu=
t<br>
&gt; exclude i.e. sdb1 which doesn=92t seem to work.<br>
&gt;<br>
&gt; I really would appreciate any advice as I am sure that to someone who<=
br>
&gt; has the experience here will probably be able to resolve this in a<br>
&gt; couple of lines as opposed to my couple of years!<br>
&gt;<br>
&gt; Thank you<br>
&gt;<br>
&gt; --<br>
&gt; Lucas<br>
</div></div>&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D=
"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
<font color=3D"#888888"><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</font></blockquote></div><br><br clear=3D"all"><br>-- <br>Lucas<br>

--0015175df46eb602b80475802863--


--===============1034221298==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1034221298==--
