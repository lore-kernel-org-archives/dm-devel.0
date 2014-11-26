From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: dm-writeboost: About inclusion into mainline
Date: Thu, 27 Nov 2014 00:02:15 +0900
Message-ID: <5475EB77.3050004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, corbet@lwn.net, masami.hiramatsu@gmail.com
List-Id: dm-devel.ids

Hi,

I am wondering what's the next step of dm-writeboost, my log-structured SSD-caching driver.
I want to discuss this.

I will start from introducing my activity on dm-writeboost.
It was more than a year ago that I proposed my dm-writeboost for staging.
Mike Snitzer, a maintainer of device-mapper, rejected it because dm-writeboost at that moment wasn't even suitable for staging.
(http://www.redhat.com/archives/dm-devel/2013-September/msg00075.html)
It is clear that the comment was really right. The code was actually terrible.
Since then, with helps of DM guys, dm-writeboost's design and implementation has been polished.
And it was included into Joe's linux-2.6 where he develops his drivers.
(https://github.com/jthornber/linux-2.6/tree/thin-dev/drivers/md)
I found some bugs and fixed them after this inclusion. I am confident the quality is good enough for staging.

Now, I can't find the way how I go over the wall.
It seems that third party drivers are rarely merged into the md.
The fact is, no third party driver (meaning proposed by other than RH) was included since I am involved with device-mapper, for 2 years.
I am really afraid dm-writeboost will never be into the md ever after.

In one sense, this sounds too conservative. New features are always rejected. As a result, third party developers, including me, are losing their willingness.
As you know, developing driver is a hard work and spend lot of time. Actually, I spent hundreds or thousands of my private hours on my driver (hoping that my driver will be included and become famous) but I am almost giving up dm-writeboost if it has no hope. I know, storage softwares should become safe-side but I also know that willingness is the only key for non-paid development.

- Akira
