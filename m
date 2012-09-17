From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v2] dm table: do not allow queue limits
	that	will exceed hardware limits
Date: Mon, 17 Sep 2012 20:52:33 +0100
Message-ID: <20120917195233.GE16447@agk-dp.fab.redhat.com>
References: <20120914204133.GA376@redhat.com>
	<213748621.1049831.1347911069189.JavaMail.root@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <213748621.1049831.1347911069189.JavaMail.root@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Mon, Sep 17, 2012 at 03:44:29PM -0400, David Jeffery wrote:
> Instead of setting to defaults, how about maintaining previous limits?
> The initial queue setup sets defaults when a queue is first configured,
> and this maintains known, working limits if all paths are temporarly
> lost.  For example, I have a test setup with a lower than normal max
> segment list.  It can fail a test with the previous patch as the
> default limits exceed the hardware limits. But this setup will work if
> we leave queue limits unchanged in the special case of there being no
> target devices.
 
Firstly, the problem cannot be fixed completely - so let's make sure the
patch header doesn't claim that, and does explain how different
situations are handled and why.

Secondly, it's a mpath problem, so the solution should be a patch to 
dm-mpath that does NOT change the way any non-mpath dm devices are handled.

Now my question is whether this can be fixed adequately within the existing
interface, or whether userspace needs the ability to control whether
limits are reset or not (either by message or ioctl flag).

Alasdair
