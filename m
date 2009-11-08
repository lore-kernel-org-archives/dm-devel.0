From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: is 'vgchange -an' deprecated ?
Date: Sun, 08 Nov 2009 22:57:44 +0100
Message-ID: <1257717464.10825.7.camel@zezette>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Sorry for the hooker's subject.

On Ubuntu 9.10, using udev+DeviceKit, I observe the following sequence

1/ manually : "vgchange -an myvg"
2/ manually : "sg_persist -r /dev/sdb" sdb being a path of a PV of myvg
3/ udevadm monitor shows shortly thereafter :
KERNEL[1257716424.475961]
change   /devices/platform/host5/session1/target5:0:0/5:0:0:0/block/sdb
(block)
UDEV  [1257716427.373569]
change   /devices/platform/host5/session1/target5:0:0/5:0:0:0/block/sdb
(block)
4/ and finally the VG has its LV active again :)

Funny, but is that really indented ? In a failover cluster setup, isn't
it considered safer to not import VG on the failover node ? How can we
achieve that in this dynamic age ?

Best regards,
cvaroqui
