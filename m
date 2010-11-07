From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs v3 on 2.6.37-rc* ?
Date: Sun, 7 Nov 2010 20:45:47 +0100
Message-ID: <20101107194547.GA12521@basil.fritz.box>
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

> I read about barrier-problems and data getting to the partition when
> using dm-crypt and several layers so I don't know if that could be
> related

Barriers seem to be totally broken on dm-crypt currently.

But that's probably not your problem. I use the scalability patch
on 2.6.36 and it's very stable. Most likely some mistake 
in the forward port.

-Andi
