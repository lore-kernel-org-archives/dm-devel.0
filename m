From: Daniel Ehrenberg <dehrenberg@google.com>
Subject: Re: dm: Get devices using name_to_dev_t
Date: Wed, 14 Jan 2015 20:15:25 -0800
Message-ID: <CAAK6Zt0yzdyd3zK8zLJh_+Lym_6KujiwVxd6xs3145ghao_-vg@mail.gmail.com>
References: <1421280960-23984-1-git-send-email-dehrenberg@chromium.org>
	<20150115022636.GA7967@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6764413107540070057=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150115022636.GA7967@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Grant Grundler <grundler@chromium.org>, drewry@chromium.org, Gwendal Grignou <gwendal@chromium.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============6764413107540070057==
Content-Type: multipart/alternative; boundary=089e01175f2b086886050ca91bef

--089e01175f2b086886050ca91bef
Content-Type: text/plain; charset=UTF-8

On Jan 14, 2015 6:26 PM, "Mike Snitzer" <snitzer@redhat.com> wrote:
>
> On Wed, Jan 14 2015 at  7:16pm -0500,
> Dan Ehrenberg <dehrenberg@chromium.org> wrote:
>
> > If a device is used as the root filesystem, it can't be built
> > off of devices which are within the root filesystem (just like
> > command line arguments to root=). For this reason, Linux has a
> > pseudo-filesystem for root= and md initialization based on the
> > function name_to_dev_t, which handles different ways of specifying
> > devices including PARTUUID and major:minor.
> >
> > This patch applies name_to_dev_t to dm initialization. Rather
> > than assuming that all things which are not major:minor are paths
> > in an already-mounted filesystem, this patch first attempts
> > name_to_dev_t and tries the filesystem as a fallback.
>
> What is all this talk of an already-mounted filesystem?
>
> dm_get_device() currently assumes either a major:minor or path to the
> block device is provided.  Please be specific about what functionality
> this change enables that you cannot do without.

I want to run dm-verity on top of an ubiblock device. Ubiblock uses a
dynamic major number so I can't just refer to it as a major:minor. Because
it is the root filesystem I can't refer to it through the lookup_bdev path.

Thanks,
Dan

--089e01175f2b086886050ca91bef
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
On Jan 14, 2015 6:26 PM, &quot;Mike Snitzer&quot; &lt;<a href=3D"mailto:sni=
tzer@redhat.com">snitzer@redhat.com</a>&gt; wrote:<br>
&gt;<br>
&gt; On Wed, Jan 14 2015 at=C2=A0 7:16pm -0500,<br>
&gt; Dan Ehrenberg &lt;<a href=3D"mailto:dehrenberg@chromium.org">dehrenber=
g@chromium.org</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; If a device is used as the root filesystem, it can&#39;t be built=
<br>
&gt; &gt; off of devices which are within the root filesystem (just like<br=
>
&gt; &gt; command line arguments to root=3D). For this reason, Linux has a<=
br>
&gt; &gt; pseudo-filesystem for root=3D and md initialization based on the<=
br>
&gt; &gt; function name_to_dev_t, which handles different ways of specifyin=
g<br>
&gt; &gt; devices including PARTUUID and major:minor.<br>
&gt; &gt;<br>
&gt; &gt; This patch applies name_to_dev_t to dm initialization. Rather<br>
&gt; &gt; than assuming that all things which are not major:minor are paths=
<br>
&gt; &gt; in an already-mounted filesystem, this patch first attempts<br>
&gt; &gt; name_to_dev_t and tries the filesystem as a fallback.<br>
&gt;<br>
&gt; What is all this talk of an already-mounted filesystem?<br>
&gt;<br>
&gt; dm_get_device() currently assumes either a major:minor or path to the<=
br>
&gt; block device is provided.=C2=A0 Please be specific about what function=
ality<br>
&gt; this change enables that you cannot do without.</p>
<p dir=3D"ltr">I want to run dm-verity on top of an ubiblock device. Ubiblo=
ck uses a dynamic major number so I can&#39;t just refer to it as a major:m=
inor. Because it is the root filesystem I can&#39;t refer to it through the=
 lookup_bdev path.</p>
<p dir=3D"ltr">Thanks,<br>
Dan</p>

--089e01175f2b086886050ca91bef--


--===============6764413107540070057==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6764413107540070057==--
