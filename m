From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Unable to use multipath with LVM2
Date: Tue, 3 May 2005 15:05:19 +0200
Message-ID: <20050503130519.GA3266@marowsky-bree.de>
References: <BFCF159FFD14F444B205968F32DBD5BB01700376@MAILEX01.rasgroup.ita.localnet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <BFCF159FFD14F444B205968F32DBD5BB01700376@MAILEX01.rasgroup.ita.localnet>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2005-05-03T14:49:03, Magni Fabrizio <Fabrizio.Magni@rasnet.it> wrote:

> > Either the /dev/disk/by-*/ files, or /dev/dm-*; either will do. It's
> > just important that it only uses those paths and doesn't use the raw
> > disks (/dev/sdX).
> 
> /dev/disk/by-*/ can be scanned but they don't work properly on top of
> multipath since they are linked directly to the "basic devices"
> /dev/sd*.

In SP2 and onwards, /dev/disk/by-name/ are symlinks to /dev/dm-* named
after the mappings.

> I really don't understand why /dev/dm-* cannot be scanned properly by
> the LVM2...

Well, it seems to work for me; but I only tried it on SP2 betas.


-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
