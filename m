From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 00/10] fixes for kpartx -d
Date: Fri, 5 May 2017 23:18:19 +0100
Message-ID: <20170505221819.GG11857@agk-dp.fab.redhat.com>
References: <20170505220559.7248-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170505220559.7248-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, May 06, 2017 at 12:05:49AM +0200, Martin Wilck wrote:
>   3) kpartx should only delete "partitions", which are single-target
>      linear mappings into a block device. Other maps should not be touched.

The prefix on the dm device's uuid should guarantee this: all devices
kpartx creates should have the same initial characters (a
not-quite-standard form "part" IIRC instead of "KPARTX-") and any
devices without those initial characters must be ignored.

Alasdair
