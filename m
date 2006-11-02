From: Dale.R.Fowle@seagate.com
Subject: Fw: MP Tools 0.4.7 kernel dependencies
Date: Thu, 2 Nov 2006 14:37:11 -0700
Message-ID: <OF8CDECA18.B64F7793-ON8725721A.00752704-8725721A.0076C9B0@seagate.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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


I guess I spoke too soon on this one. I tried upgrading to 0.4.7 (from
0.4.5-0.20) on some other hosts that didn't have any storage already
configured. When I did configure storage, I noticed that /dev/disk/by-name
does not get populated so I rebooted and noticed the same thing. So,
something between the device-mapper/multipath tools and udev is not
creating the symlinks that usually get created. The piece that does work is
that 'multipath' actually does take control of the devices and create
/dev/dm-* devices. So, I guess my revised question would be has something
in the kernel and it's interaction with udev changed,...and because of
that, MP Tools changed as well?

Thanks again,
Dale

Dale Fowle

----- Forwarded by Dale R Fowle/Seagate on 11/02/2006 02:19 PM -----
                                                                           
             Dale R                                                        
             Fowle/Seagate                                                 
             719-388-5584                                               To 
                                       dm-devel@redhat.com                 
                                                                        cc 
             11/02/2006 09:13                                              
             AM                                                    Subject 
                                       MP Tools 0.4.7 kernel dependencies  
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           



Hi all, I was just wondering what specifically the 0.4.7 version of MP
Tools requires from a kernel rev. of 2.6.10 or higher. I'm running on SLES
9, which is stuck on a 2.6.5-x rev, but the functionality of 0.4.7 seems to
be working fine for me so far.

Thanks,
Dale


Dale Fowle
