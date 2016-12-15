From: muneendra kumar <muneendra737@gmail.com>
Subject: Fwd: how do i push my changes in dm layer to main stream
Date: Thu, 15 Dec 2016 15:09:34 +0530
Message-ID: <CAAhcyz=CQLUUecAEjLnnsy5C3MFES=u61aomE-0mDNRdUndTJw@mail.gmail.com>
References: <CAAhcyzn4EJo2J9xiBDbO5k3qWO13qTmvwhxFgGVVHrGmGdVVcQ@mail.gmail.com>
	<ecd4fe04-be9b-8a49-9175-413639fb6d7e@redhat.com>
	<CAAhcyzn=gnpp4_UOwLQ9bH__kvNDbJ+tHGoaeV2SKqjQbm9gSQ@mail.gmail.com>
	<CAAhcyz=_sL5AkPCEcwQ8HqWn6acURDy6eQ0OB_fD_QDQ02h_gQ@mail.gmail.com>
	<CAAhcyzk+bK0+fLjZ0Qdp-tcAcRNr+nVXgzZVjKwbP+bwH9VC_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5828284486737098534=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAhcyzk+bK0+fLjZ0Qdp-tcAcRNr+nVXgzZVjKwbP+bwH9VC_A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============5828284486737098534==
Content-Type: multipart/alternative; boundary=089e01493e86364e7a0543af3b42

--089e01493e86364e7a0543af3b42
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

I'm working on device-mapper multipath (dm-multipath).

This patch set adds a new hook for device-mapper in deciding the health of =
the

Of the multipath which helps in getting the deterministic Application
IO throughput.



This patch set is preliminary tested on active-active 2 paths storage.

But the patch set still needs work and is not ready for inclusion.

I'm posting it because I'd like to get comments about high-level

design before going further in details.







This patch set should be applied on top of 3.10.0 #18





=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Background

=3D-=3D-=3D-=3D-=3D-=3D



=E2=80=A2        =E2=80=9CSick but not Dead=E2=80=9D MPIO Path

=E2=80=92       Path goes into Failed state because of path IO error as see=
n
by DM driver

=E2=80=92       When the multipath daemon issues TUR command  finds health =
of
the failed path is good, makes the same path into Active state

=E2=80=92       Path repeatedly toggles between Failed and Active Path Stat=
es

=E2=80=A2        DM IO is retried on path where we are hitting multiple err=
ors.

=E2=80=A2        Causing erratic (non-deterministic) Application IO through=
put



The current existing DM layer doesn't consider the amount of errors to
decide the health of the path.

Since the failed path is becoming active immediately when the tur
command succeeds the end user will be in a

Assumption that all the multipaths are in good state.

When we run some of the field tests with this scenario we saw a
non-deterministic io throughput









=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Design Overview

=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D



=E2=80=A2        Deterministically bring the path to =E2=80=9CFaulty=E2=80=
=9D state

=E2=80=92       Configure per-DM device data with

=E2=80=A2        IO error threshold and time window for the error threshold=
 to be hit

=E2=80=92       Declare a path Faulty when error threshold is hit within th=
e
configured time window

=E2=80=92       Place the path in the failed state for a predefined time
configured by the administrator

 using the config file

=E2=80=92       Even though multipath daemon validates the path using TUR
command which succeeds

 and tries to re-instantiate the path ignore the re-instantiate of the
path for a predefined time if the err threshold is hit.

=E2=80=A2        Give time for Administrator to correct the =E2=80=9CSick B=
ut not
Dead=E2=80=9D path and bring Path to Active

=E2=80=A2        Auto Enablement of a Faulty Path to Active State after a
fixed time duration (given as a config data for each DM)

=E2=80=92       Admin can set the Deterministic MPIO behavior on per-DM dev=
ice basis

-         It implies the failed path will be reinstantiated  either by
admin or when the timeout expires.

=E2=80=A2        The above configs will be made persistent across server re=
boots



Expected benefit:

-Deterministic Application IO throughput.

-We can give a time for the administrator to analyze the path failure
and recover the path.

- user space tools need minimum change .



The above feature will be enabled only if the corresponding variables
are defined in multipath.conf



Since these changes are irrespective of the underlying algorithms
which they are using in dm layer.

The changes are applied in dm.c and dm-mpath.c



alloc_dev(),reinstate_path(),parse_path(),fail_path() are the
functions which are going to be changed.





Need more comments on this as we started the testing and the results
look determenestic.



Regards,

Muneendra.


On Thu, Dec 15, 2016 at 3:00 PM, muneendra kumar <muneendra737@gmail.com>
wrote:

