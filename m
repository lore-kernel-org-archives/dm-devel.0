From: "Srinivas, Vidya" <vidya.srinivas@intel.com>
Subject: Need some help on dmraid RAID5
Date: Mon, 29 May 2006 16:19:55 +0530
Message-ID: <A6A77F954AFACF42928F5E931ABDB18F481DB2@bgsmsx411.gar.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

I am checking dmraid functionality for RAID5 with 3 disks. I am using
the latest available patch on
http://people.redhat.com/heinzm/sw/dm/dm-raid45/
I have some confusion in the same.

The target length in the function raid_ctr in dm-raid4-5.c is being
displayed to me as the smallest disk sectors. However, I understand that
the target length should be the total sectors (of all available disks)
available for data (which in my case should be 2 disk sectors since 1
disk sectors would be utilized for parity)

What I understand is, in the user level dmraid, in
lib/activate/activate.c, under dm_raid45, sectors value is calculated
by:

Sectors =3D _smallest(lc,rs,0)

And, the same sectors value is passed to _dm_raid45_bol.

Whatever goes from this _dm_raid45_bol directly goes to the kernel
dm-raid4-5.c and under raid_ctr gets printed as ti->len right? So, the
smallest sectors (of all the devices) goes to ti->len. In my case also,
the smallest disk sectors is being printed as ti->len and not the total
data sectors. Am I wrong?


Also, I had another doubt in dm-raid4-5.c, under static struct raid_type
raid_types[], values for raid5_ls is:

{Raid5_ls. "RAID5 (left symmetric), 1, 3, raid5, left_sym}, where the
number of parity devices (being the 3rd parameter) is taken as 1.

But, I feel, since there isn't any dedicated parity device for RAID5,
shouldn't this be taken as 0. When I take this as 1, I am getting the
error, target length not divisable by number of devices.=20

When I take it as 0, my RAID volume is being created and things seem to
work.

Any suggestions would be helpful

Thanks
Vidya
