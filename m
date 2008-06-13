From: "Gianluca Cecchi" <gianluca.cecchi@gmail.com>
Subject: Re: two paths remain failed on DS6800 after code upgrade
Date: Fri, 13 Jun 2008 18:22:40 +0200
Message-ID: <561c252c0806130922m6612720dq77b31bc3bdb8c703@mail.gmail.com>
References: <561c252c0806130314x2924a027n1fbd74c29178e5c8@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1056167681=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <561c252c0806130314x2924a027n1fbd74c29178e5c8@mail.gmail.com>
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

--===============1056167681==
Content-Type: multipart/alternative;
	boundary="----=_Part_36143_10353373.1213374160666"

------=_Part_36143_10353373.1213374160666
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

It seems I solved the problem removing the disks and then adding them, with
the commands:

for sdc
remove:*
echo "1" > /sys/class/scsi_host/host0/device/target0:0:1/0:0:1:0/delete*
**
To reregister the disk with the kernel used the command:***
echo "0 1 0" > /sys/class/scsi_host/host0/scan*

for sdd
remove:*
echo "1" > /sys/class/scsi_host/host0/device/target0:0:1/0:0:1:1/delete*
**
To reregister the disk with the kernel used the command:***
echo "0 1 1" > /sys/class/scsi_host/host0/scan*

In general
deregister*
echo "1" > /sys/class/scsi_host/hostH/device/targetH:B:T/H:B:T:L/delete* To
reregister the disk with the kernel:*
echo "B T L" > /sys/class/scsi_host/hostH/scan

* Device name persistence not granted. In my case
sdc --> sdi
sdd --> sdd

All operations were transparent and with no downtime.
I also removed other disks and then readded (also during I/O using them) and
I have to say that multipath seems very robust.
Thanks to the developers.
HIH for others.
Still I don't understand why  it was before unable to reinstate the path.
Gianluca
**

------=_Part_36143_10353373.1213374160666
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

It seems I solved the problem removing the disks and then adding them, with the commands:<br><br>for sdc<br>remove:<strong><span class="cmdname"><br>echo "1" &gt; /sys/class/scsi_host/host0/device/target</span><em>0:0:1/0:0:1:0</em><span class="cmdname">/delete</span></strong>
<br><strong><span class="cmdname"></span><span class="cmdname"></span></strong>

<div class="p"><br>To reregister the disk with the kernel used the command:<strong><span class="cmdname"></span></strong><strong><span class="cmdname"><br>echo "</span><em>0 1 0</em><span class="cmdname">" &gt; /sys/class/scsi_host/host0/scan</span></strong>
</div><br>for sdd<br>
remove:<strong><span class="cmdname"><br>
echo "1" &gt; /sys/class/scsi_host/host0/device/target</span><em>0:0:1/0:0:1:1</em><span class="cmdname">/delete</span></strong>
<br>
<strong><span class="cmdname"></span><span class="cmdname"></span></strong>

<div class="p"><br>
To reregister the disk with the kernel used the command:<strong><span class="cmdname"></span></strong><strong><span class="cmdname"><br>
echo "</span><em>0 1 1</em><span class="cmdname">" &gt; /sys/class/scsi_host/host0/scan</span></strong>
</div>
<br>In general <br>deregister<strong><span class="cmdname"><br>echo "1" &gt; /sys/class/scsi_host/hostH/device/target</span><em>H:B:T/H:B:T:L</em><span class="cmdname">/delete</span></strong>

<div class="p">To reregister the disk with the kernel:<strong><span class="cmdname"><br>echo "</span><em>B T L</em><span class="cmdname">" &gt; /sys/class/scsi_host/hostH/scan<br><br></span></strong> Device name persistence not granted. In my case <br>
sdc --&gt; sdi <br>sdd --&gt; sdd<br><br>All operations were transparent and with no downtime.<br>I also removed other disks and then readded (also during I/O using them) and I have to say that multipath seems very robust.<br>
Thanks to the developers.<br>HIH for others.<br>Still I don&#39;t understand why&nbsp; it was before unable to reinstate the path.<br>Gianluca&nbsp;  <br>
</div><strong><span class="cmdname"></span></strong>

------=_Part_36143_10353373.1213374160666--


--===============1056167681==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1056167681==--
