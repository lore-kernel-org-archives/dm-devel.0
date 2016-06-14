From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Tue, 14 Jun 2016 09:50:30 -0400
Message-ID: <x49fusf282h.fsf@segfault.boston.devel.redhat.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
	<CAPcyv4jdM1phR=kGoP2-7tfsVvbNe2C6hHNS5TD28ALGZQQTSw@mail.gmail.com>
	<1465861755.3504.185.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465861755.3504.185.camel@hpe.com> (Toshimitsu Kani's message of
	"Mon, 13 Jun 2016 23:59:20 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "agk@redhat.com" <agk@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

"Kani, Toshimitsu" <toshi.kani@hpe.com> writes:

>> I had dm-linear and md-raid0 support on my list of things to look at=
,
>> did you have raid0 in your plans?
>
> Yes, I hope to extend further and raid0 is a good candidate. =C2=A0=C2=
=A0

dm-flakey would allow more xfstests test cases to run.  I'd say that's
more important than linear or raid0.  ;-)

Also, the next step in this work is to then decide how to determine on
what numa node an LBA resides.  We had discussed this at a prior
plumbers conference, and I think the consensus was to use xattrs.
Toshi, do you also plan to do that work?

Cheers,
Jeff
