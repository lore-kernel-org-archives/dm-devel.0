From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: Re: deterministic io throughput in multipath
Date: Fri, 3 Feb 2017 11:43:52 +0000
Message-ID: <8e6b21c025d64b3cbbfa181516e242b0@BRMWP-EXMB12.corp.brocade.com>
References: <af56a18e992f4a8cb474de87a208e02a@BRMWP-EXMB12.corp.brocade.com>
	<1486000201-3960-1-git-send-email-bmarzins@redhat.com>
	<3ab5d07903b44e0a913b5637862c4c96@BRMWP-EXMB12.corp.brocade.com>
	<20170202173922.GE22981@octiron.msp.redhat.com>
	<b20254cf6b8043fea2243be30d296975@BRMWP-EXMB12.corp.brocade.com>
	<20170202182959.GF22981@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8044040922084386134=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170202182959.GF22981@octiron.msp.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8044040922084386134==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_8e6b21c025d64b3cbbfa181516e242b0BRMWPEXMB12corpbrocadec_"

--_000_8e6b21c025d64b3cbbfa181516e242b0BRMWPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"

Hi Ben,
I did commit my  patches to a branch off the head of master
But when I used the below command iam getting the below errors. Not sure whether the mail has been sent to dm-devel@redhat.com<mailto:dm-devel@redhat.com>.

# git send-email --to "device-mapper development <dm-devel@redhat.com>" --cc "Christophe Varoqui <christophe.varoqui@opensvc.com>" --no-chain-reply-to --suppress-from <dir>

Iam seeing the below error. Could you please help me in this


Content-Description: Notification
Content-Type: text/plain; charset=us-ascii

This is the mail system at host localhost.localdomain.

I'm sorry to have to inform you that your message could not
be delivered to one or more recipients. It's attached below.

For further assistance, please send mail to postmaster.

If you do so, please include this problem report. You can
delete your own text from the attached returned message.

                   The mail system

<christophe.varoqui@opensvc.com>: host spool.mail.gandi.net[217.70.184.6] said:
    550 5.1.8 <root@localhost.localdomain>: Sender address rejected: Domain not
    found (in reply to RCPT TO command)

--E52C4C13C372.1486112814/localhost.localdomain
Content-Description: Delivery report
Content-Type: message/delivery-status

Reporting-MTA: dns; localhost.localdomain
X-Postfix-Queue-ID: E52C4C13C372
X-Postfix-Sender: rfc822; root@localhost.localdomain
Arrival-Date: Fri,  3 Feb 2017 14:36:22 +0530 (IST)

Final-Recipient: rfc822; christophe.varoqui@opensvc.com
Action: failed
Status: 5.1.8
Remote-MTA: dns; spool.mail.gandi.net
Diagnostic-Code: smtp; 550 5.1.8 <root@localhost.localdomain>: Sender address
    rejected: Domain not found

--E52C4C13C372.1486112814/localhost.localdomain
Content-Description: Undelivered Message
Content-Type: message/rfc822

Return-Path: <root@localhost.localdomain>
Received: by localhost.localdomain (Postfix, from userid 0)
        id E52C4C13C372; Fri,  3 Feb 2017 14:36:22 +0530 (IST)
From: M Muneendra Kumar <mmandala@brocade.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 0/1] multipathd: deterministic io throughput in multipath
Date: Fri,  3 Feb 2017 14:36:21 +0530
Message-Id: <1486112782-12706-1-git-send-email-mmandala@brocade.com>
X-Mailer: git-send-email 1.8.3.1

Regards,
Muneendra.

-----Original Message-----
From: Benjamin Marzinski [mailto:bmarzins@redhat.com]
Sent: Friday, February 03, 2017 12:00 AM
To: Muneendra Kumar M <mmandala@Brocade.com>
Cc: device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] deterministic io throughput in multipath

On Thu, Feb 02, 2017 at 06:02:57PM +0000, Muneendra Kumar M wrote:
> Hi Ben,
> Thanks for the review.
> So can I push my changes as mentioned by you in the below mail using git.

Sure.

-Ben

