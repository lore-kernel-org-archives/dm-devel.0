From: Christoph Nelles <evilazrael@evilazrael.de>
Subject: Re: DM-Cache Writeback & Direct IO?
Date: Thu, 09 Jul 2015 17:51:50 +0200
Message-ID: <559E9896.3040305@evilazrael.de>
References: <9E0DEE10BA62134F89BB5A513CA84BC3A1A6B5CA@MAILSERVER01.trt9a.local>	<CAEZ+n-j_9QGWi7pdZY71VAmF-tnuRWb_8neWBd3iKMTm-yQU1A@mail.gmail.com>
	<CAEZ+n-hF2EUPAHYC98ao0x_Q2nWXFodaxXkBqjg8ZvpqNviVKQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0584186564011214562=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAEZ+n-hF2EUPAHYC98ao0x_Q2nWXFodaxXkBqjg8ZvpqNviVKQ@mail.gmail.com>
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

This is a multi-part message in MIME format.
--===============0584186564011214562==
Content-Type: multipart/alternative;
	boundary="------------020104090005010205010004"

This is a multi-part message in MIME format.
--------------020104090005010205010004
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi Leonardo,

I am aware that sequential IO is routed directly to the backing device. 
And I also played with the parameters like sequential_threshold and the 
write_promote_adjustment introduced in 3.14.
To test this i ran ./fio --name=test --filename=/dev/mapper/dmcache  
--rw=randwrite  --filesize=16G --bs=64k --ioengine=libaio --direct=1 
--iodepth=1000 in a endless loop.

Regards

Christoph


Am 08.07.2015 um 19:55 schrieb Leonardo Santos:
> Are you using sequential or random workload?
> It's important, since DMCache bypasses sequential I/O based on theshold.
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--------------020104090005010205010004
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx4-phx2.redhat.com id t69FpojF027438

<html>
  <head>
    <meta content=3D"text/html; charset=3Dwindows-1252"
      http-equiv=3D"Content-Type">
  </head>
  <body bgcolor=3D"#FFFFFF" text=3D"#000000">
    <div class=3D"moz-cite-prefix">Hi Leonardo, <br>
      <br>
      I am aware that sequential IO is routed directly to the backing
      device. And I also played with the parameters like
      sequential_threshold and the write_promote_adjustment introduced
      in 3.14. <br>
      To test this i ran ./fio --name=3Dtest
      --filename=3D/dev/mapper/dmcache=A0 --rw=3Drandwrite=A0 --filesize=3D=
16G=A0
      --bs=3D64k --ioengine=3Dlibaio --direct=3D1 --iodepth=3D1000 in a e=
ndless
      loop. <br>
      <br>
      Regards <br>
      <br>
      Christoph<br>
      <br>
      <br>
      Am 08.07.2015 um 19:55 schrieb Leonardo Santos:<br>
    </div>
    <blockquote
cite=3D"mid:CAEZ+n-hF2EUPAHYC98ao0x_Q2nWXFodaxXkBqjg8ZvpqNviVKQ@mail.gmai=
l.com"
      type=3D"cite">
      <div dir=3D"ltr">
        <div class=3D"gmail_extra">
          <div class=3D"gmail_quote">
            <pre style=3D"color:rgb(0,0,0)"><font face=3D"arial, sans-ser=
if">Are you using sequential or random workload?=A0</font></pre>
            <pre style=3D"color:rgb(0,0,0)"><span style=3D"font-family:ar=
ial,sans-serif">It's important, since DMCache bypasses sequential I/O bas=
ed on theshold.</span></pre>
          </div>
        </div>
      </div>
      <br>
      <fieldset class=3D"mimeAttachmentHeader"></fieldset>
      <br>
      <pre wrap=3D"">--
dm-devel mailing list
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:dm-devel@redhat.com"=
>dm-devel@redhat.com</a>
<a class=3D"moz-txt-link-freetext" href=3D"https://www.redhat.com/mailman=
/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a><=
/pre>
    </blockquote>
    <br>
  </body>
</html>

--------------020104090005010205010004--


--===============0584186564011214562==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============0584186564011214562==--
