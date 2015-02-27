From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/2] dm-snapshot: suspend origin when doing
 exception handover
Date: Fri, 27 Feb 2015 14:20:31 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502271413251.32344@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1502261137120.13050@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1502261137120.13050@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On Thu, 26 Feb 2015, Mikulas Patocka wrote:

> In the function snapshot_resume we perform exception store handover. If
> there is another active snapshot target, the exception store is moved from
> this target to the target that is being resume.
> 
> The problem is that if there is some pending exception, it will point to
> an incorrect exception store after that handover, causing crash in BUG in
> dm-snap-persistent.c:get_exception - see bug 1177389.
> 
> This bug can be triggered by repeatedly changing snapshot permissions with
> "lvchange -p r" and "lvchange -p rw" while there are writes on the
> associated origin device.
> 
> To fix this bug, we must suspend the origin device when doing the
> exception store handover to make sure that there is no pending exception.
> 
> This patch:
> - introdices _origin_hash that keeps track of dm_origin structures.
> - introduces function __lookup_dm_origin, __insert_dm_origin and
>   __remove_dm_origin that manipulate the origin hash.
> - modifies snapshot_resume so that it calls dm_internal_suspend_fast and
>   dm_internal_resume_fast on the origin device.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

I forgot to add

Cc: stable@vger.kernel.org

Note to people who backport it:

When backporting to kernels 3.12-3.18, use dm_internal_suspend and 
dm_internal_resume instead of dm_internal_suspend_fast and 
dm_internal_resume_fast.

When backporting to kernels older than 3.12, you need to pick functions 
dm_internal_suspend and dm_internal_resume from the patch 
fd2ed4d252701d3bbed4cd3e3d267ad469bb832a.

Mikulas