> Hello,
>
> This is the place where iam currently working and the details are given b=
elow
>
>
>
> I'm working on device-mapper multipath (dm-multipath).
>
> This patch set adds a new hook for device-mapper in deciding the health o=
f the
>
> Of the multipath which helps in getting the deterministic Application IO =
throughput.
>
>
>
> This patch set is preliminary tested on active-active 2 paths storage.
>
> But the patch set still needs work and is not ready for inclusion.
>
> I'm posting it because I'd like to get comments about high-level
>
> design before going further in details.
>
>
>
>
>
>
>
> This patch set should be applied on top of 3.10.0 #18
>
>
>
>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Background
>
> =3D-=3D-=3D-=3D-=3D-=3D
>
>
>
> =E2=80=A2        =E2=80=9CSick but not Dead=E2=80=9D MPIO Path
>
> =E2=80=92       Path goes into Failed state because of path IO error as s=
een by DM driver
>
> =E2=80=92       When the multipath daemon issues TUR command  finds healt=
h of the failed path is good, makes the same path into Active state
>
> =E2=80=92       Path repeatedly toggles between Failed and Active Path St=
ates
>
> =E2=80=A2        DM IO is retried on path where we are hitting multiple e=
rrors.
>
> =E2=80=A2        Causing erratic (non-deterministic) Application IO throu=
ghput
>
>
>
> The current existing DM layer doesn't consider the amount of errors to de=
cide the health of the path.
>
> Since the failed path is becoming active immediately when the tur command=
 succeeds the end user will be in a
>
> Assumption that all the multipaths are in good state.
>
> When we run some of the field tests with this scenario we saw a non-deter=
ministic io throughput
>
>
>
>
>
>
>
>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Design Overview
>
> =3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
>
>
>
> =E2=80=A2        Deterministically bring the path to =E2=80=9CFaulty=E2=
=80=9D state
>
> =E2=80=92       Configure per-DM device data with
>
> =E2=80=A2        IO error threshold and time window for the error thresho=
ld to be hit
>
> =E2=80=92       Declare a path Faulty when error threshold is hit within =
the configured time window
>
> =E2=80=92       Place the path in the failed state for a predefined time =
configured by the administrator
>
>  using the config file
>
> =E2=80=92       Even though multipath daemon validates the path using TUR=
 command which succeeds
>
>  and tries to re-instantiate the path ignore the re-instantiate of the pa=
th for a predefined time if the err threshold is hit.
>
> =E2=80=A2        Give time for Administrator to correct the =E2=80=9CSick=
 But not Dead=E2=80=9D path and bring Path to Active
>
> =E2=80=A2        Auto Enablement of a Faulty Path to Active State after a=
 fixed time duration (given as a config data for each DM)
>
> =E2=80=92       Admin can set the Deterministic MPIO behavior on per-DM d=
evice basis
>
> -         It implies the failed path will be reinstantiated  either by ad=
min or when the timeout expires.
>
> =E2=80=A2        The above configs will be made persistent across server =
reboots
>
>
>
> Expected benefit:
>
> -Deterministic Application IO throughput.
>
> -We can give a time for the administrator to analyze the path failure and=
 recover the path.
>
> - user space tools need minimum change .
>
>
>
>
>
> Since these changes are irrespective of the underlying algorithms which t=
hey are using in dm layer.
>
> The changes are applied in dm.c and dm-mpath.c
>
>
>
> alloc_dev(),reinstate_path(),parse_path(),fail_path() are the functions w=
hich are going to be changed.
>
>
>
>
>
> Need more comments on this as we started the testing and the results look=
 determenestic.
>
>
> On Mon, Dec 5, 2016 at 9:35 PM, muneendra kumar <muneendra737@gmail.com>
> wrote:
>
>> Thanks a lot for sharing the info.
>> I will discuss the problem in detail in my earlier mail,
>>
>> Regards,
>> Muneendra.
>>
>> On Mon, Dec 5, 2016 at 5:45 PM, Zdenek Kabelac <zkabelac@redhat.com>
>> wrote:
>>
>>> Dne 5.12.2016 v 07:29 muneendra kumar napsal(a):
>>>
>>>> Hi,
>>>> This is a general question.
>>>> If i do any changes in both multipath tool and dm driver (kernel).
>>>> How do i push my changes into main stream.
>>>> Can someone explain me the process so that it will help me a lot.
>>>>
>>>>
>>>
>>> Hi
>>>
>>> You propose your changes here on the list - you get a review and
>>> it the patches are found useful - maintainer of dm subsystem
>>> will accept them.
>>>
>>> Note - it's usually better to ask and discuss 'ahead' what is your
>>> problem
>>> and how do you want to improve/fix it.
>>> So you avoid losing time on implementing unacceptable patch.
>>>
>>> Regards
>>>
>>> Zdenek
>>>
>>>
>>>
>>>
>>
>

