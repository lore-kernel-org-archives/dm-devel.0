From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1 of 29] dm-snap-rename-dm_snap_exception.patch
Date: Tue, 17 Mar 2009 17:07:36 +0000
Message-ID: <20090317170736.GK3063@agk.fab.redhat.com>
References: <200903171402.n2HE2LMR017324@hydrogen.msp.redhat.com>
	<20090317165436.GA17085@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090317165436.GA17085@infradead.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Mar 17, 2009 at 12:54:36PM -0400, Christoph Hellwig wrote:
> Can you give your patches proper Subject lines?
> E.g. for this one:
> Subject: [PATCH 1/29] dm: rename dm_snap_exception to dm_exception
 
Here's the perl I use, if it's any help to you.
        $tidyname =~ s/\.patch//;
        $tidyname =~ s/-/ /g;
	$tidyname =~ s/(dm( (crypt|delay|exception store|ioctl|io|kcopyd|log|mpath|raid1|snapshot|table|target|request)|))/\1:/;

Alasdair
-- 
agk@redhat.com
