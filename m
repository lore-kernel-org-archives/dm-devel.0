From: Thanos Makatos <thanos.makatos@onapp.com>
Subject: Re: dm-cache failure semantics in write-back mode
Date: Tue, 3 Mar 2015 17:13:37 +0000
Message-ID: <CAM2wQBsS2hyA674CspKx6xZ49Fc1a=53UghaT5JkAPpjT3D_Ng@mail.gmail.com>
References: <CAM2wQBtW2Bit2rx-1+hngUyh1gObtt+vjWQkDVWcTfm=axCyDw@mail.gmail.com>
	<CAM2wQBsGay5cnTR+CO_BpSL8SiYiaQm-MnWFDQC_hG1AH3PcQw@mail.gmail.com>
	<20150303161935.GA23166@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7930388510766926307=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150303161935.GA23166@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Thanos Makatos <thanos.makatos@onapp.com>, dm-devel@redhat.com, heinzm@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

--===============7930388510766926307==
Content-Type: multipart/alternative; boundary=001a113edada9a89b305106574d4

--001a113edada9a89b305106574d4
Content-Type: text/plain; charset=UTF-8

Thanks, Joe. So just to make sure I've understood correctly, if the SSD
cache is configured as a write-back cache but the device cache is
disabled/set to write-though on the HDD and the SSD, then there is no risk
of data loss in the event of a failure. Is my understanding correct?

On Tue, Mar 3, 2015 at 4:19 PM, Joe Thornber <thornber@redhat.com> wrote:

> On Tue, Mar 03, 2015 at 03:53:39PM +0000, Thanos Makatos wrote:
> > On Tue, Feb 17, 2015 at 12:15 PM, Thanos Makatos <
> thanos.makatos@onapp.com>
> > wrote:
> >
> > > Hi,
> > >
> > > I'm trying to understand the failure semantics of dm-cache in
> write-back
> > > mode. In Documentation/device-mapper/cache.txt it is stated:
> > >
> > > "On-disk metadata is committed every time a FLUSH or FUA bio is
> written.
> > > If no such requests are made then commits will occur every second.
> This
> > > means the cache behaves like a physical disk that has a volatile write
> > > cache.  If power is lost you may lose some recent writes.  The metadata
> > > should always be consistent in spite of any crash."
> > >
> > > Which I admit confuses me. Assumie that no FLUSH/FUA requerst is issued
> > > (e.g. the user of the cached device is a Windows VM) and a failure
> occurs
> > > (e.g. there is a power failure but both the HDD and the SSD are fine)
> > > immediatelly after a write I/O request, but before on-disk metadata get
> > > commited (e.g. the failure occurs less than a second after the write
> I/O
> > > request was completed). After the hosts reboots, is this completed
> write
> > > I/O request going to be lost?
> > >
> >
> > I haven't gotten any reply to this so I'll try to rephrase: If the user
> of
> > the cache doesn't issue FLUSH/FUA, is there a chance of (irreversible)
> data
> > loss in the event of a kernel crash or power failure?
>
> If the mappings change, ie. something is promoted to the cache, or
> demoted from it.  Then the metadata update is committed and updated
> before the triggering io is issued.
>
> So power failure will not result in loss of a mapping, it may result
> in loss of data if your physical device has a write cache.  But this
> is also the case with the cache.
>
> - Joe
>

--001a113edada9a89b305106574d4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks, Joe. So just to make sure I&#39;ve understood corr=
ectly, if the SSD cache is configured as a write-back cache but the device =
cache is disabled/set to write-though on the HDD and the SSD, then there is=
 no risk of data loss in the event of a failure. Is my understanding correc=
t?</div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, M=
ar 3, 2015 at 4:19 PM, Joe Thornber <span dir=3D"ltr">&lt;<a href=3D"mailto=
:thornber@redhat.com" target=3D"_blank">thornber@redhat.com</a>&gt;</span> =
wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bord=
er-left:1px #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=
=3D"h5">On Tue, Mar 03, 2015 at 03:53:39PM +0000, Thanos Makatos wrote:<br>
&gt; On Tue, Feb 17, 2015 at 12:15 PM, Thanos Makatos &lt;<a href=3D"mailto=
:thanos.makatos@onapp.com">thanos.makatos@onapp.com</a>&gt;<br>
&gt; wrote:<br>
&gt;<br>
&gt; &gt; Hi,<br>
&gt; &gt;<br>
&gt; &gt; I&#39;m trying to understand the failure semantics of dm-cache in=
 write-back<br>
&gt; &gt; mode. In Documentation/device-mapper/cache.txt it is stated:<br>
&gt; &gt;<br>
&gt; &gt; &quot;On-disk metadata is committed every time a FLUSH or FUA bio=
 is written.<br>
&gt; &gt; If no such requests are made then commits will occur every second=
.=C2=A0 This<br>
&gt; &gt; means the cache behaves like a physical disk that has a volatile =
write<br>
&gt; &gt; cache.=C2=A0 If power is lost you may lose some recent writes.=C2=
=A0 The metadata<br>
&gt; &gt; should always be consistent in spite of any crash.&quot;<br>
&gt; &gt;<br>
&gt; &gt; Which I admit confuses me. Assumie that no FLUSH/FUA requerst is =
issued<br>
&gt; &gt; (e.g. the user of the cached device is a Windows VM) and a failur=
e occurs<br>
&gt; &gt; (e.g. there is a power failure but both the HDD and the SSD are f=
ine)<br>
&gt; &gt; immediatelly after a write I/O request, but before on-disk metada=
ta get<br>
&gt; &gt; commited (e.g. the failure occurs less than a second after the wr=
ite I/O<br>
&gt; &gt; request was completed). After the hosts reboots, is this complete=
d write<br>
&gt; &gt; I/O request going to be lost?<br>
&gt; &gt;<br>
&gt;<br>
&gt; I haven&#39;t gotten any reply to this so I&#39;ll try to rephrase: If=
 the user of<br>
&gt; the cache doesn&#39;t issue FLUSH/FUA, is there a chance of (irreversi=
ble) data<br>
&gt; loss in the event of a kernel crash or power failure?<br>
<br>
</div></div>If the mappings change, ie. something is promoted to the cache,=
 or<br>
demoted from it.=C2=A0 Then the metadata update is committed and updated<br=
>
before the triggering io is issued.<br>
<br>
So power failure will not result in loss of a mapping, it may result<br>
in loss of data if your physical device has a write cache.=C2=A0 But this<b=
r>
is also the case with the cache.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
- Joe<br>
</font></span></blockquote></div><br></div>

--001a113edada9a89b305106574d4--


--===============7930388510766926307==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7930388510766926307==--