--089e01493e86364e7a0543af3b42
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_quote"><br><br><div dir=3D"ltr"><d=
iv><div class=3D"h5"><pre style=3D"white-space:pre-wrap"><span style=3D"col=
or:black">Hello,</span></pre><pre style=3D"white-space:pre-wrap">I&#39;m wo=
rking on device-mapper multipath (dm-multipath).<br></pre><pre style=3D"whi=
te-space:pre-wrap"><span style=3D"color:black">This patch set adds a new ho=
ok for device-mapper in deciding the health of the</span></pre><pre style=
=3D"white-space:pre-wrap"><span style=3D"color:black">Of the multipath whic=
h helps in getting the deterministic Application IO throughput.</span></pre=
><pre style=3D"white-space:pre-wrap"><span style=3D"color:black">=C2=A0</sp=
an></pre><pre style=3D"white-space:pre-wrap"><span style=3D"color:black">Th=
is patch set is preliminary tested on active-active 2 paths storage.</span>=
</pre><pre style=3D"white-space:pre-wrap"><span style=3D"color:black">But t=
he patch set still needs work and is not ready for inclusion.</span></pre><=
pre style=3D"white-space:pre-wrap"><span style=3D"color:black">I&#39;m post=
ing it because I&#39;d like to get comments about high-level</span></pre><p=
re style=3D"white-space:pre-wrap"><span style=3D"color:black">design before=
 going further in details.</span></pre><pre style=3D"white-space:pre-wrap">=
<span style=3D"color:black">=C2=A0</span></pre><pre style=3D"white-space:pr=
e-wrap"><span style=3D"color:black">=C2=A0</span></pre><pre style=3D"white-=
space:pre-wrap"><span style=3D"color:black">=C2=A0</span></pre><pre style=
=3D"white-space:pre-wrap"><span style=3D"color:black">This patch set should=
 be applied on top of 3.10.0 #18</span></pre><pre style=3D"white-space:pre-=
wrap"><span style=3D"color:black">=C2=A0</span></pre><pre style=3D"white-sp=
ace:pre-wrap"><span style=3D"color:black">=C2=A0</span></pre><pre style=3D"=
white-space:pre-wrap"><span style=3D"color:black">=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<wbr>=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D<wbr>=3D=3D=3D=3D=3D=3D=3D=3D</span></pre><pre style=3D"white-s=
pace:pre-wrap"><span style=3D"color:black">Background</span></pre><pre styl=
e=3D"white-space:pre-wrap"><span style=3D"color:black">=3D-=3D-=3D-=3D-=3D-=
=3D</span></pre><pre style=3D"white-space:pre-wrap"><span style=3D"color:bl=
ack">=C2=A0</span></pre><pre style=3D"white-space:pre-wrap;margin-left:0.5i=
n"><span style=3D"font-family:arial,sans-serif;color:black">=E2=80=A2<span =
style=3D"font-variant-numeric:normal;font-stretch:normal;font-size:7pt;line=
-height:normal;font-family:&quot;times new roman&quot;">=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><span style=3D"color:black">=E2=80=
=9CSick but not Dead=E2=80=9D MPIO Path</span></pre><pre style=3D"white-spa=
ce:pre-wrap;margin-left:1in"><span style=3D"font-family:arial,sans-serif;co=
lor:black">=E2=80=92<span style=3D"font-variant-numeric:normal;font-stretch=
:normal;font-size:7pt;line-height:normal;font-family:&quot;times new roman&=
quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><span style=3D"co=
lor:black">Path goes into Failed state because of path IO error as seen by =
DM driver</span></pre><pre style=3D"white-space:pre-wrap;margin-left:1in"><=
span style=3D"font-family:arial,sans-serif;color:black">=E2=80=92<span styl=
e=3D"font-variant-numeric:normal;font-stretch:normal;font-size:7pt;line-hei=
ght:normal;font-family:&quot;times new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 </span></span><span style=3D"color:black">When the multipat=
h daemon issues TUR command =C2=A0finds health of the failed path is good, =
makes the same path into Active state</span></pre><pre style=3D"white-space=
:pre-wrap;margin-left:1in"><span style=3D"font-family:arial,sans-serif;colo=
r:black">=E2=80=92<span style=3D"font-variant-numeric:normal;font-stretch:n=
ormal;font-size:7pt;line-height:normal;font-family:&quot;times new roman&qu=
ot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><span style=3D"colo=
r:black">Path repeatedly toggles between Failed and Active Path States</spa=
n></pre><pre style=3D"white-space:pre-wrap;margin-left:1.5in"><span style=
=3D"font-family:arial,sans-serif;color:black">=E2=80=A2<span style=3D"font-=
variant-numeric:normal;font-stretch:normal;font-size:7pt;line-height:normal=
;font-family:&quot;times new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 </span></span><span style=3D"color:black">DM IO is retried on pat=
h where we are hitting multiple errors.</span></pre><pre style=3D"white-spa=
ce:pre-wrap;margin-left:1.5in"><span style=3D"font-family:arial,sans-serif;=
color:black">=E2=80=A2<span style=3D"font-variant-numeric:normal;font-stret=
ch:normal;font-size:7pt;line-height:normal;font-family:&quot;times new roma=
n&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><span sty=
le=3D"color:black">Causing erratic (non-deterministic) Application IO throu=
ghput</span></pre><pre style=3D"white-space:pre-wrap"><span style=3D"color:=
black">=C2=A0</span></pre><pre style=3D"white-space:pre-wrap"><font color=
=3D"#000000">The current existing DM layer doesn&#39;t consider the amount =
of errors to decide the health of the path.</font></pre><pre style=3D"white=
-space:pre-wrap"><span style=3D"color:black">Since the failed path is becom=
ing active immediately when the tur command succeeds the end user will be i=
n a</span></pre><pre style=3D"white-space:pre-wrap"><span style=3D"color:bl=
ack">Assumption that all the multipaths are in good state.</span></pre><pre=
 style=3D"white-space:pre-wrap"><font color=3D"#000000">When we run some of=
 the field tests with this scenario we saw a non-deterministic io throughpu=
