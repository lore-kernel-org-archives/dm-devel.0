From: Ross Anderson <rosander@dsotm.net>
Subject: Re: partx fails 4096 block size
Date: Tue, 16 Sep 2014 10:35:45 -0500
Message-ID: <541858D1.2050506@dsotm.net>
References: <54174287.30508@dsotm.net>
	<20140916085234.GA21419@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140916085234.GA21419@localhost.localdomain>
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

Bryn,

Let me first say thank you for a very detailed reply. I apologize for 
misunderstanding the multi path scheme and partx vs kpartx. After 
reading the information provided I still have an outstanding issue. 
kpartx works as expected when called manuall. The rules provided inside 
the git pull kpartx.rules are in the udev path.  I still experience a 
lack of partition creation. Udev debug shows the lun dm devices being 
created. My question is does udev call kpartx or is there some trigger 
within multipath? I do see the feature no_partition located in the git 
example conf file. I checked my conf and found no such setting. I'd 
appreciate any suggestion as to if this is a udev or mpath issue.

http://pastebin.com/K3VBtzAG

Thanks again for everyone's time reading this.

Ross

On 9/16/2014 3:52 AM, Bryn M. Reeves wrote:
> On Mon, Sep 15, 2014 at 02:48:23PM -0500, Ross Anderson wrote:
>> I'd appreciate any help in troubleshooting this. Quiet frustrating not being
>> able to use mpath on 4k blocks.
> Doesn't seem related to sector size.
>   
>> http://pastebin.com/EbTMXdvE
>> ###partx -a-v
>> partition: none, disk: /dev/dm-0, lower: 0, upper: 0
>> /dev/dm-0: partition table type 'gpt' detected
>> partx: /dev/dm-0: adding partition #1 failed: Invalid argument
> partx is trying to call a BLKPG partition management ioctl on a
> device-mapper device. Since dm devices are not partitionable it
> fails with EINVAL.
>
>> partx: /dev/dm-0: adding partition #2 failed: Invalid argument
>> partx: /dev/dm-0: error adding partitions 1-2
> The partx program comes from the util-linux package:
>
> $ qwhich partx
> util-linux-2.24.2-1.fc20.x86_64
>
> You're probably looking for kpartx which is part of multipath-tools. On
> Red Hat distros it's in a separate sub-package named kpartx:
>
> $ qwhich kpartx
> kpartx-0.4.9-56.fc20.x86_64
>
> The kpartx command reads partition data from the disk and creates
> device-mapper linear maps corresponding to each discovered partition.
> This allows you to access the partitions on a device-mapper device as
> separate dm devices (e.g. you'd get devices with paths like
> '/dev/mapper/dm-0p1' or whatever depending on the -p switch given).
>
> Most distros today will automatically run kpartx when new multipath
> devices appear or when they change so you shouldn't need to run it
> manually all the time.
>
> Regards,
> Bryn.
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
