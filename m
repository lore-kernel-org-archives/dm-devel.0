From: <Yanqing_Liu@Dell.com>
Subject: DM manual failback doesn't work on RHEL5
Date: Mon, 23 Aug 2010 15:31:32 -0500
Message-ID: <F757EE5C3631ED4DBDFD7709119219FE03C4B50BF7@AUSX7MCPS302.AMER.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4279627175415415210=="
Return-path: <dm-devel-bounces@redhat.com>
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
To: dm-devel@redhat.com
Cc: Ashokan_Vellimalai@Dell.com, Charles_Rose@Dell.com
List-Id: dm-devel.ids

--===============4279627175415415210==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_F757EE5C3631ED4DBDFD7709119219FE03C4B50BF7AUSX7MCPS302A_"

--_000_F757EE5C3631ED4DBDFD7709119219FE03C4B50BF7AUSX7MCPS302A_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi all,

In our testing with DM RDAC stack with RHEL 5 (including 5.5 and 5.4), we f=
ound that manual failback doesn't work as expected.

What we did is to connect the host to Dell PowerVault 3200/i array. After e=
verything is configured, we changed "failback" value for our device from "i=
mmediate" to "manual". Then the host is rebooted for the new value to take =
effect. However, automatic failback still happens once failed path is resto=
red. It seems failback "manual" doesn't work.

We've also verified deferred failback works as expected. So "manual" failba=
ck seems to be the only issue.

Our device section in multipath.conf is as follows:

...
device {
                vendor                "DELL"
                product               "MD32xxi"
                path_grouping_policy  group_by_prio
                prio                  rdac
                polling_interval      5
                path_checker          rdac
                path-selector         "round-robin 0"
                hardware_handler      "1 rdac"
                failback              manual
                features              "2 pg_init_retries 50"
                no_path_retry         30
                rr_min_io             100
                prio_callout          "/sbin/mpath_prio_rdac /dev/%n"
        }
...

Any sugegstion or insight on this issue?

Thanks,
Yanqing


--_000_F757EE5C3631ED4DBDFD7709119219FE03C4B50BF7AUSX7MCPS302A_
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
<font face=3D"Arial, sans-serif" size=3D"2">
<div>Hi all,</div>
<div>&nbsp;</div>
<div>In our testing with DM RDAC stack with RHEL 5 (including 5.5 and 5.4),=
 we found that manual failback doesn't work as expected.</div>
<div>&nbsp;</div>
<div>What we did is to connect the host to Dell PowerVault 3200/i array. Af=
ter everything is configured, we changed &quot;failback&quot; value for our=
 device from &quot;immediate&quot; to &quot;manual&quot;. Then the host is =
rebooted for the new value to take effect. However, automatic
failback still happens once failed path is restored. It seems failback &quo=
t;manual&quot; doesn't work.</div>
<div>&nbsp;</div>
<div>We've also verified deferred failback works as expected. So &quot;manu=
al&quot; failback seems to be the only issue. </div>
<div>&nbsp;</div>
<div>Our device section in multipath.conf is as follows:</div>
<div>&nbsp;</div>
<div>...</div>
<div><font face=3D"Courier New">device {</font></div>
<div><font face=3D"Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vendor&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot=
;DELL&quot;</font></div>
<div><font face=3D"Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; product&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;MD32=
xxi&quot;</font></div>
<div><font face=3D"Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_grouping_policy&nbsp; =
group_by_prio</font></div>
<div><font face=3D"Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; prio&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; rdac</font></div>
<div><font face=3D"Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; polling_interval&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; 5</font></div>
<div><font face=3D"Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_checker&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rdac</font></div>
<div><font face=3D"Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path-selector&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;round-robin 0&quot;</font></div>
<div><font face=3D"Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; hardware_handler&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; &quot;1 rdac&quot;</font></div>
<div><font face=3D"Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; failback&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; manual</font></=
div>
<div><font face=3D"Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; features&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;2 pg_init=
_retries 50&quot;</font></div>
<div><font face=3D"Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; no_path_retry&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 30</font></div>
<div><font face=3D"Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rr_min_io&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 100</font></div>
<div><font face=3D"Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; prio_callout&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;/sbin/mpath_prio_rdac /dev/%n=
&quot;</font></div>
<div><font face=3D"Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
}</font></div>
<div>&#8230;<br>

</div>
<div>Any sugegstion or insight on this issue?</div>
<div>&nbsp;</div>
<div>Thanks,</div>
<div>Yanqing</div>
<div>&nbsp;</div>
</font>
</body>
</html>

--_000_F757EE5C3631ED4DBDFD7709119219FE03C4B50BF7AUSX7MCPS302A_--


--===============4279627175415415210==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4279627175415415210==--
