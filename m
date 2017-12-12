From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v2 2/2] dm unstripe: Add documentation for unstripe
        target
Date: Tue, 12 Dec 2017 14:56:05 +0000
Message-ID: <20171212145605.GA18169@agk-dp.fab.redhat.com>
References: <20171211160019.20518-1-scott.bauer@intel.com> <20171211160019.20518-3-scott.bauer@intel.com> <00fdc58c-d8e9-6b42-727d-ab70d5ce1b0a@gmail.com> <20171212144556.GF11218@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171212144556.GF11218@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>, Nikolay Borisov <n.borisov.lkml@gmail.com>, Scott Bauer <scott.bauer@intel.com>, dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, jonathan.derrick@intel.com
List-Id: dm-devel.ids

On Tue, Dec 12, 2017 at 07:45:56AM -0700, Keith Busch wrote:
> Ah, this device's makers call the "stripe" size what should be called
> "chunk".

If this target is to go anywhere, let's try to define it as 'undoing'
the existing dm-stripe target using primary terminology, field names
etc. as close as possible to our existing target.  We can still mention
any alternative terminology encountered in the documentation.  The
first (simplest) documented example could be a dm-stripe target being
'unstriped'.

Alasdair
