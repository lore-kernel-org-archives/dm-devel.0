From: Jaskaran Singh Khurana <jaskarankhurana@linux.microsoft.com>
Subject: Re: [RFC PATCH v6 0/1] Add dm verity root hash pkcs7 sig
 validation.
Date: Fri, 12 Jul 2019 10:33:02 -0700 (PDT)
Message-ID: <alpine.LRH.2.21.1907121025510.66082@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
References: <20190701181958.6493-1-jaskarankhurana@linux.microsoft.com> <MN2PR21MB12008A962D4DD8662B3614508AF20@MN2PR21MB1200.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MN2PR21MB12008A962D4DD8662B3614508AF20@MN2PR21MB1200.namprd21.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gmazyland@gmail.com
Cc: ebiggers@google.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, Scott Shell <SCOTTSH@microsoft.com>, Nazmus Sakib <mdsakib@microsoft.com>, mpatocka@redhat.com
List-Id: dm-devel.ids


Hello Milan,

> Changes in v6:
>
> Address comments from Milan Broz and Eric Biggers on v5.
>
> -Keep the verification code under config DM_VERITY_VERIFY_ROOTHASH_SIG.
>
> -Change the command line parameter to requires_signatures(bool) which will
> force root hash to be signed and trusted if specified.
>
> -Fix the signature not being present in verity_status. Merged the
> https://nam06.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Fmbroz%2Flinux.git%2Fcommit%2F%3Fh%3Ddm-cryptsetup%26id%3Da26c10806f5257e255b6a436713127e762935ad3&amp;data=02%7C01%7CJaskaran.Khurana%40microsoft.com%7C18f92445e46940aeebb008d6fe50c610%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C636976020210890638&amp;sdata=aY0V9%2FBz2RHryIvoftGKUGnyPp9Fsc1JY4FZbHfW4hg%3D&amp;reserved=0
> made by Milan Broz and tested it.
>
>

Could you please provide feedback on this v6 version.

Regards,
Jaskaran
