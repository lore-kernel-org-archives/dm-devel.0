From: "suresh.babu.kandukuru@oracle.com" <suresh.babu.kandukuru@oracle.com>
Subject: Re: dm_mirror/dm_raid1 limitations ?.
Date: Mon, 26 Jan 2015 21:04:11 +0530
Message-ID: <E0704006-CC32-460A-AC22-149FD2B76583@oracle.com>
References: <4d982ea8-3769-46d2-ba73-2d1525faa63b@default>
	<54C64C4F.6090601@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: multipart/mixed; boundary="===============6224379024105283331=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54C64C4F.6090601@redhat.com>
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


--===============6224379024105283331==
Content-Type: multipart/alternative;
	boundary=Apple-Mail-E75038BD-7B84-4CA3-871D-C05E198E8363
Content-Transfer-Encoding: 7bit


--Apple-Mail-E75038BD-7B84-4CA3-871D-C05E198E8363
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable

Heinzm,thanks for the quick reply.. We are using dmestup create mirror ..as w=
e want to do that on physical San lun (block devices) ... Not the one ( lv c=
reate ) you mentioned below.. Is there any advantage going with logical volu=
me approach lvcreate -type =20

/Suresh

Sent from my iPhone

> On Jan 26, 2015, at 7:46 PM, Heinz Mauelshagen <heinzm@redhat.com> wrote:
>=20
>=20
>> On 01/26/2015 02:51 PM, Suresh Babu Kandukuru wrote:
>> Use case is : Two luns are mapped from storage array to linux host which a=
re in same SAN fabric . we want to create a mirror on the linux host with th=
ese two luns and let  host use that mirror lun .  basic tests suggest that d=
m_mirror working fine . when we have any intermittent path issues with betwe=
en host and san array , host i/o just freeze , never returns back even after=
 the path is online.=20
>=20
> Hard to tell what's happening without any kernel log.
>=20
>> =20
>> Is dm_mirror viable solution here  ?. Can you point me any link which giv=
es the limitations of dm_mirror ? . another alternate solutions you propose h=
ere ?. Thanks in advance .
>=20
> We've switched the default away from "mirror" to "raid1" in order to take a=
dvantage of th MD runtime.
> Have you tested  "lvcreate --type raid1 ..." yet?
> Please do.
>=20
> Regards,
> Heinz
>=20
>> =20
>> Thanks
>> /Suresh
>>=20
>>=20
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
> <Untitled.txt>

--Apple-Mail-E75038BD-7B84-4CA3-871D-C05E198E8363
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: 7bit

<html><head><meta http-equiv="content-type" content="text/html; charset=utf-8"></head><body dir="auto"><div>Heinzm,thanks for the quick reply.. We are using dmestup create mirror ..as we want to do that on physical San lun (block devices) ... Not the one ( lv create ) you mentioned below.. Is there any advantage going with logical volume approach lvcreate -type &nbsp;</div><div><br></div><div>/Suresh<br><br>Sent from my iPhone</div><div><br>On Jan 26, 2015, at 7:46 PM, Heinz Mauelshagen &lt;<a href="mailto:heinzm@redhat.com">heinzm@redhat.com</a>&gt; wrote:<br><br></div><blockquote type="cite"><div>
  
    <meta content="text/html; charset=windows-1252" http-equiv="Content-Type">
  
  
    <br>
    <div class="moz-cite-prefix">On 01/26/2015 02:51 PM, Suresh Babu
      Kandukuru wrote:<br>
    </div>
    <blockquote cite="mid:4d982ea8-3769-46d2-ba73-2d1525faa63b@default" type="cite">
      <meta http-equiv="Content-Type" content="text/html;
        charset=windows-1252">
      <meta name="Generator" content="Microsoft Word 14 (filtered
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
<o:shapedefaults v:ext="edit" spidmax="1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext="edit">
<o:idmap v:ext="edit" data="1" />
</o:shapelayout></xml><![endif]-->
      <div class="WordSection1">
        <p class="MsoNormal">Use case is : Two luns are mapped from
          storage array to linux host which are in same SAN fabric . we
          want to create a mirror on the linux host with these two luns
          and let&nbsp; host use that mirror lun .&nbsp; basic tests suggest that
          dm_mirror working fine . when we have any intermittent path
          issues with between host and san array , host i/o just freeze
          , never returns back even after the path is online.&nbsp; <o:p></o:p></p>
      </div>
    </blockquote>
    <br>
    Hard to tell what's happening without any kernel log.<br>
    <br>
    <blockquote cite="mid:4d982ea8-3769-46d2-ba73-2d1525faa63b@default" type="cite">
      <div class="WordSection1">
        <p class="MsoNormal"><o:p>&nbsp;</o:p></p>
        <p class="MsoNormal">Is dm_mirror viable solution here &nbsp;?. Can
          you point me any link which gives the limitations of dm_mirror
          ? . another alternate solutions you propose here ?. Thanks in
          advance .</p>
      </div>
    </blockquote>
    <br>
    We've switched the default away from "mirror" to "raid1" in order to
    take advantage of th MD runtime.<br>
    Have you tested&nbsp; "lvcreate --type raid1 ..." yet?<br>
    Please do.<br>
    <br>
    Regards,<br>
    Heinz<br>
    <br>
    <blockquote cite="mid:4d982ea8-3769-46d2-ba73-2d1525faa63b@default" type="cite">
      <div class="WordSection1">
        <p class="MsoNormal"><o:p></o:p></p>
        <p class="MsoNormal"><o:p>&nbsp;</o:p></p>
        <p class="MsoNormal">Thanks<o:p></o:p></p>
        <p class="MsoNormal">/Suresh<o:p></o:p></p>
      </div>
      <br>
      <fieldset class="mimeAttachmentHeader"></fieldset>
      <br>
      <pre wrap="">--
dm-devel mailing list
<a class="moz-txt-link-abbreviated" href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a>
<a class="moz-txt-link-freetext" href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a></pre>
    </blockquote>
    <br>
  

</div></blockquote><blockquote type="cite"><div>&lt;Untitled.txt&gt;</div></blockquote></body></html>
--Apple-Mail-E75038BD-7B84-4CA3-871D-C05E198E8363--


--===============6224379024105283331==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6224379024105283331==--