t</font></pre><pre style=3D"white-space:pre-wrap"><span style=3D"color:blac=
k">=C2=A0</span></pre><pre style=3D"white-space:pre-wrap"><span style=3D"co=
lor:black">=C2=A0</span></pre><pre style=3D"white-space:pre-wrap"><span sty=
le=3D"color:black">=C2=A0</span></pre><pre style=3D"white-space:pre-wrap"><=
span style=3D"color:black">=C2=A0</span></pre><pre style=3D"white-space:pre=
-wrap"><span style=3D"color:black">=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<wbr>=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<wb=
r>=3D=3D=3D=3D=3D=3D=3D=3D=3D</span></pre><pre style=3D"white-space:pre-wra=
p"><span style=3D"color:black">Design Overview</span></pre><pre style=3D"wh=
ite-space:pre-wrap"><span style=3D"color:black">=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D</span></pre><pre style=3D"white-space:pre-wrap"><span style=3D"col=
or:black">=C2=A0</span></pre><pre style=3D"white-space:pre-wrap;margin-left=
:0.5in"><span style=3D"font-family:arial,sans-serif;color:black">=E2=80=A2<=
span style=3D"font-variant-numeric:normal;font-stretch:normal;font-size:7pt=
;line-height:normal;font-family:&quot;times new roman&quot;">=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><span style=3D"color:black">De=
terministically bring the path to =E2=80=9CFaulty=E2=80=9D state </span></p=
re><pre style=3D"white-space:pre-wrap;margin-left:1in"><span style=3D"font-=
family:arial,sans-serif;color:black">=E2=80=92<span style=3D"font-variant-n=
umeric:normal;font-stretch:normal;font-size:7pt;line-height:normal;font-fam=
ily:&quot;times new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </spa=
n></span><span style=3D"color:black">Configure per-DM device data with</spa=
n></pre><pre style=3D"white-space:pre-wrap;margin-left:1.5in"><span style=
=3D"font-family:arial,sans-serif;color:black">=E2=80=A2<span style=3D"font-=
variant-numeric:normal;font-stretch:normal;font-size:7pt;line-height:normal=
;font-family:&quot;times new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 </span></span><span style=3D"color:black">IO error threshold and =
time window for the error threshold to be hit</span><b style=3D"font-family=
:arial,sans-serif"><i><span style=3D"font-size:11pt;font-family:calibri,san=
s-serif;color:rgb(31,73,125)">=C2=A0</span></i></b></pre><pre style=3D"whit=
e-space:pre-wrap;margin-left:1in"><span style=3D"font-family:arial,sans-ser=
if;color:black">=E2=80=92<span style=3D"font-variant-numeric:normal;font-st=
retch:normal;font-size:7pt;line-height:normal;font-family:&quot;times new r=
oman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><span style=
=3D"color:black">Declare a path Faulty when error threshold is hit within t=
he configured time window </span></pre><pre style=3D"white-space:pre-wrap;m=
argin-left:1in"><span style=3D"font-family:arial,sans-serif;color:black">=
=E2=80=92<span style=3D"font-variant-numeric:normal;font-stretch:normal;fon=
t-size:7pt;line-height:normal;font-family:&quot;times new roman&quot;">=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><span style=3D"color:black"=
>Place the path in the failed state for a predefined time configured by the=
 administrator</span></pre><pre style=3D"white-space:pre-wrap;margin-left:1=
in"><span style=3D"color:black"> using the config file</span></pre><pre sty=
le=3D"white-space:pre-wrap;margin-left:1in"><span style=3D"font-family:aria=
l,sans-serif;color:black">=E2=80=92<span style=3D"font-variant-numeric:norm=
al;font-stretch:normal;font-size:7pt;line-height:normal;font-family:&quot;t=
imes new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><s=
pan style=3D"color:black">Even though multipath daemon validates the path u=
sing TUR command which succeeds</span></pre><pre style=3D"white-space:pre-w=
rap;margin-left:1in"><font color=3D"#000000"> and tries to re-instantiate t=
he path ignore the re-instantiate of the path for a predefined time if the =
err threshold is hit.</font></pre><pre style=3D"white-space:pre-wrap;margin=
-left:0.5in"><span style=3D"font-family:arial,sans-serif;color:black">=E2=
=80=A2<span style=3D"font-variant-numeric:normal;font-stretch:normal;font-s=
ize:7pt;line-height:normal;font-family:&quot;times new roman&quot;">=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><span style=3D"color:bla=
ck">Give time for Administrator to correct the =E2=80=9CSick But not Dead=
=E2=80=9D path and bring Path to Active</span></pre><pre style=3D"white-spa=
ce:pre-wrap;margin-left:0.5in"><span style=3D"font-family:arial,sans-serif;=
color:black">=E2=80=A2<span style=3D"font-variant-numeric:normal;font-stret=
ch:normal;font-size:7pt;line-height:normal;font-family:&quot;times new roma=
n&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><span sty=
le=3D"color:black">Auto Enablement of a Faulty Path to Active State after a=
 fixed time duration (given as a config data for each DM)</span></pre><pre =
