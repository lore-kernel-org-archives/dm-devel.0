From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Problem w/
Date: Thu, 28 Aug 2008 17:19:32 -0400
Message-ID: <48B71664.4030701@hp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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


I'm attempting to boot a recent 2.6.27-rc4 based kernel, but have run
into a strange thing:

Setting up Logical Volume Management:   Failed to format  device number
for  as dm target (259,987136)
  1 logical volume(s) in volume group "oralogvg1" now active
  Failed to format  device number for  as dm target (259,1003520)
  1 logical volume(s) in volume group "oralogvg2" now active
  Failed to format  device number for  as dm target (259,905216)
  Failed to format  device number for  as dm target (259,905216)
  2 logical volume(s) in volume group "oradbvg" now active

This is (at least) due to an issue in the DM library: it only has room
for 10 total character in some names, and with:

259:1003520
259:905216

We exceed the size (need room for the '\0'). I don't know why the minors
all of a sudden became so huge (is this normal?) but I /can/ access the
devices themselves. Version information below:

root@tin(root):pvs --version
  LVM version:     2.02.26-RHEL5 (2007-08-09)
  Library version: 1.02.20 (2007-06-15)
  Driver version:  4.14.0

Is there some up-stream patch in the DM Library that has larger sizes
available for use?

Thanks,
Alan
