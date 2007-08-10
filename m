From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [patch 03/11] dm-snap: Remove dead queued_bios code
Date: Fri, 10 Aug 2007 21:43:37 +0100
Message-ID: <20070810204337.GH2064@agk.fab.redhat.com>
References: <20070810200204.455820246@suse.de>>
	<20070810200205.299669010@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070810200205.299669010@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jan Blunck <jblunck@suse.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Aug 10, 2007 at 10:02:07PM +0200, Jan Blunck wrote:
> This patch removes the unused queued_bios handling code.
 
Well I'm going to leave this in for now (as one existing unfinished
patch series does build upon it).  We can include its removal as part of
your following patch series that no doubt replaces the functionality
with something better.

Alasdair
-- 
agk@redhat.com
