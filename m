From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC] How to fix system stall on root volume multipath
Date: Sat, 10 Nov 2007 03:31:13 +0000
Message-ID: <20071110033113.GA22843@agk.fab.redhat.com>
References: <20071109.181719.115904569.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20071109.181719.115904569.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Nov 09, 2007 at 06:17:19PM -0500, Kiyoshi Ueda wrote:
> If we use multipath for "/", temporal all-paths failure could lead to
> system stall because multipathd depends on callout programs on "/".
> I would like to hear your comments about my idea to fix it.
 
I thought it avoided that problem by pre-loading everything into a ramdisk:
did that code get dropped for some reason?

Alasdair
-- 
agk@redhat.com
