From: Amar Mudrankit <amar.mudrankit@gmail.com>
Subject: Re: Query about dm device max_discard_sectors
Date: Mon, 26 Mar 2012 09:55:03 -0400
Message-ID: <CAL08bwfkO5S-O72uMLKrAobtsBOfRDhbd3RzOBttec1dPHscAQ@mail.gmail.com>
References: <CAL08bwfwD0wtOvum-oeA=skLfQQ_BKSmwJ-ZQbZ+RBwduEJm_A@mail.gmail.com>
	<20120325235421.GA31320@redhat.com>
	<20120326014910.GA31951@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1801046107619690806=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120326014910.GA31951@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============1801046107619690806==
Content-Type: multipart/alternative; boundary=14dae934096b9246a604bc25b8a7

--14dae934096b9246a604bc25b8a7
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Mar 25, 2012 at 9:49 PM, Mike Snitzer <snitzer@redhat.com> wrote:

> On Sun, Mar 25 2012 at  7:54pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
> > On Sun, Mar 25 2012 at  6:46pm -0400,
> > Amar Mudrankit <amar.mudrankit@gmail.com> wrote:
> >
> > > Hi all,
> > >
> > > I am building an experimental device mapper target which is supposed to
> > > receive
> > > all TRIM requests (REQ_DISCARD).  Irrespective of whether underlying
> actual
> > > physical block device supports discards or not, my device mapper target
> > > should
> > > receive REQ_DISCARD bios.
> >
> > I'm just curious but: what will your target do in general?
>

Target is somewhat similar to what a Flash Translation Layer does in SSDs,
but not
as fancy as that.  So, when my target maintains logical -> physical
mapping, my target
will be interested in which blocks are free from file system perspective, a
typical use
case of TRIM.  I guess somewhat similar to thin-provisioning.

>
> > > In my target, I set:
> > >
> > > ti->num_discard_requests = 1;
> > > ti->discards_supported = 1;
> >
> > You'll also want to set ti->discards_supported
> >
> > see: http://git.kernel.org/linus/4c259327
>
> ah, I now see you already did set discards_supported.
>
> > > So, if my device mapper target does not implement iterate_devices
> function
> > > (used to set max_discard_sectors based on underlying physical device's
> > > discard
> > > support) or underlying physical device does not support discards, then
> there
> > > is no way for device mapper target to set max_discard_sectors more
> than 0
> > > to receive REQ_DISCARD commands.
> > >
> > > Is this analysis correct? Or I am missing something?
> >
> > All DM targets should implement .iterate_devices -- intent is to iterate
> > over all data devices.
> >
> > You'll also want to implement .io_hints to set
> limits->max_discard_sectors
> > (like drivers/md/dm-thin.c does).
>
> BTW, the dm-thin.c discard changes will be merged in 3.4, you can see
> the relevant patches here:
>
>
> http://people.redhat.com/agk/patches/linux/editing/dm-thin-support-discards.patch
>
> http://people.redhat.com/agk/patches/linux/editing/dm_thin-add-pool-target-flags-to-control-discard.patch
>

With io_hints function pointer, I set max_discard_sectors and it is getting
set properly,  and I
was able to receive and process TRIM requests.

Thank you Mike for the help !!

Thanks and Regards,
Amar

--14dae934096b9246a604bc25b8a7
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Sun, Mar 25, 2012 at 9:49 PM, Mike Sn=
itzer <span dir=3D"ltr">&lt;<a href=3D"mailto:snitzer@redhat.com" target=3D=
"_blank">snitzer@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex">

