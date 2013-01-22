From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: "create snapshots of any block device"
Date: Tue, 22 Jan 2013 11:22:27 +0000
Message-ID: <50FE7673.7080407@redhat.com>
References: <1766138.NkjTPulnJa@inno>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1766138.NkjTPulnJa@inno>
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
Cc: Hauke Laging <mailinglisten@hauke-laging.de>
List-Id: dm-devel.ids

On 01/22/2013 11:12 AM, Hauke Laging wrote:
> Isn't that at least misleading? Is it really possible to create a snapshot of
> e.g. /dev/sda5 without creating an *additional* device as snapshot origin?

It's possible but as you note you have to create the dm layers for the 
snapshot. This means that if a non-dm device is in use you have to shut 
its users down (unmount file systems etc.), create the snapshot and then 
re-mount.

I've frequently used this in the past to snapshot large zero targets to 
create sparse devices for testing (before --virtualsize was added to LVM2).

With device-mapper devices this is unnecessary since the top-level 
device may be suspended while the snapshot layers are inserted.

Regards,
Bryn.
