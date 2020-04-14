From: "Lev R. Oshvang ." <levonshe@gmail.com>
Subject: Re: [RFC] IMA: New IMA measurements for dm-crypt and selinux
Date: Tue, 14 Apr 2020 13:06:34 +0300
Message-ID: <CAP22eLGBxy7_Q8dMoJTjBsrhveqhfh7nibzBCqrtWKhXzY74fQ@mail.gmail.com>
References: <f92bef0f-eb40-0e07-540c-321134e4b070@linux.microsoft.com>
 <CAB9W1A1=JyOV3-+6jn3xX-M+GKWBB2cCNh-VWB_kzf+YiR_d2Q@mail.gmail.com>
 <CAP22eLGJbSvUU=W0Jp=gvOFv-nxLC8YTnta3OU2PKbh746MCkQ@mail.gmail.com> <1586826679.7311.174.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1586826679.7311.174.camel@linux.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Stephen Smalley <stephen.smalley@gmail.com>, Tushar Sugandhi <tusharsu@linux.microsoft.com>, linux-integrity@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, SELinux <selinux@vger.kernel.org>, dm-devel@redhat.com, James Morris <jmorris@namei.org>, chpebeni@linux.microsoft.com, nramas@linux.microsoft.com, balajib@microsoft.com, sashal@kernel.org, suredd@microsoft.com
List-Id: dm-devel.ids

On Tue, Apr 14, 2020 at 4:11 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> On Sun, 2020-04-12 at 11:15 +0300, Lev R. Oshvang . wrote:
> > On Sat, Apr 11, 2020 at 10:07 PM Stephen Smalley
> > It sees to me that  LKRG (kernel run time guard)  takes the role of
> > measuring kernel structures.  Perhaps you need to consult with LKRG
> > guys.
>
> There definitely sounds like there is some overlap.  LKRG seems to be
> measuring kernel structures for enforcing local integrity.  In the
> context of IMA, measurements are included in the IMA measurement list
> and used to extend a TPM PCR so that it can be quoted.
>
> A generic method for measuring structures and including them in the
> IMA measurement list sounds interesting.
>
> Mimi
>
I frankly do not understand the threat model.
Secure boot or TPM provides trust in encryption/decryption keys
dm-crypt/dm-verify use.
When dm-verify discovers that the disk image is modified it will just
do not allow the system to work ( mount roots, etc).
So imagine that adversary took control of TPM  and changed the keys
dm-verify work with in order to sign malicious content on disk. In
this case, remote attestation should alert of compromised TPM, no
matter whether dmvery keys or other keys were forged.

SELinux is another story and I think a run-time check of SElinux
structures fits well into LKRG. IMA only provide guarantees that
SELinux (or any other LSM) control files and attributes were intact.
