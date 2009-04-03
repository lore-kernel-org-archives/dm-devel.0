From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: [PATCH] Miscellaneous multipath bugfixes
Date: Fri, 3 Apr 2009 10:49:07 -0400
Message-ID: <20090403144907.GB26508@mars.virtualiron.com>
References: <20090403044419.GW15911@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090403044419.GW15911@ether.msp.redhat.com>
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

On Thu, Apr 02, 2009 at 11:44:19PM -0500, Benjamin Marzinski wrote:
> This is mostly a cleanup of some bugs that recently got introduced. In
> ACT_RESIZE we were trying to create a read-only device before we tried
> to create a read/write one (I also added the ability to fail back to
> read-only in ACT_RELOAD).  There were some printouts that I assume were
> for debugging, and some duplicate code.  And I switched it so that
> dm_simplecmd_flush did flushing, and dm_simplecmd_noflush didn't.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Acked-by: Konrad Rzeszutek <konrad@virtualiron.com>
