From: Milan Broz <mbroz@redhat.com>
Subject: Re: FW: the mirror log is NOT kept on disk
Date: Mon, 21 Mar 2011 14:26:40 +0100
Message-ID: <4D875210.7010501@redhat.com>
References: <E04C10E329E0CD40816C9C17AE53BBD301950E1B@kit001.kaminario.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E04C10E329E0CD40816C9C17AE53BBD301950E1B@kit001.kaminario.local>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 03/21/2011 02:10 PM, Eli Malul wrote:

> But I still do not understand how should I create a mapped device
> with dmsetup tool which wouldl survive crash/reboot.

You cannot do that without implementing persistent metadata handling
yourself.

Use LVM here. dmsetup is simple wrapper to DM-ioctl, low level utility.

LVM is based on top of that and solves all the problems with persistent
metadata you just found.

Milan
