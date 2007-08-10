From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [patch 05/11] dm-snap: remove SECTOR_SHIFT define
Date: Fri, 10 Aug 2007 21:38:54 +0100
Message-ID: <20070810203854.GG2064@agk.fab.redhat.com>
References: <20070810200204.455820246@suse.de>>
	<20070810200205.703776854@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070810200205.703776854@suse.de>
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

On Fri, Aug 10, 2007 at 10:02:09PM +0200, Jan Blunck wrote:
> Sector size on Linux is always 512 bytes. Don't even try to give the
> impression this is changeable.

If that's what worries you, add a comment next to the definition,
perhaps?

It's there so you can easily locate all the places within dm that
perform these conversions by using a simple search.  Searching for '9'
wouldn't be as easy.  (I don't know about other people, but I find the
code easier to read the way it is.)

BTW When changing one thing across the whole of dm, you may combine
the sub-component patches into a single patch.

Alasdair
-- 
agk@redhat.com
