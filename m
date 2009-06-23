From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: rdac path checker reporting "path down" when path comes
	up
Date: Tue, 23 Jun 2009 15:08:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0906231500390.18393@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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


I'm just starting to use d-m-multipath 0.4.7.rhel5.13 with CentOS 5.3, 
with a Sun StorageTek 2510. I notice when unplugging a link to the 
controller, that the path is seen as down, but then is reported again as 
down when the link is restored.

Here's a sample log:

Jun 23 14:12:25 sun4150node1 iscsid: connection1:0 is operational after 
recovery (4 attempts)
Jun 23 14:13:10 sun4150node1 kernel: ping timeout of 10 secs expired, last 
rx 172050, last ping 177050,
now 187050
Jun 23 14:13:10 sun4150node1 kernel:  connection1:0: iscsi: detected conn 
error (1011)
Jun 23 14:13:11 sun4150node1 multipathd: sdb: rdac checker reports path is 
down
Jun 23 14:13:11 sun4150node1 multipathd: checker failed path 8:16 in map 
mpath0
Jun 23 14:13:11 sun4150node1 kernel: device-mapper: multipath: Failing 
path 8:16.
Jun 23 14:13:11 sun4150node1 multipathd: mpath0: remaining active paths: 1
Jun 23 14:13:11 sun4150node1 multipathd: dm-2: add map (uevent)
Jun 23 14:13:11 sun4150node1 multipathd: dm-2: devmap already registered
Jun 23 14:13:12 sun4150node1 iscsid: Kernel reported iSCSI connection 1:0 
error (1011) state (3)
Jun 23 14:13:37 sun4150node1 multipathd: sdb: rdac checker reports path is 
down
Jun 23 14:13:37 sun4150node1 multipathd: 8:16: reinstated
Jun 23 14:13:37 sun4150node1 multipathd: mpath0: remaining active paths: 2

Notice the first message at 14:13:37.

Here's the relevant code:

extern int
rdac(struct checker * c)
{
         struct volume_access_inq inq;

         if (0 != do_inq(c->fd, 0xC9, &inq, sizeof(struct volume_access_inq))) {
                 MSG(c, MSG_RDAC_DOWN);
                 return PATH_DOWN;
         }

         return ((inq.avtcvp & 0x1) ? PATH_UP : PATH_GHOST);
}

MSG_RDAC_UP is defined, but never used.
