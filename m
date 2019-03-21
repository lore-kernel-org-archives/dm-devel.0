From: Russell Weber <rustyscottweber@gmail.com>
Subject: Re: Where to read the WWID of a multipath device
Date: Thu, 21 Mar 2019 01:57:39 -0600
Message-ID: <CAKROqvcrwnvfLpmW2Z42q20djgGi+pzzHi4y+Wu6+O21Fd4m8Q@mail.gmail.com>
References: <20190320102805.GA30538@canonical>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5325240912423526482=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190320102805.GA30538@canonical>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sahid Orentino Ferdjaoui <sahid.ferdjaoui@canonical.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============5325240912423526482==
Content-Type: multipart/alternative; boundary="000000000000458f4a0584961802"

--000000000000458f4a0584961802
Content-Type: text/plain; charset="UTF-8"

I would assume that most linux distributions at this point in time support
getting the wwids through:
```cat /etc/multipath/wwids````
This can also be parsed out of multipath -ll
```
[USER ~]# multipath -ll
mpathak (26639613661623365) dm-3 FUSIONIO,ION LUN
size=2.7T features='3 queue_if_no_path pg_init_retries 50' hwhandler='1
alua' wp=rw
|-+- policy='queue-length 0' prio=50 status=active
| |- 7:0:0:1  sdb 8:16 active ready running
| `- 8:0:0:1  sdc 8:32 active ready running
`-+- policy='queue-length 0' prio=1 status=enabled
  |- 9:0:0:1  sdd 8:48 active ready running
  `- 10:0:0:1 sde 8:64 active ready running
[USER ~]# cat /etc/multipath/wwids | grep -i 26639613661623365
/26639613661623365/
```
However, I'm curious as to why you would need the wwid as most higher level
python management libraries I've worked with are much more concerned with
the disk or partition GUID,  LUN number, or some other ID for the disk.
Example:
```
[USER by-uuid]# ls -al
total 0
drwxr-xr-x. 2 root root 120 Mar 20 14:58 .
drwxr-xr-x. 5 root root 100 Mar 20 14:58 ..
lrwxrwxrwx. 1 root root  10 Mar 21 00:04
5b1c21dc-6f65-4d88-99a0-b30f76d08931 -> ../../dm-2
lrwxrwxrwx. 1 root root  10 Mar 21 00:04
72e5d3ab-d4b2-4d0a-8b77-ba9dd718871c -> ../../sda1
lrwxrwxrwx. 1 root root  10 Mar 21 00:04
df4b2a63-4a56-4173-ba82-45f567d1b5bf -> ../../dm-0
lrwxrwxrwx. 1 root root  10 Mar 21 00:04
fa3c2abb-d8d2-4a99-84d2-09f8204e429e -> ../../dm-1
[USER by-uuid]# pwd
/dev/disk/by-uuid

```
What do you need the WWID for as the multipath wwid may not be the best
option for the application you are looking at?

On Wed, Mar 20, 2019 at 4:28 AM Sahid Orentino Ferdjaoui <
sahid.ferdjaoui@canonical.com> wrote:

> Hi,
>
> The question is as indicated on title, what would be the best way to
> get the WWID of a multipath device, something which would work on any
> systems or storages.
>
> My idea was to read /sys/block/dm-X/name but someone indicated to me
> that may not be correct in some situation, like it seems that
> /lib/udev/scsi_id would not be correct either.
>
> To give a bit of context it's for an OpenStack library in Python.
>
> Thanks,
> s.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--000000000000458f4a0584961802
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr">I would=
 assume that most linux distributions at this point in time support getting=
 the wwids through:<br> ```cat /etc/multipath/wwids````</div><div>This can =
also be parsed out of multipath -ll<br>```<br></div><div dir=3D"ltr">[USER =
~]# multipath -ll<br>mpathak (26639613661623365) dm-3 FUSIONIO,ION LUN<br>s=
ize=3D2.7T features=3D&#39;3 queue_if_no_path pg_init_retries 50&#39; hwhan=
dler=3D&#39;1 alua&#39; wp=3Drw<br>|-+- policy=3D&#39;queue-length 0&#39; p=
rio=3D50 status=3Dactive<br>| |- 7:0:0:1=C2=A0 sdb 8:16 active ready runnin=
g<br>| `- 8:0:0:1=C2=A0 sdc 8:32 active ready running<br>`-+- policy=3D&#39=
;queue-length 0&#39; prio=3D1 status=3Denabled<br>=C2=A0 |- 9:0:0:1=C2=A0 s=
dd 8:48 active ready running<br>=C2=A0 `- 10:0:0:1 sde 8:64 active ready ru=
nning<br>[USER ~]# cat /etc/multipath/wwids | grep -i 26639613661623365<br>=
/26639613661623365/<br>```<br></div><div>However, I&#39;m curious as to why=
 you would need the wwid as most higher level python management libraries I=
&#39;ve worked with are much more concerned with the disk or partition GUID=
,=C2=A0 LUN number, or some other ID for the disk.<br></div><div>Example:<b=
r>```<br>[USER by-uuid]# ls -al<br>total 0<br>drwxr-xr-x. 2 root root 120 M=
ar 20 14:58 .<br>drwxr-xr-x. 5 root root 100 Mar 20 14:58 ..<br>lrwxrwxrwx.=
 1 root root=C2=A0 10 Mar 21 00:04 5b1c21dc-6f65-4d88-99a0-b30f76d08931 -&g=
t; ../../dm-2<br>lrwxrwxrwx. 1 root root=C2=A0 10 Mar 21 00:04 72e5d3ab-d4b=
2-4d0a-8b77-ba9dd718871c -&gt; ../../sda1<br>lrwxrwxrwx. 1 root root=C2=A0 =
10 Mar 21 00:04 df4b2a63-4a56-4173-ba82-45f567d1b5bf -&gt; ../../dm-0<br>lr=
wxrwxrwx. 1 root root=C2=A0 10 Mar 21 00:04 fa3c2abb-d8d2-4a99-84d2-09f8204=
e429e -&gt; ../../dm-1<br>[USER by-uuid]# pwd<br>/dev/disk/by-uuid<br><br>`=
``<br></div><div>What do you need the WWID for as the multipath wwid may no=
t be the best option for the application you are looking at?<br></div></div=
></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail=
_attr">On Wed, Mar 20, 2019 at 4:28 AM Sahid Orentino Ferdjaoui &lt;<a href=
=3D"mailto:sahid.ferdjaoui@canonical.com">sahid.ferdjaoui@canonical.com</a>=
&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px =
0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hi,<=
br>
<br>
The question is as indicated on title, what would be the best way to<br>
get the WWID of a multipath device, something which would work on any<br>
systems or storages.<br>
<br>
My idea was to read /sys/block/dm-X/name but someone indicated to me<br>
that may not be correct in some situation, like it seems that<br>
/lib/udev/scsi_id would not be correct either.<br>
<br>
To give a bit of context it&#39;s for an OpenStack library in Python.<br>
<br>
Thanks,<br>
s.<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</blockquote></div>

--000000000000458f4a0584961802--


--===============5325240912423526482==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5325240912423526482==--
