From: Klaus <ddm01@online.de>
Subject: Re: device-errors and multipath device access issue
Date: Fri, 14 Dec 2007 09:44:56 +0000 (UTC)
Message-ID: <loom.20071214T085107-682@post.gmane.org>
References: <2072641508@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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

 <devzero <at> web.de> writes:

> 
> Hello !
> 
> we are using multipath on sles9 and access those devices via
/dev/mapper/devicename
> 
> on boot, we get lot`s of error messages like
> 
> > Aug 28 10:30:16 rac02 kernel: Device sdf not ready.
> > Aug 28 10:30:16 rac02 kernel: end_request: I/O error, dev sdf, sector 513680
> > Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block
64210
> > Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block
64211
> > Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block
64212
> 
> for each alternative path to a lun.
> 
> we also get those messages when the system is up and running because some
proprietary monitoring software
> is checking for device availability in regular intervals and there seems no
way to tell that software to
> skip certain devices - so we get spammed with this messages like this in
/var/log/messages and are not able
> to see the real errors anymore.
> 
> is there a way to hide those "classic" scsi devices from userspace?
> i`m not sure if "blacklist" in multipath.conf is what i need here (?) or if i
safely could delete those
> device-nodes - i`m not very deep into multipathing for now.
> 


Hello Roland,

I got the same problem using Sles9SP3 with a newer Kernel on a FSC TX300-Server,
this one is connected to an san using a volume-Manager, Multipathsoftware and 
so on.
After reading your hint with the monitoring software I stopped the FSC
serveragent-daemons and the messages with the Buffer I/O error are gone.
In combination with lvm2-organized disks on a second TX300 I got something like
that you described second - I have to test it again (specially the boot-process,
maybe this can solved for me using a other naming scheme for the san-luns).

So, I don't know if it is helpful for you:
you're right with the monitoring-software I think (I will discuss this for me
with the FSC-guys) but: are there all SAN-Luns in the messages file (it is in my
case)?
I disconnected step by step one of the both FC-Paths, but on my TX300 the errors
still continued, and in that situation there where no second path to the san.
So, I'm not sure if that can be the reason in your situation.

If I got some new Information I will let you now, if you solved your problem:
please let me know.

Regards,

Klaus
