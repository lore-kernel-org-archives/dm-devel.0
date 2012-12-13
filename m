From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Another cache target
Date: Thu, 13 Dec 2012 16:57:15 -0500
Message-ID: <20121213215715.GA19419@redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1355429956-22785-1-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Dec 13 2012 at  3:19pm -0500,
Joe Thornber <ejt@redhat.com> wrote:

> Here's a cache target that Heinz Mauelshagen, Mike Snitzer and I
> have been working on.
> 
> It's also available in the thin-dev branch of my git tree:
> 
> git@github.com:jthornber/linux-2.6.git

This url is best for others to clone from:
git://github.com/jthornber/linux-2.6.git

> The main features are a plug-in architecture for policies which decide
> what data gets cached, and reuse of the metadata library from the thin
> provisioning target.

It should be noted that there are more cache replacement policies
available in Joe's thin-dev branch via the "basic" policy, see:
drivers/md/dm-cache-policy-basic.c

(these basic policies include fifo, lru, lfu, and many more)
 
> These patches apply on top of the dm patches that agk has got queued
> for 3.8.

agk's patches are here:
http://people.redhat.com/agk/patches/linux/editing/series.html

But agk hasn't staged all the required patches yet.  I've imported agk's
editing tree (and a couple other required patches that I previously
posted to dm-devel, which aren't yet in agk's tree) into the
'dm-for-3.8' branch on my github tree here:
git://github.com/snitm/linux.git

This 8 patch patchset from Joe should apply cleanly ontop of my
'dm-for-3.8' branch.

But if all you care about is a tree with all the changes then please
just use Joe's github 'thin-dev' branch.
