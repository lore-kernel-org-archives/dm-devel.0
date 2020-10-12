From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v1] dm verity: Add support for signature verification
 with 2nd keyring
Date: Tue, 13 Oct 2020 02:55:02 +0300
Message-ID: <20201012235502.GA36149@linux.intel.com>
References: <20201002071802.535023-1-mic@digikod.net>
 <bda2ffd7-3b7c-33a4-667f-a3435e112fc1@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bda2ffd7-3b7c-33a4-667f-a3435e112fc1@digikod.net>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Deven Bowers <deven.desai@linux.microsoft.com>, Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>, Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
List-Id: dm-devel.ids

On Fri, Oct 09, 2020 at 11:50:03AM +0200, Mickaël Salaün wrote:
> Hi,
> 
> What do you think about this patch?
> 
> Regards,
>  Mickaël
> 
> On 02/10/2020 09:18, Mickaël Salaün wrote:
> > From: Mickaël Salaün <mic@linux.microsoft.com>
> > 
> > Add a new DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING configuration
> > to enable dm-verity signatures to be verified against the secondary
> > trusted keyring.  This allows certificate updates without kernel update
> > and reboot, aligning with module and kernel (kexec) signature
> > verifications.

I'd prefer a bit more verbose phrasing, not least because I have never
really even peeked at dm-verity, but it is also a good practice.

You have the middle part of the story missing - explaining the semantics
of how the feature leads to the aimed solution.

/Jarkko
