From: "BK, GirishKumar" <GirishKumar.BK@netapp.com>
Subject: dm-cache: Promote-Demote Policy.  How it works ?
Date: Mon, 9 Feb 2015 13:19:44 +0000
Message-ID: <D0FEB1C5.11407%GirishKumar.BK@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8898368880165525843=="
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
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8898368880165525843==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_D0FEB1C511407GirishKumarBKnetappcom_"

--_000_D0FEB1C511407GirishKumarBKnetappcom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

HI,

I'm new and trying to understand how exactly the "read_promote_adjustment" =
and "write_promote_adjustment" work in dm-cache. From the description in th=
e http://lxr.free-electrons.com/source/Documentation/device-mapper/cache-po=
licies.txt#L45 its not clear as to how promotion works.

For example:

 61<http://lxr.free-electrons.com/source/Documentation/device-mapper/cache-=
policies.txt#L61> Internally the mq policy maintains a promotion threshold =
variable.  If
 62<http://lxr.free-electrons.com/source/Documentation/device-mapper/cache-=
policies.txt#L62> the hit count of a block not in the cache goes above this=
 threshold it
 63<http://lxr.free-electrons.com/source/Documentation/device-mapper/cache-=
policies.txt#L63> gets promoted to the cache.

Here, the hit count is mentioned for the block not in cache.  Which means t=
hat, blocks are not moved to cache unless there are susequent requests for =
the same block until the read_promote_thresold is reached.  Meaning all tho=
se time the data was being read from slower disk.  Why isn't the block move=
d to cache on first miss ?

What does write_promote_adjustment mean here ? Meaning after this count rea=
ches some threshold ( not sure how this count is incremented ?) then the di=
rty data from cache is written to slow disk ?

Can anyone please the scenarios under which each of the counters used ?

Thanks,

/Girish BK












45<http://lxr.free-electrons.com/source/Documentation/device-mapper/cache-p=
olicies.txt#L45>         'read_promote_adjustment <value>'
 46<http://lxr.free-electrons.com/source/Documentation/device-mapper/cache-=
policies.txt#L46>         'write_promote_adjustment <value>'
 47<http://lxr.free-electrons.com/source/Documentation/device-mapper/cache-=
policies.txt#L47>         'discard_promote_adjustment <value>'

--_000_D0FEB1C511407GirishKumarBKnetappcom_
Content-Type: text/html; charset="iso-8859-1"
Content-ID: <B938DA30AAA86F4C988466D4BFED2297@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
</head>
<body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-lin=
e-break: after-white-space;">
<pre style=3D"color: rgb(120, 120, 120); font-family: Monaco, 'Courier New'=
, Courier, monospace; font-size: 0.95em; padding: 1em; overflow: auto; font=
-weight: bold; background-color: rgb(255, 255, 255);"><div>HI,</div></pre>
<pre style=3D"color: rgb(120, 120, 120); font-family: Monaco, 'Courier New'=
, Courier, monospace; font-size: 0.95em; padding: 1em; overflow: auto; font=
-weight: bold; background-color: rgb(255, 255, 255);">I&#8217;m new and try=
ing to understand how exactly the &#8220;read_promote_adjustment&#8221; and=
 &#8220;write_promote_adjustment&#8221; work in dm-cache. From the descript=
ion in the <a href=3D"http://lxr.free-electrons.com/source/Documentation/de=
vice-mapper/cache-policies.txt#L45" style=3D"font-family: Calibri, sans-ser=
if; font-size: 14px;">http://lxr.free-electrons.com/source/Documentation/de=
vice-mapper/cache-policies.txt#L45</a> its not clear as to how promotion wo=
rks.</pre>
<pre style=3D"color: rgb(120, 120, 120); font-family: Monaco, 'Courier New'=
, Courier, monospace; font-size: 0.95em; padding: 1em; overflow: auto; font=
-weight: bold;">For example: </pre>
<pre style=3D"padding: 1em; overflow: auto;"><pre style=3D"color: rgb(120, =
120, 120); font-family: Monaco, 'Courier New', Courier, monospace; font-siz=
e: 0.95em; font-weight: bold; padding: 1em; overflow: auto; background-colo=
r: rgb(255, 255, 255);"> <a name=3D"L61" href=3D"http://lxr.free-electrons.=
com/source/Documentation/device-mapper/cache-policies.txt#L61" style=3D"tex=
t-decoration: none; border-bottom-width: 1px; border-bottom-style: dotted; =
border-bottom-color: rgb(153, 153, 153); color: black;">61</a> Internally t=
he mq policy maintains a promotion threshold variable.  If
 <a name=3D"L62" href=3D"http://lxr.free-electrons.com/source/Documentation=
/device-mapper/cache-policies.txt#L62" style=3D"text-decoration: none; bord=
er-bottom-width: 1px; border-bottom-style: dotted; border-bottom-color: rgb=
(153, 153, 153); color: black;">62</a> the hit count of a block not in the =
cache goes above this threshold it
 <a name=3D"L63" href=3D"http://lxr.free-electrons.com/source/Documentation=
