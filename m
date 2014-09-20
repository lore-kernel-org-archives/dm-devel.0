From: Shao Miller <shao.miller@treefrog.ca>
Subject: Shared Memory Pages for Same Base Device
Date: Sat, 20 Sep 2014 11:50:23 -0400
Message-ID: <541DA23F.6000003@treefrog.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5090571618278986678=="
Return-path: <dm-devel-bounces@redhat.com>
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
--===============5090571618278986678==
Content-Type: multipart/alternative;
	boundary="------------090100080907070603020005"

This is a multi-part message in MIME format.
--------------090100080907070603020005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Good day to all.

If I've some block device "base" and I've two derived device-mapper 
devices "derived1" and "derived2" that are copy-on-write layers over top 
of that base, and I mount the filesystems on those derived block devices 
and run the same program "foo" from both, does the "foo" running from 
"derived1" share any [read and execute] memory pages with the "foo" 
running from "derived2", since the underlying sectors are both from the 
same position on "base"?

The more general question would be about mmap, but I hope this example 
is clear.  "Docker"[1] uses device-mapper in scenarios like the above 
example and I'm curious if they benefit from shared pages.

[1] https://www.docker.com/
-- 

Shao Miller
/Network Technician/
/905-836-4442 *ext: 112*/
www.treefrog.ca/shao-miller <http://www.treefrog.ca/shao-miller>
*
* /*Treefrog Inc.*/
905-836-4442
567 Davis Drive, Newmarket, ON
www.treefrog.ca <http://www.treefrog.ca/> - @Treefrog


--------------090100080907070603020005
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    Good day to all.<br>
    <br>
    If I've some block device "base" and I've two derived device-mapper
    devices "derived1" and "derived2" that are copy-on-write layers over
    top of that base, and I mount the filesystems on those derived block
    devices and run the same program "foo" from both, does the "foo"
    running from "derived1" share any [read and execute] memory pages
    with the "foo" running from "derived2", since the underlying sectors
    are both from the same position on "base"?<br>
    <br>
    The more general question would be about mmap, but I hope this
    example is clear.&nbsp; "Docker"[1] uses device-mapper in scenarios like
    the above example and I'm curious if they benefit from shared pages.<br>
    <br>
    [1] <a class="moz-txt-link-freetext" href="https://www.docker.com/">https://www.docker.com/</a><br>
    <div class="moz-signature">-- <br>
      <meta http-equiv="content-type" content="text/html;
        charset=ISO-8859-1">
      <br>
      <span class="Apple-style-span" style="font-size: 13px;
        font-weight: bold;">Shao Miller</span><br>
      <i style="font-weight: normal; font-size: 11px; orphans: 2;
        widows: 2;">Network Technician</i><br>
      <i style="font-style: normal; font-size: medium; font-weight:
        normal;"><span class="Apple-style-span" style="font-style:
          normal;">905-836-4442</span> <span class="Apple-style-span"
          style="font-style: normal;"><b>ext: 112</b></span></i><br>
      <a href="http://www.treefrog.ca/shao-miller" style="font-style:
        normal; font-weight: normal; font-size: 10px;">www.treefrog.ca/shao-miller</a><br>
      <font class="Apple-style-span" color="#659E3F"><b><br>
        </b></font> <i style="font-style: normal; font-weight: normal;
        font-size: 11px;"><span class="Apple-style-span"
          style="font-style: normal;"><b><font class="Apple-style-span"
              color="#659E3F">Treefrog Inc.</font></b></span></i>
      <div> <font class="Apple-style-span" size="2">905-836-4442<br>
          <span class="Apple-style-span" style="color: rgb(95, 94, 95);">567
            Davis Drive, Newmarket, ON</span><br>
          <a href="http://www.treefrog.ca/">www.treefrog.ca</a> -
          @Treefrog</font><br>
        <br>
      </div>
    </div>
  </body>
</html>

--------------090100080907070603020005--


--===============5090571618278986678==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5090571618278986678==--