<div>On Sun, Mar 25 2012 at =A07:54pm -0400,<br>
Mike Snitzer &lt;<a href=3D"mailto:snitzer@redhat.com" target=3D"_blank">sn=
itzer@redhat.com</a>&gt; wrote:<br>
<br>
&gt; On Sun, Mar 25 2012 at =A06:46pm -0400,<br>
&gt; Amar Mudrankit &lt;<a href=3D"mailto:amar.mudrankit@gmail.com" target=
=3D"_blank">amar.mudrankit@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; Hi all,<br>
&gt; &gt;<br>
&gt; &gt; I am building an experimental device mapper target which is suppo=
sed to<br>
&gt; &gt; receive<br>
&gt; &gt; all TRIM requests (REQ_DISCARD). =A0Irrespective of whether under=
lying actual<br>
&gt; &gt; physical block device supports discards or not, my device mapper =
target<br>
&gt; &gt; should<br>
&gt; &gt; receive REQ_DISCARD bios.<br>
&gt;<br>
&gt; I&#39;m just curious but: what will your target do in general?<br></di=
v></blockquote><div><br>Target is somewhat similar to what a Flash Translat=
ion Layer does in SSDs, but not<br>
as fancy as that.=A0 So, when my target maintains logical -&gt; physical ma=
pping, my target<br>
will be interested in which blocks are free from file system perspective, a=
 typical use<br>
case of TRIM.=A0 I guess somewhat similar to thin-provisioning.<br><br></di=
v><blockquote class=3D"gmail_quote" style=3D"margin:0pt 0pt 0pt 0.8ex;borde=
r-left:1px solid rgb(204,204,204);padding-left:1ex"><div>
&gt;<br>
&gt; &gt; In my target, I set:<br>
&gt; &gt;<br>
&gt; &gt; ti-&gt;num_discard_requests =3D 1;<br>
&gt; &gt; ti-&gt;discards_supported =3D 1;<br>
&gt;<br>
&gt; You&#39;ll also want to set ti-&gt;discards_supported<br>
&gt;<br>
&gt; see: <a href=3D"http://git.kernel.org/linus/4c259327" target=3D"_blank=
">http://git.kernel.org/linus/4c259327</a><br>
<br>
</div>ah, I now see you already did set discards_supported.<br>
<div><br>
&gt; &gt; So, if my device mapper target does not implement iterate_devices=
 function<br>
&gt; &gt; (used to set max_discard_sectors based on underlying physical dev=
ice&#39;s<br>
&gt; &gt; discard<br>
&gt; &gt; support) or underlying physical device does not support discards,=
 then there<br>
&gt; &gt; is no way for device mapper target to set max_discard_sectors mor=
e than 0<br>
&gt; &gt; to receive REQ_DISCARD commands.<br>
&gt; &gt;<br>
&gt; &gt; Is this analysis correct? Or I am missing something?<br>
&gt;<br>
&gt; All DM targets should implement .iterate_devices -- intent is to itera=
te<br>
&gt; over all data devices.<br>
&gt;<br>
&gt; You&#39;ll also want to implement .io_hints to set limits-&gt;max_disc=
ard_sectors<br>
&gt; (like drivers/md/dm-thin.c does).<br>
<br>
</div>BTW, the dm-thin.c discard changes will be merged in 3.4, you can see=
<br>
the relevant patches here:<br>
<br>
<a href=3D"http://people.redhat.com/agk/patches/linux/editing/dm-thin-suppo=
rt-discards.patch" target=3D"_blank">http://people.redhat.com/agk/patches/l=
inux/editing/dm-thin-support-discards.patch</a><br>
<a href=3D"http://people.redhat.com/agk/patches/linux/editing/dm_thin-add-p=
ool-target-flags-to-control-discard.patch" target=3D"_blank">http://people.=
redhat.com/agk/patches/linux/editing/dm_thin-add-pool-target-flags-to-contr=
ol-discard.patch</a><br>

</blockquote><div><br>With io_hints function pointer, I set max_discard_sec=
tors and it is getting set properly, =A0and I<br></div><div>was able to rec=
eive and process TRIM requests.</div><div><br></div><div>Thank you Mike for=
 the help !!</div>
</div><br>Thanks and Regards,<br>Amar<br>

--14dae934096b9246a604bc25b8a7--


--===============1801046107619690806==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1801046107619690806==--
