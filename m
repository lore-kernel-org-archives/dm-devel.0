From: Administrator <admin@photoresearchers.com>
Subject: Re: Fibre Channel related crash
Date: Wed, 22 Jun 2005 12:28:13 -0400
Message-ID: <42B9919D.2030603@photoresearchers.com>
References: <20050622160004.772B473361@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050622160004.772B473361@hormel.redhat.com>
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

William Alberto Lovaton Tovar wrote:
 > I have to say that I couldn't install Fedora Core 3 with the SAN
 > partitions enabled since it will confuse the installer thinking that
 > those "exported" disks were the first ones and the local disk was the
 > last one.
 >

I can't speak to all of your problems, but I can advise you on this one (as I 
have a similar setup).  You can fix the boot loading of SCSI devices by changing 
the order of your aliases in /etc/modules.conf.  For example, I have:

alias scsi_hostadapter0 mptbase
alias scsi_hostadapter1 mptscsih
alias scsi_hostadapter2 qla2300_conf
alias scsi_hostadapter3 qla2300
post-remove qla2300 rmmod qla2300_conf

This ordering causes my local disks to be loaded first (sda,sdb), and the FC 
then start at sdc.

--
Brian
