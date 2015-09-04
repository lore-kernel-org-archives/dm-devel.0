From: Joe Julian <me@joejulian.name>
Subject: Re: udev rules do not create partition entries when an
 lvm lv is partitioned
Date: Fri, 4 Sep 2015 12:34:16 -0700
Message-ID: <55E9F238.8080004@joejulian.name>
References: <55E9E072.8080209@joejulian.name>
	<20150904191209.GA8446@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150904191209.GA8446@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 09/04/2015 12:12 PM, Bryn M. Reeves wrote:
> On Fri, Sep 04, 2015 at 11:18:26AM -0700, Joe Julian wrote:
>> Yes, I'm aware of all the arguments against even doing this, but I have my
>> reasons for doing it this way.
>>
>> When you create a partition on an lv:
>>
>>    sgdisk /dev/vg1/lv1 -n 0:0:0
>>
>> there is no udev rule to create the partition entry, '/dev/vg1/lv1p1' (for
>> instance). For my immediate use case, this causes ceph-disk to fail as it
>> cannot find the partition as it's expecting to find the device name with a
>> new "1" at the end. Any suggestions on how I could make this happen?
> Why not just name the LV lv1p1 if ceph-disk is hard wired to expect that
> naming?
>
> There's not a lot of benefits to using partitions on top of logical
> volumes and if you're not expecting them they can be problematic (e.g.
> when they are the partitions of a running VM that is also accessing the
> disk).
>
> It is possible to create partitions on pretty much any device-mapper
> device using the normal tools and then create new dm devices to map the
> partitions using kpartx.
>
> Multipath-tools supplies udev rules to automate this so that the
> partition maps are created automatically by udev (since it works with
> whole disks): you could use that as an example if you really want to try
> that approach but it's fairly easy to get the rules wrong in subtle ways
> that may prevent booting.
>
> If you just want a temporary mapping to set things up run:
>
> # kpartx -a /dev/vg1/lv1
>
> And you should find partition maps at /dev/mapper/vg1-lv1p1 etc.
>
> kpartx -d to remove.
>
> Regards,
> Bryn.
>   
I've looked at the ceph-disk source. It's expecting whatever device path 
I give it to add r".*1" as it (ceph-disk) creates the partitions so a 
naming trick isn't going to work. There's no chance during the process 
to manually add dm mappings or use kpartx.

And like I said, I'm aware that there's either not a lot of benefits, or 
no benefit, to using partitions on top of logical volumes. Ceph has a 
very complex configuration and installation, so redoing that seems like 
it would be a much more cumbersome task over just making partition 
mappings work.
