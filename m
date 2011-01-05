From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 0/8] dm-raid (raid456) target
Date: Wed, 5 Jan 2011 17:36:29 -0500
Message-ID: <20110105223628.GA13164@redhat.com>
References: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
 <20101221141443.5aea0b12@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101221141443.5aea0b12@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: jbrassow@redhat.com, agk@redhat.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Dec 20 2010 at 10:14pm -0500,
Neil Brown <neilb@suse.de> wrote:

> On Mon, 20 Dec 2010 21:37:37 -0500 Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > I reviewed all patches and adjusted patch headers in preparation for
> > inclusion in Alasdair's tree (upstream target being v2.6.38).  The 2
> > md/bitmap changes can obviously go through Neil's MD tree if that is
> > preferred.
> > 
> > - added Copyright to the top of dm-raid.c
> > - fixed drivers/md/Kconfig so that DM_RAID will select MD_RAID456
> > - removed unused 'conf' variable in raid_status()
> > - few misc style and whitespace changes
> > 
> > Neil,
> > Hopefully you're comfortable with the authorship of most of these
> > patches still being attributed to you (despite Jon's changes to your
> > original patches).
> > 
> > Please advise, thanks!
> 
> I haven't had a chance to have a proper look yet, and I'm about to go on
> leave for a couple of weeks.
> I'm probably happy with the authorship remaining as-is, but I reserve the
> right to change my mind (about anything) once I've had a chance to have a
> proper look.

Hi Neil,

Please advise on how you'd like things to proceed with this initial 8
patch set.  Ideally we'd get them in to linux-next now and ultimately
2.6.38 before the merge window closes.

Thanks,
Mike
