From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Stopped disk causes LVM to go crazy
Date: Wed, 11 Feb 2009 10:39:20 +0000
Message-ID: <4992AAD8.2060001@redhat.com>
References: <638406528.2295221234308660984.JavaMail.root@jaguar7.sfu.ca>
Reply-To: bmr@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <638406528.2295221234308660984.JavaMail.root@jaguar7.sfu.ca>
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

Alireza Nematollahi wrote:
> hi guys,
> 
> I have a system with two SATA disks and I have LVM on the disks. I
> use sdparm (sdparm -C stop /dev/sdb) to spin-down one of them. It
> works fine and I can hear the disk spinning down and all...But when
> I run any LVM command, say lvscan or whatever, I get lots of error
> messages:

What did you expect? :)

If the volume group is active when you remove/spin down the disks LVM 
has no way of knowing that you wanted to do that. To the software, it 
just looks like a drive has failed or gone away while it was in use.

<snip>

> /dev/sdb2: read failed after 0 of 4096 at 2993881088: Input/output
> error /dev/sdb2: read failed after 0 of 4096 at 0: Input/output
> error /dev/sdb4: read failed after 0 of 1024 at 144082075648:
> Input/output error /dev/sdb4: read failed after 0 of 2048 at 0:

> Input/output error Even when I physically remove the disk it still
> happens. Is there any way I can stop LVM from querying both disks
> or at least to stop displaying the error messages?

Tell LVM to stop using the disk first. See the man page for vgchange 
for full details but you want to run:

vgchange -an <volume group>

To deactivate the volume group *before* you start removing devices 
that it is using.

Regards,
Bryn.
