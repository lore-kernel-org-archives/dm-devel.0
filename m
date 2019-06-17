From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH v4 1/1] Add dm verity root hash pkcs7 sig validation.
Date: Mon, 17 Jun 2019 15:31:21 +0200
Message-ID: <ab346931-1d1b-bd2f-8314-ee4779bd44bf@gmail.com>
References: <20190613010610.4364-1-jaskarankhurana@linux.microsoft.com>
 <20190613010610.4364-2-jaskarankhurana@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190613010610.4364-2-jaskarankhurana@linux.microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, scottsh@microsoft.com, ebiggers@google.com, mpatocka@redhat.com
List-Id: dm-devel.ids

On 13/06/2019 03:06, Jaskaran Khurana wrote:
...

> Adds DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE: roothash signature *must* be
> specified for all dm verity volumes and verification must succeed prior
> to creation of device mapper block device.

I had a quick discussion about this and one suggestion was
to add dm-verity kernel module parameter instead of a new config option.

The idea is that if you can control kernel boot commandline, you can add it
there with the same effect (expecting that root device is on dm-verity as well).

Isn't this better option or it is not going to work for you?

Milan
