From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: add devname module aliases to allow module on-demand
	auto-loading
Date: Tue, 25 May 2010 11:57:56 +0200
Message-ID: <AANLkTimpooOxhJ4Kp3in6BnUMuit2xupkNXREvw6unWb__656.897624912922$1274781604$gmane$org@mail.gmail.com>
References: <1274371640.302.5.camel@yio.site>
	<AANLkTilI3RYcybjG7b1juTa3H31ImxQI1-2R_l7q0yc1@mail.gmail.com>
	<AANLkTinQwEqFKAiyAwVPwmzLtUXJkaOdZ0c88O_tfp-1@mail.gmail.com>
	<201005211909.29326.knikanth@suse.de>
	<AANLkTimGBgpqB7HEZrecv7uEis6L8b5Yv7jfD6iv_f4J@mail.gmail.com>
	<20100521182325.GO3991@agk-dp.fab.redhat.com>
	<AANLkTimuciWfkVwn7dKVeKL38WpMiCvgAxGx4ngAankW@mail.gmail.com>
	<20100525053341.GB31345@maude.comedia.it>
	<20100525094845.GA3991@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100525094845.GA3991@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kay Sievers <kay.sievers@vrfy.org>, Nikanth Karthikesan <knikanth@suse.de>, Peter Rajnoha <prajnoha@redhat.com>, Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@red>
List-Id: dm-devel.ids

On Tue, May 25, 2010 at 11:48, Alasdair G Kergon <agk@redhat.com> wrote:
> On Tue, May 25, 2010 at 07:33:41AM +0200, Luca Berra wrote:
>> what patch?
>
> Peter Rajnoha is working on a final version of this, which includes
> tweaking the userspace logic to give supremacy to devtmpfs.

Note, that this will also work without devtmpfs, it will be just udev
pre-creating the nodes on startup, even when the modules aren't
loaded. Any access to the "dead" device nodes will cause the kernel to
load the corresponding module.

We need this facility mainly for other subsystems, which depend on
this behavior for some time already.

Thanks,
Kay
