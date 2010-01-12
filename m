From: "Chelly Youssef (ISEFC)" <chilonnb@gmail.com>
Subject: Re: Problem Delay construction of multipath device
Date: Tue, 12 Jan 2010 13:03:15 +0100
Message-ID: <a960d84c1001120403r738e1b2br1cc9a57ebf90c942@mail.gmail.com>
References: <a960d84c1001110316r59c2443bx9feee2da793b7946@mail.gmail.com>
	<561c252c1001120045r7cde4af1jf8bb7c05bb1a1315@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9127650634375173611=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <561c252c1001120045r7cde4af1jf8bb7c05bb1a1315@mail.gmail.com>
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

--===============9127650634375173611==
Content-Type: multipart/alternative; boundary=0015174c0f185336da047cf67011

--0015174c0f185336da047cf67011
Content-Type: text/plain; charset=ISO-8859-1

hi,

i use rhel 5.4 and my hw/sw config is supported. how can i open a case. you
have the link ?

Thanks.

2010/1/12 Gianluca Cecchi <gianluca.cecchi@gmail.com>

> On Mon, Jan 11, 2010 at 12:16 PM, Chelly Youssef (ISEFC)
> <chilonnb@gmail.com> wrote:
> > Problem: Delay construction of multipath device (/ dev/dm-3)
> [snip]
>
> > My fstab :
> [snip]
>
> [snip]
> > I made the upgrade to Redhat 5.4 (2.6.18-164.el5) but I have not solved
> the
> > problem. It must be done at boot
> >
> > How I can do. I can give you my "sosreport" if you want.
> [snip]
>
> I don't know if you have some problems related to latencies or oher,
> but I have two comments:
>
> - In general, at least in rh el 5.x, dm-x names are not persistent
> across reboots, so I think it is not safe to directly refer them in
> fstab.
> You can make a label on the fs, such as this, if they are ext2/3/4
>
> tune2fs -L homefs /dev/mpath2 (with /home umounted and pointing to
> mpath2 in this case)
>
> and then in fstab
> LABEL=homefs             240G  148G   93G  62% /home
>
> or create a volume group and refer the LV with something like this in
> fstab (VG=vgname, LV=lvname) in the first column:
> /dev/mapper/vgname-lvname
>
> - If you are using rh el 5.4 and your hw/sw config is supported you
> can open a case....
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--0015174c0f185336da047cf67011
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">hi,<br><br>i use rhel 5.4 and my hw/sw config is supported=
. how can i open a case. you have the link ?<br><br>Thanks.<br><br><div cla=
ss=3D"gmail_quote">2010/1/12 Gianluca Cecchi <span dir=3D"ltr">&lt;<a href=
=3D"mailto:gianluca.cecchi@gmail.com">gianluca.cecchi@gmail.com</a>&gt;</sp=
an><br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class=3D"im"=
>On Mon, Jan 11, 2010 at 12:16 PM, Chelly Youssef (ISEFC)<br>
&lt;<a href=3D"mailto:chilonnb@gmail.com">chilonnb@gmail.com</a>&gt; wrote:=
<br>
&gt; Problem: Delay construction of multipath device (/ dev/dm-3)<br>
</div>[snip]<br>
<br>
&gt; My fstab=A0:<br>
[snip]<br>
<br>
[snip]<br>
<div class=3D"im">&gt; I made the upgrade to Redhat 5.4 (2.6.18-164.el5) bu=
t I have not solved the<br>
&gt; problem. It must be done at boot<br>
&gt;<br>
&gt; How I can do. I can give you my &quot;sosreport&quot; if you want.<br>
</div>[snip]<br>
<br>
I don&#39;t know if you have some problems related to latencies or oher,<br=
>
but I have two comments:<br>
<br>
- In general, at least in rh el 5.x, dm-x names are not persistent<br>
across reboots, so I think it is not safe to directly refer them in<br>
fstab.<br>
You can make a label on the fs, such as this, if they are ext2/3/4<br>
<br>
tune2fs -L homefs /dev/mpath2 (with /home umounted and pointing to<br>
mpath2 in this case)<br>
<br>
and then in fstab<br>
LABEL=3Dhomefs =A0 =A0 =A0 =A0 =A0 =A0 240G =A0148G =A0 93G =A062% /home<br=
>
<br>
or create a volume group and refer the LV with something like this in<br>
fstab (VG=3Dvgname, LV=3Dlvname) in the first column:<br>
/dev/mapper/vgname-lvname<br>
<br>
- If you are using rh el 5.4 and your hw/sw config is supported you<br>
can open a case....<br>
<font color=3D"#888888"><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a></font></blockquote=
></div><br></div>

--0015174c0f185336da047cf67011--


--===============9127650634375173611==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============9127650634375173611==--
