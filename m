From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: LVM on dmraid breakage
Date: Thu, 02 Aug 2007 17:50:51 -0400
Message-ID: <46B251BB.1010004@cfl.rr.com>
References: <46B0EAEF.6090305@cfl.rr.com>	<20070802065012.GA28687@percy.comedia.it>
	<46B1B5E1.1050406@redhat.com>
Reply-To: "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <ataraid-list-bounces@redhat.com>
In-Reply-To: <46B1B5E1.1050406@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ataraid-list>
List-Post: <mailto:ataraid-list@redhat.com>
List-Help: <mailto:ataraid-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=subscribe>
Sender: ataraid-list-bounces@redhat.com
Errors-To: ataraid-list-bounces@redhat.com
To: "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-lvm@redhat.com
List-Id: dm-devel.ids

Bryn M. Reeves wrote:
> But device-mapper already opens devices exclusively when a target claims
> them.
> 
> The problem here sounds more like it's down to ordering; LVM2 is being
> given a chance to scan the devices & build LVs / claim devices before
> dmraid gets a look at them.


I think the "exclusive" open only prevents you from mounting a 
filesystem on the device.  It does not stop you from opening the device 
and accessing it from user mode, nor does it apparently prevent dm from 
(re)using the device.

The problem is that lvm is looking at the physical disks at all.  It 
needs to scan the dmraid device, not the underlying disks.
