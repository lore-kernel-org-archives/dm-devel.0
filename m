From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Re: LVM on dmraid breakage
Date: Tue, 07 Aug 2007 11:58:50 -0400
Message-ID: <46B896BA.9060008@cfl.rr.com>
References: <46B0EAEF.6090305@cfl.rr.com>	<20070802065012.GA28687@percy.comedia.it>	<46B254E4.60700@cfl.rr.com>
	<20070803081133.GB939@percy.comedia.it>	<46B36F7A.2090601@cfl.rr.com>	<20070803195749.GA27271@percy.comedia.it>	<46B39E58.2040305@cfl.rr.com>	<20070804065047.GA29541@percy.comedia.it>	<46B733EE.4090507@cfl.rr.com>
	<20070807091747.GA20787@percy.comedia.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070807091747.GA20787@percy.comedia.it>
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
> And by activating a vg manually i don't benefit from the filter? why?

Huh?  I fail to see the direction you are going in with this and what it 
has to do with udev auto configuring things.

> What about if it is a ha-cluster suite that needs to activate the volume
> group. I can't have udev activate that on sight, it will probably
> corrupt data.

Right, which is why you wouldn't be using udev in such a set up.  At 
least not configured to auto mount disks when plugged in.

> probably because this is the only available way now.
> anyway this method tends to suck when you have a complex setup.
> and lvm device filters are not very intuitive to setup.

You just made my point for me.

> Let's make a deal, you code that in udev, and in the meantime try to
> convince Linus in ditching partition detection code from kernel.
> I will code the filter for current lvm.

The partition table code already can be disabled in the kernel config 
iirc.

> doing this will require changing how lvm tools work.
> 1) disable the automatic vgscan performed by every lvm command
> 2) modify pvscan to be able to scan a single device

Correct.  The commands need to be able to take a list of devices to 
manipulate rather than going after /dev/sd*.
