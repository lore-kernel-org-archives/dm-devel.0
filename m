From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: Multipath v. 0.4.7 trips over USB flash drive
Date: Thu, 22 Nov 2007 13:49:25 +0100
Message-ID: <20071122124925.GA6727@bogon.ms20.nix>
References: <3A7658DE9640014CB055D6299B111F9C1EF588@CORPUSMX20B.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <3A7658DE9640014CB055D6299B111F9C1EF588@CORPUSMX20B.corp.emc.com>
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

Hi,
On Mon, Nov 19, 2007 at 03:43:04PM -0500, usvyatsky_ilya@emc.com wrote:
> I am using DM MPIO for quite a while now and in general it works.
> Lately I encountered a problem with one of my boxes that is equipped
> with USB flash drive and is connected to a disk array.
> Namely, the flash drive has an empty bcdDevice entry, which translates
> into empty /sys/block/sdXX/device/rev file.
This has been fixed in git a while ago - 0.4.8 has the fix you need.
Cheers,
 -- Guido
