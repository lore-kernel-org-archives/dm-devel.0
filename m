From: James Morris <jmorris@namei.org>
Subject: Re: [RFC PATCH v3 1/1] Add dm verity root hash pkcs7 sig
 validation
Date: Tue, 11 Jun 2019 15:31:45 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.1906111524060.8305@namei.org>
References: <20190607223140.16979-1-jaskarankhurana@linux.microsoft.com> <20190607223140.16979-2-jaskarankhurana@linux.microsoft.com> <54170d18-31c7-463d-10b5-9af8b666df0f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54170d18-31c7-463d-10b5-9af8b666df0f@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, scottsh@microsoft.com, ebiggers@google.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Sat, 8 Jun 2019, Milan Broz wrote:

> > Adds DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE: roothash signature *must* be
> > specified for all dm verity volumes and verification must succeed prior
> > to creation of device mapper block device.
> 
> AFAIK there are tools that use dm-verity internally (some container
> functions in systemd can recognize and check dm-verity partitions) and with
> this option we will just kill possibility to use it without signature.
> 
> Anyway, this is up to Mike and Mikulas, I guess generic distros will not
> set this option.

Right, I think this option would not be for a general purpose distro, but 
for embedded systems and other cases where the user may want a more 
tightly locked-down system.

-- 
James Morris
<jmorris@namei.org>
