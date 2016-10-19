From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 1/3] segment faulty occured in dm_get_status()
Date: Wed, 19 Oct 2016 08:00:35 +0200
Message-ID: <CABr-GneDPOwG1QSEOeq=i0oyONbv0ns6FuZ-tkcktAzOKW0+qg@mail.gmail.com>
References: <1476759069-9832-1-git-send-email-tang.junhui@zte.com.cn>
	<20161018162109.GK1972@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2628443224401648989=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161018162109.GK1972@octiron.msp.redhat.com>
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
Cc: zhang.kai16@zte.com.cn, device-mapper development <dm-devel@redhat.com>, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

--===============2628443224401648989==
Content-Type: multipart/alternative; boundary=001a1141277c1d3b7c053f318716

--001a1141277c1d3b7c053f318716
Content-Type: text/plain; charset=UTF-8

Merged.

On Tue, Oct 18, 2016 at 6:21 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Tue, Oct 18, 2016 at 10:51:07AM +0800, tang.junhui@zte.com.cn wrote:
> > From: "tang.junhui" <tang.junhui@zte.com.cn>
> >
> > Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
>
> ACK. Obviously we don't want uninitialized pointers.  But do you know
> what as going on with the device that caused it to return no target? Was
> there simply no table loaded for the device?
>
> -Ben
>
> >
> > segment faulty occured in dm_get_status(), the call trace is:
> > ----------------------------------------------------------------------
> > (gdb) bt
> > 0  0x000000338ec328a5 in raise () from /lib64/libc.so.6
> > 1  0x000000338ec3400d in abort () from /lib64/libc.so.6
> > 2  0x000000000040596d in sigsegv ()
> > 3  <signal handler called>
> > 4  0x000000338ec480ac in vfprintf () from /lib64/libc.so.6
> > 5  0x000000338ec6f9d2 in vsnprintf () from /lib64/libc.so.6
> > 6  0x000000338ec4f4a3 in snprintf () from /lib64/libc.so.6
> > 7  0x00007f43fe66bbb9 in dm_get_status (name=0x7f43f0001eb0 "spathe",
> > outstatus=<value optimized out>) at devmapper.c:521
> > 8  0x00007f43fe68c058 in update_multipath_status (mpp=0x7f43f000ad60,
> > pathvec=<value optimized out>) at structs_vec.c:465
> > 9  update_multipath_strings (mpp=0x7f43f000ad60, pathvec=<value optimized
> > out>) at structs_vec.c:495
> > 10 0x0000000000409056 in check_path ()
> > 11 0x0000000000409c7e in checkerloop ()
> > 12 0x0000003b27207851 in start_thread () from /lib64/libpthread.so.0
> > 13 0x000000338ece890d in clone () from /lib64/libc.so.6
> > -----------------------------------------------------------------------
> > we debuged the code, and found that targets information storing in the
> > list dmt->head which fetching from kernel by executing dm_task_run()
> > is null.
> > -----------------------------------------------------------------------
> > rbx            0x7f43c4000d60   139929027874144
> > (gdb) p *(struct dm_task *)0x7f43c4000d60
> > $3 = {type = 10, dev_name = 0x7f43c4000d40 "spathe", head = 0x0, tail =
> > 0x0, read_only = 0, event_nr = 0, major = -1, minor = -1,
> >   allow_default_major_fallback = 1, uid = 0, gid = 0, mode = 384,
> >   read_ahead = 4294967295, read_ahead_flags = 0, dmi = {
> >       v4 = 0x7f43c40011e0, v1 = 0x7f43c40011e0}, newname = 0x0, message =
> >       0x0, geometry = 0x0, sector = 0, no_flush = 0,
> >         no_open_count = 1, skip_lockfs = 0, query_inactive_table = 0,
> >       suppress_identical_reload = 0, existing_table_size = 0,
> >         cookie_set = 0, uuid = 0x0}
> > -----------------------------------------------------------------------
> > since status is not initioned to null, so after calling
> > dm_get_next_target(dmt, next, &start, &length,&target_type,
> > &status),status becaming wild pointer, which lead snprintf() into the
> > situation of segment faulty.
> > ---
> >  libmultipath/devmapper.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index 5eb1713..89aa5da 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -534,8 +534,8 @@ dm_get_status(char * name, char * outstatus)
> >       int r = 1;
> >       struct dm_task *dmt;
> >       uint64_t start, length;
> > -     char *target_type;
> > -     char *status;
> > +     char *target_type = NULL;
> > +     char *status = NULL;
> >
> >       if (!(dmt = dm_task_create(DM_DEVICE_STATUS)))
> >               return 1;
> > @@ -551,6 +551,10 @@ dm_get_status(char * name, char * outstatus)
> >       /* Fetch 1st target */
> >       dm_get_next_target(dmt, NULL, &start, &length,
> >                          &target_type, &status);
> > +     if (!status) {
> > +             condlog(2, "get null status.");
> > +             goto out;
> > +     }
> >
> >       if (snprintf(outstatus, PARAMS_SIZE, "%s", status) <= PARAMS_SIZE)
> >               r = 0;
> > --
> > 2.8.1.windows.1
>

