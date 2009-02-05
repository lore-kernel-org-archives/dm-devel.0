From: =?ISO-8859-1?Q?Christian_R=F8snes?= <christian.rosnes@gmail.com>
Subject: Re: Multipath setup and rdac questions
Date: Thu, 5 Feb 2009 19:56:31 +0100
Message-ID: <1a4a774c0902051056j7dab1bf9p28d6f1c947d03565@mail.gmail.com>
References: <1a4a774c0902050558r661093dag83e71a06250c24aa@mail.gmail.com>
	<498B00B3.5020402@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0112666576=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <498B00B3.5020402@redhat.com>
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

--===============0112666576==
Content-Type: multipart/alternative; boundary=0016e6d7e11865646e0462307664

--0016e6d7e11865646e0462307664
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2009 at 4:07 PM, Bryn M. Reeves <bmr@redhat.com> wrote:

> Christian R=F8snes wrote:
>
> u should check what the MD3000i reports in sysfs. E.g. for an EMC
> clariion device I see:
>
> # cat /sys/block/sdj/device/vendor
> DGC
> # cat /sys/block/sdj/device/model
> RAID 5
>
> And the corresponding entry in multipath.conf is:
>
>               vendor                  "DGC"
>               product                 "*"
>
> I suspect from the output below that you want:
>
>               vendor                  "DELL"
>               product                 "DELL,MD Virtual Disk"
>
>
Here's what I see for the MD3000i:

# cat /sys/block/sdb/device/vendor
DELL
# cat /sys/block/sdb/device/model
MD Virtual Disk

Thank you
Christian

--0016e6d7e11865646e0462307664
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Thu, Feb 5, 2009 at 4:07 PM, Bryn M. =
Reeves <span dir=3D"ltr">&lt;<a href=3D"mailto:bmr@redhat.com">bmr@redhat.c=
om</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"bord=
er-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-l=
eft: 1ex;">
<div class=3D"Ih2E3d">Christian R=F8snes wrote:<br><br></div>u should check=
 what the MD3000i reports in sysfs. E.g. for an EMC<br>
clariion device I see:<br>
<br>
# cat /sys/block/sdj/device/vendor<br>
DGC<br>
# cat /sys/block/sdj/device/model<br>
RAID 5<br>
<br>
And the corresponding entry in multipath.conf is:<br>
<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; vendor &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&quot;DGC&quot;<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; product &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &quot;*&quot;<br>
<br>
I suspect from the output below that you want:<br>
<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; vendor &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&quot;DELL&quot;<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; product &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &quot;DELL,MD Virtual Disk&quot;<br>
<br>
</blockquote><div><br>Here&#39;s what I see for the MD3000i:<br><br># cat /=
sys/block/sdb/device/vendor<br>DELL<br># cat /sys/block/sdb/device/model<br=
>
MD Virtual Disk<br>&nbsp;
<br>Thank you<br>Christian<br></div></div><br>

--0016e6d7e11865646e0462307664--


--===============0112666576==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0112666576==--
