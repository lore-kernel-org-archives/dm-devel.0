From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [git pull] device mapper fixes for 4.10-rc7
Date: Mon, 6 Feb 2017 15:48:31 -0500
Message-ID: <20170206204831.GA24338@redhat.com>
References: <20170203191108.GA3796@redhat.com>
	<CA+55aFytrfm+kGWNPdg4PYHtZhx4kVn+EJDcLMskRhVwemzROw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CA+55aFytrfm+kGWNPdg4PYHtZhx4kVn+EJDcLMskRhVwemzROw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ondrej Kozina <okozina@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 03 2017 at  7:18pm -0500,
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Feb 3, 2017 at 11:11 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> > are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-4.10-fixes
> 
> Hmm.
> 
>    "fatal: Couldn't find remote ref dm-4.10-fixes"
> 
> Forgot to push?  And why didn't git pull-request warn about it? Have
> you cooked up your own broken script for this?

I did forget to push, sorry about that, now pushed.

As for why git-request-pull didn't warn.  I used this commandline:
git request-pull v4.10-rc6 git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-4.10-fixes | tee dm-4.10-fixes-pull.txt

I just did a test with a local dm-4.10-test tag that I didn't push and
sure enough I _do_ get a warning.  But that warning went to stderr and
I just missed it.  I'll improve my workflow to check the error code of
the git-request-pull first. And then re-run to output to a text file.

> There is a "dm-4.10" branch with that commit, but iirc you usually
> have signed tags so I suspect it really is a missed push, not a wrong
> name.

Right, just missed the push, I always do signed tags.

Thanks,
Mike
