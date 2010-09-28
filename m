From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH] dm-thinp: new device mapper target to thin
 provision storage
Date: Tue, 28 Sep 2010 17:44:37 -0400
Message-ID: <4CA261C5.7070005@cfl.rr.com>
References: <1285706977.22966.20.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1285706977.22966.20.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com
List-Id: dm-devel.ids

On 9/28/2010 4:49 PM, Heinz Mauelshagen wrote:
> 
> These are 2 new device mapper targets "thinp" and "thinp-dev"
> implemented in one module, which allow for thin provisioning of storage
> on a single host from a storage pool to an arbitrary amount of devices.

How is this different than snapshotting a zero target?

> +Create an ext4 filesystem on the thin provisioned device:
> +mkfs -t ext4 /dev/mapper/thinp1

FYI, that tends to spend a lot of time writing hundreds of mb of zeros
to the inode tables, allocating chunks from the backing store.  You
might want to add -E lazy_itable_init to stop that.
