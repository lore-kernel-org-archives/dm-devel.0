From: Artur Bergman <sky@nanisky.com>
Subject: Re: Device Mapper as a cache for SAN?
Date: Mon, 10 Apr 2006 15:22:28 -0700
Message-ID: <EC183B04-E6D8-461A-ABB2-5B997CCC0B88@nanisky.com>
References: <a4e6962a0604101058w75a7147cy8860bc9ebf8f269e@mail.gmail.com>
	<20060410184531.GA12908@www.ewilts.org>
	<a4e6962a0604101246y5f912a01y72519a6c58291f5@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: multipart/mixed; boundary="===============2081668931=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a4e6962a0604101246y5f912a01y72519a6c58291f5@mail.gmail.com>
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


--===============2081668931==
Content-Type: multipart/alternative; boundary=Apple-Mail-18-1044307359


--Apple-Mail-18-1044307359
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed


On 10 Apr 2006, at 12:46, Eric Van Hensbergen wrote:

>  The various cluster file systems
> may provide something more akin to this, but again, this doesn't
> really cover SAN technologies -- not in any sort of a generic way.
> Let me know if I'm missing something.

I think everyone asking is missing something.

kernels cache, applications that use raw disk cache, SAN devices  
cache, I fail to see what you really are proposing and therefore I  
fail to see what value you are proposing?

Caching a SAN to local disk? usually my SANs are quite a bit faster  
than local disk, caching to memory? what does that buy you that the  
kernel/application caching gets you?

Artur
--Apple-Mail-18-1044307359
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=ISO-8859-1

<HTML><BODY style=3D"word-wrap: break-word; -khtml-nbsp-mode: space; =
-khtml-line-break: after-white-space; "><BR><DIV><DIV>On 10 Apr 2006, at =
12:46, Eric Van Hensbergen wrote:</DIV><BR =
class=3D"Apple-interchange-newline"><BLOCKQUOTE type=3D"cite"><P =
style=3D"margin: 0.0px 0.0px 0.0px 0.0px"><FONT face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica"><SPAN =
class=3D"Apple-converted-space">=A0</SPAN>The various cluster file =
systems</FONT></P> <P style=3D"margin: 0.0px 0.0px 0.0px 0.0px"><FONT =
face=3D"Helvetica" size=3D"3" style=3D"font: 12.0px Helvetica">may =
provide something more akin to this, but again, this doesn't</FONT></P> =
<P style=3D"margin: 0.0px 0.0px 0.0px 0.0px"><FONT face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">really cover SAN =
technologies -- not in any sort of a generic way.<SPAN =
class=3D"Apple-converted-space">=A0</SPAN></FONT></P> <P style=3D"margin: =
0.0px 0.0px 0.0px 0.0px"><FONT face=3D"Helvetica" size=3D"3" =
style=3D"font: 12.0px Helvetica">Let me know if I'm missing =
something.</FONT></P> </BLOCKQUOTE></DIV><BR><DIV>I think everyone =
asking is missing something.</DIV><DIV><BR =
class=3D"khtml-block-placeholder"></DIV><DIV>kernels=A0cache, =
applications that use raw disk cache, SAN devices cache, I fail to see =
what you really are proposing and therefore I fail to see what value you =
are proposing?</DIV><DIV><BR =
class=3D"khtml-block-placeholder"></DIV><DIV>Caching a SAN to local =
disk? usually my SANs are quite a bit faster than local disk, caching to =
memory? what does that buy you that the kernel/application caching gets =
you?</DIV><DIV><BR =
class=3D"khtml-block-placeholder"></DIV><DIV>Artur</DIV></BODY></HTML>=

--Apple-Mail-18-1044307359--


--===============2081668931==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2081668931==--
