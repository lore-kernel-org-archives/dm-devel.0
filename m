From: Eli Klein <elijah@aclue.com>
Subject: Re: Question regarding failback option in multipath.conf
Date: Fri, 2 Oct 2009 08:40:20 -0600
Message-ID: <3f5a695c0910020740u90e8c87xca2ffe2decb55946@mail.gmail.com>
References: <5A70833B-9208-470E-88B7-7C351EED2122@aclue.com>
	<4AC3AC88.9020404@redhat.com>
	<06F122DE-B7E5-4721-BA08-D0453D10581C@aclue.com>
	<4AC3B084.4060700@redhat.com>
	<B38A0B62-A47C-4400-B113-5D46D13453D6@aclue.com>
	<3f5a695c0910011416i6d87dcbcr94a04dfd825fba04@mail.gmail.com>
	<1254443952.6539.11.camel@jaspav.missionsit.net.missionsit.net>
	<3f5a695c0910011801r607e0890t45802be2bbb52a26@mail.gmail.com>
	<4AC60EA3.8070505@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0126609592=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AC60EA3.8070505@redhat.com>
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

--===============0126609592==
Content-Type: multipart/alternative; boundary=0016e68e910a8756550474f4bf4d

--0016e68e910a8756550474f4bf4d
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Oct 2, 2009 at 8:30 AM, John Brier <jbrier@redhat.com> wrote:

> On 10/01/2009 09:01 PM, Eli Klein wrote:
>
>> Sorry, I forgot to mention that I did.. it didn't help.
>> In addition, from the output of multipath -v3, multipathd is picking up
>> all
>> of the correct settings, even with the two separate default sections.
>>
>>
> It seems like you set it all up right but failback isn't working like it
> *seems* it should. (I have never needed it) If you're interested in a hack..
>
> Since you don't seem to care how long it takes to failover, you could do
> the *opposite* of what this kbase recommends:
>
> How can I improve the failover time of a faulty path when using
> device-mapper-multipath over iSCSI?
>
> http://kbase.redhat.com/faq/docs/DOC-2877
>
>
> Aside from that I would suggest you open a support case with Red Hat if the
> box is covered under a support contract.
>
>
> John Brier
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

I've seen that doc before (it was helpful!).  Unfortunately, I *do* care
about how long it takes for the initial failover.  I have this configured to
take 15 seconds at the moment.  One thing that's interesting is that even
when I had "node.session.timeo.replacement_timeout" set to 120 seconds, the
failback was still immediate. The initial failover would take at minimum 120
seconds.

All of my problems seem to be cause by what appears to be a failback
parameter that doesn't actually have any effect.  I'll have to open up a
support case to get to the bottom of the failback issues.

Thank you very much for your help!

-Eli

--0016e68e910a8756550474f4bf4d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div><br></div><div class=3D"gmail_quote">On Fri, Oct 2, 2009 at 8:30 AM, J=
ohn Brier <span dir=3D"ltr">&lt;<a href=3D"mailto:jbrier@redhat.com">jbrier=
@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">

<div class=3D"im">On 10/01/2009 09:01 PM, Eli Klein wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Sorry, I forgot to mention that I did.. it didn&#39;t help.<br>
In addition, from the output of multipath -v3, multipathd is picking up all=
<br>
of the correct settings, even with the two separate default sections.<br>
<br>
</blockquote>
<br></div>
It seems like you set it all up right but failback isn&#39;t working like i=
t *seems* it should. (I have never needed it) If you&#39;re interested in a=
 hack..<br>
<br>
Since you don&#39;t seem to care how long it takes to failover, you could d=
o the *opposite* of what this kbase recommends:<br>
<br>
How can I improve the failover time of a faulty path when using device-mapp=
er-multipath over iSCSI?<br>
<br>
<a href=3D"http://kbase.redhat.com/faq/docs/DOC-2877" target=3D"_blank">htt=
p://kbase.redhat.com/faq/docs/DOC-2877</a><br>
<br>
<br>
Aside from that I would suggest you open a support case with Red Hat if the=
 box is covered under a support contract.<div><div></div><div class=3D"h5">=
<br>
<br>
John Brier<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</div></div></blockquote></div><br><div><div>I&#39;ve seen that doc before =
(it was helpful!). =A0Unfortunately, I *do* care about how long it takes fo=
r the initial failover. =A0I have this configured to take 15 seconds at the=
 moment. =A0One thing that&#39;s interesting is that even when I had &quot;=
<span class=3D"Apple-style-span" style=3D"font-family: monospace, Arial, He=
lvetica, sans-serif; font-size: 12px; color: rgb(51, 51, 51); white-space: =
pre; ">node.session.timeo.replacement_timeout&quot;</span><span class=3D"Ap=
ple-style-span" style=3D"font-size: 12px; color: rgb(51, 51, 51); white-spa=
ce: pre; "><font class=3D"Apple-style-span" face=3D"arial, helvetica, sans-=
serif"> <span class=3D"Apple-style-span" style=3D"font-size: small; ">set t=
o 120 seconds, the failback was still immediate.  The initial failover woul=
d take at minimum 120 seconds.</span></font></span></div>

<div><font class=3D"Apple-style-span" color=3D"#333333" face=3D"arial, helv=
etica, sans-serif"><span class=3D"Apple-style-span" style=3D"white-space: p=
re; "><br></span></font></div><div>All of my problems seem to be cause by w=
hat appears to be a failback parameter that doesn&#39;t actually have any e=
ffect. =A0I&#39;ll have to open up a support case to get to the bottom of t=
he failback issues.</div>

<div><br></div><div>Thank you very much for your help!</div><div><br></div>=
<div>-Eli</div><div><br></div></div>

--0016e68e910a8756550474f4bf4d--


--===============0126609592==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0126609592==--
