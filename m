From: Steve Feehan <sfeehan@sbb.uvm.edu>
Subject: Re: multipath and StorageWorks HSG80
Date: Fri, 21 Apr 2006 09:40:55 -0400
Message-ID: <20060421134055.GA16090@ingress.sbb.uvm.edu>
References: <20060420194321.GE29759@ingress.sbb.uvm.edu>
	<4447EA16.9070708@free.fr>
	<20060420204449.GA32417@ingress.sbb.uvm.edu>
	<1145567444.3118.60.camel@gator.sc.steeleye.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1145567444.3118.60.camel@gator.sc.steeleye.com>
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

On Thu, Apr 20, 2006 at 05:10:44PM -0400, Eddie Williams wrote:
> On Thu, 2006-04-20 at 16:44 -0400, Steve Feehan wrote:
> > On Thu, Apr 20, 2006 at 10:07:50PM +0200, Christophe Varoqui wrote:
> 
> > And that makes the errors go away for the LVM case. But I still 
> > get the kernel errors during bootup.
> > 
> 
> Did you rebuild your RAM disk?  If not it will scan LVM using the conf
> file from the last build.

No, I hadn't considered that. But looking at the content of the
initramfs there is not a copy of lvm.conf in there.

But I have since rebuilt the initramfs and it did not make a
difference.

I have not customized the default Ubuntu initramfs (other than
building it for the patched kernel that I needed to build to get
the dm-hp-sw module). Should I be doing anything special in the
initramfs? Note that I'm not trying to put the / file system on
a multipath device... I'm not nearly that ambitious. :)

Also, I noticed this when the device-mapper modules are loaded
from the initramfs:


Begin: Loading e[42949384.440000] SCSI subsystem initialized
ssential drivers[42949384.500000] device-mapper: 4.4.0-ioctl
(2005-01-12) initialised: dm-devel@redhat.com
... ...
[42949384.620000] device-mapper: dm-multipath version 1.0.4 loaded
[42949384.710000] dm_hp_sw: Unknown parameter `dm-hp-sw.c'
Done.


But looking at the boot text, there was something wrong with the
loading of dm-hp-sw from the initramfs. It appears that the
dm-hp-sw module was not successfully loaded until much later in
the boot sequence.

I tracked this down and fixed the problem. But still, even with
dm-hp-sw loading before the SCSI devices are probed, I get a ton
of SCSI errors trying to access the "ghost" devices.

-- 
Steve Feehan
