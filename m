From: Milan Broz <mbroz@redhat.com>
Subject: Re: BUG in dm/dm-mirror module?
Date: Sat, 11 Aug 2007 10:52:07 +0200
Message-ID: <46BD78B7.3080200@redhat.com>
References: <20070811010853.GA9952@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070811010853.GA9952@us.ibm.com>
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

malahal@us.ibm.com wrote:
> Hi, I am trying to create a mirrored disk log. I have four block
> devices, two for the log (which is a mirror!) and two for the actual
> mirror device.  But I can't use the mirror device at all. It just hangs
> for any read/write. Here are the details of dmsetup calls. I am using
> RHEL5 (2.6.18-8.el5). Looks like a mirror module bug and I appreciate
> any help.
> 
> dev1="/dev/sda1"
> dev2="/dev/sdb1"
> dev3="/dev/sdc1"
> dev4="/dev/sdd1"
> echo "0 8192 mirror core 1 512 2 $dev1 0 $dev2 0" | dmsetup create log
> echo "0 24576 mirror disk 2 /dev/mapper/log 512 2 $dev3 0 $dev4 0" | dmsetup create mirror

Hi,

yes, there is known problem with one kmirrord thread and using mirrored log.
(i.e. mirror over mirror)

For problem description see this patch for upstream kernel
http://www2.kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.21/dm-raid1-one-kmirrord-per-mirror.patch

All testing RHEL5 kernels from 2.6.18-18 has this fix included,
so for testing purposes you can try RHEL5.1 beta kernel.

Milan
--
mbroz@redhat.com
