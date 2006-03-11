From: "Ken Hwang" <ken.hwang@zyxel.com>
Subject: RE: 2.6 device mapper performance?
Date: Fri, 10 Mar 2006 21:58:22 -0800
Message-ID: <HIENIDNHFMODBIPFNJPDAENODAAA.ken.hwang@zyxel.com>
References: <1142009962.20484.83.camel@localhost.localdomain>
Reply-To: ken.hwang@zyxel.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1142009962.20484.83.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mingz@ele.uri.edu, device-mapper development <dm-devel@redhat.com>
Cc: ken.hwang@zyxel.com
List-Id: dm-devel.ids

Hi Ming,

I did more tests and list them at the following. Please help me analyze them
if it's possible and thanks. Allow me describe the disk/volume layout. I had
4 120GB sata disks as sda, sdb, sdc, sdd. And they form 4 raid5 region, on
top of the raid5 region there is a container, then I take 50% of the
container to be a evms region, and then put a evms volume /dev/evms/volume1
on top of the region. And I believe the raid5 region I used can be found at
/dev/evms/.nodes/md/md3.

test: sync; time dd if=/dev/evms/volume1 of=/dev/null bs=1024k count=1024
kernel 2.4 got 33.649s/0.010s/20.430s (real/user/sys)
kernel 2.6 got 46.690s/0.024s/26.902s

test: sync; time dd if=/dev/evms/.nodes/md/md3 of=/dev/null bs=1024k
count=1024
kernel 2.4: 19.471s/0.000s/13.480s
kernel 2.6: 23.763s/0.008s/16.097s

test: sync; time dd if=/dev/zero of=/dev/evms/volume1 bs=1024k count=1024
kernel 2.4: 69.183s/0.000s/15.430s
krenel 2.6: 52.543s/0.004/7.640s

test: sync; time dd if=/dev/zero of=/dev/evms/.nodes/md/md3 bs=1024k
count=1024
kernel 2.4: 37.862s/0.000s/11.730s
kernel 2.6: 23.628s/0.000s/5.536s

test: blockdev --getra /dev/evms/volume1
kernel 2.4: 1024
kernel 2.6: 384

test: blockdev --getra /dev/evms/.nodes/md/md3
kernel 2.4: 64
kernel 2.6: 256

Looks like kernel 2.4 reading is faster than 2.6 but 2.6 writing is faster.

By comparing read from md3 and volume1,
kernel 2.4 drop from 19.471s to 33.649s (72.8%)
kernel 2.6 drop from 23.763s to 46.690s (96.4%)

By comparing write to md3 and volume1,
kernel 2.4 drop from 37.862s to 69.183s (82.7%)
kernel 2.6 drop from 23.628s to 52.543s (122.4%)

What's the blockdev numbers mean?

Thanks,

Ken


-----Original Message-----
From: Ming Zhang [mailto:mingz@ele.uri.edu]
Sent: Friday, March 10, 2006 8:59 AM
To: ken.hwang@zyxel.com; device-mapper development
Subject: Re: [dm-devel] 2.6 device mapper performance?


u have too many chances here. so hard to blame any one. suggest u to
test it one by one if possible.

for example, have same box run 2.4 and 2.6, test performance on volume
first before run xfs, and samba.

ming

On Wed, 2006-03-08 at 16:49 -0800, Ken Hwang wrote:
> Hi,
>
> I'm not sure I should ask this question here, if this is not the place
then
> I apologize. I have a home made NAS with Linux. I use evms to create
volume,
> put xfs on top of it, and then use samba to share it with Windows clients.
> When I was using kernel 2.4 with all the needed patches I could get
netbench
> 106Mbps with 4 clients, and 95Mbps with 8 clients. Recently I upgraded the
> same hardware to kernel 2.6 (I also upgraded the related application such
as
> samba, xfs utility, and dmsetup accordingly). Then I ran netbench again
and
> got 80Mbps with 4 clients, 53Mbps with 8 clients. Which drop almost 80%
(95
> vs 53) in 8 clients case.
>
> I then  make and mount xfs on another raid5 (which uses the same disk but
on
> different partitions) and found it got better performance (95Mbps with 4
> clients, 85Mbps with 8 clients). In brief:
> xfs volume on raid5 md/md1 on sda6/sdb6/sdc6/sdd6 netbench: 95/85Mbps
> xfs volume on EVMS volume /dev/evms/volume1 on raid5 md/md3 on
> sda8/sdb8/sdc8/sdd8: 80/53Mbps
>
> Do you think the slow down (85 to 53Mbps) was caused by device mapper?
> Please advice.
>
> Ken
>
> --
> No virus found in this outgoing message.
> Checked by AVG Free Edition.
> Version: 7.1.375 / Virus Database: 268.2.0/276 - Release Date: 3/7/2006
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
--
No virus found in this incoming message.
Checked by AVG Free Edition.
Version: 7.1.375 / Virus Database: 268.2.1/278 - Release Date: 3/9/2006

--
No virus found in this outgoing message.
Checked by AVG Free Edition.
Version: 7.1.375 / Virus Database: 268.2.1/279 - Release Date: 3/10/2006
