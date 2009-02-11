From: Alireza Nematollahi <alirezan@sfu.ca>
Subject: Re: Stopped disk causes LVM to go crazy
Date: Wed, 11 Feb 2009 12:04:46 -0800 (PST)
Message-ID: <746454649.2869521234382686755.JavaMail.root@jaguar7.sfu.ca>
References: <288159352.2860111234381750007.JavaMail.root@jaguar7.sfu.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2037699418=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <288159352.2860111234381750007.JavaMail.root@jaguar7.sfu.ca>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bmr@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2037699418==
Content-Type: multipart/alternative;
	boundary="----=_Part_104067_370842149.1234382686754"

------=_Part_104067_370842149.1234382686754
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello, 

I think I did it in order: 
1- nothing is mounted 
> mount 
rootfs on / type rootfs (rw) 
proc on /proc type proc (rw) 
sysfs on /sys type sysfs (rw) 
devpts on /dev/pts type devpts (rw) 
tmpfs on /dev/shm type tmpfs (rw) 
rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw) 
nfsd on /proc/fs/nfsd type nfsd (rw) 

2- deactivating VG/LVs 
> vgchange -an disk2 

3- stop the storage 
> sdparm -C stop /dev/sdb 

4- checking for LVs on other disk 
> lvscan 


Isn't it the right order? I'm new to LVM and that's why I may be confused... 

I don't like doing "echo 1 > /sys/block/sdb/device/delete" since I can't get the device restarted when I do sdparm -C start /dev/sdb... 

Thanks 



----- Original Message ----- 
From: "Bryn M. Reeves" <bmr@redhat.com> 
To: "Alireza Nematollahi" <alirezan@sfu.ca> 
Cc: "device-mapper development" <dm-devel@redhat.com> 
Sent: Wednesday, February 11, 2009 10:50:45 AM GMT -08:00 US/Canada Pacific 
Subject: Re: [dm-devel] Stopped disk causes LVM to go crazy 

Alireza Nematollahi wrote: 
> hi. Thanks for your reply. Well, I had tried that before, but no luck. I tried it again, and still no luck: 

You have to do it *BEFORE* you disable/remove the storage. Doing it 
afterwards will just throw all the errors you are seeing since the LVM 
tools can no longer access the device. 

You have to do things in the correct order; first unmount any file 
systems, then de-activate LVs/VGs, then stop or remove the storage 
hardware. 

If you do this in the wrong order you'll end up with the problems 
you're seeing. 

For now, you can clean up /dev/sdb by deleting it via sysfs: 

echo 1 > /sys/block/sdb/device/delete 

Which will stop other commands that scan the disks from tripping over 
the dead device. You can also manually delete any remaining device 
mapper devices that reference the removed disk (see similar thread 
yesterday). 

Regards, 
Bryn. 


------=_Part_104067_370842149.1234382686754
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><style type=3D'text/css'>p { margin: 0; }</style></head><body><=
div style=3D'font-family: Times New Roman; font-size: 12pt; color: #000000'=
>Hello,<br><br>I think I did it in order:<br>1- nothing is mounted<br>&gt; =
mount<br>rootfs on / type rootfs (rw)<br>proc on /proc type proc (rw)<br>sy=
sfs on /sys type sysfs (rw)<br>devpts on /dev/pts type devpts (rw)<br>tmpfs=
 on /dev/shm type tmpfs (rw)<br>rpc_pipefs on /var/lib/nfs/rpc_pipefs type =
rpc_pipefs (rw)<br>nfsd on /proc/fs/nfsd type nfsd (rw)<br><br>2- deactivat=
ing VG/LVs<br>&gt; vgchange -an disk2<br><br>3- stop the storage<br>&gt; sd=
parm -C stop /dev/sdb<br><br>4- checking for LVs on other disk<br>&gt; lvsc=
an<br><br><br>Isn't it the right order? I'm new to LVM and that's why I may=
 be confused...<br><br>I don't like doing "echo 1 &gt; /sys/block/sdb/devic=
e/delete" since I can't get the device restarted when I do sdparm -C start =
/dev/sdb...<br><br>Thanks<br><br><br><br>----- Original Message -----<br>Fr=
om: "Bryn M. Reeves" &lt;bmr@redhat.com&gt;<br>To: "Alireza Nematollahi" &l=
t;alirezan@sfu.ca&gt;<br>Cc: "device-mapper development" &lt;dm-devel@redha=
t.com&gt;<br>Sent: Wednesday, February 11, 2009 10:50:45 AM GMT -08:00 US/C=
anada Pacific<br>Subject: Re: [dm-devel] Stopped disk causes LVM to go craz=
y<br><br>Alireza Nematollahi wrote:<br>&gt; hi. Thanks for your reply. Well=
, I had tried that before, but no luck. I tried it again, and still no luck=
: <br><br>You have to do it *BEFORE* you disable/remove the storage. Doing =
it <br>afterwards will just throw all the errors you are seeing since the L=
VM <br>tools can no longer access the device.<br><br>You have to do things =
in the correct order; first unmount any file <br>systems, then de-activate =
LVs/VGs, then stop or remove the storage <br>hardware.<br><br>If you do thi=
s in the wrong order you'll end up with the problems <br>you're seeing.<br>=
<br>For now, you can clean up /dev/sdb by deleting it via sysfs:<br><br>ech=
o 1 &gt; /sys/block/sdb/device/delete<br><br>Which will stop other commands=
 that scan the disks from tripping over <br>the dead device. You can also m=
anually delete any remaining device <br>mapper devices that reference the r=
emoved disk (see similar thread <br>yesterday).<br><br>Regards,<br>Bryn.<br=
><br></div></body></html>
------=_Part_104067_370842149.1234382686754--


--===============2037699418==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2037699418==--
