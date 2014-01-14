From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] Re: dm: wait until kobject is destroyed
Date: Mon, 13 Jan 2014 22:02:02 -0500
Message-ID: <20140114030202.GB5816@redhat.com>
References: <alpine.LRH.2.02.1401092050190.31354@file01.intranet.prod.int.rdu2.redhat.com>
	<20140110210314.GA12660@redhat.com>
	<alpine.LRH.2.02.1401131932130.30362@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1401131932130.30362@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jan 13 2014 at  7:37pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:
 
> Here I'm sending the updated patch. (it reverts the patch that is already 
> in git and applies the new patch). The patch is untested, because I don't 
> use that git branch, but the same code was tested on Linus' 3.13-rc7.
> 
> Mikulas
> 
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> dm-sysfs: fix a module unload race
> 
> The code that calls the completion must be placed in non-module file,
> otherwise there is a module unload race (if the process is preempted and
> module unloaded after the completion is triggered, but before the function
> returns).
> 
> To fix this race, this patch moves the completion code to dm-builtin.c
> that is always compiled directly to the kernel.
> 
> The patch introduces a new structure struct dm_kobject_holder, its purpose
> is to keep the completion and the kobject at one place, so that it can be
> accessed from non-module code without the need to export the layout of
> struct mapped_device to that code.

Thanks for this v2 patch and updated header, I'll get it queued up.
