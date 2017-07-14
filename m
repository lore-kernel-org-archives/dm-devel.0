From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH 1/4] libmultipath: get_udev_uid: make sure
 pp->wwid is 0-terminated
Date: Fri, 14 Jul 2017 23:21:20 +0200
Message-ID: <1500067280.4808.27.camel@suse.de>
References: <20170714113209.17177-1-mwilck@suse.com>
	<20170714113209.17177-2-mwilck@suse.com>
	<1500044188.2662.4.camel@wdc.com>
	<1500060099.4808.21.camel@suse.de> <1500063703.2662.9.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1500063703.2662.9.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "bmarzins@redhat.com" <bmarzins@redhat.com>, "tang.junhui@zte.com.cn" <tang.junhui@zte.com.cn>, "hare@suse.de" <hare@suse.de>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>, "guanjunxiong@huawei.com" <guanjunxiong@huawei.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: dm-devel.ids

On Fri, 2017-07-14 at 20:21 +0000, Bart Van Assche wrote:
> On Fri, 2017-07-14 at 21:21 +0200, Martin Wilck wrote:
> > 
> > Let's have a strncpy vs. strlcpy discussion :D !
> > 
> > I can do this if you insist, but I don't see a big benefit. We've
> > tested with the patch I submitted.
> 
> My comments were not intended as an invitation to open a strncpy()
> vs. strlcpy()
> discussion. What I wanted to illustrate with the above patch is that
> when using
> strlcpy() it is not necessary to explicitly zero-terminate a string
> because
> strlcpy() guarantees zero-termination. Compact code that is as
> readable as more
> verbose code is always better because compact code is easier to
> verify.

OK. I'll wait for comments on the other patches, and change v2 of this
patch to your version.

Martin
