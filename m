From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: dm_mirror/dm_raid1 limitations ?.
Date: Mon, 26 Jan 2015 15:16:47 +0100
Message-ID: <54C64C4F.6090601@redhat.com>
References: <4d982ea8-3769-46d2-ba73-2d1525faa63b@default>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6474000732995191182=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4d982ea8-3769-46d2-ba73-2d1525faa63b@default>
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

This is a multi-part message in MIME format.
--===============6474000732995191182==
Content-Type: multipart/alternative;
	boundary="------------000108070005060602040100"

This is a multi-part message in MIME format.
--------------000108070005060602040100
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit


On 01/26/2015 02:51 PM, Suresh Babu Kandukuru wrote:
>
> Use case is : Two luns are mapped from storage array to linux host 
> which are in same SAN fabric . we want to create a mirror on the linux 
> host with these two luns and let  host use that mirror lun .  basic 
> tests suggest that dm_mirror working fine . when we have any 
> intermittent path issues with between host and san array , host i/o 
> just freeze , never returns back even after the path is online.
>

Hard to tell what's happening without any kernel log.

> Is dm_mirror viable solution here  ?. Can you point me any link which 
> gives the limitations of dm_mirror ? . another alternate solutions you 
> propose here ?. Thanks in advance .
>

We've switched the default away from "mirror" to "raid1" in order to 
take advantage of th MD runtime.
Have you tested  "lvcreate --type raid1 ..." yet?
Please do.

Regards,
Heinz

> Thanks
>
> /Suresh
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--------------000108070005060602040100
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx4-phx2.redhat.com id t0QEGp56020467

<html>
  <head>
    <meta content=3D"text/html; charset=3Dwindows-1252"
      http-equiv=3D"Content-Type">
  </head>
  <body text=3D"#000000" bgcolor=3D"#FFFFFF">
    <br>
    <div class=3D"moz-cite-prefix">On 01/26/2015 02:51 PM, Suresh Babu
      Kandukuru wrote:<br>
    </div>
    <blockquote cite=3D"mid:4d982ea8-3769-46d2-ba73-2d1525faa63b@default"
      type=3D"cite">
      <meta http-equiv=3D"Content-Type" content=3D"text/html;
        charset=3Dwindows-1252">
      <meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered
        medium)">
      <style><!--
/* Font Definitions */
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
      <div class=3D"WordSection1">
        <p class=3D"MsoNormal">Use case is : Two luns are mapped from
          storage array to linux host which are in same SAN fabric . we
          want to create a mirror on the linux host with these two luns
          and let=A0 host use that mirror lun .=A0 basic tests suggest th=
at
          dm_mirror working fine . when we have any intermittent path
          issues with between host and san array , host i/o just freeze
          , never returns back even after the path is online.=A0 <o:p></o=
:p></p>
      </div>
    </blockquote>
    <br>
    Hard to tell what's happening without any kernel log.<br>
    <br>
    <blockquote cite=3D"mid:4d982ea8-3769-46d2-ba73-2d1525faa63b@default"
      type=3D"cite">
      <div class=3D"WordSection1">
        <p class=3D"MsoNormal"><o:p>=A0</o:p></p>
        <p class=3D"MsoNormal">Is dm_mirror viable solution here =A0?. Ca=
n
          you point me any link which gives the limitations of dm_mirror
          ? . another alternate solutions you propose here ?. Thanks in
          advance .</p>
      </div>
    </blockquote>
    <br>
    We've switched the default away from "mirror" to "raid1" in order to
    take advantage of th MD runtime.<br>
    Have you tested=A0 "lvcreate --type raid1 ..." yet?<br>
    Please do.<br>
    <br>
    Regards,<br>
    Heinz<br>
    <br>
    <blockquote cite=3D"mid:4d982ea8-3769-46d2-ba73-2d1525faa63b@default"
      type=3D"cite">
      <div class=3D"WordSection1">
        <p class=3D"MsoNormal"><o:p></o:p></p>
        <p class=3D"MsoNormal"><o:p>=A0</o:p></p>
        <p class=3D"MsoNormal">Thanks<o:p></o:p></p>
        <p class=3D"MsoNormal">/Suresh<o:p></o:p></p>
      </div>
      <br>
      <fieldset class=3D"mimeAttachmentHeader"></fieldset>
      <br>
      <pre wrap=3D"">--
dm-devel mailing list
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:dm-devel@redhat.com"=
>dm-devel@redhat.com</a>
<a class=3D"moz-txt-link-freetext" href=3D"https://www.redhat.com/mailman=
/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a><=
/pre>
    </blockquote>
    <br>
  </body>
</html>

--------------000108070005060602040100--


--===============6474000732995191182==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============6474000732995191182==--
