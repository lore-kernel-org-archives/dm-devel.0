From: "Eric Van Hensbergen" <ericvh@gmail.com>
Subject: Re: [RFC][PATCH] dm-cache: block level disk cache target
	for device mapper
Date: Mon, 27 Nov 2006 13:55:58 -0600
Message-ID: <a4e6962a0611271155q55adf6fftd489de84d6ae7e88@mail.gmail.com>
References: <200611271826.kARIQYRi032717@hera.kernel.org>
	<20061127184748.GA11219@outpost.ds9a.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061127184748.GA11219@outpost.ds9a.nl>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bert hubert <bert.hubert@netherlabs.nl>, dm-devel@redhat.com, ming@acis.ufl.edu, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 11/27/06, bert hubert <bert.hubert@netherlabs.nl> wrote:
> On Mon, Nov 27, 2006 at 06:26:34PM +0000, Eric Van Hensbergen wrote:
> > This is the first cut of a device-mapper target which provides a write-back
> > or write-through block cache.  It is intended to be used in conjunction with
> > remote block devices such as iSCSI or ATA-over-Ethernet, particularly in
> > cluster situations.
>
> How does this work in practice? In other words, what is a typical actual
> configuration?
>
> There is a remote block device, and a local one, and these are kept into
> sync in some way?
>

That's the basic idea.  In our testbed, we had a single iSCSI server
exporting block devices to several clients -- each maintaining their
own local disk cache of the server exported block devices.  You can
configured either write-through or write-back policies -- write-back
has better performance, but somewhat obvious consistency issues in
failure cases.

The original intent was to combine this with the dm-cow target (which
I posted a few hours before the dm-cache patch) to provide a scalable
cluster deployment system based on back-end iSCSI or ATA-over-Ethernet
storage.

          -eric
