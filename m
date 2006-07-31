From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Bug in multipath detecting devices
Date: Tue, 01 Aug 2006 01:03:25 +0200
Message-ID: <1154387006.29739.24.camel@localhost.localdomain>
References: <E59516884AA0B041BCB80771B7714983365199@lumbergh.spscommerce.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E59516884AA0B041BCB80771B7714983365199@lumbergh.spscommerce.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jeff Gibson <jgibson@spscommerce.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


> It seems that if you have more than 26 disks/luns it will detect sdaa
> before it detects sdb (sda is the onboard raid & is blacklisted).  The
> result is that the major/minor numbers in /dev/mapper get out of order
> with the disks presented to the system.  For example:
> 
Yes.

Nobody claimed mapper devices numbers are static nor even predictible.
But their names really are.

Actually, you shouldn't trust Linux device number at all : the dynamic
device numbering idea still has fans amongst kernel developpers, I
guess ;)


> The major problem with this is that if I add another disk/lun in the
> future sdaa will change to another disk.  This is because sdaa is on the
> second port of the qlogic card and gets detected as a later device than
> before.  When multipath comes along it creates the device in /dev/mapper
> that sdaa is a member of before sdb's device is created.  As a result
> the multipath devices aren't in the same sequnce as the devices that the
> OS detects (sdb, sdc, etc).  It would be better if sdb was always
> detected before sdaa.  However, I don't see a way to do that in
> /etc/multipath.conf without blacklisting all of the sda* drives.
> Another option would be to have a user-configurable scan order, which I
> don't think exists (correct me if I'm wrong).  
> 
The multipath assembly walks the device list as show by
"ls /sys/block/", ie alphabetically.

I still don't see the need to do it differently.

Regards,
cvaroqui
