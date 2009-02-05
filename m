From: =?ISO-8859-1?Q?Christian_R=F8snes?= <christian.rosnes@gmail.com>
Subject: Re: Multipath setup and rdac questions
Date: Thu, 5 Feb 2009 20:23:01 +0100
Message-ID: <1a4a774c0902051123o3323baccr62ce8c83a19bce8c@mail.gmail.com>
References: <1a4a774c0902050558r661093dag83e71a06250c24aa@mail.gmail.com>
	<498B00B3.5020402@redhat.com>
	<E463DF2B2E584B4A82673F53D62C2EF4663975E3@cosmail01.lsi.com>
	<1a4a774c0902051113u513d9d43sda8278ebaf6899bd@mail.gmail.com>
	<498B3B25.3060204@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0379733974=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <498B3B25.3060204@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bmr@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0379733974==
Content-Type: multipart/alternative; boundary=001636c599782fa313046230d5bd

--001636c599782fa313046230d5bd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2009 at 8:16 PM, Bryn M. Reeves <bmr@redhat.com> wrote:

> Christian R=F8snes wrote:
>
>> # multipath -ll
>> mpathe (36002219000918b4c00005b6c497e6632) dm-4 DELL,MD Virtual Disk
>> [size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
>> \_ round-robin 0 [prio=3D6][active]
>>  \_ 9:0:0:1  sdi 8:128 [active][ready]
>>
>
> That looks better! Seems like device-mapper multipath is configuring thes=
e
> OK now. You might want to just check that mpp is fully disabled if you're
> going with device-mapper (and also test some cable-pulls to make sure the
> RDAC failover happens properly) but this is certainly picking up your hw
> handler configuration now.
>
>
Ok. I'll look into disabling mpp, and test the device-mapper failover by
pulling cables and manually switching controller modules during
disk access.

Thank you.
Christian

--001636c599782fa313046230d5bd
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Thu, Feb 5, 2009 at 8:16 PM, Bryn M. =
Reeves <span dir=3D"ltr">&lt;<a href=3D"mailto:bmr@redhat.com">bmr@redhat.c=
om</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"bord=
er-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-l=
eft: 1ex;">
<div class=3D"Ih2E3d">Christian R=F8snes wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
# multipath -ll<br>
mpathe (36002219000918b4c00005b6c497e6632) dm-4 DELL,MD Virtual Disk<br>
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>
\_ round-robin 0 [prio=3D6][active]<br>
&nbsp;\_ 9:0:0:1 &nbsp;sdi 8:128 [active][ready]<br>
</blockquote>
<br></div>
That looks better! Seems like device-mapper multipath is configuring these =
OK now. You might want to just check that mpp is fully disabled if you&#39;=
re going with device-mapper (and also test some cable-pulls to make sure th=
e RDAC failover happens properly) but this is certainly picking up your hw =
handler configuration now.<div>
<div></div><div class=3D"Wj3C7c"><br>
</div></div></blockquote><div><br>Ok. I&#39;ll look into disabling mpp, and=
 test the device-mapper failover by pulling cables and manually switching c=
ontroller modules during<br>disk access.<br><br>Thank you. <br></div></div>
Christian<br>

--001636c599782fa313046230d5bd--


--===============0379733974==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0379733974==--
