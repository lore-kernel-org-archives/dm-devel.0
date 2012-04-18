From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 0 of 4] dm-raid: various bug fixes
Date: Wed, 18 Apr 2012 16:32:00 -0500
Message-ID: <A71FAACD-D1A7-4452-BDD3-5156DB9E5497@redhat.com>
References: <1334716219.23908.14.camel@f14.redhat.com>
	<20120418134843.1376cc7e@notabene.brown>
	<3F107DB9-0ED6-47C5-9F5A-DF485017EA92@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: multipart/mixed; boundary="===============5679787356347500322=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3F107DB9-0ED6-47C5-9F5A-DF485017EA92@redhat.com>
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
Cc: linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids


--===============5679787356347500322==
Content-Type: multipart/alternative; boundary=Apple-Mail-1--4764693


--Apple-Mail-1--4764693
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Apr 18, 2012, at 9:05 AM, Brassow Jonathan wrote:

>=20
> 5-of-5: changing the check to 'saved_raid_disk >=3D 0' would be fine, =
but I think I should initialize 'saved_raid_disk' to -1 in dm-raid.c =
then normally.  Right now, an nominal initial value is not set - meaning =
it is '0'.  (When a device comes back from a failure, 'saved_raid_disk' =
is assigned its old position.)

... that's not quite right.  I do call 'md_rdev_init' which sets =
'saved_raid_disk' to -1.  Then, if the device has returned after a =
disappearance, I set 'saved_raid_disk' to it's old position.  Therefore, =
'saved_raid_disk >=3D 0' would be fine and wouldn't require me to set -1 =
in dm-raid.c.

 brassow


--Apple-Mail-1--4764693
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
"><br><div><div>On Apr 18, 2012, at 9:05 AM, Brassow Jonathan =
wrote:</div><br class=3D"Apple-interchange-newline"><blockquote =
type=3D"cite"><span class=3D"Apple-style-span" style=3D"border-collapse: =
separate; font-family: Helvetica; font-style: normal; font-variant: =
normal; font-weight: normal; letter-spacing: normal; line-height: =
normal; orphans: 2; text-align: -webkit-auto; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; font-size: medium; "><br>5-of-5: =
changing the check to 'saved_raid_disk &gt;=3D 0' would be fine, but I =
think I should initialize 'saved_raid_disk' to -1 in dm-raid.c then =
normally. &nbsp;Right now, an nominal initial value is not set - meaning =
it is '0'. &nbsp;(When a device comes back from a failure, =
'saved_raid_disk' is assigned its old =
position.)<br></span></blockquote></div><br><div>... that's not quite =
right. &nbsp;I do call 'md_rdev_init' which sets 'saved_raid_disk' to =
-1. &nbsp;Then, if the device has returned after a disappearance, I set =
'saved_raid_disk' to it's old position. &nbsp;Therefore, =
'saved_raid_disk &gt;=3D 0' would be fine and wouldn't require me to set =
-1 in =
dm-raid.c.</div><div><br></div><div>&nbsp;brassow</div><div><br></div></bo=
dy></html>=

--Apple-Mail-1--4764693--


--===============5679787356347500322==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5679787356347500322==--
