From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 7158] New: Out of memory happen in
	snapshot
Date: Wed, 13 Sep 2006 20:52:49 -0700
Message-ID: <20060913205249.1aa784d9.akpm@osdl.org>
References: <200609140320.k8E3K0Cu016567@fire-2.osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200609140320.k8E3K0Cu016567@fire-2.osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

I've switched this to the mailing list - please send all replies via email
(not the bugzilla web interface) and please ensure that all cc's are
retained.


On Wed, 13 Sep 2006 20:20:00 -0700
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7158
> 
>            Summary: Out of memory happen in snapshot
>     Kernel Version: 2.6.17.13
>             Status: NEW
>           Severity: blocking
>              Owner: agk@redhat.com
>          Submitter: kevin_cheng@thecus.com
> 
> 
> Most recent kernel where this bug did not occur:
> Distribution:
> Hardware Environment:
>   celoron M 1,5GHz
>   memory :256MB
>   swap memory have 1GB
> 
> Software Environment:
>   My volumn be created on RAID0
>   kernel is 2.6.17.13
>   Filesyetm is ext3
>   
> Problem Description:
>    We create the 8 snapshots in one volumn ,and copy a 4G file to the volumn ,
> and system happen "out of memory" and oom-killer kill my processes. 
> Someone have happen this problem ,have any way to solve it ? Thanks!!
> 
> Steps to reproduce:
>   - use three hdd to create RAID0
>   - create vg on RAID0 is called vg0
>   - Create lv on vg0 is called lv0
>   - mke2fsck -j /dev/vg0/lv0 , format to ext3 filesystem
>   - mount /dev/vg0/lv0 to /raid/data
>   - create a folder pub on /raid/data
>   - create 8 snapshots base on lv0 ,snapshot lv sizes have 22GB,every snapshot 
> are the same.
>   - use dd command to create 4G file to lv0
>     dd if=/dev/zero of=/raid/data/4G.bin bs=1M count=4096
>   - system have some thing happen 
>     sometime system will crash ,not any more message.
>     sometime have "out of memory" in dmesg
> 


The oom-killer info which you've included there is ambiguous.  A large
amount f memory is in slab, which might indicate a slab leak.  But there is
also a large amount of memory on the page LRU, which one would expect to
have been reclaimed before declaration of OOM.  

Could you please capture the contents of /proc/slabinfo after the
oom-killing and send that?
