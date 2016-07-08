From: Mike Christie <mchristi@redhat.com>
Subject: Re: [Question] udev ID_UID attribute ???
Date: Fri, 8 Jul 2016 10:52:51 -0500
Message-ID: <5c9472d8-ef1a-bfd7-a916-d4120d881fc1@redhat.com>
References: <22f39ecd-bfe7-d3b0-87af-e0b28d368bc8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <22f39ecd-bfe7-d3b0-87af-e0b28d368bc8@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

On 07/07/2016 04:21 PM, Xose Vazquez Perez wrote:
> Is "ID_UID" really valid?
> 
> libmultipath/hwtable.c:         .uid_attribute = "ID_UID",
> 

I was wondering the same thing. For ceph rbd, we do not have the normal
scsi serial/wwn values, so I am modifying our udev rule to export ID_UID.

I made the ID_UID, the values we use for the udev (/dev/rbd) name which
is the pool name (basically just a grouping of storage) plus the image
name (basically name of a disk created in a pool).
