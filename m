From: "Cu.auto.fw@gmail.com" <cu.auto.fw@gmail.com>
Subject: Multipath device error
Date: Sat, 1 May 2010 02:57:28 +0800
Message-ID: <23E6F3D2-07C4-4B92-9CCB-E1BD13EBFAA4@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (iPhone Mail 7D11)
Content-Type: multipart/mixed; boundary="===============0173542300738118142=="
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
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============0173542300738118142==
Content-Type: multipart/alternative;
	boundary=Apple-Mail-1-141389500
Content-Transfer-Encoding: 7bit


--Apple-Mail-1-141389500
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

    i found simillar error like this:
 >
 > refer tohttps://bugzilla.redhat.com/show_bug.cgi?id=516170.
 >
 > "When an attempt is made to read a bad sector via a multipath  
device, the
 > multipath driver fails the path it hit the medium error through,  
and tries
 > again through the next path. Meanwhile the multipathd daemon re- 
enables the
 > path. As a result the I/O hangs forever (even if you unset the
 > queue_if_no_path
 > feature and set no_path_retry to something sensible, because the  
paths get
 > re-enabled we never get to the point where there are no live paths).
 > "
 >
 > is th above bug closed?  how can i resolve it?  i would be very  
thankful if
 > you can give me some information.
 >
 > Best regards, 
--Apple-Mail-1-141389500
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><body bgcolor=3D"#FFFFFF"><div></div><span =
class=3D"Apple-style-span" style=3D"font-size: 15px; =
-webkit-tap-highlight-color: rgba(26, 26, 26, 0.296875); =
-webkit-composition-fill-color: rgba(175, 192, 227, 0.230469); =
-webkit-composition-frame-color: rgba(77, 128, 180, 0.230469); =
">&nbsp;&nbsp; i found simillar error like =
this:&nbsp;<br>&gt;&nbsp;<br>&gt; refer to<a =
href=3D"https://bugzilla.redhat.com/show_bug.cgi?id=3D516170"><a =
href=3D"https://bugzilla.redhat.com/show_bug.cgi?id=3D516170">https://bugz=
illa.redhat.com/show_bug.cgi?id=3D516170</a></a>.&nbsp;<br>&gt;&nbsp;<br>&=
gt; "When an attempt is made to read a bad sector via a multipath =
device, the&nbsp;<br>&gt; multipath driver fails the path it hit the =
medium error through, and tries&nbsp;<br>&gt; again through the next =
path. Meanwhile the multipathd daemon re-enables the&nbsp;<br>&gt; path. =
As a result the I/O hangs forever (even if you unset the&nbsp;<br>&gt; =
queue_if_no_path&nbsp;<br>&gt; feature and set no_path_retry to =
something sensible, because the paths get&nbsp;<br>&gt; re-enabled we =
never get to the point where there are no live paths).&nbsp;<br>&gt; =
"&nbsp;<br>&gt;&nbsp;<br>&gt; is th above bug closed?&nbsp; how can i =
resolve it?&nbsp; i would be very thankful if&nbsp;<br>&gt; you can give =
me some information.&nbsp;<br>&gt;&nbsp;<br>&gt; Best =
regards,&nbsp;</span></body></html>=

--Apple-Mail-1-141389500--


--===============0173542300738118142==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0173542300738118142==--
