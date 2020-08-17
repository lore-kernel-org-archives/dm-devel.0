From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: Re: [PATCH 0/2] dm-devel:dm-crypt: infrastructure for measurement of
 DM target data using IMA
Date: Mon, 17 Aug 2020 15:45:17 -0700
Message-ID: <f252a595-7b6a-9e20-bf08-97f102c41c01@linux.microsoft.com>
References: <20200816210250.11506-1-tusharsu@linux.microsoft.com>
 <5f12cc89c535ccfc6c3d63efa2bf716a1fdd966d.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5f12cc89c535ccfc6c3d63efa2bf716a1fdd966d.camel@linux.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.ibm.com>, agk@redhat.com, snitzer@redhat.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, nramas@linux.microsoft.com, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On 2020-08-17 2:46 p.m., Mimi Zohar wrote:
> On Sun, 2020-08-16 at 14:02 -0700, Tushar Sugandhi wrote:
>> There are several device-mapper targets which contribute to verify
>> the integrity of the mapped devices e.g. dm-integrity, dm-verity,
>> dm-crypt etc.
>>
>> But they do not use the capabilities provided by kernel integrity
>> subsystem (IMA). For instance, the IMA capability that measures several
>> in-memory constructs and files to detect if they have been accidentally
>> or maliciously altered, both remotely and locally. IMA also has the
>> capability to include these measurements in the IMA measurement list and
>> use them to extend a TPM PCR so that it can be quoted.
> 
> "both remotely" refers to measurement and attestation, while "locally"
> refers to integrity enforcement, based on hashes or signatures.  Is
> this patch set adding both IMA-measurement and IMA-appraisal?
> 
> Mimi
> 
Thanks Mimi for looking at this patch set.

I added both "remotely" and "locally" in the description, so that
people less familiar with IMA would get a general overview of whats
possible with IMA.

In this patch set we are only adding support for measurement and
attestation. In the next iteration, I will remove the references to
"local" detection.
~Tushar
<snip>
