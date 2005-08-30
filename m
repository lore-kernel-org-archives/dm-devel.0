From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [dm-devel] Re: fibre channel/multipath questions
Date: Tue, 30 Aug 2005 07:01:48 +0200
Message-ID: <1125378108.6375.15.camel@zezette>
References: <200508261812.23328.Rik.Bobbaers@cc.kuleuven.be>
	 <20050829172316.GC7875@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20050829172316.GC7875@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Rik Bobbaers <Rik.Bobbaers@cc.kuleuven.be>, linux-scsi@vger.kernel.org
List-Id: dm-devel.ids

On lun, 2005-08-29 at 18:23 +0100, Christoph Hellwig wrote:
> I think you can setup dm-multipath based on WWNs, so the device
> numbers don't matter.  Cc'ed the dm-devel list to verify my assumption.
> 
Yes, true for the multipathed devices, which leaves the problem intact
for the local drives ...
-- 
christophe varoqui <christophe.varoqui@free.fr>


