From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] multipathd: fix SIGUSR2 handling
Date: Tue, 14 Mar 2017 23:29:52 +0000
Message-ID: <1489534179.2676.18.camel@sandisk.com>
References: <1482998174-11884-1-git-send-email-tang.junhui@zte.com.cn>
	<20170103185909.GB2732@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170103185909.GB2732@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <421A39BFD0E3954ABA464DA4D5E35D04@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "tang.junhui@zte.com.cn" <tang.junhui@zte.com.cn>
Cc: "zhang.kai16@zte.com.cn" <zhang.kai16@zte.com.cn>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "mwilck@suse.com" <mwilck@suse.com>
List-Id: dm-devel.ids

On Tue, 2017-01-03 at 12:59 -0600, Benjamin Marzinski wrote:
> On Thu, Dec 29, 2016 at 03:56:14PM +0800, tang.junhui@zte.com.cn wrote:
> > From: "tang.junhui" <tang.junhui@zte.com.cn>
> > 
> > SIGUSR2 is not blocked by default, it would cause bellow conflict
> > in removing of the last path:
> 
> ACK

Hello Christophe,

This patch was posted more than two months ago. Do you think it should
be reposted?

Thanks,

Bart.
