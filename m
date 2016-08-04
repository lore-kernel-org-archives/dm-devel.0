From: peng.liang5@zte.com.cn
Subject: =?gb2312?b?tPC4tDogUmU6ICBbUEFUQ0hdIG11bHRpcGF0aGQ6?=
 =?gb2312?b?IGZpeCBpc3N1ZSBpbiAnbWFwICRtYXAgZ2V0cHJzdGF0dXMnIHJlcGx5?=
Date: Thu, 4 Aug 2016 09:39:24 +0800
Message-ID: <OF675940B4.B973A293-ON48258005.0008BDFA-48258005.000913D7@zte.com.cn>
References: <1470208155-6544-1-git-send-email-peng.liang5@zte.com.cn>
	<fcc1a865-f918-17a8-c424-6cff341129e1@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0694511575349371150=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <fcc1a865-f918-17a8-c424-6cff341129e1@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

This is a multipart message in MIME format.
--===============0694511575349371150==
Content-Type: multipart/alternative;
	boundary="=_alternative 000913D448258005_="

This is a multipart message in MIME format.
--=_alternative 000913D448258005_=
Content-Type: text/plain; charset="US-ASCII"

Hi Bart,

Thanks again.
I got it.

-       *len = 3;
-       asprintf(reply, "%d\n", mpp->prflag);
+       *len = asprintf(reply, "%d\n", mpp->prflag);
+       if (*len < 0)
+               return 1;

On 08/03/2016 12:09 AM, peng.liang5@zte.com.cn wrote:
> +              *len = 3;
> +              asprintf(reply, "%d\n", mpp->prflag);

Hello Peng,

Please use the return value of asprintf() to compute *len instead of 
assigning a hard-coded constant to *len.

Thanks,

Bart.


--=_alternative 000913D448258005_=
Content-Type: text/html; charset="US-ASCII"

<font size=2>Hi Bart,</font>
<br>
<br><font size=2>Thanks again.</font>
<br><font size=2>I got it.</font>
<br>
<br><font size=1 color=#c20000 face="Lucida Console">- &nbsp; &nbsp; &nbsp;
*len = 3;</font>
<br><font size=1 color=#c20000 face="Lucida Console">- &nbsp; &nbsp; &nbsp;
asprintf(reply, &quot;%d\n&quot;, mpp-&gt;prflag);</font>
<br><font size=1 color=#00c200 face="Lucida Console">+</font><font size=1 face="Lucida Console">
&nbsp; &nbsp; &nbsp; </font><font size=1 color=#00c200 face="Lucida Console">*len
= asprintf(reply, &quot;%d\n&quot;, mpp-&gt;prflag);</font>
<br><font size=1 color=#00c200 face="Lucida Console">+</font><font size=1 face="Lucida Console">
&nbsp; &nbsp; &nbsp; </font><font size=1 color=#00c200 face="Lucida Console">if
(*len &lt; 0)</font>
<br><font size=1 color=#00c200 face="Lucida Console">+</font><font size=1 face="Lucida Console">
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </font><font size=1 color=#00c200 face="Lucida Console">return
1;</font>
<br>
<br><font size=2>On 08/03/2016 12:09 AM, peng.liang5@zte.com.cn wrote:<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
*len = 3;<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
asprintf(reply, &quot;%d\n&quot;, mpp-&gt;prflag);<br>
<br>
Hello Peng,<br>
<br>
Please use the return value of asprintf() to compute *len instead of <br>
assigning a hard-coded constant to *len.<br>
<br>
Thanks,<br>
<br>
Bart.</font><font size=2 face="sans-serif"><br>
</font>
<br>
--=_alternative 000913D448258005_=--


--===============0694511575349371150==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0694511575349371150==--
