From: Nicholas Nevin <njnevin@gmail.com>
Subject: Re: /dev/mapper/<dm_name> symlink not being created
Date: Tue, 15 May 2012 09:55:49 -0400
Message-ID: <CACmkXc75Sp1itjaNvsU-y8Jq51V34feZuzxRFPqWxC1ASdo22g@mail.gmail.com>
References: <CACmkXc5fQCF78UW1_tEruAiuWL_EgODLt87=ZD-d_f2zT-GPeA@mail.gmail.com>
	<CACmkXc5cEhvdBgHzbNW13cFcoj83LjFea=qwZOq5UUq5vpwdAw@mail.gmail.com>
	<4FB10BE7.8090602@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0771552529434675601=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4FB10BE7.8090602@redhat.com>
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
List-Id: dm-devel.ids

--===============0771552529434675601==
Content-Type: multipart/alternative; boundary=047d7b339dd9dc4d1004c01392e1

--047d7b339dd9dc4d1004c01392e1
Content-Type: text/plain; charset=ISO-8859-1

On Mon, May 14, 2012 at 9:43 AM, Zdenek Kabelac <zkabelac@redhat.com> wrote:

> Dne 12.5.2012 16:59, Nicholas Nevin napsal(a):
> > Anyone have any thoughts on this?
> >
> > Thanks, Nick.
> >
> > On Mon, Apr 30, 2012 at 8:08 AM, Nicholas Nevin <njnevin@gmail.com>
> wrote:
> >
> >> In nightly testing of our product the tests do a fair bit of
> >> creating/destroying of device mapper devices and we have been seeing
> >> infrequent cases where the device is created OK but the corresponding
> >> /dev/mapper/<dm_name> symlink does not exist.
> >>
> >> Here is an example of the dmsetup command used to create the devices.
> >>
> >> # dmsetup create tap0 --table '0 47247164 linear
> /dev/xen/blktap-2/tapdev0
> >> 1'
> >>
> >> I managed to reproduce this problem with udev logging enabled and
> 'udevadm
> >> monitor' running and from the logs the cause appears to be that the udev
> >> add action (from the device create) and the udev change action (from
> when
> >> the device is resumed after loading the table) are running
> >> concurrently. The processing of the rules for the change action creates
> the
> >> /dev/mapper/tap0 symlink but then the processing of the add action
> deletes
> >> the symlink because /dev/mapper/tap0 is not in the add action DEVLINKS.
> >>
> >> The question I have is should dmsetup be ensuring that the add action
> >> completes before the change action is handled or is this behaviour
> expected?
> >>
> >> That /dev/mapper/tap0 is not in the DEVLINKS for the add action is
> AFAICT
> >> because of a race between the creation of the sysfs entries for the
> device
> >> and the processing of the add action in udevd. This can be fixed by
> >> sprinkling in some WAIT_FOR conditions in the dm udev rules. Our system
> is
> >> based on Ubuntu 12.04.
> >>
> >> I have attached the udevadm monitor output and the relevant piece of
> >> syslog for a test case where the /dev/mapper/tap0 symlink wasn't present
> >> when dmsetup returned.
> >>
> >> I hope this is the right place to ask this. If not please point me in
> the
> >> right direction.
>
> You have not specified version of lvm2 tools in use.
>

Ah yes, here we go.

root@nick-lt:~# lvm version
  LVM version:     2.02.66(2) (2010-05-20)
  Library version: 1.02.48 (2010-05-20)
  Driver version:  4.22.0
root@nick-lt:~# dmsetup version
Library version:   1.02.48 (2010-05-20)
Driver version:    4.22.0
root@nick-lt:~#



> But on udev system there are 2 options when nodes/links are created.
>
> By default it's on RESUME - since this is the moment table is defined,
> and proper messages are passed across udev system.
>
> For backward compatibility (and for non-udev systems) there is
> dmsetup create --addnodeoncreate  - which basically creates links on
> 'create'
> phase - but with old 'badness' behind - since normally no one should create
> nodes in /dev  - it's the  udev 'kingdom' which should not be externally
> modified (udev might not know about such entries).
>
> So the proper moment to work with created devices is after they have been
> resumed - everything else will be ugly udev hack with unpredictable
> results.


> Zdenek
>

Makes sense thanks. The problem seems to be though that the handling of the
add (on create) and change (on resume) actions coming from the kernel to
udevd
are not handled sequentially by udevd which can cause problems such I
described.
It seems to me that dmsetup should be ensuring that the add action upon
create
has been fully handled before doing the resume which generates the change
action.
I'm no expert though so I could well have things wrong here.

-nick

--047d7b339dd9dc4d1004c01392e1
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Mon, May 14, 2012 at 9:43 AM, Zdenek =
Kabelac <span dir=3D"ltr">&lt;<a href=3D"mailto:zkabelac@redhat.com" target=
=3D"_blank">zkabelac@redhat.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">

