From: Dwaine Garden <dwainegarden@rogers.com>
Subject: Re: dm-striped device sizes must be multiple of chunk-size
Date: Thu, 18 May 2006 10:45:07 -0700 (PDT)
Message-ID: <20060518174507.11849.qmail@web88211.mail.re2.yahoo.com>
References: <1146743537.3583.2.camel@localhost>
Reply-To: Dwaine Garden <dwainegarden@rogers.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0455481347=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1146743537.3583.2.camel@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

--===============0455481347==
Content-Type: multipart/alternative; boundary="0-750411739-1147974307=:9813"

--0-750411739-1147974307=:9813
Content-Type: text/plain; charset=us-ascii

If you download the new dmraid rc11 rpm, it will resolve this problem.  But get the official rpm and not the
test version on the dmraid site.
 
Dwaine

----- Original Message ----
From: Stephen Howell <showell@bigpond.net.au>
To: dm-devel@redhat.com
Sent: Thursday, May 4, 2006 7:52:17 AM
Subject: [dm-devel] dm-striped device sizes must be multiple of chunk-size


I thought I might also add to my comment of a few hours ago that I have
just compiled the 2.6.15 kernel and have no problem with my dm-stripe
drives under this kernel either. So I appear to be having the same
problem as Joe pointed out.

SH.

On Thu, 2006-05-04 at 20:11 +1000, Stephen Howell wrote:
> I have been reading the post at 
> http://www.archivesat.com/RedHat_device-mapper_development/thread353566.htm
> 
> I also have this problem
> 
> dmraid -s
> *** Active Set
> name   : nvidia_egiafbgb
> size   : 1562845532
> stride : 128
> type   : stripe
> status : ok
> subsets: 0
> devs   : 2
> spares : 0
> 
> dmraid -r
> /dev/sdb: nvidia, "nvidia_egiafbgb", stripe, ok, 781422766 sectors,
> data@ 0
> /dev/sdc: nvidia, "nvidia_egiafbgb", stripe, ok, 781422766 sectors,
> data@ 0
> 
> and get the dm-stripe error listed in the subject above.
> 
> This occurs under 2.6.16 but not under 2.6.14.
> 
> Thought I might add some more data to Joe's comments.
> 
> Stephen Howell
> Melbourne Australia

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--0-750411739-1147974307=:9813
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px} --></style></head><body><div style="font-family:times new roman, new york, times, serif;font-size:12pt"><DIV style="FONT-SIZE: 12pt; FONT-FAMILY: times new roman, new york, times, serif">
<DIV>If you download the new dmraid rc11 rpm, it will resolve this problem.&nbsp;&nbsp;But get the official rpm and not the</DIV>
<DIV>test version on the dmraid site.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Dwaine<BR><BR>----- Original Message ----<BR>From: Stephen Howell &lt;showell@bigpond.net.au&gt;<BR>To: dm-devel@redhat.com<BR>Sent: Thursday, May 4, 2006 7:52:17 AM<BR>Subject: [dm-devel] dm-striped device sizes must be multiple of chunk-size<BR><BR></DIV>
<DIV>I thought I might also add to my comment of a few hours ago that I have<BR>just compiled the 2.6.15 kernel and have no problem with my dm-stripe<BR>drives under this kernel either. So I appear to be having the same<BR>problem as Joe pointed out.<BR><BR>SH.<BR><BR>On Thu, 2006-05-04 at 20:11 +1000, Stephen Howell wrote:<BR>&gt; I have been reading the post at <BR>&gt; <A href="http://www.archivesat.com/RedHat_device-mapper_development/thread353566.htm" target=_blank>http://www.archivesat.com/RedHat_device-mapper_development/thread353566.htm</A><BR>&gt; <BR>&gt; I also have this problem<BR>&gt; <BR>&gt; dmraid -s<BR>&gt; *** Active Set<BR>&gt; name&nbsp;&nbsp; : nvidia_egiafbgb<BR>&gt; size&nbsp;&nbsp; : 1562845532<BR>&gt; stride : 128<BR>&gt; type&nbsp;&nbsp; : stripe<BR>&gt; status : ok<BR>&gt; subsets: 0<BR>&gt; devs&nbsp;&nbsp; : 2<BR>&gt; spares : 0<BR>&gt; <BR>&gt; dmraid -r<BR>
 &gt; /dev/sdb: nvidia, "nvidia_egiafbgb", stripe, ok, 781422766 sectors,<BR>&gt; data@
 0<BR>&gt; /dev/sdc: nvidia, "nvidia_egiafbgb", stripe, ok, 781422766 sectors,<BR>&gt; data@ 0<BR>&gt; <BR>&gt; and get the dm-stripe error listed in the subject above.<BR>&gt; <BR>&gt; This occurs under 2.6.16 but not under 2.6.14.<BR>&gt; <BR>&gt; Thought I might add some more data to Joe's comments.<BR>&gt; <BR>&gt; Stephen Howell<BR>&gt; Melbourne Australia<BR><BR>--<BR>dm-devel mailing list<BR>dm-devel@redhat.com<BR><A href="https://www.redhat.com/mailman/listinfo/dm-devel" target=_blank>https://www.redhat.com/mailman/listinfo/dm-devel</A></DIV></DIV></div></body></html>
--0-750411739-1147974307=:9813--


--===============0455481347==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0455481347==--
