From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: Is there a way to see updated contents of a DM
 target's underlying device while the DM target is in use?
Date: Wed, 30 Jun 2010 17:58:11 -0700
Message-ID: <20100701005811.GB24284@us.ibm.com>
References: <4BD43A85686FC34D819098DB1C3999D99E4199BA@orsmsx502.amr.corp.intel.com>
	<20100701102203.51d9a8fc@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100701102203.51d9a8fc@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Neil Brown [neilb@suse.de] wrote:
> try blockdev --flushbufs
> on the device before reading it.
> Or issue the ioctl yourself.

This should help.

> Or use O_DIRECT to read.

Can this help? He is reading from logical volume lv1 but the page cache
exists for linear device fred01.

Thanks, Malahal.