--001a1141277c1d3b7c053f318716
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.</div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Tue, Oct 18, 2016 at 6:21 PM, Benjamin Marzinski <span dir=
=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"_blank">bmarz=
ins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><spa=
n class=3D"">On Tue, Oct 18, 2016 at 10:51:07AM +0800, <a href=3D"mailto:ta=
ng.junhui@zte.com.cn">tang.junhui@zte.com.cn</a> wrote:<br>
&gt; From: &quot;tang.junhui&quot; &lt;<a href=3D"mailto:tang.junhui@zte.co=
m.cn">tang.junhui@zte.com.cn</a>&gt;<br>
&gt;<br>
&gt; Signed-off-by: tang.junhui &lt;<a href=3D"mailto:tang.junhui@zte.com.c=
n">tang.junhui@zte.com.cn</a>&gt;<br>
<br>
</span>ACK. Obviously we don&#39;t want uninitialized pointers.=C2=A0 But d=
o you know<br>
what as going on with the device that caused it to return no target? Was<br=
>
there simply no table loaded for the device?<br>
<br>
-Ben<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt;<br>
&gt; segment faulty occured in dm_get_status(), the call trace is:<br>
&gt; ------------------------------<wbr>------------------------------<wbr>=
----------<br>
&gt; (gdb) bt<br>
&gt; 0=C2=A0 0x000000338ec328a5 in raise () from /lib64/libc.so.6<br>
&gt; 1=C2=A0 0x000000338ec3400d in abort () from /lib64/libc.so.6<br>
&gt; 2=C2=A0 0x000000000040596d in sigsegv ()<br>
&gt; 3=C2=A0 &lt;signal handler called&gt;<br>
&gt; 4=C2=A0 0x000000338ec480ac in vfprintf () from /lib64/libc.so.6<br>
&gt; 5=C2=A0 0x000000338ec6f9d2 in vsnprintf () from /lib64/libc.so.6<br>
&gt; 6=C2=A0 0x000000338ec4f4a3 in snprintf () from /lib64/libc.so.6<br>
&gt; 7=C2=A0 0x00007f43fe66bbb9 in dm_get_status (name=3D0x7f43f0001eb0 &qu=
ot;spathe&quot;,<br>
&gt; outstatus=3D&lt;value optimized out&gt;) at devmapper.c:521<br>
&gt; 8=C2=A0 0x00007f43fe68c058 in update_multipath_status (mpp=3D0x7f43f00=
0ad60,<br>
&gt; pathvec=3D&lt;value optimized out&gt;) at structs_vec.c:465<br>
&gt; 9=C2=A0 update_multipath_strings (mpp=3D0x7f43f000ad60, pathvec=3D&lt;=
value optimized<br>
&gt; out&gt;) at structs_vec.c:495<br>
&gt; 10 0x0000000000409056 in check_path ()<br>
&gt; 11 0x0000000000409c7e in checkerloop ()<br>
&gt; 12 0x0000003b27207851 in start_thread () from /lib64/libpthread.so.0<b=
r>
&gt; 13 0x000000338ece890d in clone () from /lib64/libc.so.6<br>
&gt; ------------------------------<wbr>------------------------------<wbr>=
-----------<br>
&gt; we debuged the code, and found that targets information storing in the=
<br>
&gt; list dmt-&gt;head which fetching from kernel by executing dm_task_run(=
)<br>
&gt; is null.<br>
&gt; ------------------------------<wbr>------------------------------<wbr>=
-----------<br>
&gt; rbx=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x7f43c4000d60=C2=A0 =C2=
=A0139929027874144<br>
&gt; (gdb) p *(struct dm_task *)0x7f43c4000d60<br>
&gt; $3 =3D {type =3D 10, dev_name =3D 0x7f43c4000d40 &quot;spathe&quot;, h=
ead =3D 0x0, tail =3D<br>
&gt; 0x0, read_only =3D 0, event_nr =3D 0, major =3D -1, minor =3D -1,<br>
&gt;=C2=A0 =C2=A0allow_default_major_fallback =3D 1, uid =3D 0, gid =3D 0, =
mode =3D 384,<br>
&gt;=C2=A0 =C2=A0read_ahead =3D 4294967295, read_ahead_flags =3D 0, dmi =3D=
 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0v4 =3D 0x7f43c40011e0, v1 =3D 0x7f43c40011e0=
}, newname =3D 0x0, message =3D<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A00x0, geometry =3D 0x0, sector =3D 0, no_flus=
h =3D 0,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0no_open_count =3D 1, skip_lockfs =3D =
0, query_inactive_table =3D 0,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0suppress_identical_reload =3D 0, existing_ta=
ble_size =3D 0,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cookie_set =3D 0, uuid =3D 0x0}<br>
&gt; ------------------------------<wbr>------------------------------<wbr>=
-----------<br>
&gt; since status is not initioned to null, so after calling<br>
&gt; dm_get_next_target(dmt, next, &amp;start, &amp;length,&amp;target_type=
,<br>
&gt; &amp;status),status becaming wild pointer, which lead snprintf() into =
the<br>
&gt; situation of segment faulty.<br>
&gt; ---<br>
&gt;=C2=A0 libmultipath/devmapper.c | 8 ++++++--<br>
&gt;=C2=A0 1 file changed, 6 insertions(+), 2 deletions(-)<br>
&gt;<br>
&gt; diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c<br>
&gt; index 5eb1713..89aa5da 100644<br>
&gt; --- a/libmultipath/devmapper.c<br>
&gt; +++ b/libmultipath/devmapper.c<br>
&gt; @@ -534,8 +534,8 @@ dm_get_status(char * name, char * outstatus)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int r =3D 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_task *dmt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0uint64_t start, length;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0char *target_type;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0char *status;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char *target_type =3D NULL;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char *status =3D NULL;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(dmt =3D dm_task_create(DM_DEVICE_<wbr>=
STATUS)))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt; @@ -551,6 +551,10 @@ dm_get_status(char * name, char * outstatus)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Fetch 1st target */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_get_next_target(dmt, NULL, &amp;start, &a=
mp;length,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 &amp;target_type, &amp;status);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!status) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(2, &quot;get =
null status.&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (snprintf(outstatus, PARAMS_SIZE, &quot;%=
s&quot;, status) &lt;=3D PARAMS_SIZE)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D 0;<br>
&gt; --<br>
&gt; 2.8.1.windows.1<br>
</div></div></blockquote></div><br></div>

--001a1141277c1d3b7c053f318716--


--===============2628443224401648989==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2628443224401648989==--
