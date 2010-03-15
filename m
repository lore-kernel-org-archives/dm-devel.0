From: "Charlie Sharkey" <charlie.sharkey@bustech.com>
Subject: Re: max number of paths
Date: Mon, 15 Mar 2010 16:26:07 -0400
Message-ID: <03FB5D708BE3C8448E8079186A56CDE60162B9F9@BTIBURMAIL.bustech.com>
References: <03FB5D708BE3C8448E8079186A56CDE60162B9C7@BTIBURMAIL.bustech.com>
	<4B9E9552.9000603@actcom.co.il>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4B9E9552.9000603@actcom.co.il>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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


I'm seeing this on a Suse Sles10 x86_64 system, 2.6.16.60-0.34-smp.
I have a qlogic qle2462 connected to a hp eva back end. 



-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of guy keren
Sent: Monday, March 15, 2010 4:15 PM
To: device-mapper development
Subject: Re: [dm-devel] max number of paths


Charlie Sharkey wrote:
>  
> 
> Is there a maximum number of paths supported by the device mapper ?
> 
> I have a setup with 12 paths to 14 luns. I had to reduce the number of
paths
> 
> to 10 for the device mapper to startup correctly.

i have seen such problems with linux kernel 2.4, long ago, when max SCSI

disk devices was 256 (and hence - also max paths for such devices).

if you're not using SCSI, but rather some other type of device - it 
could be a limitation of the specific low level driver.

which kernel are you using? and which linux distribution? and what kind 
of block devices do your disks reside on?

--guy

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
