From: Thanos Makatos <thanos.makatos@onapp.com>
Subject: Re: dm-cache failure semantics in write-back mode
Date: Tue, 3 Mar 2015 15:53:39 +0000
Message-ID: <CAM2wQBsGay5cnTR+CO_BpSL8SiYiaQm-MnWFDQC_hG1AH3PcQw@mail.gmail.com>
References: <CAM2wQBtW2Bit2rx-1+hngUyh1gObtt+vjWQkDVWcTfm=axCyDw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1277830177252303912=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAM2wQBtW2Bit2rx-1+hngUyh1gObtt+vjWQkDVWcTfm=axCyDw@mail.gmail.com>
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
Cc: heinzm@redhat.com, thornber@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

--===============1277830177252303912==
Content-Type: multipart/alternative; boundary=089e013d0df899b72205106456fe

--089e013d0df899b72205106456fe
Content-Type: text/plain; charset=UTF-8

On Tue, Feb 17, 2015 at 12:15 PM, Thanos Makatos <thanos.makatos@onapp.com>
wrote:

> Hi,
>
> I'm trying to understand the failure semantics of dm-cache in write-back
> mode. In Documentation/device-mapper/cache.txt it is stated:
>
> "On-disk metadata is committed every time a FLUSH or FUA bio is written.
> If no such requests are made then commits will occur every second.  This
> means the cache behaves like a physical disk that has a volatile write
> cache.  If power is lost you may lose some recent writes.  The metadata
> should always be consistent in spite of any crash."
>
> Which I admit confuses me. Assumie that no FLUSH/FUA requerst is issued
> (e.g. the user of the cached device is a Windows VM) and a failure occurs
> (e.g. there is a power failure but both the HDD and the SSD are fine)
> immediatelly after a write I/O request, but before on-disk metadata get
> commited (e.g. the failure occurs less than a second after the write I/O
> request was completed). After the hosts reboots, is this completed write
> I/O request going to be lost?
>

I haven't gotten any reply to this so I'll try to rephrase: If the user of
the cache doesn't issue FLUSH/FUA, is there a chance of (irreversible) data
loss in the event of a kernel crash or power failure?

--089e013d0df899b72205106456fe
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On T=
ue, Feb 17, 2015 at 12:15 PM, Thanos Makatos <span dir=3D"ltr">&lt;<a href=
=3D"mailto:thanos.makatos@onapp.com" target=3D"_blank">thanos.makatos@onapp=
.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"lt=
r"><div>Hi,</div><div><br></div><div>I&#39;m trying to understand the failu=
re semantics of dm-cache in write-back mode. In Documentation/device-mapper=
/cache.txt it is stated:</div><div><br></div><div><div>&quot;On-disk metada=
ta is committed every time a FLUSH or FUA bio is written.</div><div>If no s=
uch requests are made then commits will occur every second.=C2=A0 This</div=
><div>means the cache behaves like a physical disk that has a volatile writ=
e</div><div>cache.=C2=A0 If power is lost you may lose some recent writes.=
=C2=A0 The metadata</div><div>should always be consistent in spite of any c=
rash.&quot;</div></div><div><br></div><div>Which I admit confuses me. Assum=
ie that no FLUSH/FUA requerst is issued (e.g. the user of the cached device=
 is a Windows VM) and a failure occurs (e.g. there is a power failure but b=
oth the HDD and the SSD are fine) immediatelly after a write I/O request, b=
ut before on-disk metadata get commited (e.g. the failure occurs less than =
a second after the write I/O request was completed). After the hosts reboot=
s, is this completed write I/O request going to be lost?</div></div></block=
quote><div><br></div><div>I haven&#39;t gotten any reply to this so I&#39;l=
l try to rephrase: If the user of the cache doesn&#39;t issue FLUSH/FUA, is=
 there a chance of (irreversible) data loss in the event of a kernel crash =
or power failure?</div></div><br></div></div>

--089e013d0df899b72205106456fe--


--===============1277830177252303912==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1277830177252303912==--
