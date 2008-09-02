From: "Larry Dickson" <ldickson@cuttedge.com>
Subject: Could not create kcopyd client
Date: Tue, 2 Sep 2008 15:27:25 -0700
Message-ID: <1c748a490809021527w48d6ed27wc99490a2a10923ef@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1161139414=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1161139414==
Content-Type: multipart/alternative;
	boundary="----=_Part_10165_24948299.1220394445452"

------=_Part_10165_24948299.1220394445452
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

This is a digest of a problem in LVM snapshot which seems to have its roots
in dm. I placed it on the LVM list already; here is a copy for dm-devel,
just in case anybody has seen this a thousand times before... Our customer
is not happy with a 15-snapshot limit.

 With a 768 GB logical volume in a 2235 GB volume group, and 4 GB of memory,
I try to set up lots of snapshots (of 45 or 50 GB each) and can't get past
15. Sometimes I'll succeed in generating more than 15 COWs in /dev/mapper,
but lvdisplay never shows more than 15 snapshots in the "LV snapshot status
source of" listing under the parent volume. I searched and found 15
snapshots mentioned in a couple places like
wiki.samba.org/index.php/Shadow_Copies_with_Snapshots - but nothing really
authoritative.

Is there really such a limit? Or is it a memory requirement - I seem to
remember so many MB memory per GB of storage, but can't find that either.
Versions are (variants of) lvm2-2.02.38, device-mapper-1.02.26,
kernel-smp-2.6.20 (64 bit).

 More details: I found a /var/log/messages note that corresponded exactly to
the following bug:
==========================

http://www.linux-archive.org/debian-kernel/7067-bug-453254-linux-2-6-18-5-xen-686-unable-create-more-than-32-lvm-snapshots-total.html

11-28-2007, 01:34 AM
Peter de Zwart

Default Bug#453254: linux-2.6.18-5-xen-686: Unable to create more than 32
LVM snapshots in total
Package: linux-2.6.18-5-xen-686
Severity: normal


When attempting to create more than 32 LVM snapshots, the following error
message is sent from the Kernel:

device-mapper: table: 254:142: snapshot: Could not create kcopyd client
device-mapper: ioctl: error adding target to table

==========================
(End of reference; no follow-up found.)

Thanks in advance,

Larry Dickson

Cutting Edge Networked Storage

------=_Part_10165_24948299.1220394445452
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div>Hi,</div>
<div>&nbsp;</div>
<div>This is a digest of a problem in LVM snapshot which seems to have its roots in dm. I placed it on the LVM list already; here is a copy for dm-devel, just in case anybody has seen this a thousand times before... Our customer is not happy with a 15-snapshot limit.</div>

<div>&nbsp;</div>
<div>
<div>With a 768 GB logical volume in a 2235 GB volume group, and 4 GB of memory, I try to set up lots of snapshots (of 45 or 50 GB each)&nbsp;and can&#39;t get past 15. Sometimes I&#39;ll succeed in generating more than 15 COWs in /dev/mapper, but lvdisplay never shows more than 15 snapshots in the &quot;LV snapshot status source of&quot; listing under the parent volume. I searched and found 15 snapshots mentioned in a couple places like <span><a onclick="return top.js.OpenExtLink(window,event,this)" href="http://wiki.samba.org/index.php/Shadow_Copies_with_Snapshots" target="_blank">wiki.samba.org/index.php/Shadow_Copies_with_Snapshots</a> - but nothing really authoritative.</span></div>

<div><span></span>&nbsp;</div>
<div><span>Is there really such a limit? Or is it a memory requirement - I seem to remember so many MB memory per GB of storage, but can&#39;t find that either. Versions are (variants of)&nbsp;lvm2-2.02.38, device-mapper-1.02.26, kernel-smp-2.6.20 (64 bit).</span></div>

<div><span></span>&nbsp;</div>
<div><span>
<div>More details: I found a /var/log/messages note that corresponded exactly to the following bug:</div>
<div>==========================</div>
<div>
<p><a onclick="return top.js.OpenExtLink(window,event,this)" href="http://www.linux-archive.org/debian-kernel/7067-bug-453254-linux-2-6-18-5-xen-686-unable-create-more-than-32-lvm-snapshots-total.html" target="_blank">http://www.linux-archive.org/debian-kernel/7067-bug-453254-linux-2-6-18-5-xen-686-unable-create-more-than-32-lvm-snapshots-total.html</a></p>

<p>11-28-2007, 01:34 AM<br>Peter de Zwart<br>&nbsp;&nbsp; &nbsp;<br>Default Bug#453254: linux-2.6.18-5-xen-686: Unable to create more than 32 LVM snapshots in total<br>Package: linux-2.6.18-5-xen-686<br>Severity: normal</p>
<p><br>When attempting to create more than 32 LVM snapshots, the following error message is sent from the Kernel:</p>
<p>device-mapper: table: 254:142: snapshot: Could not create kcopyd client<br>device-mapper: ioctl: error adding target to table</p>
<p>==========================<br>(End of reference; no follow-up found.)</p>
<p>Thanks in advance,</p>
<p>Larry Dickson</p>
<p>Cutting Edge Networked Storage</p></div></span></div></div>

------=_Part_10165_24948299.1220394445452--


--===============1161139414==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1161139414==--
