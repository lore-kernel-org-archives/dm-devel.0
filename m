From: John Little <jslittl@hendricks.org>
Subject: Re: Fw: Multipath and SAN Fabric failover
Date: Thu, 14 Sep 2006 08:08:41 -0400
Message-ID: <20060914080841.25106efd@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-devel-bounces@redhat.com wrote on 09/10/2006 03:23:55 PM:

> Heya,
> > Just to make sure that I've covered everything I partitioned the
> > disk as /dev/sdc and then used lvm2 command:
> >   
> sorry, I've missed that before. /dev/sdc is only _one_ of your paths
> to a LUN. multipath will take the right 2 of those sd* to create one
> dm device file. Have a look if there's somethign in /dev/mapper, also
> check your udev rules, you need this line in there:
> 
> KERNEL=="dm-[0-9]*", PROGRAM="/sbin/devmap_name %M %m", NAME="%k", 
> SYMLINK="%c"
> 
> most distros have a line like
> #KERNEL=="dm-[0-9]*",           NAME=""
> in there, you need to comment it out if you add the lien above.
> 
> 
> Hope that helped,
> 
> best regards
> 
> Bernd Zeimetz

Bernd,

I haven't had a chance to work on this for a couple of days but I did
get do some reading.  I'm wondering if I'm using the correct driver for
this.  I have been trying to use the QLogic driver shipped with SLES.
Should I be using the non-EMC driver from the Qlogic website?

Regards,
John