/device-mapper/cache-policies.txt#L63" style=3D"text-decoration: none; bord=
er-bottom-width: 1px; border-bottom-style: dotted; border-bottom-color: rgb=
(153, 153, 153); color: black;">63</a> gets promoted to the cache. </pre><p=
re style=3D"color: rgb(120, 120, 120); font-family: Monaco, 'Courier New', =
Courier, monospace; font-size: 0.95em; font-weight: bold; padding: 1em; ove=
rflow: auto; background-color: rgb(255, 255, 255);">Here, the hit count is =
mentioned for the block not in cache.  Which means that, blocks are not mov=
ed to cache unless there are susequent requests for the same block until th=
e read_promote_thresold is reached.  Meaning all those time the data was be=
ing read from slower disk.  Why isn&#8217;t the block moved to cache on fir=
st miss ?</pre><pre style=3D"color: rgb(120, 120, 120); font-family: Monaco=
, 'Courier New', Courier, monospace; font-size: 0.95em; font-weight: bold; =
padding: 1em; overflow: auto; background-color: rgb(255, 255, 255);">What d=
oes write_promote_adjustment mean here ? Meaning after this count reaches s=
ome threshold ( not sure how this count is incremented ?) then the dirty da=
ta from cache is written to slow disk ?</pre><pre style=3D"padding: 1em; ov=
erflow: auto;"><span style=3D"background-color: rgb(255, 254, 254);"><font =
color=3D"#787878" face=3D"Monaco,Courier New,Courier,monospace"><span style=
=3D"font-size: 0.95em;"><b>Can anyone please the scenarios under which each=
 of the counters used ? </b></span></font></span></pre><pre style=3D"color:=
 rgb(120, 120, 120); font-family: Monaco, 'Courier New', Courier, monospace=
; font-size: 0.95em; font-weight: bold; padding: 1em; overflow: auto;"><spa=
n style=3D"background-color: rgb(255, 254, 254);">Thanks,</span></pre><pre =
style=3D"color: rgb(120, 120, 120); font-family: Monaco, 'Courier New', Cou=
rier, monospace; font-size: 0.95em; font-weight: bold; padding: 1em; overfl=
ow: auto;"><span style=3D"background-color: rgb(254, 253, 253);">/Girish BK=
</span></pre><pre style=3D"color: rgb(120, 120, 120); font-family: Monaco, =
'Courier New', Courier, monospace; font-size: 0.95em; font-weight: bold; pa=
dding: 1em; overflow: auto;"><span style=3D"background-color: rgb(255, 254,=
 254);"><br></span></pre><pre style=3D"color: rgb(120, 120, 120); font-fami=
ly: Monaco, 'Courier New', Courier, monospace; font-size: 0.95em; font-weig=
ht: bold; padding: 1em; overflow: auto; background-color: rgb(255, 255, 255=
);"><br></pre><pre style=3D"color: rgb(120, 120, 120); font-family: Monaco,=
 'Courier New', Courier, monospace; font-size: 0.95em; font-weight: bold; p=
adding: 1em; overflow: auto; background-color: rgb(255, 255, 255);"><br></p=
re><pre style=3D"color: rgb(120, 120, 120); font-family: Monaco, 'Courier N=
ew', Courier, monospace; font-size: 0.95em; font-weight: bold; padding: 1em=
; overflow: auto; background-color: rgb(255, 255, 255);"> </pre><pre style=
=3D"color: rgb(120, 120, 120); font-family: Monaco, 'Courier New', Courier,=
 monospace; font-size: 0.95em; font-weight: bold; padding: 1em; overflow: a=
uto; background-color: rgb(255, 255, 255);"><br></pre></pre>
<pre style=3D"color: rgb(120, 120, 120); font-family: Monaco, 'Courier New'=
, Courier, monospace; font-size: 0.95em; padding: 1em; overflow: auto; font=
-weight: bold; background-color: rgb(255, 255, 255);"><br></pre>
<pre style=3D"color: rgb(120, 120, 120); font-family: Monaco, 'Courier New'=
, Courier, monospace; font-size: 0.95em; padding: 1em; overflow: auto; font=
-weight: bold; background-color: rgb(255, 255, 255);"><br></pre>
<pre style=3D"color: rgb(120, 120, 120); font-family: Monaco, 'Courier New'=
, Courier, monospace; font-size: 0.95em; padding: 1em; overflow: auto; font=
-weight: bold; background-color: rgb(255, 255, 255);">&nbsp;</pre>
<pre style=3D"color: rgb(120, 120, 120); font-family: Monaco, 'Courier New'=
, Courier, monospace; font-size: 0.95em; padding: 1em; overflow: auto; font=
-weight: bold; background-color: rgb(255, 255, 255);"><br></pre>
<pre style=3D"color: rgb(120, 120, 120); font-family: Monaco, 'Courier New'=
, Courier, monospace; font-size: 0.95em; padding: 1em; overflow: auto; font=
-weight: bold; background-color: rgb(255, 255, 255);"><a name=3D"L45" href=
=3D"http://lxr.free-electrons.com/source/Documentation/device-mapper/cache-=
policies.txt#L45" style=3D"text-decoration: none; border-bottom-width: 1px;=
 border-bottom-style: dotted; border-bottom-color: rgb(153, 153, 153); colo=
r: black;">45</a>         'read_promote_adjustment &lt;value&gt;'
 <a name=3D"L46" href=3D"http://lxr.free-electrons.com/source/Documentation=
/device-mapper/cache-policies.txt#L46" style=3D"text-decoration: none; bord=
er-bottom-width: 1px; border-bottom-style: dotted; border-bottom-color: rgb=
(153, 153, 153); color: black;">46</a>         'write_promote_adjustment &l=
t;value&gt;'
 <a name=3D"L47" href=3D"http://lxr.free-electrons.com/source/Documentation=
/device-mapper/cache-policies.txt#L47" style=3D"text-decoration: none; bord=
er-bottom-width: 1px; border-bottom-style: dotted; border-bottom-color: rgb=
(153, 153, 153); color: black;">47</a>         'discard_promote_adjustment =
&lt;value&gt;'</pre>
</body>
</html>

--_000_D0FEB1C511407GirishKumarBKnetappcom_--


--===============8898368880165525843==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8898368880165525843==--
