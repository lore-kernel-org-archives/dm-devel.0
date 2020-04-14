From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [RFC] IMA: New IMA measurements for dm-crypt and selinux
Date: Mon, 13 Apr 2020 21:11:19 -0400
Message-ID: <1586826679.7311.174.camel@linux.ibm.com>
References: <f92bef0f-eb40-0e07-540c-321134e4b070@linux.microsoft.com>
         <CAB9W1A1=JyOV3-+6jn3xX-M+GKWBB2cCNh-VWB_kzf+YiR_d2Q@mail.gmail.com>
         <CAP22eLGJbSvUU=W0Jp=gvOFv-nxLC8YTnta3OU2PKbh746MCkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAP22eLGJbSvUU=W0Jp=gvOFv-nxLC8YTnta3OU2PKbh746MCkQ@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: "Lev R. Oshvang ." <levonshe@gmail.com>, Stephen Smalley <stephen.smalley@gmail.com>
Cc: Tushar Sugandhi <tusharsu@linux.microsoft.com>, linux-integrity@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, SELinux <selinux@vger.kernel.org>, dm-devel@redhat.com, James Morris <jmorris@namei.org>, chpebeni@linux.microsoft.com, nramas@linux.microsoft.com, balajib@microsoft.com, sashal@kernel.org, suredd@microsoft.com
List-Id: dm-devel.ids

On Sun, 2020-04-12 at 11:15 +0300, Lev R. Oshvang . wrote:
> On Sat, Apr 11, 2020 at 10:07 PM Stephen Smalley
> It sees to me that  LKRG (kernel run time guard)  takes the role of
> measuring kernel structures.  Perhaps you need to consult with LKRG
> guys.

There definitely sounds like there is some overlap.  LKRG seems to be
measuring kernel structures for enforcing local integrity.  In the
context of IMA, measurements are included in the IMA measurement list
and used to extend a TPM PCR so that it can be quoted.

A generic method for measuring structures and including them in the
IMA measurement list sounds interesting.

Mimi
