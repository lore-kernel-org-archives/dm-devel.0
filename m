From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Re: LVM on dmraid breakage
Date: Mon, 06 Aug 2007 10:45:02 -0400
Message-ID: <46B733EE.4090507@cfl.rr.com>
References: <46B0EAEF.6090305@cfl.rr.com>	<20070802065012.GA28687@percy.comedia.it>	<46B254E4.60700@cfl.rr.com>
	<20070803081133.GB939@percy.comedia.it>	<46B36F7A.2090601@cfl.rr.com>	<20070803195749.GA27271@percy.comedia.it>	<46B39E58.2040305@cfl.rr.com>
	<20070804065047.GA29541@percy.comedia.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070804065047.GA29541@percy.comedia.it>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, ataraid-list@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

Luca Berra wrote:
> the above is called FUD

No, it is called extensible design.  I didn't make claims that the sky 
is falling or any other such nonsense, I simply pointed out what new 
requirements may be added in the future, and that if it isn't too hard, 
we should design the system now to be able to handle those new 
requirements.

> udev is not the only thing on earth that wants to activate a volume
> group. what if i wanted to do it manually?

Then you do so manually.  This discussion is about what the system does 
automatically.

> whoever wrote about editing the conf file?
> i wrote about detecting that a device is already in user by
> device-mapper and skipping that.

Johnathan Brassow suggested adding the devices claimed by dmraid to 
lvm's filter spec in its conf file.

What I am saying is to generalize your suggestion.  Rather than 
specifically code the lvm tools to use the dm ioctls to check if a 
device is in use and avoid using it, take a more general approach that 
will work on similar problems as well, that don't involve device mapper 
targeting the underlying device, and may be easier to implement.

If udev uses pvscan on each disk to find out if it is a member of a vg, 
it can then note which vg it is a member of in its db.  Then it can 
invoke lvm to attempt to activate that vg, explicitly telling lvm which 
devices comprise the known pvs of that vg ( since it knows this 
information ), rather than letting lvm scan /dev/sd*.  When dmraid 
activates a raid set, udev can note that the physical disk is claimed by 
dmraid, and it will never ask lvm to do anything with it.

Not only does that solve the lvm/dmraid problem, but any future reasons 
that arise for lvm NOT to scan a given volume can be solved using the 
same udev attributes rather than having to patch lvm ( and dmraid ).
