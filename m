From: Chen Zumeng <zumeng.chen@windriver.com>
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.8.0: Introduction
Date: Wed, 22 Oct 2008 16:12:21 +0800
Message-ID: <48FEE065.20406@windriver.com>
References: <20081017.160950.71109894.ryov@valinux.co.jp>	<48FDB8AC.9020707@windriver.com>	<48FEDC63.308@windriver.com> <20081022.170536.193712541.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754356AbYJVIP2@vger.kernel.org>
In-Reply-To: <20081022.170536.193712541.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryo Tsuruta <ryov@valinux.co.jp>, haotian.zhang@windriver.com
Cc: bruce.ashfield@windriver.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp
List-Id: dm-devel.ids

Ryo Tsuruta wrote:
> Hi Chen,
> 
>> Chen Zumeng wrote:
>>> Hi, Ryo Tsuruta
>>> And our test team want to test bio_tracking as your benchmark reports,
>>> so would you please send me your test codes? Thanks in advance.
>> Hi Ryo Tsuruta,
>>
>> I wonder if you received last email, so I reply this email to ask
>> for your bio_tracking test codes to generate your benchmark reports
>> as shown in your website. Thanks in advance :)
Thanks for you quick reply :)

Regards,
Zumeng
> 
> I've uploaded two scripts here:
> http://people.valinux.co.jp/~ryov/dm-ioband/scripts/xdd-count.sh
> http://people.valinux.co.jp/~ryov/dm-ioband/scripts/xdd-size.sh
> 
> xdd-count.sh controls bandwidth based on the number of I/O requests,
> and xdd-size.sh controls bandwidth based onthe number of I/O sectors.
> Theses scritpts require xdd disk I/O testing tool which can be
> downloaded from here:
> http://www.ioperformance.com/products.htm
> 
> Please feel free to ask me questions if you have any questions.
OK thanks.
> 
>>> P.S. The following are my changes to avoid schedule_timeout:
> 
> Thanks, but your patch seems to cause a problem when ioband devices
> which have the same name are created at the same time. I will fix the
> issue in the next release.
Maybe, hoping your next release :)

Zumeng
> 
> Thanks,
> Ryo Tsuruta
> 
