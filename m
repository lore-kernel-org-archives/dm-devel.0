From: Richard Davies <richard@arachsys.com>
Subject: Re: Occasional dmsetup resume lockups
Date: Fri, 12 Feb 2016 08:50:41 +0000
Message-ID: <20160212085041.GA2576@alpha.arachsys.com>
References: <56BCFC90.5030508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56BCFC90.5030508@gmail.com>
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

Zdenek Kabelac wrote:
> There could be number of reasons - but since you mention you operate with
> live device - aren't you actually running your dmsetup from a device you
> manipulate with - aka your root volume ?

No. It is different partitions.

The live device which we are running dmsetup on is the storage for a VM.
Under the dm-raid1 DRIVE, this is a dm-crypt ORIGIN over an LVM LV over md
RAID of some partitions.

The root filesystem including the dmsetup binary is on md RAID of different
partitions of the same physical disks.

> lvm2 locks itself into memory to avoid any page swapping issues.

Sorry, I don't understand if this is relevant?

> You could also try debugging kernel on serial console with sysrq+t to see
> what's get blocked on disk access.

OK, we will try this and share when we have it.

Richard. 
