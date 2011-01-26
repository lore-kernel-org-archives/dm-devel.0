From: nishant mungse <nishantmungse@gmail.com>
Subject: Re: multipath: change the DEFAULT_MINIO for the request
 based multipath
Date: Wed, 26 Jan 2011 12:27:43 -0500
Message-ID: <AANLkTi=kDz5MpdQNBQcvaQUubmjeR2+Qx4bzVkie=6SC@mail.gmail.com>
References: <91d6dae7d88296d8a1fe.1295472607@malahal>
	<4D37E513.3070506@suse.de> <20110120160726.GA23529@redhat.com>
	<4D392FBD.5080207@ce.jp.nec.com>
	<1295599627.23625.16.camel@zezette>
	<20110121141204.GE30411@redhat.com>
	<1295621193.23625.37.camel@zezette>
	<20110121173930.GB20278@us.ibm.com>
	<4D3E9020.6010009@ce.jp.nec.com> <20110126022307.GA512@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7827909090524080782=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110126022307.GA512@us.ibm.com>
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

--===============7827909090524080782==
Content-Type: multipart/alternative; boundary=90e6ba6150c28f268b049ac32642

--90e6ba6150c28f268b049ac32642
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jan 25, 2011 at 9:23 PM, Malahal Naineni <malahal@us.ibm.com> wrote:

> Jun'ichi Nomura [j-nomura@ce.jp.nec.com] wrote:
> > >> Defaults are layered. For current minio, we have :
> > >> [1] one top level default (hardcoded, superseded by config)
> > >> [2] per hardware default (hardcoded, superseded by config)
> > >> [3] per multipath value (none hardcoded, defined by config)
> > >>
> > >> You suggest multipath-tools to adapt only the top level minio default
> > >> depending on dm-rq availability [1], but what of the hwtable defaults
> > >> [2] ? Should we provide vendors with a way to describe a with-rq minio
> > >> default *and* a without-rq minio default (a new parameter in the
> hwentry
> > >> struct) ? If so, we should also provide a new config file keyword to
> > >> override this new hwentry parameter hardcoded value ... then the
> > >> reasoning cascades to the mpentry struct minio setting [3].
> > >>
> > >> Actually, [1] is hardly the common case : only unknown hardware resort
> > >> to these defaults.
> >
> > Do we really need [2]?
> >
> > Currently, there seem only 3 minio values in per-hardware default:
> >   - 1000 (DEFAULT_MINIO)
> >   - 128
> >   - 100
> >
> > I think both 128 and 100 are based on that, in many systems/cases,
> > max request size (max_sectors) is 512KB and BIO submission
> > is done in page-size unit (4KB).
> >
> > If there isn't strong reason for the current default (1000)
> > (and I think there isn't), it seems we can remove [2]
> > after changing the default to 128 (or 100).
> >
> > > 1. Set DEFAULT_MINIO to -1
> > > 2. If bio based mapping and the value is -1, set it to 1000
> > >    (DEFAULT_BIO_MINIO)
> > > 3. If request based mapping, set it to DEFAULT_REQUEST_MINIO.
> >
> > Does it mean users can't change rr_min_io value for request-based dm?
> > I suspect it is possible that someone wants to set non-default
> > value to minio for request-based dm.
>
> Your reading is correct that my proposal doesn't allow it. If we get away
> with [2] above (hwatable.c based values), then we can have something
> like this:
>
> 1. Remove it from hwentry structure or set it to -1
> 2. If rr_minio is specified in the conf file (either through default or
>   device section etc), use it.
> 3. If not specified in the config file, use DEFAULT_BIO_MINIO or
>   DEFAULT_REQUEST_MINIO based on the multipath module version.
>
> In other words, every device out there uses DEFAULT_BIO_MINIO or
> DEFAULT_REQUEST_MINIO if not specified by the administrator.
> Admin can override it in /etc/multipath.conf file.
>
> CON: No per device controller default  (aka hwtable entry value)
>
> Thanks, Malahal.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>


hello all,

There is one doubt regarding the dm-raid1. As far as i know, in dm-raid1 the
data is written parallelly  on all the mirrors of mirrorset and if any of
the mirror fails to write the data then dm-mirror adds this mirror to fail
list by increasing the error count in "fail mirror" function in dm-raid1.
Actually my doubt is where this error count is decremented? i.e after kcpyd
or before and where exactly this error count is decremented?

Regards,
Nishant.

--90e6ba6150c28f268b049ac32642
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Tue, Jan 25, 2011 at 9:23 PM, Malahal=
 Naineni <span dir=3D"ltr">&lt;<a href=3D"mailto:malahal@us.ibm.com">malaha=
l@us.ibm.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" sty=
le=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex;=
 padding-left: 1ex;">
Jun&#39;ichi Nomura [<a href=3D"mailto:j-nomura@ce.jp.nec.com">j-nomura@ce.=
jp.nec.com</a>] wrote:<br>
&gt; &gt;&gt; Defaults are layered. For current minio, we have :<br>
&gt; &gt;&gt; [1] one top level default (hardcoded, superseded by config)<b=
r>
&gt; &gt;&gt; [2] per hardware default (hardcoded, superseded by config)<br=
>
&gt; &gt;&gt; [3] per multipath value (none hardcoded, defined by config)<b=
r>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; You suggest multipath-tools to adapt only the top level minio=
 default<br>
