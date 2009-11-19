From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 00/12] snapshot-merge target
Date: Thu, 19 Nov 2009 09:02:33 -0500
Message-ID: <20091119140233.GA3894@redhat.com>
References: <1258474344-10886-1-git-send-email-snitzer@redhat.com>
	<87y6m24uyk.fsf@basil.nowhere.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87y6m24uyk.fsf@basil.nowhere.org>
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
Cc: Andi Kleen <andi@firstfloor.org>
List-Id: dm-devel.ids

On Thu, Nov 19 2009 at  6:25am -0500,
Andi Kleen <andi@firstfloor.org> wrote:

> Mike Snitzer <snitzer@redhat.com> writes:
> 
> > snapshot-merge target, quilt tree is maintained here:
> > http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel/2.6.33/
> 
> It might seem trivial to you, but afaik nothing in the whole series
> (nor in the comments in the code) says what snapshot merging
> actually is. Please write meaningful changelogs and comments.

OK, I hadn't noticed because I was so focused on the details.

DM (and LVM) snapshot merging allows a snapshot (its COW store) to be
merged back into the snapshot's origin device.

One expected use of snapshot merging is rollback of a root filesystem
after system upgrades (e.g.: yum update).

Mike
