From: <Yanqing_Liu@Dell.com>
Subject: Re: Dell MD3200 - sd: Current: sense key: Illegal
Date: Thu, 3 Mar 2011 12:30:15 -0600
Message-ID: <DB6E482E89290547898851B8CC9D81100142CFBE@AUSX7MCPS302.AMER.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: slivkoff@cmu.edu
List-Id: dm-devel.ids

Charles,

It seems that you mapped your LUNs some time after host bootup. That causes pseudo LUN 0 to be created. If you lay down DM using Dell software package, please invoke "rescan_dm_devs" for re-configuration.

We may need your related kernel message for further analysis. As to why setting "failback" to manual doesn't work on MD3200, the problem may be in multipathing daemon, in combination with SAS tranpportation trearing down all devices immediately after path loss. We've filed a bugzilla for this.

BTW, what is your LVM setting for these devices?

Thanks,
Yanqing


Date: Wed, 02 Mar 2011 13:52:23 -0500
From: Charles Slivkoff <slivkoff@cmu.edu>
To: dm-devel@redhat.com
Subject: Re: [dm-devel] Dell MD3200 - sd: Current: sense key: Illegal
	Request ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Message-ID: <4D6E91E7.4010305@cmu.edu>
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"

Hello Babu. Thanks for responding.

> You said "The array is split into 2 virtual disk, each assigned to one 
> of the RAID controllers". Did you mean you redistributed the two 
> luns(one is owned by controller A and one by controller B)?

Yes. I have assigned 1 LUN to each of the controllers.

> It appears that your luns are moving back and forth between two 
> controllers.. You can try setting failback to manual(failback manual).  
> This is not a solution but to understand the problem.

I changed to "failback manual" in /etc/multipath.conf and rebooted. I'm not sure if the reboot was necessary or not. This does not appear to have changed the behavior.

> Are you seeing "MODE_SELECT" messages in the logs..  Can you paste 
> snippet of log messages..

There are no "MODE_SELECT" messages in syslog. Would these be appearing elsewhere? The syslog from the last reboot up until I started receiving the "Illegal Request" messages is available here http://tinypaste.com/f7f413


-Charles
