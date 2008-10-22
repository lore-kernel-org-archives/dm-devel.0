From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller
 v1.8.0: Introduction
Date: Wed, 22 Oct 2008 17:05:36 +0900 (JST)
Message-ID: <20081022.170536.193712541.ryov@valinux.co.jp>
References: <20081017.160950.71109894.ryov@valinux.co.jp>
	<48FDB8AC.9020707@windriver.com> <48FEDC63.308@windriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <48FEDC63.308@windriver.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: zumeng.chen@windriver.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, fernando@oss.ntt.co.jp, bruce.ashfield@windriver.com, haotian.zhang@windriver.com
List-Id: dm-devel.ids

Hi Chen,

> Chen Zumeng wrote:
> > Hi, Ryo Tsuruta
> > And our test team want to test bio_tracking as your benchmark reports,
> > so would you please send me your test codes? Thanks in advance.
> Hi Ryo Tsuruta,
> 
> I wonder if you received last email, so I reply this email to ask
> for your bio_tracking test codes to generate your benchmark reports
> as shown in your website. Thanks in advance :)

I've uploaded two scripts here:
http://people.valinux.co.jp/~ryov/dm-ioband/scripts/xdd-count.sh
http://people.valinux.co.jp/~ryov/dm-ioband/scripts/xdd-size.sh

xdd-count.sh controls bandwidth based on the number of I/O requests,
and xdd-size.sh controls bandwidth based onthe number of I/O sectors.
Theses scritpts require xdd disk I/O testing tool which can be
downloaded from here:
http://www.ioperformance.com/products.htm

Please feel free to ask me questions if you have any questions.

> > P.S. The following are my changes to avoid schedule_timeout:

Thanks, but your patch seems to cause a problem when ioband devices
which have the same name are created at the same time. I will fix the
issue in the next release.

Thanks,
Ryo Tsuruta