Dne 12.5.2012 16:59, Nicholas Nevin napsal(a):<br>
<div><div class=3D"h5">&gt; Anyone have any thoughts on this?<br>
&gt;<br>
&gt; Thanks, Nick.<br>
&gt;<br>
&gt; On Mon, Apr 30, 2012 at 8:08 AM, Nicholas Nevin &lt;<a href=3D"mailto:=
njnevin@gmail.com">njnevin@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt;&gt; In nightly testing of our product the tests do a fair bit of<br>
&gt;&gt; creating/destroying of device mapper devices and we have been seei=
ng<br>
&gt;&gt; infrequent cases where the device is created OK but the correspond=
ing<br>
&gt;&gt; /dev/mapper/&lt;dm_name&gt; symlink does not exist.<br>
&gt;&gt;<br>
&gt;&gt; Here is an example of the dmsetup command used to create the devic=
es.<br>
&gt;&gt;<br>
&gt;&gt; # dmsetup create tap0 --table &#39;0 47247164 linear /dev/xen/blkt=
ap-2/tapdev0<br>
&gt;&gt; 1&#39;<br>
&gt;&gt;<br>
&gt;&gt; I managed to reproduce this problem with udev logging enabled and =
&#39;udevadm<br>
&gt;&gt; monitor&#39; running and from the logs the cause appears to be tha=
t the udev<br>
&gt;&gt; add action (from the device create) and the udev change action (fr=
om when<br>
&gt;&gt; the device is resumed after loading the table) are running<br>
&gt;&gt; concurrently. The processing of the rules for the change action cr=
eates the<br>
&gt;&gt; /dev/mapper/tap0 symlink but then the processing of the add action=
 deletes<br>
&gt;&gt; the symlink because /dev/mapper/tap0 is not in the add action DEVL=
INKS.<br>
&gt;&gt;<br>
&gt;&gt; The question I have is should dmsetup be ensuring that the add act=
ion<br>
&gt;&gt; completes before the change action is handled or is this behaviour=
 expected?<br>
&gt;&gt;<br>
&gt;&gt; That /dev/mapper/tap0 is not in the DEVLINKS for the add action is=
 AFAICT<br>
&gt;&gt; because of a race between the creation of the sysfs entries for th=
e device<br>
&gt;&gt; and the processing of the add action in udevd. This can be fixed b=
y<br>
&gt;&gt; sprinkling in some WAIT_FOR conditions in the dm udev rules. Our s=
ystem is<br>
&gt;&gt; based on Ubuntu 12.04.<br>
&gt;&gt;<br>
&gt;&gt; I have attached the udevadm monitor output and the relevant piece =
of<br>
&gt;&gt; syslog for a test case where the /dev/mapper/tap0 symlink wasn&#39=
;t present<br>
&gt;&gt; when dmsetup returned.<br>
&gt;&gt;<br>
&gt;&gt; I hope this is the right place to ask this. If not please point me=
 in the<br>
&gt;&gt; right direction.<br>
<br>
</div></div>You have not specified version of lvm2 tools in use.<br></block=
quote><div><br></div><div>Ah yes, here we go.</div><div><br></div><div>root=
@nick-lt:~# lvm version</div><div>=A0 LVM version: =A0 =A0 2.02.66(2) (2010=
-05-20)</div>

<div>=A0 Library version: 1.02.48 (2010-05-20)</div><div>=A0 Driver version=
: =A04.22.0</div><div>root@nick-lt:~# dmsetup version</div><div>Library ver=
sion: =A0 1.02.48 (2010-05-20)</div><div>Driver version: =A0 =A04.22.0</div=
><div>root@nick-lt:~#=A0</div>

<div><br></div><div><br></div><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
But on udev system there are 2 options when nodes/links are created.<br>
<br>
By default it&#39;s on RESUME - since this is the moment table is defined,<=
br>
and proper messages are passed across udev system.<br>
<br>
For backward compatibility (and for non-udev systems) there is<br>
dmsetup create --addnodeoncreate =A0- which basically creates links on &#39=
;create&#39;<br>
phase - but with old &#39;badness&#39; behind - since normally no one shoul=
d create<br>
nodes in /dev =A0- it&#39;s the =A0udev &#39;kingdom&#39; which should not =
be externally<br>
modified (udev might not know about such entries).<br>
<br>
So the proper moment to work with created devices is after they have been<b=
r>
resumed - everything else will be ugly udev hack with unpredictable results=
.=A0</blockquote><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8=
ex;border-left:1px #ccc solid;padding-left:1ex">
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Zdenek<br></font></span></blockquote><div><br></div><div>Makes sense thanks=
. The problem seems to be though that the handling of the</div><div>add (on=
 create) and change (on resume) actions coming from the kernel to udevd</di=
v>

<div>are not handled sequentially by udevd which can cause problems such I =
described.</div><div>It seems to me that dmsetup should be ensuring that th=
e add action upon create</div><div>has been fully handled before doing the =
resume which generates the change action.</div>

<div>I&#39;m no expert though so I could well have things wrong here.</div>=
<div><br></div><div>-nick</div><div><br></div></div>

--047d7b339dd9dc4d1004c01392e1--


--===============0771552529434675601==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0771552529434675601==--
