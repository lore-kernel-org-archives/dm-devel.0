From: nishant mungse <nishantmungse@gmail.com>
Subject: Re: multipath: change the DEFAULT_MINIO for the request
 based multipath
Date: Thu, 27 Jan 2011 10:16:00 -0500
Message-ID: <AANLkTimomHXP6E6bmzOeN-8bLdFJt+JrsDdYOd-XhG5-@mail.gmail.com>
References: <91d6dae7d88296d8a1fe.1295472607@malahal>
	<4D37E513.3070506@suse.de> <20110120160726.GA23529@redhat.com>
	<4D392FBD.5080207@ce.jp.nec.com>
	<1295599627.23625.16.camel@zezette>
	<20110121141204.GE30411@redhat.com>
	<1295621193.23625.37.camel@zezette>
	<20110121173930.GB20278@us.ibm.com>
	<4D3E9020.6010009@ce.jp.nec.com> <20110126022307.GA512@us.ibm.com>
	<AANLkTi=kDz5MpdQNBQcvaQUubmjeR2+Qx4bzVkie=6SC@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7363491254004846890=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AANLkTi=kDz5MpdQNBQcvaQUubmjeR2+Qx4bzVkie=6SC@mail.gmail.com>
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

--===============7363491254004846890==
Content-Type: multipart/alternative; boundary=90e6ba6154b65b884f049ad56d05

--90e6ba6154b65b884f049ad56d05
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Jan 26, 2011 at 12:27 PM, nishant mungse <nishantmungse@gmail.com>wrote:

