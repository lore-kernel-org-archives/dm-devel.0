From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [BUG] multipath-tools: missing internal values
 (multipath -t)
Date: Thu, 27 Apr 2017 09:10:09 +0200
Message-ID: <CABr-Gnd_6OnfOGrdyW2SYftoT6V+-V7RAANCBsVncVLgxtEuKg@mail.gmail.com>
References: <5a9ce04c-3996-9f88-1682-822b0d7b9e65@gmail.com>
	<20170425184224.GV19236@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8778395815267709717=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170425184224.GV19236@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

--===============8778395815267709717==
Content-Type: multipart/alternative; boundary=001a113ee8aec1778f054e20a541

--001a113ee8aec1778f054e20a541
Content-Type: text/plain; charset=UTF-8

Hi,

The config outputed should be usable, so a comment could be printed for the
keywords you suggest printing <undef> as the default for.

Example:

# no_path_retry <comment explaining the contextual default behaviour>

or simply

# no_path_retry <contextual, see man page>

On Tue, Apr 25, 2017 at 8:42 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Tue, Apr 25, 2017 at 04:26:06PM +0200, Xose Vazquez Perez wrote:
> > Hi,
> >
> > These values:
>
> What do you think of these?
> > no_path_retry
>
> The default if no_path_retry is set is to use the features line to
> determine what to do when there are no paths. we could have it
> print something like
>
> no_path_retry <undef>
>
> > dev_loss_tmo
>
> The default here is to keep whatever the sysfs value currently is. We
> could print
>
> dev_loss_tmo <undef>
>
> or
>
> dev_loss_tmo <sysfs>
>
> or something else. I'm open to ideas.
>
> > reservation_key
>
> The default here is nothing
>
> reservation_key <undef>
>
> probably makes the most sense
>
> > partition_delimite
>
> The default here is an empty string
>
> partition_delm ""
>
> is probably the right answer.
>
> > delay_watch_checks
> > delay_wait_checks
>
> These clearly have well defined default values and should be set.
>
>
> -Ben
>
> > are missing from the "defaults section" of multipath -t output.
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a113ee8aec1778f054e20a541
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>The config outputed should be usabl=
e, so a comment could be printed for the keywords you suggest printing &lt;=
undef&gt; as the default for.</div><div><br></div><div>Example:</div><div><=
br></div><div>#=C2=A0<span style=3D"font-size:19.2px">no_path_retry &lt;com=
ment explaining the contextual default behaviour&gt;</span></div><div><span=
 style=3D"font-size:19.2px"><br></span></div><div><span style=3D"font-size:=
19.2px">or simply</span></div><div><span style=3D"font-size:19.2px"><br></s=
pan></div><div><span style=3D"font-size:19.2px"># no_path_retry &lt;context=
ual, see man page&gt;</span></div></div><div class=3D"gmail_extra"><br><div=
 class=3D"gmail_quote">On Tue, Apr 25, 2017 at 8:42 PM, Benjamin Marzinski =
<span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"_bla=
nk">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail=
_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:=
1ex">On Tue, Apr 25, 2017 at 04:26:06PM +0200, Xose Vazquez Perez wrote:<br=
>
&gt; Hi,<br>
&gt;<br>
&gt; These values:<br>
<br>
What do you think of these?<br>
&gt; no_path_retry<br>
<br>
The default if no_path_retry is set is to use the features line to<br>
determine what to do when there are no paths. we could have it<br>
print something like<br>
<br>
no_path_retry &lt;undef&gt;<br>
<br>
&gt; dev_loss_tmo<br>
<br>
The default here is to keep whatever the sysfs value currently is. We<br>
could print<br>
<br>
dev_loss_tmo &lt;undef&gt;<br>
<br>
or<br>
<br>
dev_loss_tmo &lt;sysfs&gt;<br>
<br>
or something else. I&#39;m open to ideas.<br>
<br>
&gt; reservation_key<br>
<br>
The default here is nothing<br>
<br>
reservation_key &lt;undef&gt;<br>
<br>
probably makes the most sense<br>
<br>
&gt; partition_delimite<br>
<br>
The default here is an empty string<br>
<br>
partition_delm &quot;&quot;<br>
<br>
is probably the right answer.<br>
<br>
&gt; delay_watch_checks<br>
&gt; delay_wait_checks<br>
<br>
These clearly have well defined default values and should be set.<br>
<br>
<br>
-Ben<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; are missing from the &quot;defaults section&quot; of multipath -t outp=
ut.<br>
&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"no=
referrer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm=
-devel</a><br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm-deve=
l</a><br>
</div></div></blockquote></div><br></div>

--001a113ee8aec1778f054e20a541--


--===============8778395815267709717==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8778395815267709717==--
