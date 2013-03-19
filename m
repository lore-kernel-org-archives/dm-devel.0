From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-cache: Add handle to contlr
	if	cache_create failed.
Date: Tue, 19 Mar 2013 00:44:00 +0000
Message-ID: <20130319004400.GE20480@agk-dp.fab.redhat.com>
References: <5139441C.7000309@gmail.com>
	<20130308021027.GV8913@agk.fab.redhat.com>
	<20130318231357.GA10638@blackbox.djwong.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130318231357.GA10638@blackbox.djwong.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, majianpeng <majianpeng@gmail.com>
List-Id: dm-devel.ids

On Mon, Mar 18, 2013 at 04:13:57PM -0700, Darrick J. Wong wrote:
> I realize dm-cache hasn't been in an upstream release yet, but could we add new
> fields at the end of the disk superblock?  

Updated here:
  http://people.redhat.com/agk/patches/linux/editing/dm-cache-policy-change-version-from-string-to-integer-set.patch

I presume this will now be compatible (just losing the hints the first time
after updating the kernel)?

> And after 3.9, maybe have some sort
> of guard too?
 
There's already a version number CACHE_VERSION.

I would hope the space after the superblock is automatically filled with zeros.
If not, that will need to be fixed too.

Alasdair
