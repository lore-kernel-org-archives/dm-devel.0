From: gistolero@gmx.de
Subject: Re: Re: EMC Cx300 multipath seems to work
Date: Tue, 13 Sep 2005 19:02:00 +0200
Message-ID: <43270608.8090807@gmx.de>
References: <4326878A.3090303@theorematica.it> <4326C29F.3060202@gmx.de>
	<43270359.80504@theorematica.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43270359.80504@theorematica.it>
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

> Yes, after reboot I see only one path too, but when I run udevstart I
> see all paths, for this reason I put udevstart in /etc/conf.d/local.start

Yes, but udevstart doesn't work for me. I have to start "multipath /dev/sda" 
again.


> udev 0.68-r1 needs unstable baselayout (1.12) to execute udev-start.sh,
> what baselayout are you using?

testhalde2 ~ # epm -aq | grep baselayout
baselayout-1.12.0_pre6-r3

Regards
Simon
