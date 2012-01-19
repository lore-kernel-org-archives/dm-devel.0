From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [dm-devel] (no subject)
Date: Thu, 19 Jan 2012 14:06:28 +0000
Message-ID: <4F182364.6090503@redhat.com>
References: <CALLzPKYdD22kg9QCtzLsENwTmBnkZqJ6sykrU1PoadTLMXtHTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALLzPKYdD22kg9QCtzLsENwTmBnkZqJ6sykrU1PoadTLMXtHTg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/19/2012 01:00 PM, Kasatkin, Dmitry wrote:
> Hi,
> 
> I rebased on the stop of latest mainline tree and now dmsetup
> fails... It says: "Failed to create notification semaphore:
> Function not implemented". I run strace and saw that dmsetup uses
> "semget" which returns -ENOSYS...
> 
> Any ideas?

Do you have SysV IPC turned on in kconfig (CONFIG_SYSVIPC and
CONFIG_SYSVIPC_COMPAT if using 32-bit compat ioctls)?

Regards,
Bryn.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk8YI2MACgkQ6YSQoMYUY97KrgCgyi6qwG2kF6gGFh9tPZYpIvrN
RbQAoKck78dZdCPpOXeI92NFM8cjyIy2
=LsuP
-----END PGP SIGNATURE-----
