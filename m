From: Peter Desnoyers <pjd@ccs.neu.edu>
Subject: Re: Question about dmsetup / udev interactions
Date: Fri, 20 Jan 2017 11:53:24 -0500
Message-ID: <2FC6489A-CA46-435A-B1F3-352A91D382E6@ccs.neu.edu>
References: <55BECEAF-A213-425D-87F8-9C83ABA4DDA9@ccs.neu.edu>
	<bd19464c-0e45-2442-2eae-a2bb0f1ab457@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/mixed; boundary="===============6404401798220131610=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <bd19464c-0e45-2442-2eae-a2bb0f1ab457@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Rajnoha <prajnoha@redhat.com>
Cc: Mohammad Hossein Hajkazemi <hajkazemi@gmail.com>, MAniA Abdi <mania.abdi287@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids


--===============6404401798220131610==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_D3CC9986-ACBB-4C28-BF28-300768DD5743"


--Apple-Mail=_D3CC9986-ACBB-4C28-BF28-300768DD5743
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


> On Jan 20, 2017, at 3:40 AM, Peter Rajnoha <prajnoha@redhat.com> =
wrote:
>=20
> =46rom what you wrote, it seems you're using libdevmapper directly to =
set
> up the mapping, right?

We *should* be using libdevmapper directly. We'll certainly do that =
before we show our code to anyone else :-)

>=20
> The important flags to avoid scanning within udev rules (blkid and
> similar calls there) is the DM_UDEV_DISABLE_DISK_RULES_FLAG (this is =
to
> disable the blkid call in 13-dm-disk.rules and associated symlink
> creation) and also DM_UDEV_DISABLE_OTHER_RULES_FLAG to disable all the
> other foreign non-dm udev rules - this is a flag that other rules
> (should) check to skip processing if they see it.

I had a suspicion that this was going to involve udev rules. This should =
be enough to get us started.

> This is only general information on how device-mapper with libdm
> interacts with udev. To help you more, I'd probably need more detailed
> look at your usecase, design and goals you need to achieve so feel =
free
> to contact me...

Will do. Thanks again.

.....................................................................
 Peter Desnoyers                                  pjd@ccs.neu.edu
 Northeastern Computer & Information Science      (617) 373-8683




--Apple-Mail=_D3CC9986-ACBB-4C28-BF28-300768DD5743
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=windows-1252

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dwindows-1252"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><br class=3D""><div><blockquote type=3D"cite" class=3D""><div =
class=3D"">On Jan 20, 2017, at 3:40 AM, Peter Rajnoha &lt;<a =
href=3D"mailto:prajnoha@redhat.com" class=3D"">prajnoha@redhat.com</a>&gt;=
 wrote:</div><br class=3D"Apple-interchange-newline"><div class=3D""><span=
 style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: auto; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: auto; word-spacing: =
0px; -webkit-text-stroke-width: 0px; float: none; display: inline =
!important;" class=3D"">=46rom what you wrote, it seems you're using =
libdevmapper directly to set</span><br style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant: normal; font-weight: =
normal; letter-spacing: normal; line-height: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: =
0px;" class=3D""><span style=3D"font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant: normal; font-weight: normal; =
letter-spacing: normal; line-height: normal; orphans: auto; text-align: =
start; text-indent: 0px; text-transform: none; white-space: normal; =
widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; float: =
none; display: inline !important;" class=3D"">up the mapping, =
right?</span><br style=3D"font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant: normal; font-weight: normal; =
letter-spacing: normal; line-height: normal; orphans: auto; text-align: =
start; text-indent: 0px; text-transform: none; white-space: normal; =
widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px;" =
class=3D""></div></blockquote><div><br class=3D""></div>We *should* be =
using libdevmapper directly. We'll certainly do that before we show our =
code to anyone else :-)</div><div><br class=3D""><blockquote type=3D"cite"=
 class=3D""><div class=3D""><br style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant: normal; font-weight: =
