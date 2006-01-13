From: Chris Penney <penney@msu.edu>
Subject: Re: STK / LSI Multipath Support
Date: Fri, 13 Jan 2006 12:00:41 -0500
Message-ID: <111aefd0601130900w76ed8c8eo53d3a64b41dc4345@mail.gmail.com>
References: <111aefd0601121952r55594f0ahdb5ed4fa46ae145d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2000678507=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <111aefd0601121952r55594f0ahdb5ed4fa46ae145d@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

--===============2000678507==
Content-Type: multipart/alternative;
	boundary="----=_Part_34176_4691637.1137171641566"

------=_Part_34176_4691637.1137171641566
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 1/12/06, Chris Penney <penney@msu.edu> wrote:
>
> Hello,
>
> The multipath code seems to support STK D280 (active / passive) disk
> arrays, but with one exception.  It doesn't seem to be able to query the
> priorities of the luns properly.  For example, I create four luns on a D2=
80
> and assign two luns to controller A and two to controller B.  When the
> system (which has dual hbas) boots they all end up on one controller and
> multipathd never switches to the primary paths even though they are
> available.
>
> I am guessing this is because "prio_callout" is set to "/bin/true" so it
> defaults to the first path in the list.  Is there a prio_callout that wor=
ks
> with lsi branded arrays?  I run SLES 9 and I see there are
> mpath_prio_{emc,tpc,alua}, but none (somewhat obviously) don't work.  I w=
as
> able to write a perl script that simply took a device arguement and looke=
d
> up a priority in a table and it appears to work, but it's obviously a nas=
ty
> hack and doesn't automatically detect the proper path (which would be
> necessary in the case of a manual failover).
>
> Thanks,
>
>    Chris Penney
>    penney@msu.edu


After some experimentation and looking at the defaults for the SGI 9500
(which is the same hardware as the STK D280 with only some firmware
differences) I found that I could use mpath_prio_tpc with the STK array.  I=
s
this a reasonable solution?

    Chris

------=_Part_34176_4691637.1137171641566
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div><span class=3D"gmail_quote">On 1/12/06, <b class=3D"gmail_sendername">=
Chris Penney</b> &lt;<a href=3D"mailto:penney@msu.edu">penney@msu.edu</a>&g=
t; wrote:</span>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Hello,<br><br>The multipath code=
 seems to support STK D280 (active / passive) disk arrays, but with one exc=
eption.&nbsp; It doesn't seem to be able to query the priorities of the lun=
s properly.&nbsp; For example, I create four luns on a D280 and assign two =
luns to controller A and two to controller B.&nbsp; When the system (which =
has dual hbas) boots they all end up on one controller and multipathd never=
 switches to the primary paths even though they are available.=20
<br><br>I am guessing this is because &quot;prio_callout&quot; is set to &q=
uot;/bin/true&quot; so it defaults to the first path in the list.&nbsp; Is =
there a prio_callout that works with lsi branded arrays?&nbsp; I run SLES 9=
 and I see there are mpath_prio_{emc,tpc,alua}, but none (somewhat obviousl=
y) don't work.&nbsp; I was able to write a perl script that simply took a d=
evice arguement and looked up a priority in a table and it appears to work,=
 but it's obviously a nasty hack and doesn't automatically detect the prope=
r path (which would be necessary in the case of a manual failover).=20
<br><br>Thanks,<br><span class=3D"sg"><br>&nbsp;&nbsp; Chris Penney<br>&nbs=
p;&nbsp; <a onclick=3D"return top.js.OpenExtLink(window,event,this)" href=
=3D"mailto:penney@msu.edu" target=3D"_blank">penney@msu.edu</a></span></blo=
ckquote>
<div>&nbsp;</div>
<div>After some experimentation and looking at the defaults for the SGI 950=
0 (which is the same hardware as the STK D280 with only some firmware diffe=
rences) I found that I could use mpath_prio_tpc with the STK array.&nbsp; I=
s this a reasonable solution?
</div>
<div>&nbsp;</div>
<div>&nbsp;&nbsp;&nbsp; Chris</div>
<div>&nbsp;</div><br>&nbsp;</div>

------=_Part_34176_4691637.1137171641566--


--===============2000678507==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2000678507==--
