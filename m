From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Implement barrier support for single device
	DM devices
Date: Fri, 15 Feb 2008 12:20:02 +0000
Message-ID: <20080215122002.GM29914@agk.fab.redhat.com>
References: <20080215120821.GA8267@basil.nowhere.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080215120821.GA8267@basil.nowhere.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andi Kleen <andi@firstfloor.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Feb 15, 2008 at 01:08:21PM +0100, Andi Kleen wrote:
> Implement barrier support for single device DM devices
 
Thanks.  We've got some (more-invasive) dm patches in the works that
attempt to use flushing to emulate barriers where we can't just
pass them down like that.

Alasdair
-- 
agk@redhat.com
