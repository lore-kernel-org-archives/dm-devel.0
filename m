From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm snapshot: allow live exception store handover
	between tables
Date: Fri, 6 Nov 2009 19:41:36 +0000
Message-ID: <20091106194136.GT13375@agk-dp.fab.redhat.com>
References: <1257532814-17100-1-git-send-email-snitzer@redhat.com>
	<20091106184642.GC13427@redhat.com>
	<20091106192620.GD13427@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091106192620.GD13427@redhat.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Fri, Nov 06, 2009 at 02:26:21PM -0500, Mike Snitzer wrote:
> OK, actually in practice 'lvchange --refresh' is:
> old->suspend
> new->ctr

Those two need to be swapped.
(I think it's a pre-existing userspace bug that's simple to fix.)

> old->resume
>  - device-mapper: snapshots: Unable to handover exceptions to another snapshot on resume.
> new->resume
>  - snapshot_resume: handing over exceptions

Handover to new device and make it live first, then remove old device.
It doesn't make sense to me to remove the old device before the new one has
successfully taken over from it.
 
Alasdair
