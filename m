From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Unable to delete snapshots
Date: Thu, 7 Apr 2005 13:47:19 +0100
Message-ID: <20050407124719.GQ9049@agk.surrey.redhat.com>
References: <425463D0.5232BE61@polymtl.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <425463D0.5232BE61@polymtl.ca>
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

On Wed, Apr 06, 2005 at 06:33:52PM -0400, Christian Robert wrote:
> Last thing I did two weeks ago was to add a logical volume and a snapshot
> to this logical volume. ( so I went from 63 logical volumes to 65 )
 
> device-mapper: Could not create kcopyd client
> device-mapper: error adding target to table

You've almost certainly run out of kernel memory.
(e.g. add more RAM)

(Some work is underway to reduce the resource usage and make
things more predictable etc.)

Alasdair