normal; letter-spacing: normal; line-height: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: =
0px;" class=3D""><span style=3D"font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant: normal; font-weight: normal; =
letter-spacing: normal; line-height: normal; orphans: auto; text-align: =
start; text-indent: 0px; text-transform: none; white-space: normal; =
widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; float: =
none; display: inline !important;" class=3D"">The important flags to =
avoid scanning within udev rules (blkid and</span><br =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: auto; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: auto; word-spacing: =
0px; -webkit-text-stroke-width: 0px;" class=3D""><span =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: auto; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: auto; word-spacing: =
0px; -webkit-text-stroke-width: 0px; float: none; display: inline =
!important;" class=3D"">similar calls there) is the =
DM_UDEV_DISABLE_DISK_RULES_FLAG (this is to</span><br =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: auto; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: auto; word-spacing: =
0px; -webkit-text-stroke-width: 0px;" class=3D""><span =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: auto; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: auto; word-spacing: =
0px; -webkit-text-stroke-width: 0px; float: none; display: inline =
!important;" class=3D"">disable the blkid call in 13-dm-disk.rules and =
associated symlink</span><br style=3D"font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant: normal; font-weight: normal; =
letter-spacing: normal; line-height: normal; orphans: auto; text-align: =
start; text-indent: 0px; text-transform: none; white-space: normal; =
widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px;" =
class=3D""><span style=3D"font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant: normal; font-weight: normal; =
letter-spacing: normal; line-height: normal; orphans: auto; text-align: =
start; text-indent: 0px; text-transform: none; white-space: normal; =
widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; float: =
none; display: inline !important;" class=3D"">creation) and also =
DM_UDEV_DISABLE_OTHER_RULES_FLAG to disable all the</span><br =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: auto; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: auto; word-spacing: =
0px; -webkit-text-stroke-width: 0px;" class=3D""><span =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: auto; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: auto; word-spacing: =
0px; -webkit-text-stroke-width: 0px; float: none; display: inline =
!important;" class=3D"">other foreign non-dm udev rules - this is a flag =
that other rules</span><br style=3D"font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant: normal; font-weight: normal; =
letter-spacing: normal; line-height: normal; orphans: auto; text-align: =
start; text-indent: 0px; text-transform: none; white-space: normal; =
widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px;" =
class=3D""><span style=3D"font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant: normal; font-weight: normal; =
letter-spacing: normal; line-height: normal; orphans: auto; text-align: =
start; text-indent: 0px; text-transform: none; white-space: normal; =
widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; float: =
none; display: inline !important;" class=3D"">(should) check to skip =
processing if they see it.</span></div></blockquote><br =
class=3D""></div><div>I had a suspicion that this was going to involve =
udev rules. This should be enough to get us started.</div><div><br =
class=3D""></div><div><blockquote type=3D"cite" class=3D"">This is only =
general information on how device-mapper with libdm<br =
class=3D"">interacts with udev. To help you more, I'd probably need more =
detailed<br class=3D"">look at your usecase, design and goals you need =
to achieve so feel free<br class=3D"">to contact me...<br =
class=3D""></blockquote><br class=3D""></div><div>Will do. Thanks =
again.</div><br class=3D""><div apple-content-edited=3D"true" class=3D"">
<div class=3D""><div =
class=3D"">...............................................................=
......</div><div class=3D"">&nbsp;Peter Desnoyers &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp;<a href=3D"mailto:pjd@ccs.neu.edu" =
class=3D"">pjd@ccs.neu.edu</a></div><div class=3D"">&nbsp;Northeastern =
Computer &amp; Information Science &nbsp; &nbsp; &nbsp;(617) =
373-8683</div></div><div class=3D""><br class=3D""></div><br =
class=3D"Apple-interchange-newline">

</div>
<br class=3D""></body></html>=

--Apple-Mail=_D3CC9986-ACBB-4C28-BF28-300768DD5743--


--===============6404401798220131610==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6404401798220131610==--
