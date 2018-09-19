From: =?UTF-8?B?w5Z6a2FuIEfDtmtzdQ==?= <ozkangksu@gmail.com>
Subject: Re: device-mapper: ioctl: ioctl interface mismatch:
 kernel(4.37.0), user(4.39.0), cmd(16)
Date: Wed, 19 Sep 2018 15:07:23 +0300
Message-ID: <CAPUHmCq6QDw4d0R+H_b-t52g8VRqB-1qOUiTnG+=ksCFWKjtGA@mail.gmail.com>
References: <CAPUHmCpwJ7jX-d6PHdmOWQC47zOBkT1-c6o2DH4xS9_Uq13vBA@mail.gmail.com>
	<427e4283-7ea2-f394-b463-89c9c6bd0a23@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1514021943057805736=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <427e4283-7ea2-f394-b463-89c9c6bd0a23@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============1514021943057805736==
Content-Type: multipart/alternative; boundary="0000000000006904680576384065"

--0000000000006904680576384065
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your answer.

I will report the issue to arch-linux team.

Regards.

Heinz Mauelshagen <heinzm@redhat.com>, 19 Eyl 2018 =C3=87ar, 14:48 tarihind=
e
=C5=9Funu yazd=C4=B1:

> =C3=96zkan,
>
> as you report, your device-mapper version is too recent for your kernel
> (the major version has to match and the kernel minor version needs to
> greater or equal),
> i.e. 4.39 is too recent for version 4.37 in the kernel.
>
> In case you updated kernel and userspace by pacman means, something's
> broken in the Arch repositories.
>
> You either have to downgrade your device-mapper userspace
> or upgrade your kernel accordingly.
>
> Heinz
>
> On 09/19/2018 12:35 PM, =C3=96zkan G=C3=B6ksu wrote:
>
> Hello.
> I just upgraded my Kernel to: 4.14.70-1-lts | device-mapper 2.02.181-1 |
> multipath-tools 0.7.7-1
> After that multipathd started to giving the log: // device-mapper: ioctl:
> ioctl interface mismatch: kernel(4.37.0), user(4.39.0), cmd(16)
> It was working great on my ex kernel "4.14.30-1-lts" with | device-mapper
> 2.02.177-5 | multipath-tools 0.7.6-1
> Also I tried multipath git version but nothing change.
>
> I think the problem related to device-mapper and my device mapper Build
> Date: 2018-08-01 19:05 UTC =3D
> https://www.archlinux.org/packages/core/x86_64/device-mapper/
> Do I need to compile device mapper git version or what should I do?
>
>
> --
> dm-devel mailing listdm-devel@redhat.comhttps://www.redhat.com/mailman/li=
stinfo/dm-devel
>
>
>

--0000000000006904680576384065
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thank you for your answer.<div><br></div><div>I will repor=
t the issue to arch-linux team.=C2=A0</div><div><br></div><div>Regards.=C2=
=A0</div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr">Heinz Mauels=
hagen &lt;<a href=3D"mailto:heinzm@redhat.com">heinzm@redhat.com</a>&gt;, 1=
9 Eyl 2018 =C3=87ar, 14:48 tarihinde =C5=9Funu yazd=C4=B1:<br></div><blockq=
uote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc =
solid;padding-left:1ex">
 =20
   =20
 =20
  <div text=3D"#000000" bgcolor=3D"#FFFFFF">
    <p>=C3=96zkan,<br>
    </p>
    <p>as you report, your device-mapper version is too recent for your
      kernel<br>
      (the major version has to match and the kernel minor version needs
      to greater or equal),<br>
      i.e. 4.39 is too recent for version 4.37 in the kernel.</p>
    <p>In case you updated kernel and userspace by pacman means,
      something&#39;s broken in the Arch repositories.<br>
    </p>
    <p>You either have to downgrade your device-mapper userspace<br>
      or upgrade your kernel accordingly.<br>
      <br>
      Heinz<br>
    </p>
    <br>
    <div class=3D"m_3002063019584387866moz-cite-prefix">On 09/19/2018 12:35=
 PM, =C3=96zkan G=C3=B6ksu
      wrote:<br>
    </div>
    <blockquote type=3D"cite">
     =20
      <div dir=3D"ltr">
        <div dir=3D"ltr">
          <div dir=3D"ltr">
            <div dir=3D"ltr">
              <div class=3D"m_3002063019584387866gmail-linestyle1 m_3002063=
019584387866gmail-colourline">Hello.
                <br>
                <span style=3D"font-size:12.8px">I just upgraded my Kernel
                  to: 4.14.70-1-lts | device-mapper 2.02.181-1 |
                  multipath-tools 0.7.7-1</span><br>
              </div>
              <div class=3D"m_3002063019584387866gmail-linestyle2 m_3002063=
019584387866gmail-colourline"><span style=3D"font-size:12.8px">After that m=
ultipathd started
                  to giving the log:=C2=A0</span><span style=3D"font-size:1=
2.8px">// device-mapper: ioctl:
                  ioctl interface mismatch: kernel(4.37.0),
                  user(4.39.0), cmd(16)</span><br>
              </div>
              <div class=3D"m_3002063019584387866gmail-linestyle2 m_3002063=
019584387866gmail-colourline"><span style=3D"font-size:12.8px">It was worki=
ng great on my ex
                  kernel &quot;4.14.30-1-lts&quot; with | device-mapper 2.0=
2.177-5
                  | multipath-tools 0.7.6-1</span><br>
              </div>
              <div class=3D"m_3002063019584387866gmail-linestyle2 m_3002063=
019584387866gmail-colourline"><span style=3D"font-size:12.8px">Also I tried=
 multipath git
                  version but nothing change.</span><br>
              </div>
              <div class=3D"m_3002063019584387866gmail-linestyle1 m_3002063=
019584387866gmail-colourline"><br>
              </div>
              <div class=3D"m_3002063019584387866gmail-linestyle1 m_3002063=
019584387866gmail-colourline">I
                think the problem related to device-mapper and my device
                mapper Build Date: 2018-08-01 19:05 UTC =3D=C2=A0<a href=3D=
"https://www.archlinux.org/packages/core/x86_64/device-mapper/" rel=3D"noop=
ener" target=3D"_blank">https://www.archlinux.org/packages/core/x86_64/devi=
ce-mapper/</a></div>
              <div class=3D"m_3002063019584387866gmail-linestyle2 m_3002063=
019584387866gmail-colourline">Do
                I need to compile device mapper git version or what
                should I do?</div>
            </div>
          </div>
        </div>
      </div>
      <br>
      <fieldset class=3D"m_3002063019584387866mimeAttachmentHeader"></field=
set>
      <br>
      <pre>--
dm-devel mailing list
<a class=3D"m_3002063019584387866moz-txt-link-abbreviated" href=3D"mailto:d=
m-devel@redhat.com" target=3D"_blank">dm-devel@redhat.com</a>
<a class=3D"m_3002063019584387866moz-txt-link-freetext" href=3D"https://www=
.redhat.com/mailman/listinfo/dm-devel" target=3D"_blank">https://www.redhat=
.com/mailman/listinfo/dm-devel</a></pre>
    </blockquote>
    <br>
  </div>

</blockquote></div>

--0000000000006904680576384065--


--===============1514021943057805736==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1514021943057805736==--
