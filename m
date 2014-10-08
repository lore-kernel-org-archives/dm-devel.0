From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 4/5] lightnvm: NVMe integration
Date: Wed, 8 Oct 2014 10:13:48 -0600 (MDT)
Message-ID: <alpine.LRH.2.03.1410081004310.4688@AMR>
References: <1412783736-18115-1-git-send-email-m@bjorling.me> <1412783736-18115-5-git-send-email-m@bjorling.me>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1164306420-1412784831=:4688"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1412783736-18115-5-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>
Cc: thornber@redhat.com, snitzer@redhat.com, hch@infradead.org, hayakawa@valinux.co.jp, axboe@fb.com, andy@rudoff.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, bvanassche@acm.org, linux-nvme@lists.infradead.org, jmad@itu.dk
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1164306420-1412784831=:4688
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 8 Oct 2014, Matias Bjørling wrote:
> NVMe devices are identified by the vendor specific bits:
>
> Bit 3 in OACS (device-wide). Currently made per device, as the nvme
> namespace is missing in the completion path.

The NVM-Express 1.2 actually defined this bit for Namespace Management,
so I don't think we can use bits the spec marked as "reserved". Maybe
you can trigger off some vendor specific Command Set Supported instead.
--8323328-1164306420-1412784831=:4688--
