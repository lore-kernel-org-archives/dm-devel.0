From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH v4 00/19] Misc Multipath patches
Date: Wed, 10 Oct 2018 09:25:07 +0200
Message-ID: <23e6ed4f277880bb47528f44fe66bd5fcbcf9ad2.camel@suse.de>
References: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
	<095f24f4a6273d5861b79d9dc1d88ed393c907d7.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <095f24f4a6273d5861b79d9dc1d88ed393c907d7.camel@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2018-10-10 at 09:19 +0200, Martin Wilck wrote:
> On Tue, 2018-10-09 at 18:02 -0500, Benjamin Marzinski wrote:
> > This batch is a resend of v4, rebased on the latest upstream code
> > with
> > changes base on Martin's review
> > 
> > Changes in v4
> > 	0001-libmultipath-fix-tur-checker-timeout.patch now fails back
> > 	to synchronous mode if the thread was cancelled but continues
> > to
> > 	run.  Since this is an unlikely event, I decided that it made
> > 	more sense to not complicate the existing thread
> > synchronization
> > 	code to allow multiple threads. However, if someone else want's
> > 	to make those changes, I'm open to the idea.
> > 
> > 	0002-libmultipath-fix-tur-checker-double-locking.patch now
> > saves
> > 	dev_t instead of a string in the checker context, as suggested
> > 	by Martin
> > 
> > 	The only differences in patches 0003-0005 are that they are
> > 	rebased on top of the new patches 0001-0002, but I took off
> > 	Martin's Reviewed-by (just it case I messed something up when
> > 	rebasing them).
> 
> For the whole series except 01/19:
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> (I believe minor rebasing would be necessary if my suggested change
> for
> 01/19 is applied).

I just realized that Christophe already applied the whole series. So
I'll send my own suggestions as patches on top of this.

Martin
