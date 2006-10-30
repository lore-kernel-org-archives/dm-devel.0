From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [BUG] dmsetup table output changed from 2.6.18 to 2.6.19-rc3 and breaks yaird.
Date: Mon, 30 Oct 2006 18:43:31 +0000
Message-ID: <20061030184331.GY3928@agk.surrey.redhat.com>
References: <20061030151930.GQ27337@susi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161341AbWJ3SoO@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20061030151930.GQ27337@susi>
Sender: linux-kernel-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org, Stefan Schmidt <stefan@datenfreihafen.org>, dm-devel@redhat.com, dm-crypt@saout.de, Christophe Saout <christophe@saout.de>, Andrew Morton <akpm@osdl.org>, torvalds@osdl.org
List-Id: dm-devel.ids

On Mon, Oct 30, 2006 at 04:19:30PM +0100, Stefan Schmidt wrote:
> dmsetup table on 2.6.18 reports: aes-cbc-essiv:sha256
> dmsetup table on 2.6.19-rc3 reports: cbc(aes)-cbc-essiv:sha256

> The problem seems to be on the kernel side here. Herbert Xu changed
> the output with d1806f6a97a536b043fe50e6d8a25b061755cf50
> http://kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d1806f6a97a536b043fe50e6d8a25b061755cf50

> The question is if this change was intentional and yaird should be
> fixed, or it's a kernel API breakage.
 
It cannot have been intentional as there was no mention of the change to the
userspace interface in the git changelog (and the interface version number
was not changed).

A new patch is needed to revert the part of the patch that changed the
userspace interface.

Please don't forget to copy in the appropriate maintainers when you send
messages like this one:
  http://marc.theaimsgroup.com/?l=linux-netdev&m=115547174417490&w=2
so they can provide acks:-)

Alasdair
-- 
agk@redhat.com
