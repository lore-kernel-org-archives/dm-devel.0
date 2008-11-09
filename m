From: "Reng Zeng" <alan@fiucssa.org>
Subject: Question about 'dmsetup remove' and dtr of target_type
Date: Sun, 9 Nov 2008 00:27:24 -0500
Message-ID: <60468f1e0811082127h3dac5b60h829d871fb38dd63a@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1080997157=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

--===============1080997157==
Content-Type: multipart/alternative;
	boundary="----=_Part_55339_23420779.1226208444450"

------=_Part_55339_23420779.1226208444450
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I suppose "dmsetup remove' will invoke dtr of target_type to remove the
device.

However, I use "dmsetup remove" hundreds times, as the debug info, but it
never enter the dtr function I defined.

Anybody have idea on this? Or how to dig into that to discover the reason?
Thanks.

To be of more details, I have cache_target as below.
static struct target_type cache_target = {
...
        .dtr    = cache_dtr,
...
};
I add debug info into cache_dtr, it show it never enter into cache_dtr when
I "dmsetup remove".

Thanks again,
Alan

------=_Part_55339_23420779.1226208444450
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,<br><br>I suppose &quot;dmsetup remove&#39; will invoke dtr of target_type to remove the device.<br><br>However, I use &quot;dmsetup remove&quot; hundreds times, as the debug info, but it never enter the dtr function I defined.<br>
<br>Anybody have idea on this? Or how to dig into that to discover the reason? Thanks.<br><br>To be of more details, I have cache_target as below.<br>static struct target_type cache_target = {<br>...<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .dtr&nbsp;&nbsp;&nbsp; = cache_dtr,<br>
...<br>};<br>I add debug info into cache_dtr, it show it never enter into cache_dtr when I &quot;dmsetup remove&quot;.<br><br>Thanks again,<br>Alan<br><br>

------=_Part_55339_23420779.1226208444450--


--===============1080997157==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1080997157==--
