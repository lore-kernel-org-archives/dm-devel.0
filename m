From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 07/11] [dm-thin] Commit every second to
 prevent too much of a position building up.
Date: Fri, 10 Feb 2012 09:55:22 -0500
Message-ID: <20120210145520.GB32379@redhat.com>
References: <1328200754-13642-1-git-send-email-ejt@redhat.com>
	<1328200754-13642-8-git-send-email-ejt@redhat.com>
	<20120207165319.GA27715@redhat.com> <20120210144757.GA8599@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120210144757.GA8599@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 10 2012 at  9:48am -0500,
Joe Thornber <thornber@redhat.com> wrote:

> On Tue, Feb 07, 2012 at 11:53:25AM -0500, Mike Snitzer wrote:
> > Shouldn't this be:
> > 
> > 	if (bio_list_empty(&bios) || !need_commit_due_to_time(pool))
> > 		return;
> > 
> > ?
> 
> I don't think so.  It's saying 'if <there's no reason to commit>'.  The reasons to commit are bios being non-empty or need_commit_due_to_time.
> 
> reason to commit = !bio_list_empty(&bios) || need_commit_due_to_time(pool)
> !reason_to_commit = !(!bio_list_empty(&bios) || need_commit_due_to_time(pool))
> !reason_to_commit = (bio_list_empty(&bios) && !need_commit_due_to_time(pool))
> 
> Agree?

Yeap, I followed up saying something like nevermind.
 
> > Also, should we make the commit interval tunable (akin to ext[34]'s
> > 'commit' mount option)?  Or did you defer doing so until it proves
> > worthwhile?
> 
> y, tunable is on the list.  Every second will do for now though.

OK.
