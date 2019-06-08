From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH v3 0/1] Add dm verity root hash pkcs7 sig validation.
Date: Sat, 8 Jun 2019 10:46:19 +0200
Message-ID: <3f9f2df1-c811-18d4-2665-0ffddb7a7f0e@gmail.com>
References: <20190607223140.16979-1-jaskarankhurana@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190607223140.16979-1-jaskarankhurana@linux.microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, scottsh@microsoft.com, ebiggers@google.com, mpatocka@redhat.com
List-Id: dm-devel.ids

On 08/06/2019 00:31, Jaskaran Khurana wrote:
> This patch set adds in-kernel pkcs7 signature checking for the roothash of
> the dm-verity hash tree.
> The verification is to support cases where the roothash is not secured by
> Trusted Boot, UEFI Secureboot or similar technologies.

...
>  drivers/md/Kconfig                |  23 ++++++
>  drivers/md/Makefile               |   2 +-
>  drivers/md/dm-verity-target.c     |  34 +++++++-
>  drivers/md/dm-verity-verify-sig.c | 132 ++++++++++++++++++++++++++++++
>  drivers/md/dm-verity-verify-sig.h |  30 +++++++

Please could you also modify Documentation/device-mapper/verity.txt and
describe the new table parameter?

It would be also nice to have a reference example how to configure it,
including how to create the signature file.

Milan
