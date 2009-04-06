From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2/3] kcopyd+snapshots race condition
Date: Mon, 6 Apr 2009 20:39:44 +0100
Message-ID: <20090406193944.GC5688@agk.fab.redhat.com>
References: <20090316190642.GH5098@agk.fab.redhat.com>
	<Pine.LNX.4.64.0903170920000.26754@hs20-bc2-1.build.redhat.com>
	<20090317203838.GQ3063@agk.fab.redhat.com>
	<Pine.LNX.4.64.0903181913260.25113@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0903181914120.25113@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903181914120.25113@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Mar 18, 2009 at 07:14:42PM -0400, Mikulas Patocka wrote:
> Test for job->pages being zero. This will be needed for the next patch.
 
Queued to linux-next (+stable).

Alasdair
-- 
agk@redhat.com