style=3D"white-space:pre-wrap;margin-left:1in"><span style=3D"font-family:a=
rial,sans-serif;color:black">=E2=80=92<span style=3D"font-variant-numeric:n=
ormal;font-stretch:normal;font-size:7pt;line-height:normal;font-family:&quo=
t;times new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span=
><span style=3D"color:black">Admin can set the Deterministic MPIO behavior =
on per-DM device basis</span></pre><pre style=3D"white-space:pre-wrap;margi=
n-left:73.2pt"><span style=3D"font-family:calibri,sans-serif;color:black">-=
<span style=3D"font-variant-numeric:normal;font-stretch:normal;font-size:7p=
t;line-height:normal;font-family:&quot;times new roman&quot;">=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><span style=3D"color:bla=
ck">It implies the failed path will be reinstantiated =C2=A0either by admin=
 or when the timeout expires.</span></pre><pre style=3D"white-space:pre-wra=
p;margin-left:0.5in"><span style=3D"font-family:arial,sans-serif;color:blac=
k">=E2=80=A2<span style=3D"font-variant-numeric:normal;font-stretch:normal;=
font-size:7pt;line-height:normal;font-family:&quot;times new roman&quot;">=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><span style=3D"col=
or:black">The above configs will be made persistent across server reboots</=
span></pre><pre style=3D"white-space:pre-wrap"><span style=3D"color:black">=
=C2=A0</span></pre><pre style=3D"white-space:pre-wrap"><span style=3D"color=
:black">Expected benefit:</span></pre><pre style=3D"white-space:pre-wrap"><=
span style=3D"color:black">-Deterministic Application IO throughput</span><=
span style=3D"color:rgb(31,73,125)">.</span><span style=3D"color:black"></s=
pan></pre><pre style=3D"white-space:pre-wrap"><span style=3D"color:black">-=
We can give a time for the administrator to analyze the path failure and re=
cover the path.</span></pre><pre style=3D"white-space:pre-wrap"><span style=
=3D"font-size:11pt;font-family:calibri,sans-serif;color:rgb(31,73,125)">-</=
span><span style=3D"color:black"> user space tools need minimum change .</s=
pan></pre><pre style=3D"white-space:pre-wrap"><span style=3D"font-size:11pt=
;font-family:calibri,sans-serif;color:rgb(31,73,125)">=C2=A0</span></pre></=
div></div><pre style=3D"white-space:pre-wrap"><span style=3D"font-size:11pt=
;font-family:calibri,sans-serif;color:rgb(31,73,125)">The above feature wil=
l be enabled only if the corresponding variables are defined in multipath.c=
onf</span></pre><span class=3D""><pre style=3D"white-space:pre-wrap"><span =
style=3D"color:black">=C2=A0</span></pre><pre style=3D"white-space:pre-wrap=
"><span style=3D"color:black">Since these changes are irrespective of the u=
nderlying algorithms which they are using in dm layer.</span></pre><pre sty=
le=3D"white-space:pre-wrap"><span style=3D"color:black">The changes are app=
lied in dm.c and dm-mpath.c</span></pre><pre style=3D"white-space:pre-wrap"=
><span style=3D"color:black">=C2=A0</span></pre><pre style=3D"white-space:p=
re-wrap"><span style=3D"color:black">alloc_dev(),reinstate_path(),p<wbr>ars=
e_path(),fail_path() are the functions which are going to be changed.</span=
></pre><pre style=3D"white-space:pre-wrap"><span style=3D"color:black">=C2=
=A0</span></pre><pre style=3D"white-space:pre-wrap"><span style=3D"color:bl=
ack">=C2=A0</span></pre><pre style=3D"white-space:pre-wrap"><span style=3D"=
color:black">Need more comments on this as we started the testing and the r=
esults look determenestic.</span></pre><pre style=3D"white-space:pre-wrap">=
<span style=3D"color:black"><br></span></pre><pre style=3D"white-space:pre-=
wrap"><span style=3D"color:black"><br></span></pre></span><pre style=3D"whi=
te-space:pre-wrap"><span style=3D"color:black">Regards,</span></pre><pre st=
yle=3D"white-space:pre-wrap"><span style=3D"color:black">Muneendra.</span><=
/pre></div><div class=3D"HOEnZb"><div class=3D"h5"><div class=3D"gmail_extr=
a"><br><div class=3D"gmail_quote">On Thu, Dec 15, 2016 at 3:00 PM, muneendr=
a kumar <span dir=3D"ltr">&lt;<a href=3D"mailto:muneendra737@gmail.com" tar=
get=3D"_blank">muneendra737@gmail.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex"><div dir=3D"ltr"><pre><span style=3D"color:black">Hello,=
<span></span></span></pre><pre><span style=3D"color:black">This is the plac=
e where iam currently working and the details are given below</span></pre><=
pre><span style=3D"color:black">=C2=A0</span></pre><pre><span style=3D"colo=
r:black">I&#39;m working on device-mapper multipath (dm-multipath).<span></=
span></span></pre><pre><span style=3D"color:black">This patch set adds a ne=
w hook for device-mapper in deciding the health of the<span></span></span><=
/pre><pre><span style=3D"color:black">Of the multipath which helps in getti=
ng the deterministic Application IO throughput.<span></span></span></pre><p=
re><span style=3D"color:black">=C2=A0</span></pre><pre><span style=3D"color=
:black">This patch set is preliminary tested on active-active 2 paths stora=
ge.<span></span></span></pre><pre><span style=3D"color:black">But the patch=
 set still needs work and is not ready for inclusion.<span></span></span></=
