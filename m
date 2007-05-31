From: "Bruen, Mark" <mbruen@AffinionGroup.com>
Subject: md device using SAN multipath device?
Date: Thu, 31 May 2007 15:20:06 -0400
Message-ID: <465F1FE6.8070900@AffinionGroup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I'm trying to use device mapper multipath devices (/dev/mapper/73g1 and 
73g2) for one of the RAID1 devices in /dev/md0 and /dev/md1. Seems to 
work fine until reboot and then the dm devices (dm-11 and dm-12) are 
removed from the arrays. Is what I'm trying to do possible? Thanks.
    -Mark
