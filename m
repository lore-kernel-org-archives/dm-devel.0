From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: Re: [RFC] IMA: New IMA measurements for dm-crypt and selinux
Date: Thu, 16 Apr 2020 17:52:05 -0700
Message-ID: <e0e214c7-09d2-46c1-fe63-febd23488720@linux.microsoft.com>
References: <f92bef0f-eb40-0e07-540c-321134e4b070@linux.microsoft.com>
 <CAB9W1A1=JyOV3-+6jn3xX-M+GKWBB2cCNh-VWB_kzf+YiR_d2Q@mail.gmail.com>
 <CAP22eLGJbSvUU=W0Jp=gvOFv-nxLC8YTnta3OU2PKbh746MCkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAP22eLGJbSvUU=W0Jp=gvOFv-nxLC8YTnta3OU2PKbh746MCkQ@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: "Lev R. Oshvang ." <levonshe@gmail.com>, Stephen Smalley <stephen.smalley@gmail.com>
Cc: linux-integrity@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>, LSM List <linux-security-module@vger.kernel.org>, SELinux <selinux@vger.kernel.org>, dm-devel@redhat.com, James Morris <jmorris@namei.org>, chpebeni@linux.microsoft.com, nramas@linux.microsoft.com, balajib@microsoft.com, sashal@kernel.org, suredd@microsoft.com
List-Id: dm-devel.ids



On 2020-04-12 1:15 a.m., Lev R. Oshvang . wrote:
<snip>
> 
> It sees to me that  LKRG (kernel run time guard)  takes the role of
> measuring kernel structures.  Perhaps you need to consult with LKRG
Thanks Lev for the feedback. I will investigate more into it.
> guys.
> Lev.
> 
