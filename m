From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipathd: use 0 for initial pg if there
 are no priority groups
Date: Thu, 21 Apr 2011 06:35:49 +0200
Message-ID: <1303360549.31314.70.camel@zezette>
References: <20110420212400.GA6114@redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110420212400.GA6114@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On mer., 2011-04-20 at 17:24 -0400, Mike Snitzer wrote:
> dm-multipath now accommodates a DM table that doesn't have any priority
> groups, see: http://git.kernel.org/linus/a490a07a67b7a37
> 
> That kernel change imposes that multipathd must pass 0 for the initial
> priority group if there aren't any priority groups (currently passes 1).
> 
> There is no need to check the multipath target version to decide whether
> to pass an initial_pg of 0 or 1 because until recently dm-multipath
> never accommodated a DM table with no priority groups.
> 
Applied.

-- 
Christophe Varoqui
OpenSVC - Software to scale
http://www.opensvc.com/
