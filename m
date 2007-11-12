From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [RFC] How to fix system stall on root volume multipath
Date: Mon, 12 Nov 2007 11:24:54 -0500 (EST)
Message-ID: <20071112.112454.71086888.k-ueda@ct.jp.nec.com>
References: <20071109.181719.115904569.k-ueda@ct.jp.nec.com>
	<20071110033113.GA22843@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071110033113.GA22843@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, bmarzins@redhat.com, christophe.varoqui@free.fr
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Alasdair,

On Sat, 10 Nov 2007 03:31:13 +0000, Alasdair G Kergon <agk@redhat.com> wrote:
> On Fri, Nov 09, 2007 at 06:17:19PM -0500, Kiyoshi Ueda wrote:
> > If we use multipath for "/", temporal all-paths failure could lead to
> > system stall because multipathd depends on callout programs on "/".
> > I would like to hear your comments about my idea to fix it.
>  
> I thought it avoided that problem by pre-loading everything into a ramdisk:
> did that code get dropped for some reason?

Thank you for the information!  I had forgotten it!
Yes, we used to have it, and it seems to be removed by the commit below:
    http://git.kernel.org/gitweb.cgi?p=linux/storage/multipath-tools/.git;a=commitdiff;h=cad20ecf8919b2126ab6f4f793a1a738e9864f59

And probably the following thread is related to the commit.
    https://www.redhat.com/archives/dm-devel/2005-July/msg00044.html


Ben, Christophe,
Is that code still problem for current multipathd?
And what do you think about my proposal?

Thanks,
Kiyoshi Ueda
