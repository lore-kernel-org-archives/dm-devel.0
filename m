From: Bas Mevissen <abuse@basmevissen.nl>
Subject: Re: dmraid ./dmraid.spec lib/version.h lib/misc/li ...
Date: Wed, 17 Feb 2010 15:07:21 +0100
Message-ID: <1266415641.24106.37.camel@msdes019.mapscape.nl>
References: <20100217115155.28893.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100217115155.28893.qmail@sourceware.org>
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
List-Id: dm-devel.ids

On Wed, 2010-02-17 at 11:51 +0000, heinzm@sourceware.org wrote:

> Log message:
> 	Change library version to '1' and enhance display of internal extended version
> 

Maybe making the DSO version (and possibly all version info) an autoconf
parameter? This avoids spreading the DSO number through multiple files.

Best Regards,

Bas.
