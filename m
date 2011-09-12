From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] select STACKTRACE if using it
Date: Mon, 12 Sep 2011 14:51:47 +0100
Message-ID: <20110912135146.GA14861@ubuntu>
References: <Pine.LNX.4.64.1109120703190.10238@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1109120703190.10238@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Sep 12, 2011 at 07:05:31AM -0400, Mikulas Patocka wrote:
> dm-thinp: select STACKTRACE if using it
> 
> This patch selects option "STACKTRACE" if dm-thinp uses it. If we don't 
> select this option, it isn't included in the kernel and dm-thinp can't be 
> compiled.
> 
> Mikulas
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

thx
