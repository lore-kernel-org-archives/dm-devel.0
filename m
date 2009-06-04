From: Larry Dickson <ldickson@cuttedge.com>
Subject: Re: Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft
	RAID under Linux
Date: Thu, 4 Jun 2009 08:33:34 -0700
Message-ID: <1c748a490906040833u7698591ds770a69bd8b221f8b@mail.gmail.com>
References: <18980.48553.328662.80987@notabene.brown>
	<4A25876A.1010901@garzik.org>
	<18981.62579.171350.910761@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0243050705=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <18981.62579.171350.910761@notabene.brown>
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
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Arjan van de Ven <arjan@infradead.org>
List-Id: dm-devel.ids

--===============0243050705==
Content-Type: multipart/alternative; boundary=001e680f0c84c051e8046b877f6d

--001e680f0c84c051e8046b877f6d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi all,

As a user of both dm (in lvm) and md, I am not reassured by the "turf war"
flavor coming from the dm side. The idea that all functions should be
glooped together in one monster program, whether dm or the Microsoft
operating system, is not an automatic + in my opinion. The massive patch
activity that I see in dm-devel could be an indication of function
overcentralization leading to design risk, just as in Microsoft development.

A minor technical note follows.


> For things like suspend/resume of incoming IO (so a device can be
> reconfigured), maybe.  I recently added that so that I could effect
> raid5->raid6 conversions.


Suspend is not necessary, only barriers, as long as you define a hybrid
raid5/raid6 array via a moving watermark. Only those IOs that hit in the
neighborhood of the watermark are affected.

Larry Dickson
Cutting Edge Networked Storage




> NeilBrown
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001e680f0c84c051e8046b877f6d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi all,</div>
<div>=A0</div>
<div>As a user of both dm (in lvm) and md, I am not reassured by the &quot;=
turf war&quot; flavor coming from the dm side. The idea that all functions =
should be glooped together in one monster program, whether dm or the Micros=
oft operating system, is not an automatic + in my opinion. The massive patc=
h activity that I see in dm-devel could be an indication of function overce=
ntralization leading to design risk, just as in Microsoft development.<br>
=A0</div>
<div>A minor technical note follows.<br>=A0</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">For things like suspend/resume o=
f incoming IO (so a device can be<br>reconfigured), maybe.=A0=A0I recently =
added that so that I could effect<br>
raid5-&gt;raid6 conversions.</blockquote>
<div>=A0</div>
<div>Suspend is not necessary, only barriers, as long as you define a hybri=
d raid5/raid6 array via a moving watermark. Only those IOs that hit in the =
neighborhood of the watermark are affected.</div>
<p>Larry Dickson</p>
<div>Cutting Edge Networked Storage</div>
<div>=A0</div>
<div><br>=A0</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">NeilBrown<br><br>--<br>dm-devel =
mailing list<br><a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com<=
/a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel">https://www.re=
dhat.com/mailman/listinfo/dm-devel</a><br></blockquote><br>

--001e680f0c84c051e8046b877f6d--


--===============0243050705==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0243050705==--
