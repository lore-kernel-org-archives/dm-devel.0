From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Make the mq policy an alias for smq
Date: Fri, 26 Feb 2016 17:03:51 -0500
Message-ID: <20160226220351.GB27783@redhat.com>
References: <1455100523-16922-1-git-send-email-ejt@redhat.com>
	<20160211021305.GB4481@redhat.com> <20160211104130.GB5021@rh-vpn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160211104130.GB5021@rh-vpn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Feb 11 2016 at  5:41am -0500,
Joe Thornber <thornber@redhat.com> wrote:

> On Wed, Feb 10, 2016 at 09:13:05PM -0500, Mike Snitzer wrote:
> > Shouldn't get_policy()'s call to get_policy_once() resolve "mq" to be
> > "smq" if we just add this to the bottom of dm-cache-policy-smq?:
> > 
> > MODULE_ALIAS("dm-cache-mq");
> 
> Yes, you're right.  See my fixup patch.

Hmm, not seeing what you consider to be the latest fixed up version..
(nothing that sets: MODULE_ALIAS("dm-cache-mq") in smq.c)

But I've staged this in linux-next for 4.6, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=8cbd0cb8cca67baa3e430fb6d636613fdc1cee1a
