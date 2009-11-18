From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm snapshot: rework writing to snapshot origin
Date: Wed, 18 Nov 2009 11:44:10 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911181141500.5068@hs20-bc2-1.build.redhat.com>
References: <1258472477-5795-1-git-send-email-snitzer@redhat.com>
	<20091117174902.GB5223@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091117174902.GB5223@redhat.com>
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
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

I think this should be applied, otherwise snapshots turn into 
unmaintainable mess.

Mikulas

> Alasdair,
> 
> I am not aware of any "cons" associated with this patch. 
> 
> Mikulas are you?  Alasdair would like both "pros" and "cons" documented
> in the patch header.
> 
> Here is a revised patch header that now documents why this patch is a
> prerequisite for snapshot-merge (specifically this patch:
> http://patchwork.kernel.org/patch/60708/):
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> The previous code selected one exception as "primary_pe", linked all
> other exceptions on it and used reference counting to wait until all
> exceptions are reallocated.
> 
> All the complexity with exceptions linking and reference counting has
> been removed.  Now, a bio is linked to one exception and when that
> exception is reallocated, the bio is retried to possibly wait for other
> exceptions.
> 
> The new __origin_write() interface affords the snapshot-merge support,
> snapshot_merge_process() specifically, the ability to trigger exceptions
> in other snapshots without having a need for an associated bio (which
> snapshot-merge does not generate).  As such this patch is a prerequisite
> for snapshot-merge.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
