From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] dm-crypt, dm-integrity: allow unaligned bv_offset
Date: Tue, 7 Nov 2017 09:31:01 +0100
Message-ID: <f8bb8497-7b6d-3ce1-8a59-0eb90975c4c0@gmail.com>
References: <20171102213903.1baa4a10@uranus>
 <20171106161808.GC25073@redhat.com> <20171106232918.25c0ae1a@uranus>
 <alpine.LRH.2.02.1711061852380.23082@file01.intranet.prod.int.rdu2.redhat.com>
 <20171107091323.20664e3f@pluto.restena.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171107091323.20664e3f@pluto.restena.lu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Bruno_Pr=c3=a9mont?= <bonbons@sysophe.eu>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 11/07/2017 09:13 AM, Bruno Prémont wrote:
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>> Cc: stable@vger.kernel.org	# v4.12+
>> Fixes: 8f0009a22517 ("dm crypt: optionally support larger encryption sector size")
>> Fixes: 7eada909bfd7 ("dm: add integrity target")
> 
> Reported-by: Bruno Prémont <bonbons@sysophe.eu>
> Tested-by: Bruno Prémont <bonbons@sysophe.eu>
> 
> Successfully tested on 4.12.14, 4.13.11 and 4.14-rc8+ (e4880bc5dfb1).

Thanks!

(That alignment check was added after our discussion - we wanted
to have dm-crypt and dm-integrity to check the same thing, just to trigger
possible data corruption, but obviously it was incorrect check.)

It must go to stable well, I think there are possibly more situations
we broke for dm-crypt by this.

Reviewed-by: Milan Broz <gmazyland@gmail.com>

m.