pre><pre><span style=3D"color:black">I&#39;m posting it because I&#39;d lik=
e to get comments about high-level<span></span></span></pre><pre><span styl=
e=3D"color:black">design before going further in details.<span></span></spa=
n></pre><pre><span style=3D"color:black">=C2=A0</span></pre><pre><span styl=
e=3D"color:black">=C2=A0</span></pre><pre><span style=3D"color:black">=C2=
=A0</span></pre><pre><span style=3D"color:black">This patch set should be a=
pplied on top of 3.10.0 #18<span></span></span></pre><pre><span style=3D"co=
lor:black">=C2=A0</span></pre><pre><span style=3D"color:black">=C2=A0</span=
></pre><pre><span style=3D"color:black">=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<wbr>=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D<wbr>=3D=3D=3D=3D=3D=3D=3D=3D<span></span></span></pre><pre><span style=
=3D"color:black">Background<span></span></span></pre><pre><span style=3D"co=
lor:black">=3D-=3D-=3D-=3D-=3D-=3D<span></span></span></pre><pre><span styl=
e=3D"color:black">=C2=A0</span></pre><pre style=3D"margin-left:0.5in"><span=
 style=3D"font-family:arial,sans-serif;color:black">=E2=80=A2<span style=3D=
"font-variant-numeric:normal;font-stretch:normal;font-size:7pt;line-height:=
normal;font-family:&quot;times new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 </span></span><span style=3D"color:black">=E2=80=9CSick but=
 not Dead=E2=80=9D MPIO Path<span></span></span></pre><pre style=3D"margin-=
left:1in"><span style=3D"font-family:arial,sans-serif;color:black">=E2=80=
=92<span style=3D"font-variant-numeric:normal;font-stretch:normal;font-size=
:7pt;line-height:normal;font-family:&quot;times new roman&quot;">=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><span style=3D"color:black">Path =
goes into Failed state because of path IO error as seen by DM driver<span><=
/span></span></pre><pre style=3D"margin-left:1in"><span style=3D"font-famil=
y:arial,sans-serif;color:black">=E2=80=92<span style=3D"font-variant-numeri=
c:normal;font-stretch:normal;font-size:7pt;line-height:normal;font-family:&=
quot;times new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></s=
pan><span style=3D"color:black">When the multipath daemon issues TUR comman=
d =C2=A0finds health of the failed path is good, makes the same path into A=
ctive state<span></span></span></pre><pre style=3D"margin-left:1in"><span s=
tyle=3D"font-family:arial,sans-serif;color:black">=E2=80=92<span style=3D"f=
ont-variant-numeric:normal;font-stretch:normal;font-size:7pt;line-height:no=
rmal;font-family:&quot;times new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 </span></span><span style=3D"color:black">Path repeatedly toggles=
 between Failed and Active Path States<span></span></span></pre><pre style=
=3D"margin-left:1.5in"><span style=3D"font-family:arial,sans-serif;color:bl=
ack">=E2=80=A2<span style=3D"font-variant-numeric:normal;font-stretch:norma=
l;font-size:7pt;line-height:normal;font-family:&quot;times new roman&quot;"=
>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><span style=3D"co=
lor:black">DM IO is retried on path where we are hitting multiple errors.<s=
pan></span></span></pre><pre style=3D"margin-left:1.5in"><span style=3D"fon=
t-family:arial,sans-serif;color:black">=E2=80=A2<span style=3D"font-variant=
-numeric:normal;font-stretch:normal;font-size:7pt;line-height:normal;font-f=
amily:&quot;times new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 </span></span><span style=3D"color:black">Causing erratic (non-determin=
istic) Application IO throughput<span></span></span></pre><pre><span style=
=3D"color:black">=C2=A0</span></pre><pre><font color=3D"#000000">The curren=
t existing DM layer doesn&#39;t consider the amount of errors to decide the=
 health of the path.<span></span></font></pre><pre><span style=3D"color:bla=
