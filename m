From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: Re: Changes hwtable.c to Support New Pillar Hardware
Date: Tue, 6 Feb 2007 14:00:25 +0100
Message-ID: <OF1EE74310.3946E3E8-ONC125727A.0046CC9D-C125727A.00475ECE@de.ibm.com>
References: <1170715904.20348.6.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1170715904.20348.6.camel@localhost.localdomain>
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

dm-devel-bounces@redhat.com wrote on 05.02.2007 23:51:44:
> 
> I'm wondering : "%d" or "/dev/%n" should work as mpath_prio_alua
> parameter. Does "%n" does too ?
> 
Yes, "%n" uses "/dev" (or the directory given with -d) as device
directory, if there is no leading "/" in the device name.
It might be a workaround for the problems with the temporary device
node (makedev macro seems to be the wrong choice...) but will get
other problems. If udev/hotplug doesn't create the device node fast
enough the call will fail. This was the reason to implement the "%d"
support in the first place. May someone has a good idea how to
do the node creation correctly...

Regards,
Stefan
