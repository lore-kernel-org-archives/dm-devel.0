From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: Unable to deactivate lv,
	pehaps due to semaphore problem...
Date: Thu, 27 Nov 2014 17:27:35 +0100
Message-ID: <CAG2kNCz=KuBKcLog-Z=iZBNAg9J31KwFRa7RgJ0GLXNqsd4UYQ@mail.gmail.com>
References: <CAG2kNCxiZhRpfnifa58bDODfcyhaArLmP4kbgPfPs=2Lq_tYWw@mail.gmail.com>
	<54773621.5090301@redhat.com>
	<CAG2kNCyDcgCdCpUAzZ51mAyqS8LF9i9Tau3Lke5E2ZJy352_ig@mail.gmail.com>
	<54774220.7080709@redhat.com>
	<CAG2kNCz7hmtcMQBeVQRbryVTzsE_DKr9y8Pg8rfKmSf8UDVDRQ@mail.gmail.com>
	<5477469A.1080103@redhat.com>
	<CAG2kNCz_SKbHc4b56L1Dzkb19HsozW9aKs1Ln4MmYY9iUiLJOg@mail.gmail.com>
	<54774BCC.6020709@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3135878093609141400=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54774BCC.6020709@redhat.com>
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

--===============3135878093609141400==
Content-Type: multipart/alternative; boundary=047d7b5d61943425af0508d99f85

--047d7b5d61943425af0508d99f85
Content-Type: text/plain; charset=UTF-8

On Thu, Nov 27, 2014 at 5:05 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote:

>
>>
> So it's likely a time to look through 'dmesg' output if there is not
> something suspicious ?
>
> Kernel bug/report showing some error behavior which may lead to openned
> descriptor being leaked?
>
> Is there anything in  /sys/block/dm-49/holders ?
>
> cat /proc/self/mountinfo | grep 253:49 ?
>
>
>
I tried before, but found nothing

[root@orapr2 ~]# ll /sys/block/dm-49/holders
total 0

[root@orapr2 ~]# cat /proc/self/mountinfo | grep 253:49
[root@orapr2 ~]#

last lines of dmesg contain
dlm: closing connection to node 1
dlm: got connection from 1

That refers to when we restarted the passive node yesterday
Nov 26 17:23:58 orapr2 kernel: dlm: closing connection to node 1

--047d7b5d61943425af0508d99f85
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On T=
hu, Nov 27, 2014 at 5:05 PM, Zdenek Kabelac <span dir=3D"ltr">&lt;<a href=
=3D"mailto:zkabelac@redhat.com" target=3D"_blank">zkabelac@redhat.com</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0=
px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);borde=
r-left-style:solid;padding-left:1ex"><div><div class=3D"h5"><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;=
border-left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex=
"><br>
</blockquote>
<br></div></div>
So it&#39;s likely a time to look through &#39;dmesg&#39; output if there i=
s not something suspicious ?<br>
<br>
Kernel bug/report showing some error behavior which may lead to openned des=
criptor being leaked?<br>
<br>
Is there anything in=C2=A0 /sys/block/dm-49/holders ?<br>
<br>
cat /proc/self/mountinfo | grep 253:49 ?<div class=3D""><div class=3D"h5"><=
br><br>
</div></div></blockquote></div></div><div class=3D"gmail_extra"><br></div><=
div class=3D"gmail_extra">I tried before, but found nothing</div><div class=
=3D"gmail_extra"><br></div><div class=3D"gmail_extra"><div class=3D"gmail_e=
xtra">[root@orapr2 ~]# ll /sys/block/dm-49/holders</div><div class=3D"gmail=
_extra">total 0</div><div><br></div><div><div>[root@orapr2 ~]# cat /proc/se=
lf/mountinfo | grep 253:49</div><div>[root@orapr2 ~]#=C2=A0</div></div><div=
><br></div><div>last lines of dmesg contain</div><div><div>dlm: closing con=
nection to node 1</div><div>dlm: got connection from 1</div></div><div><br>=
</div><div>That refers to when we restarted the passive node yesterday</div=
><div><div>Nov 26 17:23:58 orapr2 kernel: dlm: closing connection to node 1=
</div></div><div><br></div><div><br></div><div><br></div></div></div>

--047d7b5d61943425af0508d99f85--


--===============3135878093609141400==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3135878093609141400==--
