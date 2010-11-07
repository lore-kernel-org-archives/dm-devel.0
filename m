From: Heinz Diehl <htd@fritha.org>
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs v3 on 2.6.37-rc* ?
Date: Sun, 7 Nov 2010 21:36:37 +0100
Message-ID: <20101107203637.GA12615@fritha.org>
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>
 <4CD6B7FA.3050005@redhat.com>
 <AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com>
 <AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt <jackdachef@gmail.com>
Cc: Milan Broz <mbroz@redhat.com>, Andi Kleen <andi@firstfloor.org>, Linux Kernel <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, htd@fancy-poultry.org
List-Id: dm-devel.ids

On 07.11.2010, Matt wrote: 

> noatime,nodiratime,barrier=1

One of my systems runs a squid webcache and has a lot of disk load,
and I've never seen data loss or corruption, all the way up from 2.6.34 to
the latest -git.

(Btw: "noatime" superseeds "nodiratime", you can therefore drop it when
"noatime" is set.)

> I read about barrier-problems and data getting to the partition when
> using dm-crypt and several layers so I don't know if that could be
> related

I would rather guess that you have filesystem / harddisk problems,
but I must admit I've never mounted one of my filesystems with barriers
enabled (I use XFS exclusively).
