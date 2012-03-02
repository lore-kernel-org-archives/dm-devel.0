From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: readonly snapshots of LVM on same machine
Date: Fri, 2 Mar 2012 02:16:13 +0000
Message-ID: <20120302021613.GB1328@agk-dp.fab.redhat.com>
References: <4F502C68.7000307@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4F502C68.7000307@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: George Shuklin <george.shuklin@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 02, 2012 at 06:11:52AM +0400, George Shuklin wrote:
> If I attach a readonly snapshot of same disk as system disk, I'm getting  
> message of duplicate ID (obvious, huh).  But snapshot is in readonly, so  
> there is no way to rename it or change ID. Changing ID of system LVM is  
> not really good idea.

All you can do then is set up filters so each cmd only sees the disks you
want it to see.

Temporarily, --config lets you do this on each cmdline.

For a permanent setup, another option is to use a separate lvm.conf by setting
LVM_SYSTEM_DIR in the environment.

Alasdair
