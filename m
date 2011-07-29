From: benoit.welterlen@bull.net
Subject: dm_calculate_queue_limits and default values
Date: Fri, 29 Jul 2011 16:20:43 +0200
Message-ID: <OF4A6F5144.D7A8CB4B-ONC12578DC.004D193F-C12578DC.004EF0B6@bull.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3305901260189884148=="
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Message en plusieurs parties au format MIME
--===============3305901260189884148==
Content-Type: multipart/alternative;
	boundary="=_alternative 004ECC41C12578DC_="

Message en plusieurs parties au format MIME
--=_alternative 004ECC41C12578DC_=
Content-Type: text/plain; charset="US-ASCII"

Hi,

I'm a newbie on dm and all this stuff, but I'm wondering why 
"max_segments" of all dm's queue is always 128 (cat 
/sys/block/dm-*/queue/max_segments), even if all devices used in the dm 
have another value (cat 
/sys/devices/pci0000:00/0000:00:1f.2/host0/scsi_host/host0/sg_tablesize : 
168).

I looked over the source code of dm_calculate_queue_limits, and saw that 
limits of all devices are combined with default limits 
(blk_set_default_limits(limits);). But, the value used is always the 
min_not_zero, so always 128, the default value.

As I understand, even if all devices have big limits, default values will 
be used.
Is my understanding wrong or there is a bug ?

Thank you to explain me the dm operation.

Regards

Benoit Welterlen
--=_alternative 004ECC41C12578DC_=
Content-Type: text/html; charset="US-ASCII"

<font size=2 face="sans-serif">Hi,</font>
<br>
<br><font size=2 face="sans-serif">I'm a newbie on dm and all this stuff,
but I'm wondering why &quot;max_segments&quot; of all dm's queue is always
128 (cat /sys/block/dm-*/queue/max_segments), even if all devices used
in the dm have another value (cat /sys/devices/pci0000:00/0000:00:1f.2/host0/scsi_host/host0/sg_tablesize
: 168).</font>
<br>
<br><font size=2 face="sans-serif">I looked over the source code of dm_calculate_queue_limits,
and saw that limits of all devices are combined with default limits (blk_set_default_limits(limits);).
But, the value used is always the min_not_zero, so always 128, the default
value.</font>
<br>
<br><font size=2 face="sans-serif">As I understand, even if all devices
have big limits, default values will be used.</font>
<br><font size=2 face="sans-serif">Is my understanding wrong or there is
a bug ?</font>
<br>
<br><font size=2 face="sans-serif">Thank you to explain me the dm operation.</font>
<br>
<br><font size=2 face="sans-serif">Regards</font>
<br>
<br><font size=2 face="sans-serif">Benoit Welterlen</font>
--=_alternative 004ECC41C12578DC_=--


--===============3305901260189884148==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3305901260189884148==--