>
>
> On Tue, Jan 25, 2011 at 9:23 PM, Malahal Naineni <malahal@us.ibm.com>wrote:
>
>> Jun'ichi Nomura [j-nomura@ce.jp.nec.com] wrote:
>> > >> Defaults are layered. For current minio, we have :
>> > >> [1] one top level default (hardcoded, superseded by config)
>> > >> [2] per hardware default (hardcoded, superseded by config)
>> > >> [3] per multipath value (none hardcoded, defined by config)
>> > >>
>> > >> You suggest multipath-tools to adapt only the top level minio default
>> > >> depending on dm-rq availability [1], but what of the hwtable defaults
>> > >> [2] ? Should we provide vendors with a way to describe a with-rq
>> minio
>> > >> default *and* a without-rq minio default (a new parameter in the
>> hwentry
>> > >> struct) ? If so, we should also provide a new config file keyword to
>> > >> override this new hwentry parameter hardcoded value ... then the
>> > >> reasoning cascades to the mpentry struct minio setting [3].
>> > >>
>> > >> Actually, [1] is hardly the common case : only unknown hardware
>> resort
>> > >> to these defaults.
>> >
>> > Do we really need [2]?
>> >
>> > Currently, there seem only 3 minio values in per-hardware default:
>> >   - 1000 (DEFAULT_MINIO)
>> >   - 128
>> >   - 100
>> >
>> > I think both 128 and 100 are based on that, in many systems/cases,
>> > max request size (max_sectors) is 512KB and BIO submission
>> > is done in page-size unit (4KB).
>> >
>> > If there isn't strong reason for the current default (1000)
>> > (and I think there isn't), it seems we can remove [2]
>> > after changing the default to 128 (or 100).
>> >
>> > > 1. Set DEFAULT_MINIO to -1
>> > > 2. If bio based mapping and the value is -1, set it to 1000
>> > >    (DEFAULT_BIO_MINIO)
>> > > 3. If request based mapping, set it to DEFAULT_REQUEST_MINIO.
>> >
>> > Does it mean users can't change rr_min_io value for request-based dm?
>> > I suspect it is possible that someone wants to set non-default
>> > value to minio for request-based dm.
>>
>> Your reading is correct that my proposal doesn't allow it. If we get away
>> with [2] above (hwatable.c based values), then we can have something
>> like this:
>>
>> 1. Remove it from hwentry structure or set it to -1
>> 2. If rr_minio is specified in the conf file (either through default or
>>   device section etc), use it.
>> 3. If not specified in the config file, use DEFAULT_BIO_MINIO or
>>   DEFAULT_REQUEST_MINIO based on the multipath module version.
>>
>> In other words, every device out there uses DEFAULT_BIO_MINIO or
>> DEFAULT_REQUEST_MINIO if not specified by the administrator.
>> Admin can override it in /etc/multipath.conf file.
>>
>> CON: No per device controller default  (aka hwtable entry value)
>>
>> Thanks, Malahal.
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
>
>
> hello all,
>
> There is one doubt regarding the dm-raid1. As far as i know, in dm-raid1
> the data is written parallelly  on all the mirrors of mirrorset and if any
> of the mirror fails to write the data then dm-mirror adds this mirror to
> fail list by increasing the error count in "fail mirror" function in
> dm-raid1.
> Actually my doubt is where this error count is decremented? i.e after kcpyd
> or before and where exactly this error count is decremented?
>
> Regards,
> Nishant.
>



Hi,

I've created a device mapper target and I wanna test its read and
write mechanisms. I created a device using this target and tried to
write a filesystem on to the device.

My target is creating roughly two outgoing bios per incoming bio.
Which is maybe why I'm not able to get a proper log after running the
mke2fs command as while writing the filesystem, there are massive
amounts of writes performed on the device.

So, I tried to use the cat command to directly write to the device
file. The write is being performed for sure because I'm able to view
the data written to the underlying device.

But there is no output when I try to read the device file contents using
cat.

Is there any other way to test the read/write workflows of a dm target
that can give out a proper log ?

Regards,
Nishant.

--90e6ba6154b65b884f049ad56d05
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Wed, Jan 26, 2011 at 12:27 PM, nishan=
t mungse <span dir=3D"ltr">&lt;<a href=3D"mailto:nishantmungse@gmail.com">n=
ishantmungse@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_=
quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt =
0pt 0.8ex; padding-left: 1ex;">
<div><div></div><div class=3D"h5"><br><br><div class=3D"gmail_quote">On Tue=
, Jan 25, 2011 at 9:23 PM, Malahal Naineni <span dir=3D"ltr">&lt;<a href=3D=
"mailto:malahal@us.ibm.com" target=3D"_blank">malahal@us.ibm.com</a>&gt;</s=
pan> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Jun&#39;ichi Nomura [<a href=3D"mailto:j-nomura@ce.jp.nec.com" target=3D"_b=
lank">j-nomura@ce.jp.nec.com</a>] wrote:<br>
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
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</font></blockquote></div><br><br></div></div>hello all,<br><br>
There is one doubt regarding the dm-raid1. As far as i know, in
dm-raid1 the data is written parallelly=A0 on all the mirrors of
mirrorset and if any of the mirror fails to write the data then
dm-mirror adds this mirror to fail list by increasing the error count
in &quot;fail mirror&quot; function in dm-raid1. <br>
Actually my doubt is where this error count is decremented? i.e after
kcpyd or before and where exactly this error count is decremented?<br><br>R=
egards,<br><font color=3D"#888888">Nishant.<br></font></blockquote><div><br=
><br><br>Hi,<br><br>I&#39;ve created a device mapper target and I wanna tes=
t its read and<br>
write mechanisms. I created a device using this target and tried to<br>writ=
e a filesystem on to the device.<br><br>My target is creating roughly two o=
utgoing bios per incoming bio.<br>Which is maybe why I&#39;m not able to ge=
t a proper log after running the<br>
mke2fs command as while writing the filesystem, there are massive<br>amount=
s of writes performed on the device.<br><br>So, I tried to use the cat comm=
and to directly write to the device<br>file. The write is being performed f=
or sure because I&#39;m able to view<br>
the data written to the underlying device.<br><br>But there is no output wh=
en I try to read the device file contents using cat.<br><br>Is there any ot=
her way to test the read/write workflows of a dm target<br>that can give ou=
t a proper log ?<br>
<br>Regards,<br>Nishant. <br></div></div><br>

--90e6ba6154b65b884f049ad56d05--


--===============7363491254004846890==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7363491254004846890==--
