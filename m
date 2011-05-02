From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] do not disable ext4 discards on first discard failure? [was: Re: dm snapshot: ignore discards issued to the snapshot-origin target]
Date: Mon, 02 May 2011 09:48:44 -0400
Message-ID: <yq1vcxt43ib.fsf@sermon.lab.mkp.net>
References: <20110413224025.GA18589@redhat.com>
	<20110413234854.GA19793@redhat.com>
	<20110426173213.GA19604@redhat.com>
	<20110428001912.GA14659@redhat.com>
	<20110428075355.GA2190@infradead.org>
	<20110428205935.GA24979@redhat.com>
	<alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com>
	<20110429122454.GL32370@agk-dp.fab.redhat.com>
	<alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com>
	<20110502081308.GC8642@agk-dp.fab.redhat.com>
	<20110502081925.GA11312@infradead.org>
	<alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com>
	(Lukas Czerner's message of "Mon, 2 May 2011 12:24:33 +0200 (CEST)")
Sender: linux-ext4-owner@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, sandeen@redhat.com, Mike Snitzer <snitzer@redhat.com>, DarkNovaNick@gmail.com, linux-lvm@redhat.com, linux-ext4@vger.kernel.org
List-Id: dm-devel.ids

>>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:

Lukas> however it also advertise discard_zeroes_data which is wrong and
Lukas> possibly dangerous and should be fixed!

That shouldn't happen. I'll have a look...

-- 
Martin K. Petersen	Oracle Linux Engineering
