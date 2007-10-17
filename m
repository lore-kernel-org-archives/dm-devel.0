From: DJ <dancelicious@gmail.com>
Subject: Help with writing dm hardware handler
Date: Wed, 17 Oct 2007 12:55:26 -0700
Message-ID: <6b70dfe80710171255h89850f5u73017e6c8505a5af@mail.gmail.com>
Reply-To: dancelicious@gmail.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0052192246=="
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

--===============0052192246==
Content-Type: multipart/alternative;
	boundary="----=_Part_45919_25685615.1192650927412"

------=_Part_45919_25685615.1192650927412
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All,

I am writing a hardware handler for dm multipath support, but I am getting
the following error everytime.

"kernel: device-mapper: table: 253:0: multipath: unknown hardware handler
type"

My module name is dm-smaple.ko (which shows as dm_smaple in lsmod), code
name is dm-sample.c and the in code the module name I am specifying is
"sample".
I have also modified the multipath.conf to have the following entry:

hardware_handler "1 sample"

Could someone please let me know what am I doing wrong here?
If needed I can paste the code here.

Thanks in advance.
DJ.

------=_Part_45919_25685615.1192650927412
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div>Hi All,<br><br>I am writing a hardware handler for dm multipath support, but I am getting the following error everytime.<br><br>&quot;kernel: device-mapper: table: 253:0: multipath: unknown hardware handler type&quot;
<br><br>My module name is dm-smaple.ko (which shows as dm_smaple in lsmod), code name is dm-sample.c and the in code the module name I am specifying is &quot;sample&quot;. <br>I have also modified the multipath.conf to have the following entry:
<br><br>hardware_handler &quot;1 sample&quot; <br><br>Could someone please let me know what am I doing wrong here?<br>If needed I can paste the code here.<br><br>Thanks in advance.<br>DJ.</div>

------=_Part_45919_25685615.1192650927412--


--===============0052192246==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0052192246==--