>
> Regards,
> Muneendra.
>
>
> -----Original Message-----
> From: Benjamin Marzinski [mailto:bmarzins@redhat.com]
> Sent: Thursday, February 02, 2017 11:09 PM
> To: Muneendra Kumar M <mmandala@Brocade.com<mailto:mmandala@Brocade.com>>
> Cc: device-mapper development <dm-devel@redhat.com<mailto:dm-devel@redhat.com>>
> Subject: Re: [dm-devel] deterministic io throughput in multipath
>
> This looks fine. Thanks for all your work on this
>
> ACK
>
> -Ben
>
> On Thu, Feb 02, 2017 at 11:48:39AM +0000, Muneendra Kumar M wrote:
> > Hi Ben,
> > The below changes suggested by you are good. Thanks for it.
> > I have taken your changes and made few changes to make the functionality working.
> > I have tested the same on the setup which works fine.
> >
> > We need to increment the path_failures every time checker fails.
> > if a device is down for a while, when it comes back up, it will get delayed only if the path failures exceeds the error threshold.
> > Whether checker fails or kernel identifies the failures we need  to capture those as it tells the state of the path and target.
> > The below code has already taken care of this.
> >
> > Could you please review the attached patch and provide us your valuable comments .
> >
> > Below are the files that has been changed .
> >
> > libmultipath/config.c      |  6 ++++++
> >  libmultipath/config.h      |  9 +++++++++
> >  libmultipath/configure.c   |  3 +++
> >  libmultipath/defaults.h    |  3 ++-
> >  libmultipath/dict.c        | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------
> >  libmultipath/dict.h        |  3 +--
> >  libmultipath/propsel.c     | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
> >  libmultipath/propsel.h     |  3 +++
> >  libmultipath/structs.h     | 14 ++++++++++----
> >  multipath/multipath.conf.5 | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  multipathd/main.c          | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  11 files changed, 281 insertions(+), 34 deletions(-)
> >
> > Regards,
> > Muneendra.
> >
> >


