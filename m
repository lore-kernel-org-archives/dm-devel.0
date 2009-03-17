From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1 of 29] dm-snap-rename-dm_snap_exception.patch
Date: Tue, 17 Mar 2009 12:54:36 -0400
Message-ID: <20090317165436.GA17085@infradead.org>
References: <200903171402.n2HE2LMR017324@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200903171402.n2HE2LMR017324@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Mar 17, 2009 at 09:02:21AM -0500, Jonathan Brassow wrote:
> The exception structure is not necessarily just a snapshot
> element (especially after we pull it out of dm-snap.c).
> 
> Renaming appropriately.

Can you give your patches proper Subject lines?

E.g. for this one:

Subject: [PATCH 1/29] dm: rename dm_snap_exception to dm_exception
