From: John Strange <johnstra10@gmail.com>
Subject: Re: Extending DM w/ new target type
Date: Fri, 9 Aug 2013 08:50:19 -0600
Message-ID: <CAH1aXXbc6g+kjreM2fAnFtVdiOU=rd9KyOnmu8prefr3wJ2ctQ@mail.gmail.com>
References: <CAH1aXXYQVnYndk7S6-6TM9hiuTE2xpN+4Qt8BA_36PvrQVQSsw@mail.gmail.com>
	<51FBA10F.7070006@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2747766527929145080=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <51FBA10F.7070006@redhat.com>
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

--===============2747766527929145080==
Content-Type: multipart/alternative; boundary=e89a8f923fb6b843d204e384e493

--e89a8f923fb6b843d204e384e493
Content-Type: text/plain; charset=ISO-8859-1

I see dmraid has two options -p (no_partitions) and -Z (rm_partitions).  I
see that rm_partitions does just that, but it's not clear to me what the
no_partitions option does.  Can somebody explain please?

How do utilities detect that a device is in use by DM?  I would like to be
able to prevent creation of partitions on any disks my mapping target is
using.  Are there ways to do that?  It would seem that DM solutions like
raid, multipath, etc. would require this capability.

Thanks,
-john


On Fri, Aug 2, 2013 at 6:07 AM, Zdenek Kabelac <zkabelac@redhat.com> wrote:

> Dne 1.8.2013 19:04, John Strange napsal(a):
>
>  two questions:
>>
>> 1. I'd like to use DM with a new target type.  I'm porting our virtualized
>> storage solution from Windows.  I've been able to register my target and
>> get
>> callbacks working, but in looking at the dm-raid code, I'm concerned with
>> how
>> tightly coupled it is with the routines in md.c (multiple devices
>> implementation).  Is there an expectation that a DM target use the md_xxxx
>> routines?
>>
>> 2. I used dmsetup to create a mapping for a device that my target
>> controls.
>> Is there a way to make the underlying device (e.g. /dev/sdb) not visible
>> to
>> the system?  I'm paranoid about external accesses to a LUN that I'm using.
>>
>
> In lvm2 it's solved in a way - that we use special flags for udev to avoid
> some scanning/watchrules - however all device are always available through
> /dev/mapper but  user visible devices are accessible via   /dev/vg/lv name
> which is the only suggested and supported way to use LVs.
>
> Obviously we often get reports where users are directly playing with
> /dev/dm-XXX devices or /dev/mapper/vg-lv  in their scripts and configs...
>
> But you can't hide existing devices in  system from userland visibility.
>
>
> Zdenek
>
>

--e89a8f923fb6b843d204e384e493
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>I see dmraid has two options -p (no_partiti=
ons) and -Z (rm_partitions).=A0 I see that rm_partitions does just that, bu=
t it&#39;s not clear to me what the no_partitions option does.=A0 Can someb=
ody explain please?<br>
<br></div>How do utilities detect that a device is in use by DM?=A0 I would=
 like to be able to prevent creation of partitions on any disks my mapping =
target is using.=A0 Are there ways to do that?=A0 It would seem that DM sol=
utions like raid, multipath, etc. would require this capability.<br>
<br></div>Thanks,<br></div>-john<br><div><div><div><div><div class=3D"gmail=
_extra"><br><br><div class=3D"gmail_quote">On Fri, Aug 2, 2013 at 6:07 AM, =
Zdenek Kabelac <span dir=3D"ltr">&lt;<a href=3D"mailto:zkabelac@redhat.com"=
 target=3D"_blank">zkabelac@redhat.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Dne 1.8.2013 19:04, John Strange napsal(a):<=
div><div class=3D"h5"><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
two questions:<br>
<br>
1. I&#39;d like to use DM with a new target type. =A0I&#39;m porting our vi=
rtualized<br>
storage solution from Windows. =A0I&#39;ve been able to register my target =
and get<br>
callbacks working, but in looking at the dm-raid code, I&#39;m concerned wi=
th how<br>
tightly coupled it is with the routines in md.c (multiple devices<br>
implementation). =A0Is there an expectation that a DM target use the md_xxx=
x<br>
routines?<br>
<br>
2. I used dmsetup to create a mapping for a device that my target controls.=
<br>
Is there a way to make the underlying device (e.g. /dev/sdb) not visible to=
<br>
the system? =A0I&#39;m paranoid about external accesses to a LUN that I&#39=
;m using.<br>
</blockquote>
<br></div></div>
In lvm2 it&#39;s solved in a way - that we use special flags for udev to av=
oid<br>
some scanning/watchrules - however all device are always available through =
/dev/mapper but =A0user visible devices are accessible via =A0 /dev/vg/lv n=
ame which is the only suggested and supported way to use LVs.<br>
<br>
Obviously we often get reports where users are directly playing with /dev/d=
m-XXX devices or /dev/mapper/vg-lv =A0in their scripts and configs...<br>
<br>
But you can&#39;t hide existing devices in =A0system from userland visibili=
ty.<span class=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
<br>
Zdenek<br>
<br>
</font></span></blockquote></div><br></div></div></div></div></div></div>

--e89a8f923fb6b843d204e384e493--


--===============2747766527929145080==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2747766527929145080==--
