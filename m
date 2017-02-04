From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper fixes for 4.10-rc7
Date: Fri, 3 Feb 2017 16:18:33 -0800
Message-ID: <CA+55aFytrfm+kGWNPdg4PYHtZhx4kVn+EJDcLMskRhVwemzROw@mail.gmail.com>
References: <20170203191108.GA3796@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170203191108.GA3796@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 3, 2017 at 11:11 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-4.10-fixes

Hmm.

   "fatal: Couldn't find remote ref dm-4.10-fixes"

Forgot to push?  And why didn't git pull-request warn about it? Have
you cooked up your own broken script for this?

There is a "dm-4.10" branch with that commit, but iirc you usually
have signed tags so I suspect it really is a missed push, not a wrong
name.

              Linus
