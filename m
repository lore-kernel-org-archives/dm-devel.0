From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [PATCH v3] staging: writeboost: Add dm-writeboost
Date: Sat, 21 Feb 2015 01:06:08 +0900
Message-ID: <54E75B70.1010007@gmail.com>
References: <54A508F7.1020207@gmail.com> <20150118000952.GB26160@kroah.com> <20150220174401.4badb3cbad7be3eed449f4c1@gmail.com> <20150220150614.GA4740@debian> <54E75201.9030202@gmail.com> <20150220155036.GB4740@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150220155036.GB4740@debian>
Sender: linux-kernel-owner@vger.kernel.org
To: ejt@redhat.com
Cc: Greg KH <gregkh@linuxfoundation.org>, snitzer@redhat.com, dm-devel@redhat.com, driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

The size is configurable but typically 512KB (that's the default).

Refer to bio payload sounds really dangerous but it may be possible
in some tricky way. but at the moment I am not sure how the
implementation would be.

Is there some fancy function that is like memcpy but actually "move"
the ownership?

- Akira

On 2015/02/21 0:50, Joe Thornber wrote:
> On Sat, Feb 21, 2015 at 12:25:53AM +0900, Akira Hayakawa wrote:
>> Yes.
> How big are your log chunks?  Presumably they're relatively small (eg,
> 256k).  In which case you can optimise for the common case where you
> have enough bios to hand to build your log chunk by just referencing
> the bio payloads, rather than copying.  It's only the last bit of io
> in a burst that should be using this copying slow path.
>
> - Joe
