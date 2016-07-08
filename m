From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: Subject: [PATCH 1/1] multipath-tools: fix dm- device
	filtering
Date: Fri, 8 Jul 2016 08:55:38 +0200
Message-ID: <CABr-Gnf_=7R7GTnJz_eamQEVtv=aEV7Zx3v2QGDRRj2u5NVuvw@mail.gmail.com>
References: <CAAZtj82kfWDjnqLYbqi==BRGukYQXCV=mTR3hmD6XOiD-C3-0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7437254170305897669=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAZtj82kfWDjnqLYbqi==BRGukYQXCV=mTR3hmD6XOiD-C3-0Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dragan Stancevic <dragan.stancevic@canonical.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============7437254170305897669==
Content-Type: multipart/alternative; boundary=001a114108405200ec05371a4a95

--001a114108405200ec05371a4a95
Content-Type: text/plain; charset=UTF-8

Hannes, Ben, do you ack this one ?

On Thu, Jun 23, 2016 at 11:06 PM, Dragan Stancevic <
dragan.stancevic@canonical.com> wrote:

> Hi Christophe,
>
> can you please take a look at the attached patch, we are seeing quite a
> few cases with the following errors:
>
> failed to get udev uid: Invalid argument
> failed to get sysfs uid: Invalid argument
> failed to get sgio uid: No such file or directory
>
> It causes a lot of confusion because the devices in question are in the
> blacklist but aren't getting filtered. I don't know the code well enough,
> but it seems that maybe there should be no condition in the filtering and
> the code should just be:
> if (dev && (filter_devnode(conf->blist_devnode, conf->elist_devnode, dev)
> > 0)) {
>
> But I went for smaller change option, by just allowing DEV_UEVENT to also
> be filtered.
>
> What do you think?
>
> Thanks.
>

--001a114108405200ec05371a4a95
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hannes, Ben, do you ack this one ?</div><div class=3D"gmai=
l_extra"><br><div class=3D"gmail_quote">On Thu, Jun 23, 2016 at 11:06 PM, D=
ragan Stancevic <span dir=3D"ltr">&lt;<a href=3D"mailto:dragan.stancevic@ca=
nonical.com" target=3D"_blank">dragan.stancevic@canonical.com</a>&gt;</span=
> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bo=
rder-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr">Hi Christophe,<=
br><div><br></div><div>can you please take a look at the attached patch, we=
 are seeing quite a few cases with the following errors:</div><div><br></di=
v><div><div>failed to get udev uid: Invalid argument</div><div>failed to ge=
t sysfs uid: Invalid argument</div><div>failed to get sgio uid: No such fil=
e or directory</div></div><div><br></div><div>It causes a lot of confusion =
because the devices in question are in the blacklist but aren&#39;t getting=
 filtered. I don&#39;t know the code well enough, but it seems that maybe t=
here should be no condition in the filtering and the code should just be:</=
div><div>if (dev &amp;&amp; (filter_devnode(conf-&gt;blist_devnode, conf-&g=
t;elist_devnode, dev) &gt; 0)) {<br></div><div><br></div><div>But I went fo=
r smaller change option, by just allowing=C2=A0DEV_UEVENT to also be filter=
ed.</div><div><br></div><div>What do you think?</div><div><br></div><div>Th=
anks.</div></div>
</blockquote></div><br></div>

--001a114108405200ec05371a4a95--


--===============7437254170305897669==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7437254170305897669==--
