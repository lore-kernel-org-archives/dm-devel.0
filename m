From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
Date: Tue, 29 Nov 2011 13:18:11 +0000
Message-ID: <20111129131811.GS7595@agk-dp.fab.redhat.com>
References: <20111128150400.GE6366@quack.suse.cz> <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com> <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com> <20111129101901.GA5635@quack.suse.cz> <20111129102156.GA7463@quack.suse.cz> <Pine.LNX.4.64.1111290556270.12274@hs20-bc2-1.build.redhat.com> <20111129111136.GC5635@quack.suse.cz> <Pine.LNX.4.64.1111290746230.10352@hs20-bc2-1.build.redhat.com> <20111129130913.GE5635@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111129130913.GE5635@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Mikulas Patocka <mpatocka@redhat.com>, esandeen@redhat.com, Surbhi Palande <csurbhi@gmail.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Christopher Chaltain <christopher.chaltain@canonical.com>, Valerie Aurora <val@vaaconsulting.com>
List-Id: dm-devel.ids

On Tue, Nov 29, 2011 at 02:09:13PM +0100, Jan Kara wrote:
>   Hmm, then why do these operations suspend the filesystem if they
> apparently don't need it? Sorry for my ignorance, I never seriously worked
> with LVM code...

They don't suspend it if they don't need to.

dm-ioctl.h:
/*
 * Set this to avoid attempting to freeze any filesystem when suspending.
 */
#define DM_SKIP_LOCKFS_FLAG     (1 << 10) /* In */

Alasdair
 
