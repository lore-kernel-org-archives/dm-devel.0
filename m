From: Luca Berra <bluca@comedia.it>
Subject: Re: Re: LVM on dmraid breakage
Date: Tue, 7 Aug 2007 11:17:47 +0200
Message-ID: <20070807091747.GA20787@percy.comedia.it>
References: <46B0EAEF.6090305@cfl.rr.com>
	<20070802065012.GA28687@percy.comedia.it>
	<46B254E4.60700@cfl.rr.com> <20070803081133.GB939@percy.comedia.it>
	<46B36F7A.2090601@cfl.rr.com>
	<20070803195749.GA27271@percy.comedia.it>
	<46B39E58.2040305@cfl.rr.com>
	<20070804065047.GA29541@percy.comedia.it>
	<46B733EE.4090507@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46B733EE.4090507@cfl.rr.com>
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

On Mon, Aug 06, 2007 at 10:45:02AM -0400, Phillip Susi wrote:
>>udev is not the only thing on earth that wants to activate a volume
>>group. what if i wanted to do it manually?
>
>Then you do so manually.  This discussion is about what the system does 
>automatically.
And by activating a vg manually i don't benefit from the filter? why?

What about if it is a ha-cluster suite that needs to activate the volume
group. I can't have udev activate that on sight, it will probably
corrupt data.

>>whoever wrote about editing the conf file?
>>i wrote about detecting that a device is already in user by
>>device-mapper and skipping that.
>
>Johnathan Brassow suggested adding the devices claimed by dmraid to 
>lvm's filter spec in its conf file.

probably because this is the only available way now.
anyway this method tends to suck when you have a complex setup.
and lvm device filters are not very intuitive to setup.

>What I am saying is to generalize your suggestion.  Rather than 
>specifically code the lvm tools to use the dm ioctls to check if a 
>device is in use and avoid using it, take a more general approach that 
>will work on similar problems as well, that don't involve device mapper 
>targeting the underlying device, and may be easier to implement.

Let's make a deal, you code that in udev, and in the meantime try to
convince Linus in ditching partition detection code from kernel.
I will code the filter for current lvm.

>If udev uses pvscan on each disk to find out if it is a member of a vg, 
>it can then note which vg it is a member of in its db.  Then it can 
>invoke lvm to attempt to activate that vg, explicitly telling lvm which 
>devices comprise the known pvs of that vg ( since it knows this 
>information ), rather than letting lvm scan /dev/sd*.  When dmraid 
>activates a raid set, udev can note that the physical disk is claimed by 
>dmraid, and it will never ask lvm to do anything with it.
doing this will require changing how lvm tools work.
1) disable the automatic vgscan performed by every lvm command
2) modify pvscan to be able to scan a single device

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
