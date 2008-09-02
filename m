From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: hardware_handler error with HP MSA1000
Date: Tue, 2 Sep 2008 10:47:49 -0700
Message-ID: <110b17190809021047j5b91cff8v5b402450c0d4c3ae@mail.gmail.com>
References: <e368f40808120247q2c4eed53hc8f527e4a69e1992@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e368f40808120247q2c4eed53hc8f527e4a69e1992@mail.gmail.com>
Content-Disposition: inline
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

I usually get this error if there is a mismatch in the kernel version
of the OS and the device-handler.
You could get the module info of device handler with "modinfo module-name".

Could you please post "uname -a" and "modinfo module-name".
Also, are you trying to rebuild the device-handler or the kernel?

Take care,
Pradipmaya.


2008/8/12 jean Diallo <diallo.jean@gmail.com>:
> Hi
> I have been strugling with an HP MSA1000 for a few weeks now.
> I am using the old active/passive firmware.
> Here is the device section of my multipath.conf :
>
> devices {
> 	device {
> 		vendor 		"COMPAQ"
>
> 		product		"MSA1000"
> 		hardware_handler	"1 hp_sw"
> 		path_grouping_policy	group_by_prio
> 		path_checker	hp_sw
>  			 		
>  	}
> }
>
> I am under RHEL5.2 and this is the rpm package of dm-multipath 0.4.7-16.el5.
> Here is my /var/log/messages when i start multipathd daemon :
> Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target
> to table
> Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath:
> unknown hardware handler type
> Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target
> to table
> Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath:
> unknown hardware handler type
> Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target
> to table
> Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath:
> unknown hardware handler type
> Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target
> to table
> Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath:
> unknown hardware handler type
> Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target
> to table
> Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath:
> unknown hardware handler type
> Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target
> to table
> Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath:
> unknown hardware handler type
> Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target
> to table
> Aug 12 13:48:33 cluster3 multipathd: path checkers start up
>
> If anyone can help, thanks in advance.
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
