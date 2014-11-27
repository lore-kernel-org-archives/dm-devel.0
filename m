From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: Unable to deactivate lv,
	pehaps due to semaphore problem...
Date: Thu, 27 Nov 2014 18:49:09 +0100
Message-ID: <CAG2kNCwXeqpE=1t9gsecfMuMdkKF3E8P3a3s6edSe1172=JhKw@mail.gmail.com>
References: <CAG2kNCxiZhRpfnifa58bDODfcyhaArLmP4kbgPfPs=2Lq_tYWw@mail.gmail.com>
	<54773621.5090301@redhat.com>
	<CAG2kNCyDcgCdCpUAzZ51mAyqS8LF9i9Tau3Lke5E2ZJy352_ig@mail.gmail.com>
	<54774220.7080709@redhat.com>
	<CAG2kNCz7hmtcMQBeVQRbryVTzsE_DKr9y8Pg8rfKmSf8UDVDRQ@mail.gmail.com>
	<5477469A.1080103@redhat.com>
	<CAG2kNCz_SKbHc4b56L1Dzkb19HsozW9aKs1Ln4MmYY9iUiLJOg@mail.gmail.com>
	<54774BCC.6020709@redhat.com>
	<CAG2kNCz=KuBKcLog-Z=iZBNAg9J31KwFRa7RgJ0GLXNqsd4UYQ@mail.gmail.com>
	<547752E4.70304@redhat.com>
	<CAG2kNCzQOo8OYTLdLDeUpGN3wNJQWv-ibGxUAxMnQBtQq-r3kw@mail.gmail.com>
	<54775981.1020803@redhat.com>
	<CAG2kNCwh5_eF18xE2Ubecy8+iAo6vdo3O-vD9wF+C+O-A9KoEw@mail.gmail.com>
	<54775D83.8060508@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7364064426788550288=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54775D83.8060508@redhat.com>
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

--===============7364064426788550288==
Content-Type: multipart/alternative; boundary=bcaec53d5f0fe4bb820508dac27e

--bcaec53d5f0fe4bb820508dac27e
Content-Type: text/plain; charset=UTF-8

On Thu, Nov 27, 2014 at 6:21 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote:

> Dne 27.11.2014 v 18:18 Gianluca Cecchi napsal(a):
>
>> On Thu, Nov 27, 2014 at 6:04 PM, Zdenek Kabelac <zkabelac@redhat.com
>> <mailto:zkabelac@redhat.com>> wrote:
>>
>>
>>     So I'm afraid you will need to open a RHEL support ticket to get all
>> the
>>     diagnostic  (sosreport)  -  since if this is production system,
>>     all further advices may lead to some problems.
>>
>>
>>     Zdenek
>>
>>
>> OK. Can I refer this thread  and your help provided in the case
>> discussion?
>> Gianluca
>>
>>
> Sure, np
>
>
> Zdenek
>
>
I opened case 01308210. Let's see what will happen.
We will have a maintenance on Saturday, so eventually we will have to stop
services and power off the node before enabling them again on the other
one....
Thanks for your kindness and speed in answering with proposals.

Gianluca

--bcaec53d5f0fe4bb820508dac27e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On T=
hu, Nov 27, 2014 at 6:21 PM, Zdenek Kabelac <span dir=3D"ltr">&lt;<a href=
=3D"mailto:zkabelac@redhat.com" target=3D"_blank">zkabelac@redhat.com</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0=
px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);borde=
r-left-style:solid;padding-left:1ex"><span class=3D"">Dne 27.11.2014 v 18:1=
8 Gianluca Cecchi napsal(a):<br>
</span><span class=3D""><blockquote class=3D"gmail_quote" style=3D"margin:0=
px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);b=
order-left-style:solid;padding-left:1ex">
On Thu, Nov 27, 2014 at 6:04 PM, Zdenek Kabelac &lt;<a href=3D"mailto:zkabe=
lac@redhat.com" target=3D"_blank">zkabelac@redhat.com</a><br>
&lt;mailto:<a href=3D"mailto:zkabelac@redhat.com" target=3D"_blank">zkabela=
c@redhat.com</a>&gt;&gt; wrote:<br>
<br>
<br>
=C2=A0 =C2=A0 So I&#39;m afraid you will need to open a RHEL support ticket=
 to get all the<br>
=C2=A0 =C2=A0 diagnostic=C2=A0 (sosreport)=C2=A0 -=C2=A0 since if this is p=
roduction system,<br>
=C2=A0 =C2=A0 all further advices may lead to some problems.<br>
<br>
<br>
=C2=A0 =C2=A0 Zdenek<br>
<br>
<br>
OK. Can I refer this thread=C2=A0 and your help provided in the case discus=
sion?<br>
Gianluca<br>
<br>
</blockquote>
<br></span>
Sure, np<div class=3D""><div class=3D"h5"><br>
<br>
Zdenek<br><br>
</div></div></blockquote></div><br></div><div class=3D"gmail_extra">I opene=
d case 01308210. Let&#39;s see what will happen.<br></div><div class=3D"gma=
il_extra">We will have a maintenance on Saturday, so eventually we will hav=
e to stop services and power off the node before enabling them again on the=
 other one....</div><div class=3D"gmail_extra">Thanks for your kindness and=
 speed in answering with proposals.</div><div class=3D"gmail_extra"><br></d=
iv><div class=3D"gmail_extra">Gianluca</div><div class=3D"gmail_extra"><br>=
</div></div>

--bcaec53d5f0fe4bb820508dac27e--


--===============7364064426788550288==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7364064426788550288==--
