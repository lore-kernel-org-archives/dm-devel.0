From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [RFC] [PATCH] lvm2: mirroredlog support
Date: Fri, 23 Jan 2009 13:14:00 -0600
Message-ID: <B18A3004-C5FF-4AF7-AB17-D9296F85E35F@redhat.com>
References: <20081230001055.GA13710@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/mixed; boundary="===============0990965563=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081230001055.GA13710@us.ibm.com>
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


--===============0990965563==
Content-Type: multipart/alternative; boundary=Apple-Mail-20-1027769881


--Apple-Mail-20-1027769881
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Be careful not to waste your time on some thing that will not be  
included....

I see the order of events like this:
1) Generic layering of LVs
2) Improved mirror DSO
3) Mirrored log implementation

Note that once you get #1 done you /should/ be able to get a mirrored  
log by:
prompt> lvcreate -m1 --mirrorlog core -l 1 -n mirrored_log vg
prompt> lvcreate -m1 -L 5G -n mirror vg /dev/sdb /dev/sdc /dev/vg/ 
mirrored_log

Leapfrogging #2 /might/ be acceptable, but leapfrogging #1 is not.   
This is because you are creating a one-off solution rather than  
creating something more general that would benefit LVM as a whole.

Feel free to disagree, but I really see the above as the way forward.

  brassow


On Dec 29, 2008, at 6:10 PM, malahal@us.ibm.com wrote:

> This patch adds '--mirroredlog' option to LVM commands to create a
> mirror with mirrored log device. Rebased to the latest LVM code
> (LVM2.2.02.43). Appreciate any comments.
>
> Signed-off-by: Stefan Raspl <raspl@de.ibm.com>


--Apple-Mail-20-1027769881
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><div>Be careful not to waste =
your time on some thing that will not be =
included....</div><div><br></div><div>I see the order of events like =
this:</div><div>1) Generic layering of LVs</div><div>2) Improved mirror =
DSO</div><div>3) Mirrored log =
implementation</div><div><br></div><div>Note that once you get #1 done =
you /should/ be able to get a mirrored log by:</div><div>prompt> =
lvcreate -m1 --mirrorlog core -l 1 -n mirrored_log vg</div><div>prompt> =
lvcreate -m1 -L 5G -n mirror vg /dev/sdb /dev/sdc =
/dev/vg/mirrored_log</div><div><br></div><div>Leapfrogging #2 /might/ =
be&nbsp;acceptable, but leapfrogging #1 is not. &nbsp;This is because =
you are creating a one-off solution rather than creating something more =
general that would benefit LVM as a whole.</div><div><br></div><div>Feel =
free to disagree, but I really see the above as the way =
forward.</div><div><br></div><div>&nbsp;brassow</div><div><br></div><br><d=
iv><div>On Dec 29, 2008, at 6:10 PM, <a =
href=3D"mailto:malahal@us.ibm.com">malahal@us.ibm.com</a> =
wrote:</div><br class=3D"Apple-interchange-newline"><blockquote =
type=3D"cite"><span class=3D"Apple-style-span" style=3D"border-collapse: =
separate; color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant: normal; font-weight: normal; =
letter-spacing: normal; line-height: normal; orphans: 2; text-align: =
auto; text-indent: 0px; text-transform: none; white-space: normal; =
widows: 2; word-spacing: 0px; -webkit-border-horizontal-spacing: 0px; =
-webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0; ">This patch adds '--mirroredlog' =
option to LVM commands to create a<br>mirror with mirrored log device. =
Rebased to the latest LVM code<br>(LVM2.2.02.43). Appreciate any =
comments.<br><br>Signed-off-by: Stefan Raspl &lt;<a =
href=3D"mailto:raspl@de.ibm.com">raspl@de.ibm.com</a>><br></span></blockqu=
ote></div><br></body></html>=

--Apple-Mail-20-1027769881--


--===============0990965563==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0990965563==--
