From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs v3 on 2.6.37-rc* ?
Date: Sun, 07 Nov 2010 22:39:23 +0100
Message-ID: <4CD71C8B.1050604@redhat.com>
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com> <4CD6B7FA.3050005@redhat.com> <AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com> <AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com> <20101107194547.GA12521@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101107194547.GA12521@basil.fritz.box>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Matt <jackdachef@gmail.com>, Linux Kernel <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, htd@fancy-poultry.org
List-Id: dm-devel.ids

On 11/07/2010 08:45 PM, Andi Kleen wrote:
>> I read about barrier-problems and data getting to the partition when
>> using dm-crypt and several layers so I don't know if that could be
>> related
> 
> Barriers seem to be totally broken on dm-crypt currently.

Can you explain it?

Barriers/flush change should work, if it is broken, it is not only dm-crypt.
(dm-crypt simply relies on dm-core implementation, when barrier/flush
request come to dmcrypt, all previous IO must be already finished).

Milan
