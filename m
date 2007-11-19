From: "S. J. van Harmelen" <svanharmelen@xillan.nl>
Subject: Use LVM on /dev/mapper/diskname
Date: Mon, 19 Nov 2007 14:56:42 +0100
Message-ID: <1195480602.6074.3.camel@sanderbal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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

Hi,

I have a couple of LUN's that are handled by the multipath driver. This
works great, but now I want to use LVM so I can take snapshots of one
LUN to another LUN.

Can someone tell me how to do this?

When I do pvcreate /dev/mapper/diskname I get an error that the disk is
already part of an volume group. But I sertainly did not configure that.

Can it be that the multipath driver of devmapper did that?

Sander
