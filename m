From: Dave Wysochanski <dwysocha@redhat.com>
Subject: Re: [PATCH 3/7] scsi_dh: add hp sw device handler -
	testing and hit existing oops in radix_tree_gang_lookup (fix upstream)
Date: Mon, 17 Mar 2008 16:34:15 -0400
Message-ID: <1205786055.4408.22.camel@localhost.localdomain>
References: <20080311013328.23179.76692.sendpatchset@localhost.localdomain>
	<20080311013347.23179.15406.sendpatchset@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080311013347.23179.15406.sendpatchset@localhost.localdomain>
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

On Mon, 2008-03-10 at 18:33 -0700, Chandra Seetharaman wrote:
> Subject: scsi_dh: add hp sw device handler
> 
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> This patch adds a very basic scsi device handler for older hp boxes which
> cannot be upgraded.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
> 
>  

FYI, I am testing the hp portion and hit and existing oops in
radix_tree_gang_lookup (fixed by upstream block layer patch):
http://www.gossamer-threads.com/lists/linux/kernel/880705?page=last

I saw the problem when doing this sequence:
1) multipath -F
2) "rmmod qla2xxx"
* This would trigger the oops

I added the following upstream commit
ffc4e7595734cf768fa60cea8a4d545dfef8231a on top of your patches and it
seems to have fixed the problem:
http://tinyurl.com/2bk392

My full patch series (started with 2.6.25-rc2):
# quilt series
patches/2.6.25-rc2-mm1.bz2
patches/scsi_dh-add-skeleton.patch
patches/scsi_dh-add-lsi-rdac.patch
patches/scsi_dh-add-hp-sw.patch
patches/scsi_dh-add-emc.patch
patches/scsi_dh-use-scsi-dh-in-dm-mpath.patch
patches/scsi_dh-remove-hwh-from-dm.patch
patches/scsi_dh-remove-hwh-infrastructure.patch
patches/linux-2.6.git-ffc4e7595734cf768fa60cea8a4d545dfef8231a.patch
#
