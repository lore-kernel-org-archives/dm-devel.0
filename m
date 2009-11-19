From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 00/12] snapshot-merge target
Date: Thu, 19 Nov 2009 17:08:10 +0100
Message-ID: <20091119160809.GB22938@basil.fritz.box>
References: <1258474344-10886-1-git-send-email-snitzer@redhat.com>
	<87y6m24uyk.fsf@basil.nowhere.org>
	<20091119140233.GA3894@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091119140233.GA3894@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>
List-Id: dm-devel.ids

> OK, I hadn't noticed because I was so focused on the details.
> 
> DM (and LVM) snapshot merging allows a snapshot (its COW store) to be
> merged back into the snapshot's origin device.
> 
> One expected use of snapshot merging is rollback of a root filesystem
> after system upgrades (e.g.: yum update).

Thanks. Can you put that into the changelogs (at least for the main
feature) and into a overview comment somewhere in the code?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
