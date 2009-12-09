From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 0/4] dm-replicator: introduce new remote
	replication target
Date: Wed, 9 Dec 2009 05:39:41 -0500
Message-ID: <20091209103941.GA920@infradead.org>
References: <1259683507-12455-1-git-send-email-heinzm@redhat.com>
	<20091201164142.GL19238@suse.de> <1259687919.9639.15.camel@o>
	<1260297747.4147.30.camel@mulgrave.site>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1260297747.4147.30.camel@mulgrave.site>
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
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

On Tue, Dec 08, 2009 at 12:42:27PM -0600, James Bottomley wrote:
> Could I just echo Lars' statement.  With the upstream inclusion of drbd,
> dm-replicator becomes a *third* replication system asking to be in
> kernel.  It is definitely a kernel policy question of whether we want
> three separate replicators, and so should be Cc'd to lkml so that people
> interested in that can weigh in.

And unliley the previous two this one actually offers the benefit of
beeing integrated with our major block device management framework.

Interesting that the question comes up now after I was shot down for it
in the drbd discussion.
