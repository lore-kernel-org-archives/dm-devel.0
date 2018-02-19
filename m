From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: DM Regression in 4.16-rc1 - read() returns data when
	it shouldn't
Date: Mon, 19 Feb 2018 12:15:32 -0500
Message-ID: <20180219171531.GA27498@redhat.com>
References: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com>
	<5fca4e3f-536c-9c52-31bb-927e8ab5b6c8@leemhuis.info>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5fca4e3f-536c-9c52-31bb-927e8ab5b6c8@leemhuis.info>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, NeilBrown <neilb@suse.com>
List-Id: dm-devel.ids

On Mon, Feb 19 2018 at  8:44am -0500,
Thorsten Leemhuis <regressions@leemhuis.info> wrote:

> JFYI: This issues is tracked in the regression reports for Linux 4.16
> (http://bit.ly/lnxregrep416 ) with this id:
> 
> Linux-Regression-ID: lr#9e195f
> 
> Please include this line in the comment section of patches that are
> supposed to fix the issue. Please also mention the string once in other
> mailinglist threads or different bug tracking entries if you or someone
> else start to discuss the issue there. By including that string you make
> it a whole lot easier to track where an issue gets discussed and how far
> patches to fix it have made it. For more details on this please see
> here: http://bit.ly/lnxregtrackid
> 
> Thx for your help. Ciao, Thorsten

The fix was already merged by Linus on Friday, see:
git.kernel.org/linus/8dd601fa8317243be887458c49f6c29c2f3d719f

But moving forward I have no interest in sprinkling external metadata
references in Linux commit headers. 

Seems more like you're engineering something that gives you, and
possibly a select few others, meaning but that is make work for all
Linux maintainers.

Mike
