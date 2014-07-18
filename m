From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath: Accept failed paths for multipath maps
Date: Thu, 17 Jul 2014 22:18:06 -0400
Message-ID: <20140718021806.GA1143@redhat.com>
References: <1387353155-7271-1-git-send-email-hare@suse.de>
	<20131218140858.GC17730@redhat.com> <52B1B046.3040301@suse.de>
	<1387380498.7608.6.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<20140718000411.GB337@redhat.com>
	<8A51900D08212F40B3DE22453052F69839C46AF4@wdscexmb02>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <8A51900D08212F40B3DE22453052F69839C46AF4@wdscexmb02>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Utz <John.Utz@wdc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Bryn Reeves <breeves@redhat.com>, "Stewart,
	Sean" <Sean.Stewart@netapp.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Jul 17 2014 at  8:29pm -0400,
John Utz <John.Utz@wdc.com> wrote:

> What are the release testing criteria for things like this? From a
> hand wavy perspective i am sure that the meta-requirement is 'don't
> break anything'. but how is a new release proven to not break
> anything?

Red Hat and other vendors have their own testbeds and harnesses for
testing dm-multipath.  But we really could benefit from more open
exchange and collaboration of a multipath test harness.

Had I actually tested the patches I pointed to it'd have blown up
pretty solidly, I realized something like this was needed:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=throwaway-dm-mpath-placeholder-devs&id=77d1130e602a399ed1451edd7e91044fe9225fb6

Anyway, I really don't like that 'place-holder device' approach.. way
too hackish (both my code and Hannes').  It is an elaborate workaround
rather than a proper solution.  I'm hopeful Bryn takes this multipath
problem under his wing and fixes it for real ;)

> fer instance, does anybody create dm devices, format them with XFS and
> then run xfstests against them?

We routinely use XFS and ext4 with git to generate load.  But not
xfstests... that may be useful.

> or some other formalized regimen?
> 
> or is it all kinda ad-hoc?

We have the device-mapper-test-suite (dmts) for testing various DM
targets (mainly dm-thinp and dm-cache), see:
https://github.com/jthornber/device-mapper-test-suite

I added basic support for dm-crypt to dmts; but it needs serious
expanding for it to be useful.. luckily the cryptsetup userspace code
has dm-crypt tests.

Also, the lvm2 testsuite is another major resource that is used for
testing the wide range of DM targets.
