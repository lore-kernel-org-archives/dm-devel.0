From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [dm-devel] Re: LVM on dmraid breakage
Date: Wed, 08 Aug 2007 17:13:35 -0400
Message-ID: <46BA31FF.3090509@cfl.rr.com>
References: <46B0EAEF.6090305@cfl.rr.com>	<20070802065012.GA28687@percy.comedia.it>	<46B254E4.60700@cfl.rr.com>
	<20070807212817.GB2064@agk.fab.redhat.com>
Reply-To: "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <ataraid-list-bounces@redhat.com>
In-Reply-To: <20070807212817.GB2064@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ataraid-list>
List-Post: <mailto:ataraid-list@redhat.com>
List-Help: <mailto:ataraid-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=subscribe>
Sender: ataraid-list-bounces@redhat.com
Errors-To: ataraid-list-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>, linux-lvm@redhat.com
List-Id: dm-devel.ids

Alasdair G Kergon wrote:
> As I've said many times before, in my view the current problems stem
> from some system components unilaterally switching to an event-driven
> model while others (including lvm2 and initscripts) haven't - and
> combining two incompatible models on a system was "brave".

Actually, none of the involved components here are event driven yet. 
Right now dmraid and lvm are just run during boot time in the init 
scripts.

> If lvm2 is run in an event-driven environment, the idea is for it to
> give up all its device scanning and filtering.  It will hand over
> control of what devices to use to an external module shared by
> everything that needs to know about devices - including mdadm,
> initscripts, mount, hal, udev etc.  [What owns this module is irrelevant
> but udev is an obvious candidate.]

Yes.

> When udev sees a new device, it will inform each subsystem of the
> device.
> 
> lvm2 will provide an interface that is given a device and, if a PV is
> present on it, lvm2 will pass information about it (including its UUID)
> to the external module for storage.
> 
> The external module will have an interface capable of being told
> by lvm2 (at any time) 'Devices with UUIDs X, Y and Z form a volume
> group called VGn'.
> 
> Triggers can be defined so that when all the PV UUIDs are present
> for a volume group with name VGn, an lvm2 command (like 'vgchange -ay
> VGn') gets invoked.
>  
> You can see how md, mount etc. can work in a similar event-driven
> fashion.

Exactly.  Then policy decisions like whether lvm should be allowed to 
auto detect pvs in disks being claimed by dmraid can be easily made with 
udev scripts by the distro rather than having to modify lvm, and 
presumably, all of the other components that are interacting in the 
system.