--_000_8e6b21c025d64b3cbbfa181516e242b0BRMWPEXMB12corpbrocadec_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Exchange Server">
<!-- converted from rtf -->
<style><!-- .EmailQuote { margin-left: 1pt; padding-left: 4pt; border-left:=
 #800000 2px solid; } --></style>
</head>
<body>
<font face=3D"Calibri" size=3D"2"><span style=3D"font-size:11pt;">
<div>Hi Ben,</div>
<div>I did commit my&nbsp; patches to a branch off the head of master </div=
>
<div>But when I used the below command iam getting the below errors. Not su=
re whether the mail has been sent to <a href=3D"mailto:dm-devel@redhat.com"=
><font color=3D"#0563C1"><u>dm-devel@redhat.com</u></font></a>.</div>
<div>&nbsp;</div>
<div># git send-email --to &quot;device-mapper development &lt;dm-devel@red=
hat.com&gt;&quot; --cc &quot;Christophe Varoqui &lt;christophe.varoqui@open=
svc.com&gt;&quot; --no-chain-reply-to --suppress-from &lt;dir&gt;</div>
<div>&nbsp;</div>
<div><font color=3D"red">Iam seeing the below error.<font color=3D"black"> =
Could you please help me in this</font></font></div>
<div><font color=3D"red">&nbsp;</font></div>
<div><font color=3D"red">&nbsp;</font></div>
<div><font color=3D"red">Content-Description: Notification</font></div>
<div><font color=3D"red">Content-Type: text/plain; charset=3Dus-ascii</font=
></div>
<div><font color=3D"red">&nbsp;</font></div>
<div><font color=3D"red">This is the mail system at host localhost.localdom=
ain.</font></div>
<div><font color=3D"red">&nbsp;</font></div>
<div><font color=3D"red">I'm sorry to have to inform you that your message =
could not</font></div>
<div><font color=3D"red">be delivered to one or more recipients. It's attac=
hed below.</font></div>
<div><font color=3D"red">&nbsp;</font></div>
<div><font color=3D"red">For further assistance, please send mail to postma=
ster.</font></div>
<div><font color=3D"red">&nbsp;</font></div>
<div><font color=3D"red">If you do so, please include this problem report. =
You can</font></div>
<div><font color=3D"red">delete your own text from the attached returned me=
ssage.</font></div>
<div><font color=3D"red">&nbsp;</font></div>
<div><font color=3D"red">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; The mail system<=
/font></div>
<div><font color=3D"red">&nbsp;</font></div>
<div><font color=3D"red">&lt;christophe.varoqui@opensvc.com&gt;: host spool=
.mail.gandi.net[217.70.184.6] said:</font></div>
<div><font color=3D"red">&nbsp;&nbsp;&nbsp; 550 5.1.8 &lt;root@localhost.lo=
caldomain&gt;: Sender address rejected: Domain not</font></div>
<div><font color=3D"red">&nbsp;&nbsp;&nbsp; found (in reply to RCPT TO comm=
and)</font></div>
<div><font color=3D"red">&nbsp;</font></div>
<div><font color=3D"red">--E52C4C13C372.1486112814/localhost.localdomain</f=
ont></div>
<div><font color=3D"red">Content-Description: Delivery report</font></div>
<div><font color=3D"red">Content-Type: message/delivery-status</font></div>
<div><font color=3D"red">&nbsp;</font></div>
<div><font color=3D"red">Reporting-MTA: dns; localhost.localdomain</font></=
div>
<div><font color=3D"red">X-Postfix-Queue-ID: E52C4C13C372</font></div>
<div><font color=3D"red">X-Postfix-Sender: rfc822; root@localhost.localdoma=
in</font></div>
<div><font color=3D"red">Arrival-Date: Fri,&nbsp; 3 Feb 2017 14:36:22 &#43;=
0530 (IST)</font></div>
<div><font color=3D"red">&nbsp;</font></div>
<div><font color=3D"red">Final-Recipient: rfc822; christophe.varoqui@opensv=
c.com</font></div>
<div><font color=3D"red">Action: failed</font></div>
<div><font color=3D"red">Status: 5.1.8</font></div>
<div><font color=3D"red">Remote-MTA: dns; spool.mail.gandi.net</font></div>
<div><font color=3D"red">Diagnostic-Code: smtp; 550 5.1.8 &lt;root@localhos=
t.localdomain&gt;: Sender address</font></div>
<div><font color=3D"red">&nbsp;&nbsp;&nbsp; rejected: Domain not found</fon=
t></div>
<div><font color=3D"red">&nbsp;</font></div>
<div><font color=3D"red">--E52C4C13C372.1486112814/localhost.localdomain</f=
ont></div>
<div><font color=3D"red">Content-Description: Undelivered Message</font></d=
iv>
<div><font color=3D"red">Content-Type: message/rfc822</font></div>
<div><font color=3D"red">&nbsp;</font></div>
<div><font color=3D"red">Return-Path: &lt;root@localhost.localdomain&gt;</f=
ont></div>
<div><font color=3D"red">Received: by localhost.localdomain (Postfix, from =
userid 0)</font></div>
<div><font color=3D"red">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; id E52C=
4C13C372; Fri,&nbsp; 3 Feb 2017 14:36:22 &#43;0530 (IST)</font></div>
<div><font color=3D"red">From: M Muneendra Kumar &lt;mmandala@brocade.com&g=
t;</font></div>
<div><font color=3D"red">To: device-mapper development &lt;dm-devel@redhat.=
com&gt;</font></div>
<div><font color=3D"red">Cc: Christophe Varoqui &lt;christophe.varoqui@open=
svc.com&gt;,</font></div>
<div><font color=3D"red">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Benjami=
n Marzinski &lt;bmarzins@redhat.com&gt;</font></div>
<div><font color=3D"red">Subject: [PATCH 0/1] multipathd: deterministic io =
throughput in multipath</font></div>
<div><font color=3D"red">Date: Fri,&nbsp; 3 Feb 2017 14:36:21 &#43;0530</fo=
nt></div>
<div><font color=3D"red">Message-Id: &lt;1486112782-12706-1-git-send-email-=
mmandala@brocade.com&gt;</font></div>
<div><font color=3D"red">X-Mailer: git-send-email 1.8.3.1</font></div>
<div>&nbsp;</div>
<div>Regards,</div>
<div>Muneendra.</div>
<a name=3D"_MailEndCompose"></a>
<div>&nbsp;</div>
<div>-----Original Message-----<br>

From: Benjamin Marzinski [<a href=3D"mailto:bmarzins@redhat.com">mailto:bma=
rzins@redhat.com</a>]
<br>

Sent: Friday, February 03, 2017 12:00 AM<br>

To: Muneendra Kumar M &lt;mmandala@Brocade.com&gt;<br>

Cc: device-mapper development &lt;dm-devel@redhat.com&gt;<br>

Subject: Re: [dm-devel] deterministic io throughput in multipath</div>
<div>&nbsp;</div>
<div>On Thu, Feb 02, 2017 at 06:02:57PM &#43;0000, Muneendra Kumar M wrote:=
</div>
<div>&gt; Hi Ben,</div>
<div>&gt; Thanks for the review.</div>
<div>&gt; So can I push my changes as mentioned by you in the below mail us=
ing git.</div>
<div>&nbsp;</div>
<div>Sure.</div>
<div>&nbsp;</div>
<div>-Ben</div>
<div>&nbsp;</div>
<div>&gt; </div>
<div>&gt; Regards,</div>
<div>&gt; Muneendra.</div>
<div>&gt; </div>
<div>&gt; </div>
<div>&gt; -----Original Message-----</div>
<div>&gt; From: Benjamin Marzinski [<a href=3D"mailto:bmarzins@redhat.com">=
mailto:bmarzins@redhat.com</a>] </div>
<div>&gt; Sent: Thursday, February 02, 2017 11:09 PM</div>
<div>&gt; To: Muneendra Kumar M &lt;<a href=3D"mailto:mmandala@Brocade.com"=
>mmandala@Brocade.com</a>&gt;</div>
<div>&gt; Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redh=
at.com">dm-devel@redhat.com</a>&gt;</div>
<div>&gt; Subject: Re: [dm-devel] deterministic io throughput in multipath<=
/div>
<div>&gt; </div>
<div>&gt; This looks fine. Thanks for all your work on this</div>
<div>&gt; </div>
<div>&gt; ACK</div>
<div>&gt; </div>
<div>&gt; -Ben</div>
<div>&gt; </div>
<div>&gt; On Thu, Feb 02, 2017 at 11:48:39AM &#43;0000, Muneendra Kumar M w=
rote:</div>
<div>&gt; &gt; Hi Ben,</div>
<div>&gt; &gt; The below changes suggested by you are good. Thanks for it.<=
/div>
<div>&gt; &gt; I have taken your changes and made few changes to make the f=
unctionality working.</div>
<div>&gt; &gt; I have tested the same on the setup which works fine.</div>
<div>&gt; &gt; </div>
<div>&gt; &gt; We need to increment the path_failures every time checker fa=
ils.</div>
<div>&gt; &gt; if a device is down for a while, when it comes back up, it w=
ill get delayed only if the path failures exceeds the error threshold.</div=
>
<div>&gt; &gt; Whether checker fails or kernel identifies the failures we n=
eed&nbsp; to capture those as it tells the state of the path and target.</d=
iv>
<div>&gt; &gt; The below code has already taken care of this.</div>
<div>&gt; &gt; </div>
<div>&gt; &gt; Could you please review the attached patch and provide us yo=
ur valuable comments .</div>
<div>&gt; &gt; </div>
<div>&gt; &gt; Below are the files that has been changed .</div>
<div>&gt; &gt; </div>
<div>&gt; &gt; libmultipath/config.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; =
6 &#43;&#43;&#43;&#43;&#43;&#43;</div>
<div>&gt; &gt;&nbsp; libmultipath/config.h&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&=
nbsp; 9 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;</div>
<div>&gt; &gt;&nbsp; libmultipath/configure.c&nbsp;&nbsp; |&nbsp; 3 &#43;&#=
43;&#43;</div>
<div>&gt; &gt;&nbsp; libmultipath/defaults.h&nbsp;&nbsp;&nbsp; |&nbsp; 3 &#=
43;&#43;-</div>
<div>&gt; &gt;&nbsp; libmultipath/dict.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; | 86 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;-------------------------</div>
<div>&gt; &gt;&nbsp; libmultipath/dict.h&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; |&nbsp; 3 &#43;--</div>
<div>&gt; &gt;&nbsp; libmultipath/propsel.c&nbsp;&nbsp;&nbsp;&nbsp; | 48 &#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;--</div>
<div>&gt; &gt;&nbsp; libmultipath/propsel.h&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;=
 3 &#43;&#43;&#43;</div>
<div>&gt; &gt;&nbsp; libmultipath/structs.h&nbsp;&nbsp;&nbsp;&nbsp; | 14 &#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;----</div>
<div>&gt; &gt;&nbsp; multipath/multipath.conf.5 | 57 &#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;</div>
<div>&gt; &gt;&nbsp; multipathd/main.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; | 83 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;</div>
<div>&gt; &gt;&nbsp; 11 files changed, 281 insertions(&#43;), 34 deletions(=
-)</div>
<div>&gt; &gt; </div>
<div>&gt; &gt; Regards,</div>
<div>&gt; &gt; Muneendra.</div>
<div>&gt; &gt; </div>
<div>&gt; &gt; </div>
<div>&nbsp;</div>
</span></font>
</body>
</html>

--_000_8e6b21c025d64b3cbbfa181516e242b0BRMWPEXMB12corpbrocadec_--


--===============8044040922084386134==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8044040922084386134==--
