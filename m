From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Tue, 7 Nov 2006 15:00:17 -0800
Message-ID: <20061107150017.fb78a327.akpm@osdl.org>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<20061107122837.54828e24.akpm@osdl.org>
	<45510C73.7060408@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <45510C73.7060408@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: dm-devel@redhat.com, Ingo Molnar <mingo@elte.hu>, Srinivasa DS <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, 07 Nov 2006 16:45:07 -0600
Eric Sandeen <sandeen@redhat.com> wrote:

> Andrew Morton wrote:
> 
> >> --- linux-2.6.19-rc4.orig/fs/buffer.c	2006-11-07 17:06:20.000000000 +0000
> >> +++ linux-2.6.19-rc4/fs/buffer.c	2006-11-07 17:26:04.000000000 +0000
> >> @@ -188,7 +188,9 @@ struct super_block *freeze_bdev(struct b
> >>  {
> >>  	struct super_block *sb;
> >>  
> >> -	mutex_lock(&bdev->bd_mount_mutex);
> >> +	if (down_trylock(&bdev->bd_mount_sem))
> >> +		return -EBUSY;
> >> +
> > 
> > This is a functional change which isn't described in the changelog.  What's
> > happening here?
> 
> Only allow one bdev-freezer in at a time, rather than queueing them up?
> 

You're asking me? ;)

Guys, I'm going to park this patch pending a full description of what it
does, a description of what the above hunk is doing and pending an
examination of whether we'd be better off changing the mutex-debugging code
rather than switching to semaphores.
