From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v1] dm verity: Add support for signature verification with
 2nd keyring
Date: Tue, 13 Oct 2020 10:51:34 +0200
Message-ID: <1b344a3c-2671-3b1a-3c6b-f3b28e819bc5@digikod.net>
References: <20201002071802.535023-1-mic@digikod.net>
 <bda2ffd7-3b7c-33a4-667f-a3435e112fc1@digikod.net>
 <20201012235502.GA36149@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20201012235502.GA36149@linux.intel.com>
Content-Language: en-US
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Deven Bowers <deven.desai@linux.microsoft.com>, Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>, Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>
List-Id: dm-devel.ids


On 13/10/2020 01:55, Jarkko Sakkinen wrote:
> On Fri, Oct 09, 2020 at 11:50:03AM +0200, Mickaël Salaün wrote:
>> Hi,
>>
>> What do you think about this patch?
>>
>> Regards,
>>  Mickaël
>>
>> On 02/10/2020 09:18, Mickaël Salaün wrote:
>>> From: Mickaël Salaün <mic@linux.microsoft.com>
>>>
>>> Add a new DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING configuration
>>> to enable dm-verity signatures to be verified against the secondary
>>> trusted keyring.  This allows certificate updates without kernel update
>>> and reboot, aligning with module and kernel (kexec) signature
>>> verifications.
> 
> I'd prefer a bit more verbose phrasing, not least because I have never
> really even peeked at dm-verity, but it is also a good practice.
> 
> You have the middle part of the story missing - explaining the semantics
> of how the feature leads to the aimed solution.

OK, what about:

Add a new configuration DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING
to enable dm-verity signatures to be verified against the secondary
trusted keyring. Instead of relying on the builtin trusted keyring (with
hard-coded certificates), the second trusted keyring can include
certificate authorities from the builtin trusted keyring and child
certificates loaded at run time. Using the secondary trusted keyring
enables to use dm-verity disks (e.g. loop devices) signed by keys which
did not exist at kernel build time, leveraging the certificate chain of
trust model. In practice, this allows to update certificates without
kernel update and reboot, aligning with module and kernel (kexec)
signature verification which already use the secondary trusted keyring.
