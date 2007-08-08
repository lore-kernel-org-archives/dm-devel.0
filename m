From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [dm-devel] Re: LVM on dmraid breakage
Date: Wed, 08 Aug 2007 17:04:12 -0400
Message-ID: <46BA2FCC.1040001@cfl.rr.com>
References: <46B0EAEF.6090305@cfl.rr.com>	<20070802065012.GA28687@percy.comedia.it>	<46B1B5E1.1050406@redhat.com>
	<46B251BB.1010004@cfl.rr.com>
	<20070807210359.GA2064@agk.fab.redhat.com>
Reply-To: "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <ataraid-list-bounces@redhat.com>
In-Reply-To: <20070807210359.GA2064@agk.fab.redhat.com>
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
> On Thu, Aug 02, 2007 at 05:50:51PM -0400, Phillip Susi wrote:
>> The problem is that lvm is looking at the physical disks at all.  It 
>> needs to scan the dmraid device, not the underlying disks.
>  
> Indeed.  Please send the evidence showing where it is going wrong so
> we can fix it.

https://bugs.launchpad.net/ubuntu/+source/dmraid/+bug/129285

Note the dm table listing:

nvidia_ajafeffc: 0 625142446 mirror core 2 131072 nosync 2 8:0 0 8:16 0

nvidia_ajafeffc4: 0 464776515 linear 254:2 160360830

nvidia_ajafeffc3: 0 195313 linear 254:2 160156250

nvidia_ajafeffc2: 0 78236550 linear 254:2 81915435

nvidia_ajafeffc1: 0 81915372 linear 254:2 63

volgroup-swap: 0 1843200 linear 8:2 76390784

volgroup-root: 0 76390400 linear 8:2 384

This is do to the fact that the lvm tools open /dev/sd* and look for lvm 
partitions, which it finds.
