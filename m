From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: mirrored device with thousand of mapping	tableentries
Date: Mon, 28 Feb 2011 12:11:49 +0000
Message-ID: <20110228121149.GA3626@agk-dp.fab.redhat.com>
References: <E04C10E329E0CD40816C9C17AE53BBD3018639C2@kit001.kaminario.local>
	<20110228114801.GZ3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639CE@kit001.kaminario.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <E04C10E329E0CD40816C9C17AE53BBD3018639CE@kit001.kaminario.local>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eli Malul <eli.malul@kaminario.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Feb 28, 2011 at 01:59:16PM +0200, Eli Malul wrote:
> The first few lines of the table I am loading:
> [root@vpc09 ~]# vi /tmp/mirror_table.txt
> 0 12 km_mirror core 2 8 nosync 2 /dev/loop0 0 /dev/loop1 0
> 12 12 km_mirror core 2 8 nosync 2 /dev/loop0 12 /dev/loop1 12
> 24 12 km_mirror core 2 8 nosync 2 /dev/loop0 24 /dev/loop1 24
> 36 12 km_mirror core 2 8 nosync 2 /dev/loop0 36 /dev/loop1 36
> 48 12 km_mirror core 2 8 nosync 2 /dev/loop0 48 /dev/loop1 48
> 60 12 km_mirror core 2 8 nosync 2 /dev/loop0 60 /dev/loop1 60
> 72 12 km_mirror core 2 8 nosync 2 /dev/loop0 72 /dev/loop1 72
> 84 12 km_mirror core 2 8 nosync 2 /dev/loop0 84 /dev/loop1 84
> 96 12 km_mirror core 2 8 nosync 2 /dev/loop0 96 /dev/loop1 96
> 108 12 km_mirror core 2 8 nosync 2 /dev/loop0 108 /dev/loop1 108

Why do you need this, rather than one mirror target covering the
whole device?  (And if, unlike that example, your extents are not contiguous,
create two new devices that join them together, and mirror those.  That's
what LVM does.)

Alasdair