&gt; &gt;&gt; depending on dm-rq availability [1], but what of the hwtable =
defaults<br>
&gt; &gt;&gt; [2] ? Should we provide vendors with a way to describe a with=
-rq minio<br>
&gt; &gt;&gt; default *and* a without-rq minio default (a new parameter in =
the hwentry<br>
&gt; &gt;&gt; struct) ? If so, we should also provide a new config file key=
word to<br>
&gt; &gt;&gt; override this new hwentry parameter hardcoded value ... then =
the<br>
&gt; &gt;&gt; reasoning cascades to the mpentry struct minio setting [3].<b=
r>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Actually, [1] is hardly the common case : only unknown hardwa=
re resort<br>
&gt; &gt;&gt; to these defaults.<br>
&gt;<br>
&gt; Do we really need [2]?<br>
&gt;<br>
&gt; Currently, there seem only 3 minio values in per-hardware default:<br>
&gt; =A0 - 1000 (DEFAULT_MINIO)<br>
&gt; =A0 - 128<br>
&gt; =A0 - 100<br>
&gt;<br>
&gt; I think both 128 and 100 are based on that, in many systems/cases,<br>
&gt; max request size (max_sectors) is 512KB and BIO submission<br>
&gt; is done in page-size unit (4KB).<br>
&gt;<br>
&gt; If there isn&#39;t strong reason for the current default (1000)<br>
&gt; (and I think there isn&#39;t), it seems we can remove [2]<br>
&gt; after changing the default to 128 (or 100).<br>
&gt;<br>
&gt; &gt; 1. Set DEFAULT_MINIO to -1<br>
&gt; &gt; 2. If bio based mapping and the value is -1, set it to 1000<br>
&gt; &gt; =A0 =A0(DEFAULT_BIO_MINIO)<br>
&gt; &gt; 3. If request based mapping, set it to DEFAULT_REQUEST_MINIO.<br>
&gt;<br>
&gt; Does it mean users can&#39;t change rr_min_io value for request-based =
dm?<br>
&gt; I suspect it is possible that someone wants to set non-default<br>
&gt; value to minio for request-based dm.<br>
<br>
Your reading is correct that my proposal doesn&#39;t allow it. If we get aw=
ay<br>
with [2] above (hwatable.c based values), then we can have something<br>
like this:<br>
<br>
1. Remove it from hwentry structure or set it to -1<br>
2. If rr_minio is specified in the conf file (either through default or<br>
 =A0 device section etc), use it.<br>
3. If not specified in the config file, use DEFAULT_BIO_MINIO or<br>
 =A0 DEFAULT_REQUEST_MINIO based on the multipath module version.<br>
<br>
In other words, every device out there uses DEFAULT_BIO_MINIO or<br>
DEFAULT_REQUEST_MINIO if not specified by the administrator.<br>
Admin can override it in /etc/multipath.conf file.<br>
<br>
CON: No per device controller default =A0(aka hwtable entry value)<br>
<br>
Thanks, Malahal.<br>
<font color=3D"#888888"><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</font></blockquote></div><br><br>hello all,<br><br>
There is one doubt regarding the dm-raid1. As far as i know, in
dm-raid1 the data is written parallelly=A0 on all the mirrors of
mirrorset and if any of the mirror fails to write the data then
dm-mirror adds this mirror to fail list by increasing the error count
in &quot;fail mirror&quot; function in dm-raid1. <br>
Actually my doubt is where this error count is decremented? i.e after
kcpyd or before and where exactly this error count is decremented?<br><br>R=
egards,<br>Nishant.<br>

--90e6ba6150c28f268b049ac32642--


--===============7827909090524080782==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7827909090524080782==--
