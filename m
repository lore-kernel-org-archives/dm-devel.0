From: Christopher <joffer@online.no>
Subject: qla4xxx &
 "device-mapper: table: 253:0: multipath: error getting device" error
Date: Wed, 04 Jun 2008 00:35:43 +0200
Message-ID: <4845C73F.7030009@online.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7BIT
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

Hi,

I'm on my second atempt to configure iSCSI (Dell EqualLogic PS5000XV) on 
linux (CentOS 5.1 x86_64). The first ended in a total caos and kernel 
panic I didn't manage to recover from. No biggie, since it's a new 
server (actually will be two identical running a cluster with iSCSI as 
shared storage).

I've got a dualport QLogic iSCSI HBA QLE4062C card. I am trying to 
configure my server to use multipath to the EqualLogic, but i'm not 
confident it's safe to put it in production since I get this error in my 
message log (dmesg) when what I believe is correct configuration gives 
me lots of these:

device-mapper: table: 253:0: multipath: error getting device
device-mapper: ioctl: error adding target to table

First I used the drivers from QLogic and thought it was a bug in the 
driver, but after I removed them the system loaded the kernel provided 
qla4xxx driver and the error still showed in my log.

Is this a but in device-mapper-multipath or is it my config?

For more info on this, see my open-iscsi post on google groups:
http://groups.google.com/group/open-iscsi/browse_thread/thread/8bf139d774eab658 


I posted there first, but ppl in the group told me to go to dm-devel.

/Christopher
