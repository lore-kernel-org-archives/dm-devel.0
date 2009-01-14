From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: merging dm-ioband into Linux
Date: Wed, 14 Jan 2009 02:23:33 +0000
Message-ID: <20090114022332.GT1804@agk.fab.redhat.com>
References: <20090105.225124.193700534.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090105.225124.193700534.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jan 05, 2009 at 10:51:24PM +0900, Ryo Tsuruta wrote:
> I know you are very very busy, but could you do me a favor and
> respond to my email?
 
I'm starting to use patchwork.

The same applies to anyone else with patches I haven't picked up yet.

Please read the message 'Patchwork and patch flow'.

Check the patches apply at the 'mm' level of my quilt series file
then resend them to this list so patchwork picks them up.

If there are dependencies on other patches that are not in Linus's git,
optional or not, send those patches to this list too with explanation
about the route they will take upstream (e.g. "currently in -mm")
and make sure subject lines are consistent.

Then try to find some more people willing to put their name to them and
comment on them in the threads and add 'Reviewed-by' and 'Tested-by'
lines.

Alasdair
-- 
agk@redhat.com
