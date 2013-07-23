From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: dm-cache: dirty state of blocks in writethrough mode
Date: Tue, 23 Jul 2013 15:26:08 +0200
Message-ID: <51EE8470.6070302@redhat.com>
References: <C91EDD5251EDF44CB434B1039B0DEEB82A8D0762@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3408786159625775778=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C91EDD5251EDF44CB434B1039B0DEEB82A8D0762@SACEXCMBX02-PRD.hq.netapp.com>
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

This is a multi-part message in MIME format.
--===============3408786159625775778==
Content-Type: multipart/alternative;
	boundary="------------000409000702040600070803"

This is a multi-part message in MIME format.
--------------000409000702040600070803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/23/2013 08:44 AM, Vijarnia, Anil wrote:
> Hello,
> In Documentation/cache.txt, section 'Updating on-disk metadata' mentions that "If the system crashes all cache blocks will be assumed dirty when restarted".
> I am assuming that the above line is relevant for writeback mode only, and in writethrough mode the cache will always be coherent after a crash.
> Can someone confirm/reject this assumption?

That's correct

Reason being that the cache never holds any dirty pages in writethrough 
mode.

-- lvmguy

>   
> Thanks
>   
>   
>   
>   
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--------------000409000702040600070803
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    On 07/23/2013 08:44 AM, Vijarnia, Anil wrote:<br>
    <blockquote
cite="mid:C91EDD5251EDF44CB434B1039B0DEEB82A8D0762@SACEXCMBX02-PRD.hq.netapp.com"
      type="cite">
      <meta http-equiv="Content-Type" content="text/html;
        charset=ISO-8859-1">
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
pre
	{mso-style-priority:99;
	mso-style-link:"HTML Preformatted Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.HTMLPreformattedChar
	{mso-style-name:"HTML Preformatted Char";
	mso-style-priority:99;
	mso-style-link:"HTML Preformatted";
	font-family:"Courier New";}
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
        <pre>Hello,<o:p></o:p></pre>
        <pre>In Documentation/cache.txt, section &#8216;Updating on-disk metadata&#8217; mentions that &#8220;If the system crashes all cache blocks will be assumed dirty when restarted&#8221;. <o:p></o:p></pre>
        <pre>I am assuming that the above line is relevant for writeback mode only, and in writethrough mode the cache will always be coherent after a crash. <o:p></o:p></pre>
        <pre>Can someone confirm/reject this assumption?<o:p></o:p></pre>
      </div>
    </blockquote>
    <br>
    That's correct<br>
    <br>
    Reason being that the cache never holds any dirty pages in
    writethrough mode.<br>
    <br>
    -- lvmguy<br>
    <br>
    <blockquote
cite="mid:C91EDD5251EDF44CB434B1039B0DEEB82A8D0762@SACEXCMBX02-PRD.hq.netapp.com"
      type="cite">
      <div class="WordSection1">
        <pre><o:p>&nbsp;</o:p></pre>
        <pre>Thanks<o:p></o:p></pre>
        <pre><o:p>&nbsp;</o:p></pre>
        <pre><o:p>&nbsp;</o:p></pre>
        <pre><o:p>&nbsp;</o:p></pre>
        <pre><o:p>&nbsp;</o:p></pre>
        <p class="MsoNormal"><o:p>&nbsp;</o:p></p>
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
  </body>
</html>

--------------000409000702040600070803--


--===============3408786159625775778==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3408786159625775778==--
