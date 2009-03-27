From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm: Data integrity support
Date: Fri, 27 Mar 2009 21:20:30 +0000
Message-ID: <20090327212030.GV13664@agk.fab.redhat.com>
References: <yq1sklm9h1e.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1sklm9h1e.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 09, 2009 at 11:46:05PM -0400, Martin K. Petersen wrote:
> This patch requires a change in Jens' for-linus branch that adds a GFP
> mask to bio_integrity_clone() and obsoletes the bio_set argument.
 
I've not had the chance to track down that patch, but if you can note
in this thread when it's hit Linus's tree, then I'll submit this one
behind it.

Alasdair
-- 
agk@redhat.com
