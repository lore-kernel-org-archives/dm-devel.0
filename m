From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH] raid1: use __GFP_NOFAIL
Date: Fri, 1 May 2009 19:15:59 +0100
Message-ID: <20090501181559.GF23302@agk.fab.redhat.com>
References: <Pine.LNX.4.64.0904270658390.12384@hs20-bc2-1.build.redhat.com>
	<20090430231443.GD23302@agk.fab.redhat.com>
	<Pine.LNX.4.64.0905010801490.16859@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905010801490.16859@hs20-bc2-1.build.redhat.com>
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

On Fri, May 01, 2009 at 08:04:12AM -0400, Mikulas Patocka wrote:
> As I said on chat, don't remove that GFP_IO allocation. The code is 
> deadlocky anyway and allocation from a mempool with GFP_ATOMIC and, in 
> case of failure, allocation from memory with GFP_IO is the best that can 
> be done to reduce the probability of the deadlock.
 
OK - I'll apply this one pending a more-complicated fix that uses the
mempool correctly.

Alasdair
-- 
agk@redhat.com
