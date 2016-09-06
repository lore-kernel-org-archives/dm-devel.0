From: Dennis Yang <dennisyang@qnap.com>
Subject: Re: Possible data corruption with dm-thin
Date: Tue, 6 Sep 2016 12:51:28 +0800
Message-ID: <CAAR726Krf6jU2SxghEZ_4OcGUU40rNaosyGcb9oPDvF2WHnxPw@mail.gmail.com>
References: <CAAR726JWQ4VKOVR87QX6Tmuhu1JnCymm7coLT=TFn3BseKm8XA@mail.gmail.com>
	<20160624135510.GA13946@roamer.bos.redhat.com>
	<CAAR726KCTJnbJhU-XhAn0xv3RVEHZY-NFjSNnWqnuVVO6kR4xQ@mail.gmail.com>
	<20160701131856.GB32440@roamer.bos.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2883992202260472129=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160701131856.GB32440@roamer.bos.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dennis Yang <dennisyang@qnap.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2883992202260472129==
Content-Type: multipart/alternative; boundary=047d7b874df4e85659053bcf8de8

--047d7b874df4e85659053bcf8de8
Content-Type: text/plain; charset=UTF-8

Hi Joe,

Sorry for the late reply. We have been fixing bugs and conducting many
experiments with heavy I/O to verify the correctness and stability of our
storage. This problem I mentioned in this thread cannot be reproduced
anymore with these two patches (I applied them back to 3.19.8 and 4.2.8 and
both work fine).

Thanks for your help.

Dennis

2016-07-01 21:18 GMT+08:00 Edward Thornber <thornber@redhat.com>:

> Hi Dennis,
>
> Sorry to take so long about getting back to you.  There was a bug in
> the btree library that I mistakenly thought was caused by my fix for
> your problem.  Anyway, could you try and recreate your problem with
> these two patches applied please (patches are against v4.7-rc5 + my
> usual thin-dev extras):
>
>     https://github.com/jthornber/linux-2.6/commit/
> ebdd99fc12acd0e9178831549896633171d5af1d
>     https://github.com/jthornber/linux-2.6/commit/
> c05989b59d091270c2bf7dd05bdb7a3575223529
>
> Thanks,
>
> - Joe
>



-- 
Dennis Yang
QNAP Systems, Inc.
Skype: qnap.dennis.yang
Email: dennisyang@qnap.com
Tel: (+886)-2-2393-5152 ext. 15018
Address: 13F., No.56, Sec. 1, Xinsheng S. Rd., Zhongzheng Dist., Taipei
City, Taiwan

--047d7b874df4e85659053bcf8de8
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Joe,<div><br></div><div>Sorry for the late reply. We ha=
ve been fixing bugs and conducting many experiments with heavy I/O to verif=
y the correctness and stability of our storage. This problem I mentioned in=
 this thread cannot be reproduced anymore with these two patches (I applied=
 them back to 3.19.8 and 4.2.8 and both work fine).</div><div><br></div><di=
v>Thanks for your help.</div><div><br></div><div>Dennis=C2=A0</div></div><d=
iv class=3D"gmail_extra"><br><div class=3D"gmail_quote">2016-07-01 21:18 GM=
T+08:00 Edward Thornber <span dir=3D"ltr">&lt;<a href=3D"mailto:thornber@re=
dhat.com" target=3D"_blank">thornber@redhat.com</a>&gt;</span>:<br><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc s=
olid;padding-left:1ex">Hi Dennis,<br>
<br>
Sorry to take so long about getting back to you.=C2=A0 There was a bug in<b=
r>
the btree library that I mistakenly thought was caused by my fix for<br>
your problem.=C2=A0 Anyway, could you try and recreate your problem with<br=
>
these two patches applied please (patches are against v4.7-rc5 + my<br>
usual thin-dev extras):<br>
<br>
=C2=A0 =C2=A0 <a href=3D"https://github.com/jthornber/linux-2.6/commit/ebdd=
99fc12acd0e9178831549896633171d5af1d" rel=3D"noreferrer" target=3D"_blank">=
https://github.com/jthornber/<wbr>linux-2.6/commit/<wbr>ebdd99fc12acd0e9178=
83154989663<wbr>3171d5af1d</a><br>
=C2=A0 =C2=A0 <a href=3D"https://github.com/jthornber/linux-2.6/commit/c059=
89b59d091270c2bf7dd05bdb7a3575223529" rel=3D"noreferrer" target=3D"_blank">=
https://github.com/jthornber/<wbr>linux-2.6/commit/<wbr>c05989b59d091270c2b=
f7dd05bdb7a<wbr>3575223529</a><br>
<br>
Thanks,<br>
<br>
- Joe<br>
</blockquote></div><br><br clear=3D"all"><div><br></div>-- <br><div class=
=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=3D"ltr"><s=
pan lang=3D"EN-US" style=3D"font-size:10pt;font-family:Arial,sans-serif">De=
nnis Yang=C2=A0</span><span lang=3D"EN-US" style=3D"font-size:10pt;font-fam=
ily:Arial,sans-serif">=C2=A0</span><span lang=3D"EN-US" style=3D"font-size:=
10pt;font-family:Arial,sans-serif"><br>QNAP Systems, Inc.</span><div><span =
lang=3D"EN-US" style=3D"font-size:10pt;font-family:Arial,sans-serif">Skype:=
 qnap.dennis.yang<br>Email:</span><span lang=3D"EN-US" style=3D"font-size:1=
0pt;font-family:Arial,sans-serif">=C2=A0<a href=3D"mailto:dennisyang@qnap.c=
om" target=3D"_blank">dennisyang@qnap.com</a></span><div><span lang=3D"EN-U=
S" style=3D"font-size:10pt;font-family:Arial,sans-serif">Tel:</span><span s=
tyle=3D"font-family:Arial,sans-serif;font-size:13.333333969116211px">=C2=A0=
(+886)-2-2393-5152 ext.=C2=A0</span><span style=3D"font-family:Arial,sans-s=
erif;font-size:13.333333969116211px">15018</span><div><font face=3D"Arial, =
sans-serif" size=3D"2">Address:=C2=A0</font><span style=3D"color:rgb(51,51,=
51);font-family:Verdana,Arial,Helvetica,sans-serif;font-size:12px;line-heig=
ht:18.66666603088379px">13F., No.56, Sec. 1, Xinsheng S. Rd., Zhongzheng Di=
st., Taipei City, Taiwan</span></div></div></div></div></div>
</div>

--047d7b874df4e85659053bcf8de8--


--===============2883992202260472129==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2883992202260472129==--
