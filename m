From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: 2.6 device mapper performance?
Date: Fri, 10 Mar 2006 12:11:59 -0500
Message-ID: <1142010719.20484.98.camel@localhost.localdomain>
References: <HIENIDNHFMODBIPFNJPDOEMBDAAA.ken.hwang@zyxel.com>
	<1142009962.20484.83.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: ken.hwang@zyxel.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2006-03-10 at 11:59 -0500, Ming Zhang wrote:
> u have too many chances here. so hard to blame any one. suggest u to
> test it one by one if possible.

sorry, typo. should be "too many changes" 

> 
> for example, have same box run 2.4 and 2.6, test performance on volume
> first before run xfs, and samba.
> 
> ming
> 
> On Wed, 2006-03-08 at 16:49 -0800, Ken Hwang wrote:
> > Hi,
> > 
> > I'm not sure I should ask this question here, if this is not the place then
> > I apologize. I have a home made NAS with Linux. I use evms to create volume,
> > put xfs on top of it, and then use samba to share it with Windows clients.
> > When I was using kernel 2.4 with all the needed patches I could get netbench
> > 106Mbps with 4 clients, and 95Mbps with 8 clients. Recently I upgraded the
> > same hardware to kernel 2.6 (I also upgraded the related application such as
> > samba, xfs utility, and dmsetup accordingly). Then I ran netbench again and
> > got 80Mbps with 4 clients, 53Mbps with 8 clients. Which drop almost 80% (95
> > vs 53) in 8 clients case.
> > 
> > I then  make and mount xfs on another raid5 (which uses the same disk but on
> > different partitions) and found it got better performance (95Mbps with 4
> > clients, 85Mbps with 8 clients). In brief:
> > xfs volume on raid5 md/md1 on sda6/sdb6/sdc6/sdd6 netbench: 95/85Mbps
> > xfs volume on EVMS volume /dev/evms/volume1 on raid5 md/md3 on
> > sda8/sdb8/sdc8/sdd8: 80/53Mbps
> > 
> > Do you think the slow down (85 to 53Mbps) was caused by device mapper?
> > Please advice.
> > 
> > Ken
> > 
> > --
> > No virus found in this outgoing message.
> > Checked by AVG Free Edition.
> > Version: 7.1.375 / Virus Database: 268.2.0/276 - Release Date: 3/7/2006
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 
