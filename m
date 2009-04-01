From: Rodrigo Nascimento <nascimento.rp@gmail.com>
Subject: Re: Device Mapper MultiPath
Date: Tue, 31 Mar 2009 21:59:13 -0300
Message-ID: <af7b4eb20903311759g1e97fb53u45cc6b6350a6022a@mail.gmail.com>
References: <af7b4eb20903311707o925902dn14a6dc8030498001@mail.gmail.com>
	<20090401002559.GA3213@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0192347556=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090401002559.GA3213@mars.virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

--===============0192347556==
Content-Type: multipart/alternative; boundary=000e0cd56aa4f6d5dc046673d26d

--000e0cd56aa4f6d5dc046673d26d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Konrad,

Thanks for your tips.
I'll run this tests and post the results here!

Now, I'm a Professional Services Engineer at NetApp Latin America (Brazil)
and I have some problems with FAS3140 and Citrix Xen 5.0.0 with Multipathing
enabled. Do you think that I could have some help here?

See you,

:-)

On Tue, Mar 31, 2009 at 9:25 PM, Konrad Rzeszutek <konrad@virtualiron.com>wrote:

> On Tue, Mar 31, 2009 at 09:07:08PM -0300, Rodrigo Nascimento wrote:
> > Hi All,
> >
> > I'm a student of computer sciences and I'd like to collaborate with the
> > development of the DM-MP.
> > I know that maybe you received this kind of message during all time, but
> I
>
> I think you are the first :-)
>
> > really want to help, with anything.
>
> Shakedown help would be nice. As in, trying to yank stuff underneath it,
> add new block disks, remove them, add them, remove them, edit the
> multipath.conf file and issue 'reconfigure', resize the maps,
> then add 1000+LUNs, and while they are being added, start removing the
> LUNs, then for extra fun call 'dmsetup remove_all' while in another
> thread you run 'multipath'. Ooh, and see if there are any memory leaks
> while this all is being done.
>
> >
> > I'd appreciate if someone help me how to begin here. :)
> >
> > Rgds,
> >
> > --
> > Rodrigo Nascimento
>
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



-- 
Rodrigo Nascimento

--000e0cd56aa4f6d5dc046673d26d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Konrad, </div>
<div>=A0</div>
<div>Thanks for your tips.</div>
<div>I&#39;ll run this tests and post the results here!</div>
<div>=A0</div>
<div>Now, I&#39;m a Professional Services Engineer at NetApp Latin America =
(Brazil) and I have some problems with FAS3140 and Citrix Xen 5.0.0=A0with =
Multipathing enabled. Do you think that I could have some help here?</div>

<div>=A0</div>
<div>See you,</div>
<div>=A0</div>
<div>:-)<br><br></div>
<div class=3D"gmail_quote">On Tue, Mar 31, 2009 at 9:25 PM, Konrad Rzeszute=
k <span dir=3D"ltr">&lt;<a href=3D"mailto:konrad@virtualiron.com" target=3D=
"_blank">konrad@virtualiron.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div>On Tue, Mar 31, 2009 at 09:07:08PM -0300, Rodrigo Nascimento wrote:<br=
>&gt; Hi All,<br>&gt;<br>&gt; I&#39;m a student of computer sciences and I&=
#39;d like to collaborate with the<br>&gt; development of the DM-MP.<br>
&gt; I know that maybe you received this kind of message during all time, b=
ut I<br><br></div>I think you are the first :-)<br>
<div><br>&gt; really want to help, with anything.<br><br></div>Shakedown he=
lp would be nice. As in, trying to yank stuff underneath it,<br>add new blo=
ck disks, remove them, add them, remove them, edit the<br>multipath.conf fi=
le and issue &#39;reconfigure&#39;, resize the maps,<br>
then add 1000+LUNs, and while they are being added, start removing the<br>L=
UNs, then for extra fun call &#39;dmsetup remove_all&#39; while in another<=
br>thread you run &#39;multipath&#39;. Ooh, and see if there are any memory=
 leaks<br>
while this all is being done.<br>
<div><br>&gt;<br>&gt; I&#39;d appreciate if someone help me how to begin he=
re. :)<br>&gt;<br>&gt; Rgds,<br>&gt;<br>&gt; --<br>&gt; Rodrigo Nascimento<=
br><br></div>&gt; --<br>&gt; dm-devel mailing list<br>&gt; <a href=3D"mailt=
o:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D=
"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a><br><font colo=
r=3D"#888888"><br>--<br>dm-devel mailing list<br><a href=3D"mailto:dm-devel=
@redhat.com" target=3D"_blank">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br></font></blockq=
uote></div><br><br clear=3D"all"><br>-- <br>Rodrigo Nascimento<br>

--000e0cd56aa4f6d5dc046673d26d--


--===============0192347556==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0192347556==--
