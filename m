From: Dave Wysochanski <dwysocha@redhat.com>
Subject: Re: hradware_handler error on HP MSA1000
Date: Wed, 13 Aug 2008 12:45:34 -0400
Message-ID: <1218645934.4417.2.camel@localhost.localdomain>
References: <e368f40808130230q4160d6c5p5d263c8cf81352a9@mail.gmail.com>
Reply-To: dwysocha@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e368f40808130230q4160d6c5p5d263c8cf81352a9@mail.gmail.com>
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


On Wed, 2008-08-13 at 11:30 +0200, jean Diallo wrote:
> Hi
> I have been strugling with an HP MSA1000 for a few weeks now.
> I am using the old active/passive firmware.
> Here is the device section of my multipath.conf :
> 
> devices {
> 	device {
> 		vendor 		"COMPAQ"
> 
> 
> 		product		"MSA1000"
> 		hardware_handler	"1 hp_sw"

Try "1 hp-sw" instead of "1 hp_sw".

The underscore got changed when the hp handler was submitted upstream.

> 		path_grouping_policy	group_by_prio
> 		path_checker	hp_sw
>  			 		
>  	}
> }
> 
> I am under RHEL5.2 and this is the rpm package of dm-multipath 0.4.7-16.el5.
> Here is my /var/log/messages when i start multipathd daemon :
> Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target to table
> Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath: unknown hardware handler type
> Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target to table
> Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath: unknown hardware handler type
> Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target to table
> Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath: unknown hardware handler type
> Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target to table
> Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath: unknown hardware handler type
> Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target to table
> Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath: unknown hardware handler type
> Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target to table
> Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath: unknown hardware handler type
> Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target to table
> Aug 12 13:48:33 cluster3 multipathd: path checkers start up
> 
> If anyone can help, thanks in advance.
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