ck">Since the failed path is becoming active immediately when the tur comma=
nd succeeds the end user will be in a<span></span></span></pre><pre><span s=
tyle=3D"color:black">Assumption that all the multipaths are in good state.<=
span></span></span></pre><pre><font color=3D"#000000">When we run some of t=
he field tests with this scenario we saw a non-deterministic io throughput<=
span></span></font></pre><pre><span style=3D"color:black">=C2=A0</span></pr=
e><pre><span style=3D"color:black">=C2=A0</span></pre><pre><span style=3D"c=
olor:black">=C2=A0</span></pre><pre><span style=3D"color:black">=C2=A0</spa=
n></pre><pre><span style=3D"color:black">=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<wbr>=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D<wbr>=3D=3D=3D=3D=3D=3D=3D=3D=3D<span></span></span></pre><pre><span sty=
le=3D"color:black">Design Overview<span></span></span></pre><pre><span styl=
e=3D"color:black">=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D<span></span></span></=
pre><pre><span style=3D"color:black">=C2=A0</span></pre><pre style=3D"margi=
n-left:0.5in"><span style=3D"font-family:arial,sans-serif;color:black">=E2=
=80=A2<span style=3D"font-variant-numeric:normal;font-stretch:normal;font-s=
ize:7pt;line-height:normal;font-family:&quot;times new roman&quot;">=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><span style=3D"color:bla=
ck">Deterministically bring the path to =E2=80=9CFaulty=E2=80=9D state <spa=
n></span></span></pre><pre style=3D"margin-left:1in"><span style=3D"font-fa=
mily:arial,sans-serif;color:black">=E2=80=92<span style=3D"font-variant-num=
eric:normal;font-stretch:normal;font-size:7pt;line-height:normal;font-famil=
y:&quot;times new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span>=
</span><span style=3D"color:black">Configure per-DM device data with<span><=
/span></span></pre><pre style=3D"margin-left:1.5in"><span style=3D"font-fam=
ily:arial,sans-serif;color:black">=E2=80=A2<span style=3D"font-variant-nume=
ric:normal;font-stretch:normal;font-size:7pt;line-height:normal;font-family=
:&quot;times new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </=
span></span><span style=3D"color:black">IO error threshold and time window =
for the error threshold to be hit</span><b style=3D"font-family:arial,sans-=
serif"><i><span style=3D"font-size:11pt;font-family:calibri,sans-serif;colo=
r:rgb(31,73,125)">=C2=A0</span></i></b></pre><pre style=3D"margin-left:1in"=
><span style=3D"font-family:arial,sans-serif;color:black">=E2=80=92<span st=
yle=3D"font-variant-numeric:normal;font-stretch:normal;font-size:7pt;line-h=
eight:normal;font-family:&quot;times new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 </span></span><span style=3D"color:black">Declare a path Fa=
ulty when error threshold is hit within the configured time window <span></=
span></span></pre><pre style=3D"margin-left:1in"><span style=3D"font-family=
:arial,sans-serif;color:black">=E2=80=92<span style=3D"font-variant-numeric=
:normal;font-stretch:normal;font-size:7pt;line-height:normal;font-family:&q=
uot;times new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></sp=
an><span style=3D"color:black">Place the path in the failed state for a pre=
defined time configured by the administrator</span></pre><pre style=3D"marg=
in-left:1in"><span style=3D"color:black"> using the config file<span></span=
></span></pre><pre style=3D"margin-left:1in"><span style=3D"font-family:ari=
al,sans-serif;color:black">=E2=80=92<span style=3D"font-variant-numeric:nor=
mal;font-stretch:normal;font-size:7pt;line-height:normal;font-family:&quot;=
times new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><=
span style=3D"color:black">Even though multipath daemon validates the path =
using TUR command which succeeds<span></span></span></pre><pre style=3D"mar=
gin-left:1in"><font color=3D"#000000"> and tries to re-instantiate the path=
 ignore the re-instantiate of the path for a predefined time if the err thr=
eshold is hit.<span></span></font></pre><pre style=3D"margin-left:0.5in"><s=
pan style=3D"font-family:arial,sans-serif;color:black">=E2=80=A2<span style=
=3D"font-variant-numeric:normal;font-stretch:normal;font-size:7pt;line-heig=
ht:normal;font-family:&quot;times new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 </span></span><span style=3D"color:black">Give time for =
Administrator to correct the =E2=80=9CSick But not Dead=E2=80=9D path and b=
ring Path to Active<span></span></span></pre><pre style=3D"margin-left:0.5i=
n"><span style=3D"font-family:arial,sans-serif;color:black">=E2=80=A2<span =
style=3D"font-variant-numeric:normal;font-stretch:normal;font-size:7pt;line=
-height:normal;font-family:&quot;times new roman&quot;">=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><span style=3D"color:black">Auto Ena=
blement of a Faulty Path to Active State after a fixed time duration (given=
 as a config data for each DM)<span></span></span></pre><pre style=3D"margi=
n-left:1in"><span style=3D"font-family:arial,sans-serif;color:black">=E2=80=
=92<span style=3D"font-variant-numeric:normal;font-stretch:normal;font-size=
:7pt;line-height:normal;font-family:&quot;times new roman&quot;">=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></span><span style=3D"color:black">Admin=
 can set the Deterministic MPIO behavior on per-DM device basis<span></span=
