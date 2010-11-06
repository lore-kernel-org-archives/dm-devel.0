From: Matt <jackdachef@gmail.com>
Subject: [PATCH] DM-CRYPT: Scale to multiple CPUs v3 on 2.6.37-rc* ?
Date: Sat, 6 Nov 2010 23:16:11 +0100
Message-ID: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi guys,

before diving into testing out 2.6.37-rc* kernels I wanted to make
sure that the patch:

[dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3

is safe to use with e.g. >2.6.37-rc1 kernels

I know that it's not a "fix all" patch but it significantly seems to
speed up my backup jobs (by factor 2-3)
and 2.6.37* has evolved that much that interactivity isn't hurt too much

Thanks !

Matt
