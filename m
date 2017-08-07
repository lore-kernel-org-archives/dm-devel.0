From: Tom Yan <tom.ty89@outlook.com>
Subject: [BUG] BLKZEROOUT on dm-crypt container cause OOM /
	kernel panic
Date: Mon, 7 Aug 2017 01:58:01 +0000
Message-ID: <HK2PR04MB064468C0371547D1D17C9C5488B50@HK2PR04MB0644.apcprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi all,

When I do the following:

cryptsetup open /dev/sdX[Y] rand --type plain --key-file /dev/random;
blkdiscard -z /dev/mapper/rand

Some OOM killings and a kernel panic occur. Here is a screenshot:
https://gitlab.com/cryptsetup/cryptsetup/uploads/207ffdada52f3172f54a014c67159625/DSC_0129.JPG

Similar issue is NOT found in doing `cat /dev/zero > /dev/mapper/rand`, or `blkdiscard -z /dev/sdX[Y]` (without opening a dm-crypt on it), on the same hardware and configuration.

Note that `blkdiscard -z` does not trigger the BLKDISCARD ioctl but the BLKZEROOUT ioctl. And the devices I have been testing on are USB devices that does NOT support WRITE SAME or UNMAP.

Regards,
Tom Yan
