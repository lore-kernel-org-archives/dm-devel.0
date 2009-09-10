From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Regarding dm-ioband tests
Date: Thu, 10 Sep 2009 12:06:06 +0900 (JST)
Message-ID: <20090910.120606.226774494.ryov@valinux.co.jp>
References: <20090908170649.GC8828@linux.vnet.ibm.com>
	<20090909.150511.112608142.ryov@valinux.co.jp>
	<20090909135726.GB8256@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754967AbZIJDGF@vger.kernel.org>
In-Reply-To: <20090909135726.GB8256@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vgoyal@redhat.com
Cc: dhaval@linux.vnet.ibm.com, riel@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org, nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> - Secondly, personally I think it more twisted also. Following is the
>   small code to setup two ioband devices ioband1 and ioband2 and two
>   additional groups on ioband1 device using cgroup interface.
> 

The latest dm-ioband and blkio-cgroup, configurations can be done
through the cgroup interface once a dm-device is created, blkio.setting
file is appered under the cgroup directory. There is no need to run
"dmsetup message" command and care the the blkio.id anymore.

The following is an example script based on yours.

***********************************************************************
echo "0 $(blockdev --getsize /dev/sdd1) ioband /dev/sdd1 1 0 0 cgroup"
 "weight 0 :100" | dmsetup create ioband1

mount -t cgroup -o blkio hier1 /cgroup/ioband
mkdir /cgroup/ioband/test1 /cgroup/ioband/test2

echo ioband1 200 > /cgroup/ioband/test1/blkio.settings
echo ioband1 100 > /cgroup/ioband/test2/blkio.settings

mount /dev/mapper/ioband1 /mnt/sdd1

> For status of various settings one needs to use "dmsetup status" and
> "dmsetup table" commands. Look at the output of these commands with just
> two groups. Output for all the groups is on a single line. Think of the
> situation when there are 7-8 groups and how bad it will look.
> 
> #dmsetup status
> ioband2: 0 40355280 ioband 1 -1 105 0 834 1 0 8
> ioband1: 0 37768752 ioband 1 -1 105 0 834 1 0 8 2 0 0 0 0 0 0 3 0 0 0 0 0 0

I'll provide blkio.stat file to get statistics per cgroup in the next
release.

> > Once we create a dm-ioband device, the device can be configured
> > through the cgroup interface. I think it will not severly limit its
> > usefulness.
> 
> To create the device once you need dm-tools and libcgroup needs to learn 
> how to make various use of various dm commands. It also needs to learn how
> to parse outputs of "dmsetup table" and "dmsetup status" commands and
> consolidate that information.
> 
> This is despite the fact that it is using cgroup interface finally to
> group the task. But libcgroup still need to propagate cgroup id to
> individual ioband devices.

We still need to use dmsetup for the device creation, but It is not
too much pain. I think it would be better If dm-ioband is intergrated
into LVM, then we can handle dm-ioband devies in almost the same
manner as other LV devices.

Thanks,
Ryo Tsuruta
