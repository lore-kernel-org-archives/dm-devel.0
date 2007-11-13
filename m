From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: R: [dm-devel] - info about dm
Date: Tue, 13 Nov 2007 13:22:18 -0500
Message-ID: <4739EB5A.9050102@cfl.rr.com>
References: <003d01c8260d$27a8e6b0$27819296@wegaprise>
Reply-To: "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <ataraid-list-bounces@redhat.com>
In-Reply-To: <003d01c8260d$27a8e6b0$27819296@wegaprise>
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
Cc: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

Vega Forneris wrote:
> 1) I need to change an HD which has problems...here the steps I guess
> from what I read in these days:
> - halt the machine (ok, ok it's obvious ;-P )
> - change the faulty HD
> - boot
> - when BIOS starts the RAID manager, enter and rebuild the RAID (1:
> mirror)
> - after the rebuilding, everything should be ok.
> 
> ...is it correct?

Yes... at least if your bios actually starts the rebuild process instead 
of just marking the array as needing rebuilt and relying on the OS to do 
it.

> 2) I have a machine with 2 HD SATA, on the first we have the OS
> installed (and working!), the second is blank (just added), I want to
> create a RAID 1 (mirror) of the whole disk:
> - ...
> I don't want to guess ;-P

The same way you did it the first time: in the bios.  Doing so will 
destroy the existing data on the drive though, so you will want to 
backup first.
