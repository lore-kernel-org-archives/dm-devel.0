From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v4 1/2] dm: prevent table type changes
	after	initial table load
Date: Tue, 29 Jun 2010 15:19:20 +0100
Message-ID: <20100629141920.GF23989@agk-dp.fab.redhat.com>
References: <1274964469-22289-1-git-send-email-snitzer@redhat.com>
	<1274964469-22289-2-git-send-email-snitzer@redhat.com>
	<20100629114040.GE23989@agk-dp.fab.redhat.com>
	<20100629135217.GB28705@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100629135217.GB28705@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Tue, Jun 29, 2010 at 09:52:17AM -0400, Mike Snitzer wrote:
> As we talked about on irc.  There is potential for do_resume() to
> destage the "inactive" table slot, in the process of making the table
> "live", and in parallel another table load can arrive to stage another
> "inactive" table (which can have a conflicting type).  

But the type already got set earlier and, once set, is an immutable table
property.  There cannot be conflicts with do_resume - it doesn't touch
this.

Alasdair
