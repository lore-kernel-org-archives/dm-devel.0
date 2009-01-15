From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: DM kernel interface
Date: Thu, 15 Jan 2009 18:34:21 +0000
Message-ID: <20090115183421.GX1804@agk.fab.redhat.com>
References: <496F0D7A0200000D017159D6@lucius.provo.novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <496F0D7A0200000D017159D6@lucius.provo.novell.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 15, 2009 at 10:18:34AM -0700, Allen Jack wrote:
> Is there a direct device mapper interface in kernel space that I can use to
> get the object information from?  For example, I need to see the target
> mappings within a linear object.
 
#include <linux/device-mapper.h>

(But why do you need to do this?)

Alasdair
-- 
agk@redhat.com
