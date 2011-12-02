From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: DM_snapshot_cow filesystem (dmsetup create snapshot)
Date: Fri, 2 Dec 2011 08:46:19 +0000
Message-ID: <20111202084619.GD7595@agk-dp.fab.redhat.com>
References: <4ED2DF0F.1070108@filteredperception.org>
	<CAEcBt+UEJXSY7oK+j0gw9fkzjnWOUcBFhPdXCVFe3HZNh6zOTw@mail.gmail.com>
	<4ED59040.50406@filteredperception.org>
	<CAEcBt+XxVh8b=TJu-Z+3XBL=K6LUhs2QZyeZKGMGh_Lp+UBGbA@mail.gmail.com>
	<20111130220259.GA7595@agk-dp.fab.redhat.com>
	<4ED6BD81.4090609@filteredperception.org>
	<20111201141236.GB7595@agk-dp.fab.redhat.com>
	<4ED7E11D.1090904@filteredperception.org>
	<20111201202029.GC7595@agk-dp.fab.redhat.com>
	<4ED849B5.7020206@filteredperception.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4ED849B5.7020206@filteredperception.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Thu, Dec 01, 2011 at 09:44:53PM -0600, Douglas McClendon wrote:
> The commandline to do the 'edit' was requested for users like Fred, and  
> because I guess one day I might find myself wanting to do the same.

This is unsupported, but if you want to try:
You need to flip the 5th byte of the 'cow' device from 0 to 1 (when
the snapshot is not active).  (But you might have lost the most recent
changes if they weren't flushed out when it filled up.)

Something like this:

# lvs
  LV    VG   Attr   LSize  Origin Snap%  Move Log Copy%  Convert
  lvol0 vg2  owi-a- 10.00m
  lvol1 vg2  Swi-I- 10.00m lvol0  100.00

# dmsetup table vg2-lvol1-cow
0 20480 linear 7:0 22528

# lvchange -an vg2/lvol0

# dmsetup create tmp-vg2-lvol1-cow --table "0 20480 linear 7:0 22528"

# hexdump -C /dev/mapper/tmp-vg2-lvol1-cow | head -1
00000000  53 6e 41 70 00 00 00 00  01 00 00 00 08 00 00 00  |SnAp............|

Flip byte 5, e.g. copy to file, edit that bit, copy back.
  # dd if=/dev/mapper/tmp-vg2-lvol1-cow of=/tmp/cow-start bs=512 count=1
  # vim -b /tmp/cow-start   (and/or xxd)
  # dd if=/tmp/cow-start of=/dev/mapper/tmp-vg2-lvol1-cow  

# dmsetup remove tmp-vg2-lvol1-cow

# lvchange -ay vg2/lvol0

# lvs
  LV    VG   Attr   LSize  Origin Snap%  Move Log Copy%  Convert
  lvol0 vg2  owi-a- 10.00m                                      
  lvol1 vg2  swi-a- 10.00m lvol0   10.08                        

# hexdump -C /dev/mapper/vg2-lvol1-cow | head -1
00000000  53 6e 41 70 01 00 00 00  01 00 00 00 08 00 00 00  |SnAp............|

Alasdair
