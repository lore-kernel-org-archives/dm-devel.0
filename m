From: George Shuklin <george.shuklin@gmail.com>
Subject: Re: readonly snapshots of LVM on same machine
Date: Fri, 23 Mar 2012 19:46:15 +0400
Message-ID: <4F6C9AC7.6050105@gmail.com>
References: <4F502C68.7000307@gmail.com>
	<20120302021613.GB1328@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120302021613.GB1328@agk-dp.fab.redhat.com>
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

On 02.03.2012 06:16, Alasdair G Kergon wrote:
> On Fri, Mar 02, 2012 at 06:11:52AM +0400, George Shuklin wrote:
>> If I attach a readonly snapshot of same disk as system disk, I'm getting
>> message of duplicate ID (obvious, huh).  But snapshot is in readonly, so
>> there is no way to rename it or change ID. Changing ID of system LVM is
>> not really good idea.
> All you can do then is set up filters so each cmd only sees the disks you
> want it to see.
>
> Temporarily, --config lets you do this on each cmdline.
>
> For a permanent setup, another option is to use a separate lvm.conf by setting
> LVM_SYSTEM_DIR in the environment.
>
Good day.

I've check this, but found it ignores new VG with same name.

I've filter system disk out, attach snapshot, allow only snapshot device 
to be scanned. Pvscan found pv, vgscan, vgchange -a y all them works 
without complains, but no any new /dev/dm* devices appears (and no any 
messages in udevadm monitor).

So problem is the same: how to LVM volumes on readonly snapshot on same 
machine as original disk.
