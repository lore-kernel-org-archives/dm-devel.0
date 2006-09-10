From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: Fw: Multipath and SAN Fabric failover
Date: Sun, 10 Sep 2006 21:23:55 +0200
Message-ID: <4504664B.7040509@bzed.de>
References: <20060908143410.28764b76@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060908143410.28764b76@localhost>
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

Heya,
> Just to make sure that I've covered everything I partitioned the disk
> as /dev/sdc and then used lvm2 command:
>   
sorry, I've missed that before. /dev/sdc is only _one_ of your paths to 
a LUN. multipath will take the right 2 of those sd* to create one dm 
device file. Have a look if there's somethign in /dev/mapper, also check 
your udev rules, you need this line in there:

KERNEL=="dm-[0-9]*", PROGRAM="/sbin/devmap_name %M %m", NAME="%k", 
SYMLINK="%c"

most distros have a line like
#KERNEL=="dm-[0-9]*",           NAME=""
in there, you need to comment it out if you add the lien above.


Hope that helped,

best regards

Bernd Zeimetz