></span></pre><pre style=3D"margin-left:73.2pt"><span style=3D"font-family:=
calibri,sans-serif;color:black">-<span style=3D"font-variant-numeric:normal=
;font-stretch:normal;font-size:7pt;line-height:normal;font-family:&quot;tim=
es new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span=
></span><span style=3D"color:black">It implies the failed path will be rein=
stantiated =C2=A0either by admin or when the timeout expires.<span></span><=
/span></pre><pre style=3D"margin-left:0.5in"><span style=3D"font-family:ari=
al,sans-serif;color:black">=E2=80=A2<span style=3D"font-variant-numeric:nor=
mal;font-stretch:normal;font-size:7pt;line-height:normal;font-family:&quot;=
times new roman&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span></=
span><span style=3D"color:black">The above configs will be made persistent =
across server reboots<span></span></span></pre><pre><span style=3D"color:bl=
ack">=C2=A0</span></pre><pre><span style=3D"color:black">Expected benefit:<=
span></span></span></pre><pre><span style=3D"color:black">-Deterministic Ap=
plication IO throughput</span><span style=3D"color:rgb(31,73,125)">.</span>=
<span style=3D"color:black"><span></span></span></pre><pre><span style=3D"c=
olor:black">-We can give a time for the administrator to analyze the path f=
ailure and recover the path.<span></span></span></pre><pre><span style=3D"f=
ont-size:11pt;font-family:calibri,sans-serif;color:rgb(31,73,125)">-</span>=
<span style=3D"color:black"> user space tools need minimum change .<span></=
span></span></pre><pre><span style=3D"font-size:11pt;font-family:calibri,sa=
ns-serif;color:rgb(31,73,125)"><span>=C2=A0</span></span></pre><pre><span s=
tyle=3D"color:black">=C2=A0</span></pre><pre><span style=3D"color:black">Si=
nce these changes are irrespective of the underlying algorithms which they =
are using in dm layer.<span></span></span></pre><pre><span style=3D"color:b=
lack">The changes are applied in dm.c and dm-mpath.c<span></span></span></p=
re><pre><span style=3D"color:black">=C2=A0</span></pre><pre><span style=3D"=
color:black">alloc_dev(),reinstate_path(),p<wbr>arse_path(),fail_path() are=
 the functions which are going to be changed.<span></span></span></pre><pre=
><span style=3D"color:black">=C2=A0</span></pre><pre><span style=3D"color:b=
lack">=C2=A0</span></pre><pre><span style=3D"color:black">Need more comment=
s on this as we started the testing and the results look determenestic.<spa=
n></span></span></pre></div><div class=3D"m_451764365367411905HOEnZb"><div =
class=3D"m_451764365367411905h5"><div class=3D"gmail_extra"><br><div class=
=3D"gmail_quote">On Mon, Dec 5, 2016 at 9:35 PM, muneendra kumar <span dir=
=3D"ltr">&lt;<a href=3D"mailto:muneendra737@gmail.com" target=3D"_blank">mu=
neendra737@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
"><div dir=3D"ltr">Thanks a lot for sharing the info.<div>I will discuss th=
e problem in detail in my earlier mail,</div><div><br></div><div>Regards,</=
div><div>Muneendra.</div></div><div class=3D"m_451764365367411905m_24170411=
20066841534HOEnZb"><div class=3D"m_451764365367411905m_2417041120066841534h=
5"><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Mon, Dec 5,=
 2016 at 5:45 PM, Zdenek Kabelac <span dir=3D"ltr">&lt;<a href=3D"mailto:zk=
abelac@redhat.com" target=3D"_blank">zkabelac@redhat.com</a>&gt;</span> wro=
te:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-=
left:1px #ccc solid;padding-left:1ex">Dne 5.12.2016 v 07:29 muneendra kumar=
 napsal(a):<span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Hi,<br>
This is a general question.<br>
If i do any changes in both multipath tool and dm driver (kernel).<br>
How do i push my changes into main stream.<br>
Can someone explain me the process so that it will help me a lot.<br>
<br>
</blockquote>
<br>
<br></span>
Hi<br>
<br>
You propose your changes here on the list - you get a review and<br>
it the patches are found useful - maintainer of dm subsystem<br>
will accept them.<br>
<br>
Note - it&#39;s usually better to ask and discuss &#39;ahead&#39; what is y=
our problem<br>
and how do you want to improve/fix it.<br>
So you avoid losing time on implementing unacceptable patch.<br>
<br>
Regards<span class=3D"m_451764365367411905m_2417041120066841534m_9811755391=
99487597HOEnZb"><font color=3D"#888888"><br>
<br>
Zdenek<br>
<br>
<br>
<br>
</font></span></blockquote></div><br></div>
</div></div></blockquote></div><br></div>
</div></div></blockquote></div><br></div>
</div></div></div><br></div>

--089e01493e86364e7a0543af3b42--


--===============5828284486737098534==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5828284486737098534==--
