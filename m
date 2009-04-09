From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Barriers still not passing on simple dm devices...
Date: Thu, 9 Apr 2009 11:28:51 +0100
Message-ID: <20090409102851.GT5688@agk.fab.redhat.com>
References: <Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com>
	<20090325152751.GV27476@kernel.dk>
	<Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>
	<20090326084205.GG27476@kernel.dk>
	<Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com>
	<20090331104933.GJ5178@kernel.dk>
	<Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com>
	<20090403081131.GP5178@kernel.dk>
	<Pine.LNX.4.64.0904080855340.28196@hs20-bc2-1.build.redhat.com>
	<1239240440.11220.3.camel@think.oraclecorp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1239240440.11220.3.camel@think.oraclecorp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chris Mason <chris.mason@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, ak@linux.intel.com, Mikulas Patocka <mpatocka@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

On Wed, Apr 08, 2009 at 09:27:20PM -0400, Chris Mason wrote:
> I'm afraid expecting barriers forever in the future isn't completely
> compatible with dm or md.  Both of these allow the storage to change
> over time, and the filesystem needs to handle this without corruptions.
 
The missing piece of the jigsaw is notification to upper layers *ahead*
of such reconfigurations.  (We have similar notification issues when
devices are resized - the current approach is to leave the sysadmin
responsible for co-ordinating changes through userspace.)

Alasdair
-- 
agk@redhat.com
