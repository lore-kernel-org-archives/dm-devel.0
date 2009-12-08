From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 0/4] dm-replicator: introduce new remote
	replication target
Date: Tue, 08 Dec 2009 12:42:27 -0600
Message-ID: <1260297747.4147.30.camel@mulgrave.site>
References: <1259683507-12455-1-git-send-email-heinzm@redhat.com>
	<20091201164142.GL19238@suse.de>  <1259687919.9639.15.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1259687919.9639.15.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2009-12-01 at 18:18 +0100, Heinz Mauelshagen wrote:
> On Tue, 2009-12-01 at 17:41 +0100, Lars Marowsky-Bree wrote:
> > On 2009-12-01T17:05:03, heinzm@redhat.com wrote: 
> > > Please review for upstream inclusion.
> > 
> > Should this not be Cc'ed to LKML if you aim for upstream inclusion? I
> > actually would expect that most of the criticism of drbd's inclusion
> > would also apply here, no? (With the added point that dm-replicator does
> > not actually have any users yet.)
> 
> We have a series of patches to sort out basic issues on dm-devel.
> The usual process is, that agk as the subsystem maintainer integrates
> and upstreams it.

Could I just echo Lars' statement.  With the upstream inclusion of drbd,
dm-replicator becomes a *third* replication system asking to be in
kernel.  It is definitely a kernel policy question of whether we want
three separate replicators, and so should be Cc'd to lkml so that people
interested in that can weigh in.

James
